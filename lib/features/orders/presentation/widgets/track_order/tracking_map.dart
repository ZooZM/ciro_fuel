import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/config/maps_availability.dart';
import 'driver_marker.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../shared/entities/value_objects.dart';

/// The live tracking map: the driver's last known position and the
/// delivery destination as markers, with the reload/zoom controls from the
/// design wired to the real camera (spec 005 T067). Falls back to a
/// stationary view of the destination alone until a position has arrived —
/// never an empty map standing in for "nothing to show yet" (FR-021 is
/// handled a level up, before this widget is even reached).
class TrackingMap extends StatefulWidget {
  const TrackingMap({
    this.driverLocation,
    this.destination,
    this.route = const [],
    super.key,
  });

  /// The driven route from the Directions API, already decoded. Empty when
  /// the platform has none, in which case a direct line stands in.
  final List<GeoPoint> route;

  /// The driver's last reported position. Null until one has arrived.
  final GeoPoint? driverLocation;

  /// The order's delivery address, as a fallback map centre and its own
  /// marker — never fabricated when absent.
  final GeoPoint? destination;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  GoogleMapController? _controller;

  /// Null until the platform has answered. Never assumed true.
  bool? _mapsAvailable;

  /// The truck badge, once rasterised for this screen's pixel ratio.
  BitmapDescriptor? _driverIcon;

  static const _defaultZoom = 14.0;

  @override
  void initState() {
    super.initState();
    unawaited(
      MapsAvailability.isAvailable().then((available) {
        if (mounted) setState(() => _mapsAvailable = available);
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Needs the MediaQuery, so it cannot happen in initState.
    final ratio = MediaQuery.devicePixelRatioOf(context);
    unawaited(
      DriverMarker.build(devicePixelRatio: ratio).then((icon) {
        if (mounted) setState(() => _driverIcon = icon);
      }),
    );
  }

  @override
  void didUpdateWidget(TrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // The first fit runs before the route has been fetched, so it frames only
    // the two endpoints. Re-fit once the road arrives — but only on that first
    // arrival, so later refreshes don't yank the camera back while the client
    // is panning around.
    if (oldWidget.route.isEmpty && widget.route.length >= 2) {
      _fitJourney();
      return;
    }

    final location = widget.driverLocation;
    if (location != null && location != oldWidget.driverLocation) {
      unawaited(
        _controller?.animateCamera(
          CameraUpdate.newLatLng(LatLng(location.lat, location.lng)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  GeoPoint get _initialCentre =>
      widget.driverLocation ??
      widget.destination ??
      // Riyadh, only as a last resort with neither point on hand — the
      // camera recentres the moment either arrives.
      const GeoPoint(lat: 24.7136, lng: 46.6753);

  /// The route the client sees between the truck and their station.
  ///
  /// The driven path when the platform could supply one, otherwise a direct
  /// line between the two points. The fallback is deliberately a plain
  /// straight segment: it reads as "roughly this way", where a road-shaped
  /// guess would claim a route nothing verified.
  Set<Polyline> _routes(BuildContext context) {
    if (widget.route.length >= 2) {
      return {
        Polyline(
          polylineId: const PolylineId('driver-to-station'),
          points: [
            for (final p in widget.route) LatLng(p.lat, p.lng),
          ],
          color: context.colors.brandBlue,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      };
    }

    final driver = widget.driverLocation;
    final destination = widget.destination;
    if (driver == null || destination == null) return const {};
    return {
      Polyline(
        polylineId: const PolylineId('driver-to-station'),
        points: [
          LatLng(driver.lat, driver.lng),
          LatLng(destination.lat, destination.lng),
        ],
        color: context.colors.brandBlue,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  Set<Marker> get _markers => {
    if (widget.driverLocation case final location?)
      Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(location.lat, location.lng),
        // Falls back to the default pin until the badge has rasterised —
        // one frame — rather than leaving the truck off the map.
        icon:
            _driverIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        anchor: const Offset(0.5, 0.5),
      ),
    if (widget.destination case final destination?)
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(destination.lat, destination.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
  };

  /// Frames the whole journey: the truck, the station, and every bend of the
  /// road between them.
  ///
  /// Bounds are taken over the route's own points, not just its two ends — a
  /// driven route regularly bulges outside the box its endpoints describe, and
  /// fitting only those clips the very curve the client wants to see.
  void _fitJourney() {
    final controller = _controller;
    if (controller == null) return;

    final points = <GeoPoint>[
      if (widget.route.length >= 2) ...widget.route,
      ?widget.driverLocation,
      ?widget.destination,
    ];
    if (points.isEmpty) return;

    // A single known point has no extent to fit; centre on it instead —
    // `newLatLngBounds` on a zero-area box zooms to maximum.
    if (points.length == 1) {
      unawaited(
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(points.first.lat, points.first.lng),
            _defaultZoom,
          ),
        ),
      );
      return;
    }

    var minLat = points.first.lat, maxLat = points.first.lat;
    var minLng = points.first.lng, maxLng = points.first.lng;
    for (final p in points.skip(1)) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lng < minLng) minLng = p.lng;
      if (p.lng > maxLng) maxLng = p.lng;
    }

    unawaited(
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          // Keeps the badges clear of the edge and of the button column.
          64,
        ),
      ),
    );
  }

  /// Snaps to the truck itself, for "where is my driver right now" — falls
  /// back to the station before any position has arrived.
  void _centreOnTruck() {
    final location = widget.driverLocation ?? widget.destination;
    final controller = _controller;
    if (location == null || controller == null) return;
    unawaited(
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.lat, location.lng),
          _defaultZoom,
        ),
      ),
    );
  }

  void _zoom(bool zoomIn) => unawaited(
    _controller?.animateCamera(zoomIn ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut()),
  );

  @override
  Widget build(BuildContext context) {
    final centre = _initialCentre;

    // Constructing a GoogleMap without a configured key does not fail
    // gracefully: the iOS SDK raises inside
    // `+[GMSServices checkServicePreconditions]` and aborts the process,
    // which reaches the developer as "Lost connection to device" the moment
    // tracking is opened. It cannot be caught from Dart, so the map must
    // simply not be built. A screen must always reach a settled state
    // (FR-041).
    //
    // `_mapsAvailable` is null only for the first frame, before the
    // platform has answered; withholding the map until then is what keeps
    // the check from racing the build.
    if (_mapsAvailable != true) {
      return const _MapUnavailable();
    }

    return SizedBox(
      height: AppSizes.orderMapHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(centre.lat, centre.lng),
                zoom: _defaultZoom,
              ),
              markers: _markers,
              polylines: _routes(context),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) {
                _controller = controller;
                // Frame the journey once the map exists, rather than
                // leaving the client to pan to find their own station.
                _fitJourney();
              },
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            top: AppSpacing.xl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Snap to the truck — the two framing controls now differ:
                // this one answers "where is it", the arrow below answers
                // "show me the whole trip".
                _MapButton(AppAssets.orderMapReloadIcon, onTap: _centreOnTruck),
                const SizedBox(height: AppSizes.orderMapButtonGap),
                _MapButton(
                  AppAssets.orderMapZoomInIcon,
                  onTap: () => _zoom(true),
                ),
                const SizedBox(height: AppSizes.orderMapButtonGap),
                _MapButton(
                  AppAssets.orderMapZoomOutIcon,
                  onTap: () => _zoom(false),
                ),
                const SizedBox(height: AppSizes.orderMapButtonGap),
                // Frames the truck, the station and the road between them.
                _MapButton(AppAssets.orderMapShareIcon, onTap: _fitJourney),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stands in for the map on a build with no `GOOGLE_MAPS_API_KEY`. The rest
/// of the tracking screen — driver, plate, ETA, remaining distance, handover
/// code — is unaffected and stays useful.
class _MapUnavailable extends StatelessWidget {
  const _MapUnavailable();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.orderMapHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.borderHairline),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          TrackOrderKeys.mapUnavailable.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton(this.asset, {this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: SvgPicture.asset(
        asset,
        width: AppSizes.orderMapButtonSize,
        height: AppSizes.orderMapButtonSize,
      ),
    );
  }
}

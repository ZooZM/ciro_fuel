import 'package:dio/dio.dart';

import '../../domain/entities/station.dart';
import '../models/station_mapper.dart';

/// `GET /stations` (spec 005 T014/T058) plus the CLIENT-write route
/// (`PATCH /stations/:id/favourite`, T109) — the FUEL_COMPANY_ADMIN CRUD
/// routes are web-dashboard territory, not this app's.
abstract interface class StationsRemoteDataSource {
  Future<List<Station>> getStations();

  Future<Station> setFavourite(String stationId, bool isFavourite);
}

class StationsRemoteDataSourceImpl implements StationsRemoteDataSource {
  StationsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Station>> getStations() async {
    final response = await _dio.get<Map<String, dynamic>>('/stations');
    final items = response.data!['items'] as List<dynamic>;
    return items.cast<Map<String, dynamic>>().map(StationMapper.fromJson).toList();
  }

  @override
  Future<Station> setFavourite(String stationId, bool isFavourite) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/stations/$stationId/favourite',
      data: {'isFavourite': isFavourite},
    );
    return StationMapper.fromJson(response.data!);
  }
}

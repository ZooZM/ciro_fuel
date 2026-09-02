/// One station the client can be switched to.
class StationOption {
  const StationOption({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.area,
    required this.areaEn,
    this.isActive = true,
    this.isFavourite = false,
  });

  final String id;
  final String name;
  final String nameEn;
  final String area;
  final String areaEn;

  /// Inactive stations are listed under their own divider and cannot be
  /// favourited — the design shows them as a tail on the list, still
  /// selectable so the client can see why one is unavailable.
  final bool isActive;

  final bool isFavourite;

  String localisedName(bool isArabic) => isArabic ? name : nameEn;
  String localisedArea(bool isArabic) => isArabic ? area : areaEn;

  StationOption copyWith({bool? isFavourite}) => StationOption(
    id: id,
    name: name,
    nameEn: nameEn,
    area: area,
    areaEn: areaEn,
    isActive: isActive,
    isFavourite: isFavourite ?? this.isFavourite,
  );
}

/// The stations the mock client can pick between.
const List<StationOption> kStationOptions = [
  StationOption(
    id: 'safa',
    name: 'محطة الصفا',
    nameEn: 'Al Safa Station',
    area: 'جدة - الصفا',
    areaEn: 'Jeddah - Al Safa',
  ),
  StationOption(
    id: 'hamdaniyah',
    name: 'محطة الحمدانية',
    nameEn: 'Al Hamdaniyah Station',
    area: 'جدة - الحمدانية',
    areaEn: 'Jeddah - Al Hamdaniyah',
  ),
  StationOption(
    id: 'rehab',
    name: 'محطة الرحاب',
    nameEn: 'Al Rehab Station',
    area: 'جدة - طريق مكة القديم - حي البوادي',
    areaEn: 'Jeddah - Old Makkah Road - Al Bawadi',
  ),
  StationOption(
    id: 'mazaya',
    name: 'مزايا فيول مكة البيبان',
    nameEn: 'Mazaya Fuel Makkah Al Bayban',
    area: 'مكة - البيبان',
    areaEn: 'Makkah - Al Bayban',
    isActive: false,
  ),
];

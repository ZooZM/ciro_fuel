/// The litre tiles shown on the quantity row for every grade — the sizes
/// ordered often enough to earn a tap of their own. Ascending: the row draws
/// them reversed so the largest sits nearest the لتر box under Arabic.
const List<int> kOrderQuantities = [20000, 22000, 33000];

/// Every tanker size the fleet carries, [kOrderQuantities] among them. This is
/// the ladder the counter behind the لتر box steps through, which is how the
/// sizes without a tile of their own are reached. Must stay ascending and must
/// contain every value in [kOrderQuantities], or a tile could select a
/// quantity the counter cannot step away from.
const List<int> kOrderCounterQuantities = [
  20000,
  22000,
  32000,
  33000,
  36000,
  42000,
  46000,
];

typedef Station = ({String name, String area});

const List<Station> kFavouriteStations = [
  (name: 'محطة الصفا', area: 'جدة - الصفا'),
  (name: 'محطة الحمدانية', area: 'جدة - الحمدانية'),
  (name: 'محطة الرحاب', area: 'جدة - الرحاب'),
];

enum DeliveryOption { schedule, today, fastest }

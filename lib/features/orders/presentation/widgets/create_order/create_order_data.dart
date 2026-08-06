/// Fixed litre choices offered alongside the custom-quantity field, for
/// every grade.
const List<int> kOrderQuantities = [20000, 25000, 33000];

typedef Station = ({String name, String area});

const List<Station> kFavouriteStations = [
  (name: 'محطة الصفا', area: 'جدة - الصفا'),
  (name: 'محطة الحمدانية', area: 'جدة - الحمدانية'),
  (name: 'محطة الرحاب', area: 'جدة - الرحاب'),
];

enum DeliveryOption { schedule, today, fastest }

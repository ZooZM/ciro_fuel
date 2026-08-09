/// Fixed litre choices offered alongside the custom-quantity field, for
/// every grade.
const List<int> kOrderQuantities = [20000, 25000, 33000];

typedef Station = ({String name, String area});

/// Placeholder favourites until the account's own list is fetched — sample
/// data rather than user-facing copy, so deliberately untranslated. See
/// `constants/order_mock_data.dart` for the rest of the stand-in data.
const List<Station> kFavouriteStations = [
  (name: 'محطة الصفا', area: 'جدة - الصفا'),
  (name: 'محطة الحمدانية', area: 'جدة - الحمدانية'),
  (name: 'محطة الرحاب', area: 'جدة - الرحاب'),
];

enum DeliveryOption { schedule, today, fastest }

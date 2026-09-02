/// spec 005 T058/T060: the litre ladder and favourite-station shortcuts
/// that used to be fixed here are now real data — `PricingConfig.
/// tankerCapacitiesLiters` (via `QuantitySection.tileQuantities`/
/// `counterQuantities`) and `GET /stations` (via `StationSection.stations`/
/// `favouriteStations`) respectively. Nothing platform-agnostic is left to
/// define at this layer.
enum DeliveryOption { schedule, today, fastest }

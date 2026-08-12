/// The rules the credit-limit form applies to the figure being requested.
///
/// Placeholders until the petrol company's own bands are read from the API —
/// but rules rather than copy, so they live apart from the translations.
abstract final class CreditLimitConstants {
  /// How much a single tap on ‏+‎/‏−‎ moves the requested limit.
  static const double amountStep = 10000;

  /// The floor the stepper will not go below. Held at the floor rather than
  /// hidden, so the row keeps its shape.
  static const double minAmount = 10000;

  /// Where the form opens, before the client has touched the stepper.
  static const double initialAmount = 200000;
}

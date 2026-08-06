/// Thousand-separator formatting shared by the order screens' quantity and
/// price displays.
abstract final class NumberFormatting {
  /// `20000` → `'20,000'`.
  static String thousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// `46600.0` → `'46,600.00'`.
  static String currency(double value) {
    final str = value.toStringAsFixed(2);
    final parts = str.split('.');
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${parts[0].replaceAllMapped(reg, (m) => '${m[1]},')}.${parts[1]}';
  }
}

/// Form validators. Each returns a Malay message, or null when valid.
class Validators {
  Validators._();

  static const double maxAmount = 10000000;
  static const int maxQuantity = 100000;

  static String? required(String? v, String field) =>
      (v == null || v.trim().isEmpty) ? '$field diperlukan' : null;

  /// Parses a user-entered decimal (accepts comma thousands, e.g. "1,200.50").
  static double? parseAmount(String? v) {
    if (v == null) return null;
    return double.tryParse(v.trim().replaceAll(',', ''));
  }

  static String? amount(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field diperlukan';
    final n = parseAmount(v);
    if (n == null) return '$field mesti nombor yang sah';
    if (n <= 0) return '$field mesti lebih daripada 0';
    if (n > maxAmount) return '$field terlalu besar';
    if (n != double.parse(n.toStringAsFixed(2))) {
      return '$field maksimum 2 tempat perpuluhan';
    }
    return null;
  }

  static String? quantity(String? v, [String field = 'Kuantiti']) {
    if (v == null || v.trim().isEmpty) return '$field diperlukan';
    final n = int.tryParse(v.trim());
    if (n == null) return '$field mesti nombor bulat';
    if (n <= 0) return '$field mesti lebih daripada 0';
    if (n > maxQuantity) return '$field terlalu besar';
    return null;
  }
}

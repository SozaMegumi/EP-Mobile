/// Small formatting helpers (Malay dates, RM amounts).
class Fmt {
  Fmt._();

  static const _months = [
    'Jan', 'Feb', 'Mac', 'Apr', 'Mei', 'Jun',
    'Jul', 'Ogo', 'Sep', 'Okt', 'Nov', 'Dis',
  ];

  /// "14 Okt 2026"
  static String date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  /// "14 Okt 2026 · 09:05 pagi"
  static String dateTime(DateTime d) {
    final h = d.hour;
    final period = h < 12
        ? 'pagi'
        : h == 12
            ? 'tengah hari'
            : h < 19
                ? 'petang'
                : 'malam';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    final mm = d.minute.toString().padLeft(2, '0');
    return '${date(d)} · ${h12.toString().padLeft(2, '0')}:$mm $period';
  }

  /// "2026-10-14"
  static String isoDay(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// "RM2,308.00"
  static String rm(double v) {
    final fixed = v.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return 'RM$whole.${parts[1]}';
  }

  /// Relative time for notifications.
  static String ago(DateTime created, DateTime now) {
    final diff = now.difference(created);
    if (diff.inMinutes < 1) return 'Baru sahaja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Semalam';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return date(created);
  }
}

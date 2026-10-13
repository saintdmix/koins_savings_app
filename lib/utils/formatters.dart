import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _naira =
      NumberFormat.currency(symbol: '₦', decimalDigits: 0);

  static String naira(num amount) => _naira.format(amount);

  static String greeting([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String date(DateTime d) => DateFormat('d MMM yyyy').format(d);
}

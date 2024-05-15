import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');

final dateFormatter = DateFormat.yMd();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

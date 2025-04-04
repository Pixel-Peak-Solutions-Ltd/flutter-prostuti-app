import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'bn_BD',
  symbol: '৳ ',
  customPattern: "৳ ",
  decimalDigits: 0,
);

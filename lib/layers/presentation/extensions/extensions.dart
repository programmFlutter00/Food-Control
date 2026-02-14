import 'package:intl/intl.dart';

extension StringExtension on String {
  String pickOnlyNumber() {
    return replaceAll(RegExp(r'[^0-9.]'), '');
  }
}
extension NumberToMoney on num? {
  String toMoney() {
    return NumberFormat('###,###').format(this);
  }
}
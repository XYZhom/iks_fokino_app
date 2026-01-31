// lib/utils/helpers.dart
import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date, {bool withTime = false}) {
    if (withTime) {
      return DateFormat('dd.MM.yyyy HH:mm').format(date);
    }
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 2,
    ).format(amount);
  }

  static String formatPhone(String phone) {
    if (phone.length == 10) {
      return '+7 ${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
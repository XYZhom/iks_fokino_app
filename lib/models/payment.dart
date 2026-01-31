import 'package:intl/intl.dart';

class Payment {
  final String id;
  final String accountNumber;
  final DateTime date;
  final double amount;
  final String method; // банковская карта, Сбербанк-онлайн, наличные
  final String status; // completed, pending, failed
  final String? transactionId;

  Payment({
    required this.id,
    required this.accountNumber,
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
  });

  String get formattedDate => DateFormat('dd.MM.yyyy HH:mm').format(date);
  String get formattedAmount => NumberFormat.currency(
        locale: 'ru_RU',
        symbol: '₽',
        decimalDigits: 2,
      ).format(amount);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'date': date.toIso8601String(),
      'amount': amount,
      'method': method,
      'status': status,
      'transactionId': transactionId,
    };
  }
}
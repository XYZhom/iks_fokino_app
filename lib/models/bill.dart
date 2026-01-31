import 'package:intl/intl.dart';

class Bill {
  final String id;
  final String accountNumber;
  final DateTime period;
  final double amount;
  final double? previousBalance;
  final double total;
  final DateTime dueDate;
  final String status; // paid, pending, overdue
  final List<BillItem> items;

  Bill({
    required this.id,
    required this.accountNumber,
    required this.period,
    required this.amount,
    this.previousBalance,
    required this.total,
    required this.dueDate,
    required this.status,
    required this.items,
  });

  String get formattedPeriod => DateFormat('MMMM yyyy', 'ru_RU').format(period);
  String get formattedDueDate => DateFormat('dd.MM.yyyy').format(dueDate);
  String get formattedAmount => NumberFormat.currency(
        locale: 'ru_RU',
        symbol: '₽',
        decimalDigits: 2,
      ).format(amount);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'period': period.toIso8601String(),
      'amount': amount,
      'previousBalance': previousBalance,
      'total': total,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class BillItem {
  final String service;
  final String unit;
  final double consumption;
  final double rate;
  final double amount;

  BillItem({
    required this.service,
    required this.unit,
    required this.consumption,
    required this.rate,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'service': service,
      'unit': unit,
      'consumption': consumption,
      'rate': rate,
      'amount': amount,
    };
  }
}
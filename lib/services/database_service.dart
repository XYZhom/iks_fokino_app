import 'dart:async';
import '../models/bill.dart';
import '../models/meter_reading.dart';
import '../models/payment.dart';

class DatabaseService {
  // В демо-режиме используем данные в памяти
  final List<Bill> _demoBills = [];
  final List<MeterReading> _demoReadings = [];
  final List<Payment> _demoPayments = [];

  Future<void> initialize() async {
    // Инициализируем демо-данные
    _initDemoData();
  }

  void _initDemoData() {
    // Демо счета
    _demoBills.addAll([
      Bill(
        id: 'bill_1',
        accountNumber: '1234567890',
        period: DateTime(2024, 1, 1),
        amount: 3250.75,
        previousBalance: 0,
        total: 3250.75,
        dueDate: DateTime(2024, 2, 10),
        status: 'paid',
        items: [],
      ),
      Bill(
        id: 'bill_2',
        accountNumber: '1234567890',
        period: DateTime(2024, 2, 1),
        amount: 2980.50,
        previousBalance: 0,
        total: 2980.50,
        dueDate: DateTime(2024, 3, 10),
        status: 'pending',
        items: [],
      ),
      Bill(
        id: 'bill_3',
        accountNumber: '1234567890',
        period: DateTime(2023, 12, 1),
        amount: 3560.25,
        previousBalance: 125.50,
        total: 3685.75,
        dueDate: DateTime(2024, 1, 10),
        status: 'overdue',
        items: [],
      ),
    ]);

    // Демо показания
    _demoReadings.addAll([
      MeterReading(
        id: 'reading_1',
        meterNumber: 'ТР-123456',
        serviceType: 'Счетчик отопления',
        previousReading: 120.45,
        currentReading: 125.67,
        readingDate: DateTime(2023, 12, 20),
        submissionDate: DateTime(2023, 12, 20, 10, 30),
        status: 'verified',
      ),
      MeterReading(
        id: 'reading_2',
        meterNumber: 'ВТ-789012',
        serviceType: 'Счетчик ГВС',
        previousReading: 42.15,
        currentReading: 45.23,
        readingDate: DateTime(2023, 12, 20),
        submissionDate: DateTime(2023, 12, 20, 10, 32),
        status: 'verified',
      ),
    ]);

    // Демо платежи
    _demoPayments.addAll([
      Payment(
        id: 'payment_1',
        accountNumber: '1234567890',
        date: DateTime(2024, 1, 15, 14, 30),
        amount: 3250.75,
        method: 'Банковская карта',
        status: 'completed',
        transactionId: 'TXN123456',
      ),
      Payment(
        id: 'payment_2',
        accountNumber: '1234567890',
        date: DateTime(2023, 12, 5, 9, 15),
        amount: 3560.25,
        method: 'Сбербанк-Онлайн',
        status: 'completed',
        transactionId: 'TXN789012',
      ),
      Payment(
        id: 'payment_3',
        accountNumber: '1234567890',
        date: DateTime(2024, 2, 20, 16, 45),
        amount: 1500.00,
        method: 'Банковская карта',
        status: 'pending',
        transactionId: 'TXN345678',
      ),
    ]);
  }

  // Методы для работы со счетами
  Future<List<Bill>> getBills(String accountNumber) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Имитация задержки
    return _demoBills.where((bill) => bill.accountNumber == accountNumber).toList();
  }

  // Методы для работы с показаниями
  Future<void> submitMeterReading(MeterReading reading) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _demoReadings.insert(0, reading);
  }

  Future<List<MeterReading>> getMeterReadings(String meterNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoReadings.where((reading) => reading.meterNumber == meterNumber).toList();
  }

  // Методы для работы с платежами
  Future<List<Payment>> getPayments(String accountNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoPayments.where((payment) => payment.accountNumber == accountNumber).toList();
  }

  Future<void> close() async {
    // Ничего не делаем в демо-режиме
  }
}

extension DatabaseServiceExtension on DatabaseService {
  Future<void> initialize() async {
    await initialize();
  }
}
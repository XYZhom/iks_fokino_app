import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iks_fokino_app/models/bill.dart';
import 'package:iks_fokino_app/models/meter_reading.dart';
import 'package:iks_fokino_app/models/payment.dart';
import 'package:iks_fokino_app/models/user.dart';

class ApiService {
  // В демо-режиме имитируем работу с сервером
  static const String _baseUrl = 'https://demo.iks-fokino.ru/api';
  
  // Токен авторизации (в демо-режиме статический)
  String _token = 'demo_token_123456';
  
  // Имитация задержки сети
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  // Авторизация по телефону
  Future<Map<String, dynamic>> loginWithPhone(String phone) async {
    await _simulateNetworkDelay();
    
    if (phone.length >= 10) {
      return {
        'success': true,
        'message': 'SMS отправлен',
        'retryDelay': 60,
      };
    } else {
      throw Exception('Неверный формат номера телефона');
    }
  }
  
  // Подтверждение OTP
  Future<User> verifyOTP(String phone, String otp) async {
    await _simulateNetworkDelay();
    
    if (otp == '123456') {
      // Возвращаем демо-пользователя
      return User(
        id: 1,
        phone: phone,
        name: 'Иванов Иван Иванович',
        email: 'user@example.com',
        address: 'г. Фокино, ул. Ленина, д. 10, кв. 25',
        accountNumber: '1234567890',
      );
    } else {
      throw Exception('Неверный код подтверждения');
    }
  }
  
  // Получение списка счетов
  Future<List<Bill>> getBills(String accountNumber) async {
    await _simulateNetworkDelay();
    
    // Демо-данные
    return [
      Bill(
        id: 'bill_1',
        accountNumber: accountNumber,
        period: DateTime(2024, 1, 1),
        amount: 3250.75,
        previousBalance: 0,
        total: 3250.75,
        dueDate: DateTime(2024, 2, 10),
        status: 'paid',
        items: [
          BillItem(
            service: 'Отопление',
            unit: 'Гкал',
            consumption: 1.5,
            rate: 1200.50,
            amount: 1800.75,
          ),
          BillItem(
            service: 'ГВС',
            unit: 'м³',
            consumption: 5.2,
            rate: 150.25,
            amount: 781.30,
          ),
        ],
      ),
      Bill(
        id: 'bill_2',
        accountNumber: accountNumber,
        period: DateTime(2024, 2, 1),
        amount: 2980.50,
        previousBalance: 125.50,
        total: 3106.00,
        dueDate: DateTime(2024, 3, 10),
        status: 'pending',
        items: [],
      ),
    ];
  }
  
  // Получение детальной информации о счете
  Future<Bill> getBillDetails(String billId) async {
    await _simulateNetworkDelay();
    
    return Bill(
      id: billId,
      accountNumber: '1234567890',
      period: DateTime(2024, 1, 1),
      amount: 3250.75,
      previousBalance: 0,
      total: 3250.75,
      dueDate: DateTime(2024, 2, 10),
      status: 'paid',
      items: [
        BillItem(
          service: 'Отопление',
          unit: 'Гкал',
          consumption: 1.5,
          rate: 1200.50,
          amount: 1800.75,
        ),
        BillItem(
          service: 'Горячее водоснабжение',
          unit: 'м³',
          consumption: 5.2,
          rate: 150.25,
          amount: 781.30,
        ),
        BillItem(
          service: 'Холодное водоснабжение',
          unit: 'м³',
          consumption: 3.8,
          rate: 80.50,
          amount: 305.90,
        ),
        BillItem(
          service: 'Обслуживание',
          unit: 'мес.',
          consumption: 1,
          rate: 363.80,
          amount: 363.80,
        ),
      ],
    );
  }
  
  // Отправка показаний счетчиков
  Future<bool> submitMeterReadings(List<MeterReading> readings) async {
    await _simulateNetworkDelay();
    
    // Демо-логика: всегда успешно
    return true;
  }
  
  // Получение истории показаний
  Future<List<MeterReading>> getMeterReadingsHistory(String meterNumber) async {
    await _simulateNetworkDelay();
    
    return [
      MeterReading(
        id: '1',
        meterNumber: meterNumber,
        serviceType: 'Отопление',
        previousReading: 120.45,
        currentReading: 125.67,
        readingDate: DateTime(2023, 12, 20),
        submissionDate: DateTime(2023, 12, 20, 10, 30),
        status: 'verified',
      ),
      MeterReading(
        id: '2',
        meterNumber: meterNumber,
        serviceType: 'ГВС',
        previousReading: 42.15,
        currentReading: 45.23,
        readingDate: DateTime(2023, 12, 20),
        submissionDate: DateTime(2023, 12, 20, 10, 32),
        status: 'verified',
      ),
    ];
  }
  
  // Получение истории платежей
  Future<List<Payment>> getPaymentHistory(String accountNumber) async {
    await _simulateNetworkDelay();
    
    return [
      Payment(
        id: '1',
        accountNumber: accountNumber,
        date: DateTime(2024, 1, 15, 14, 30),
        amount: 3250.75,
        method: 'Банковская карта',
        status: 'completed',
        transactionId: 'TXN123456',
      ),
      Payment(
        id: '2',
        accountNumber: accountNumber,
        date: DateTime(2023, 12, 5, 9, 15),
        amount: 3560.25,
        method: 'Сбербанк-Онлайн',
        status: 'completed',
        transactionId: 'TXN789012',
      ),
    ];
  }
  
  // Инициирование платежа
  Future<Map<String, dynamic>> initiatePayment({
    required String accountNumber,
    required double amount,
    required String method,
  }) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'transactionId': 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      'paymentUrl': 'https://demo-payment.iks-fokino.ru/pay/123',
    };
  }
  
  // Создание заявки
  Future<Map<String, dynamic>> createRequest({
    required String type,
    required String description,
    required String address,
    required String contactPhone,
  }) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'requestId': 'REQ_${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Заявка создана. Номер: REQ_${DateTime.now().millisecondsSinceEpoch}',
    };
  }
  
  // Получение статуса заявок
  Future<List<Map<String, dynamic>>> getRequests() async {
    await _simulateNetworkDelay();
    
    return [
      {
        'id': '1',
        'type': 'Аварийная служба',
        'description': 'Протечка в подвале',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'В работе',
        'priority': 'Высокий',
      },
      {
        'id': '2',
        'type': 'Техническое обслуживание',
        'description': 'Проверка счетчиков',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Завершено',
        'priority': 'Средний',
      },
    ];
  }
  
  // Получение новостей
  Future<List<Map<String, dynamic>>> getNews() async {
    await _simulateNetworkDelay();
    
    return [
      {
        'id': '1',
        'title': 'Отключение горячей воды',
        'content': 'С 15 по 20 января плановое отключение ГВС',
        'date': DateTime(2024, 1, 10),
        'important': true,
      },
      {
        'id': '2',
        'title': 'Новые тарифы',
        'content': 'С 1 января вводятся новые тарифы на отопление',
        'date': DateTime(2023, 12, 28),
        'important': false,
      },
    ];
  }
}
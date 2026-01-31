import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bill.dart';
import '../models/meter_reading.dart';
import '../models/payment.dart';

class DatabaseService {
  static const _databaseName = 'iks_fokino.db';
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Таблица счетов
    await db.execute('''
      CREATE TABLE bills (
        id TEXT PRIMARY KEY,
        accountNumber TEXT,
        period TEXT,
        amount REAL,
        previousBalance REAL,
        total REAL,
        dueDate TEXT,
        status TEXT
      )
    ''');

    // Таблица показаний счетчиков
    await db.execute('''
      CREATE TABLE meter_readings (
        id TEXT PRIMARY KEY,
        meterNumber TEXT,
        serviceType TEXT,
        previousReading REAL,
        currentReading REAL,
        readingDate TEXT,
        submissionDate TEXT,
        status TEXT
      )
    ''');

    // Таблица платежей
    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        accountNumber TEXT,
        date TEXT,
        amount REAL,
        method TEXT,
        status TEXT,
        transactionId TEXT
      )
    ''');

    // Загружаем демо-данные
    await _loadDemoData(db);
  }

  Future<void> _loadDemoData(Database db) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/demo_data.json');
      final data = jsonDecode(jsonString);

      // Загружаем счета
      for (var billData in data['bills']) {
        await db.insert('bills', billData);
      }

      // Загружаем показания
      for (var readingData in data['meter_readings']) {
        await db.insert('meter_readings', readingData);
      }

      // Загружаем платежи
      for (var paymentData in data['payments']) {
        await db.insert('payments', paymentData);
      }
    } catch (e) {
      print('Ошибка загрузки демо-данных: $e');
    }
  }

  // Методы для работы со счетами
  Future<List<Bill>> getBills(String accountNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bills',
      where: 'accountNumber = ?',
      whereArgs: [accountNumber],
      orderBy: 'period DESC',
    );

    return maps.map((map) {
      return Bill(
        id: map['id'],
        accountNumber: map['accountNumber'],
        period: DateTime.parse(map['period']),
        amount: map['amount'],
        previousBalance: map['previousBalance'],
        total: map['total'],
        dueDate: DateTime.parse(map['dueDate']),
        status: map['status'],
        items: [], // Для упрощения, в демо-версии не загружаем детализацию
      );
    }).toList();
  }

  // Методы для работы с показаниями
  Future<void> submitMeterReading(MeterReading reading) async {
    final db = await database;
    await db.insert('meter_readings', reading.toMap());
  }

  Future<List<MeterReading>> getMeterReadings(String meterNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meter_readings',
      where: 'meterNumber = ?',
      whereArgs: [meterNumber],
      orderBy: 'readingDate DESC',
    );

    return maps.map((map) {
      return MeterReading(
        id: map['id'],
        meterNumber: map['meterNumber'],
        serviceType: map['serviceType'],
        previousReading: map['previousReading'],
        currentReading: map['currentReading'],
        readingDate: DateTime.parse(map['readingDate']),
        submissionDate: DateTime.parse(map['submissionDate']),
        status: map['status'],
      );
    }).toList();
  }

  // Методы для работы с платежами
  Future<List<Payment>> getPayments(String accountNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'accountNumber = ?',
      whereArgs: [accountNumber],
      orderBy: 'date DESC',
    );

    return maps.map((map) {
      return Payment(
        id: map['id'],
        accountNumber: map['accountNumber'],
        date: DateTime.parse(map['date']),
        amount: map['amount'],
        method: map['method'],
        status: map['status'],
        transactionId: map['transactionId'],
      );
    }).toList();
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}

extension DatabaseServiceExtension on DatabaseService {
  Future<void> initialize() async {
    await database; // Инициализируем базу данных
  }
}
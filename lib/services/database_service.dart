import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bill.dart';
import '../models/meter_reading.dart';
import '../models/payment.dart';

class DatabaseService {
  static const _databaseName = 'iks_fokino.db';
  static const _databaseVersion = 2; // Увеличили версию для миграции

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
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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

    // Таблица заявок
    await db.execute('''
      CREATE TABLE requests (
        id TEXT PRIMARY KEY,
        type TEXT,
        description TEXT,
        address TEXT,
        contactPhone TEXT,
        date TEXT,
        status TEXT,
        priority TEXT
      )
    ''');

    // Таблица счетов (демо-данные)
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

    // Таблица платежей (демо-данные)
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

    // Заполняем демо-данными
    await _seedDemoData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Добавляем таблицы, если их нет
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _seedDemoData(Database db) async {
    // Демо счета
    final demoBills = [
      {
        'id': 'bill_1',
        'accountNumber': '1234567890',
        'period': DateTime(2024, 1, 1).toIso8601String(),
        'amount': 3250.75,
        'previousBalance': 0,
        'total': 3250.75,
        'dueDate': DateTime(2024, 2, 10).toIso8601String(),
        'status': 'paid',
      },
      {
        'id': 'bill_2',
        'accountNumber': '1234567890',
        'period': DateTime(2024, 2, 1).toIso8601String(),
        'amount': 2980.50,
        'previousBalance': 0,
        'total': 2980.50,
        'dueDate': DateTime(2024, 3, 10).toIso8601String(),
        'status': 'pending',
      },
    ];

    for (var bill in demoBills) {
      await db.insert('bills', bill);
    }

    // Демо платежи
    final demoPayments = [
      {
        'id': 'payment_1',
        'accountNumber': '1234567890',
        'date': DateTime(2024, 1, 15, 14, 30).toIso8601String(),
        'amount': 3250.75,
        'method': 'Банковская карта',
        'status': 'completed',
        'transactionId': 'TXN123456',
      },
      {
        'id': 'payment_2',
        'accountNumber': '1234567890',
        'date': DateTime(2023, 12, 5, 9, 15).toIso8601String(),
        'amount': 3560.25,
        'method': 'Сбербанк-Онлайн',
        'status': 'completed',
        'transactionId': 'TXN789012',
      },
    ];

    for (var payment in demoPayments) {
      await db.insert('payments', payment);
    }
  }

  // === Методы для работы с показаниями ===
  Future<void> saveMeterReading(MeterReading reading) async {
    final db = await database;
    await db.insert(
      'meter_readings',
      reading.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  // === Методы для работы с заявками ===
  Future<void> saveRequest(Map<String, dynamic> request) async {
    final db = await database;
    await db.insert(
      'requests',
      request,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRequests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'requests',
      orderBy: 'date DESC',
    );
    return maps;
  }

  // === Методы для работы со счетами ===
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
        items: [],
      );
    }).toList();
  }

  // === Методы для работы с платежами ===
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
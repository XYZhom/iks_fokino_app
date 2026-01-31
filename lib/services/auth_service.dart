import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> loginWithPhone(String phone) async {
    // Имитация API запроса
    await Future.delayed(const Duration(seconds: 1));
    
    // Демо-логика: любой номер принимается
    if (phone.length >= 10) {
      return true;
    }
    return false;
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    // Демо-логика: OTP 123456 для любого номера
    if (otp == '123456') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phone);
      await prefs.setBool('isLoggedIn', true);
      
      // Создаем демо-пользователя
      _currentUser = User(
        id: 1,
        phone: phone,
        name: 'Иванов Иван Иванович',
        email: 'user@example.com',
        address: 'г. Фокино, ул. Ленина, д. 10, кв. 25',
        accountNumber: '1234567890',
      );
      
      return true;
    }
    return false;
  }

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final phone = prefs.getString('phone');
    
    if (isLoggedIn && phone != null) {
      _currentUser = User(
        id: 1,
        phone: phone,
        name: 'Иванов Иван Иванович',
        email: 'user@example.com',
        address: 'г. Фокино, ул. Ленина, д. 10, кв. 25',
        accountNumber: '1234567890',
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
  }
}
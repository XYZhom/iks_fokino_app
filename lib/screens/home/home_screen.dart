import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/user.dart';
import 'package:iks_fokino_app/screens/bills/bills_screen.dart';
import 'package:iks_fokino_app/screens/bills/meter_reading_screen.dart';
import 'package:iks_fokino_app/screens/payments/payment_history_screen.dart';
import 'package:iks_fokino_app/screens/requests/requests_screen.dart';
import 'package:iks_fokino_app/screens/auth/login_screen.dart';
import 'package:iks_fokino_app/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  User? _user;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _user = _authService.currentUser;
  }

  final List<Widget> _screens = [
    const BillsScreen(),
    const PaymentHistoryScreen(),
    const MeterReadingScreen(),
    const RequestsScreen(),
  ];

  final List<String> _titles = [
    'Мои счета',
    'Платежи',
    'Показания',
    'Заявки',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Ошибка при выходе: $e');
    }
  }

  void _showComingSoonDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Данный раздел находится в разработке. '
            'В будущих версиях приложения функционал будет добавлен.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ИКС Фокино - Личный кабинет потребителя',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text('Версия: 1.0.0 (Демо)'),
              Text('Разработчик: ИКС-Фокино'),
              SizedBox(height: 10),
              Text(
                'Приложение для управления услугами теплоснабжения '
                'и горячего водоснабжения на территории ЗАТО Фокино.',
              ),
              SizedBox(height: 10),
              Text('© 2024 ИКС-Фокино. Все права защищены.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showContactsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Контакты'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ООО «ИКС – Фокино»',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Телефон: +7 4233 927 927'),
              Text('Адрес: г. Фокино, Приморский край'),
              SizedBox(height: 10),
              Text('Часы работы:'),
              Text('Пн-Пт: 9:00-18:00'),
              Text('Сб: 9:00-14:00'),
              Text('Вс: выходной'),
              SizedBox(height: 10),
              Text('Аварийная служба: круглосуточно'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.gray,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Счета',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Платежи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Показания',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_quote),
            label: 'Заявки',
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_user?.name ?? 'Пользователь'),
              accountEmail: Text(_user?.phone ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                child: Text(
                  _user?.name.isNotEmpty == true ? _user!.name.substring(0, 1) : 'П',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Личные данные'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Личные данные');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Объекты'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Объекты');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Настройки'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Настройки');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('О приложении'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Контакты'),
              subtitle: const Text('+7 4233 927 927'),
              onTap: () {
                Navigator.pop(context);
                _showContactsDialog(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Версия 1.0.0 • Демо-режим',
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
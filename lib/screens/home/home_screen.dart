// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/user.dart';
import 'package:iks_fokino_app/screens/bills/bills_screen.dart';
import 'package:iks_fokino_app/screens/bills/meter_reading_screen.dart';
import 'package:iks_fokino_app/screens/payments/payment_history_screen.dart';
import 'package:iks_fokino_app/screens/requests/requests_screen.dart';
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
    const BillsScreen(), // ← Теперь правильно
    const PaymentHistoryScreen(),
    const MeterReadingScreen(),
    const RequestsScreen(),
  ];

  // ... остальной код без изменений ...

  final List<String> _titles = [
    'Мои счета',
    'Платежи',
    'Показания',
    'Заявки',
  ];

  final List<IconData> _icons = [
    Icons.receipt,
    Icons.payments,
    Icons.speed,
    Icons.request_quote,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.payments),
            label: _titles[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.speed),
            label: _titles[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.request_quote),
            label: _titles[3],
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
                  _user?.name.substring(0, 1) ?? 'П',
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
                // Реализация экрана личных данных
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Объекты'),
              onTap: () {
                // Реализация экрана объектов
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Настройки'),
              onTap: () {
                // Реализация экрана настроек
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('О приложении'),
              onTap: () {
                // Реализация экрана "О приложении"
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Контакты'),
              subtitle: const Text('+7 4233 927 927'),
              onTap: () {
                // Реализация экрана контактов
              },
            ),
          ],
        ),
      ),
    );
  }
}
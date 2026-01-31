import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iks_fokino_app/constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoLoginEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'ru';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _autoLoginEnabled = prefs.getBool('autoLogin') ?? true;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      _language = prefs.getString('language') ?? 'ru';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Уведомления'),
          _buildSwitchSetting(
            'Push-уведомления',
            'Получать уведомления о новых счетах',
            _notificationsEnabled,
            (value) {
              setState(() => _notificationsEnabled = value);
              _saveSetting('notifications', value);
            },
          ),
          _buildSectionHeader('Безопасность'),
          _buildSwitchSetting(
            'Автоматический вход',
            'Сохранять сессию',
            _autoLoginEnabled,
            (value) {
              setState(() => _autoLoginEnabled = value);
              _saveSetting('autoLogin', value);
            },
          ),
          _buildSectionHeader('Внешний вид'),
          _buildSwitchSetting(
            'Темная тема',
            'Включить темный режим',
            _darkModeEnabled,
            (value) {
              setState(() => _darkModeEnabled = value);
              _saveSetting('darkMode', value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? 'Темная тема включена' : 'Темная тема выключена',
                  ),
                ),
              );
            },
          ),
          _buildLanguageSetting(),
          _buildSectionHeader('Данные приложения'),
          _buildListTile(
            Icons.storage,
            'Использование памяти',
            '12.5 МБ',
            () {
              _showStorageDialog(context);
            },
          ),
          _buildListTile(
            Icons.delete,
            'Очистить кэш',
            'Удалить временные файлы',
            () {
              _clearCache(context);
            },
            color: AppColors.errorRed,
          ),
          _buildSectionHeader('О приложении'),
          _buildListTile(
            Icons.info,
            'Версия приложения',
            '1.0.0',
            () {},
          ),
          _buildListTile(
            Icons.update,
            'Проверить обновления',
            'Последняя версия',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('У вас установлена последняя версия'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGray,
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryBlue,
    );
  }

  Widget _buildLanguageSetting() {
    return ListTile(
      title: const Text('Язык'),
      subtitle: const Text('Русский'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Выберите язык'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('Русский'),
                  value: 'ru',
                  groupValue: _language,
                  onChanged: (value) {
                    setState(() => _language = value!);
                    _saveSetting('language', value);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: const Text('Английский'),
                  value: 'en',
                  groupValue: _language,
                  onChanged: (value) {
                    setState(() => _language = value!);
                    _saveSetting('language', value);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color color = AppColors.darkGray,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Использование памяти'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Данные приложения'),
              trailing: Text('8.2 МБ'),
            ),
            ListTile(
              title: Text('Кэш'),
              trailing: Text('4.3 МБ'),
            ),
            ListTile(
              title: Text('Всего'),
              trailing: Text('12.5 МБ'),
            ),
          ],
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

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистка кэша'),
        content: const Text('Вы уверены, что хотите очистить кэш приложения?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Кэш очищен'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }
}
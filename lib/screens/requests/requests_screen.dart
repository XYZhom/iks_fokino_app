import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:intl/intl.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<Map<String, dynamic>> _requests = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedType = 'Консультация';

  final List<String> _requestTypes = [
    'Аварийная служба',
    'Техническое обслуживание',
    'Консультация',
    'Жалоба',
    'Предложение',
  ];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    // Демо-заявки
    _requests = [
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
      {
        'id': '3',
        'type': 'Консультация',
        'description': 'Вопрос по начислению платежей',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'Новый',
        'priority': 'Низкий',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Информационный блок
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightBlue,
            child: const Row(
              children: [
                Icon(
                  Icons.phone,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Аварийная служба',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('+7 4233 927 927 (круглосуточно)'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: AppColors.gray,
                    tabs: [
                      Tab(text: 'Мои заявки'),
                      Tab(text: 'Создать заявку'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Вкладка с существующими заявками
                        _buildRequestsList(),

                        // Вкладка создания новой заявки
                        _buildNewRequestForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadRequests();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(request['priority']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getRequestIcon(request['type']),
                  color: _getPriorityColor(request['priority']),
                ),
              ),
              title: Text(request['type']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request['description']),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(request['date']),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(request['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request['status'],
                  style: TextStyle(
                    color: _getStatusColor(request['status']),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewRequestForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Новая заявка',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 20),

          // Тип заявки
          const Text('Тип заявки'),
          DropdownButtonFormField<String>(
            value: _selectedType,
            items: _requestTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          // Адрес
          const Text('Адрес объекта'),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: 'г. Фокино, ул. Ленина, д. 10, кв. 25',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          // Описание
          const Text('Описание проблемы'),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Подробно опишите проблему...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          // Контактный телефон
          const Text('Контактный телефон'),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: '+7 ___ ___ __ __',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          // Кнопка отправки
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_descriptionController.text.isEmpty || 
                    _addressController.text.isEmpty || 
                    _phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Заполните все поля'),
                      backgroundColor: AppColors.warningOrange,
                    ),
                  );
                  return;
                }

                final newRequest = {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'type': _selectedType,
                  'description': _descriptionController.text,
                  'address': _addressController.text,
                  'contactPhone': _phoneController.text,
                  'date': DateTime.now(),
                  'status': 'Новый',
                  'priority': _getPriorityByType(_selectedType),
                };

                setState(() {
                  _requests.insert(0, newRequest);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Заявка успешно создана'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );

                // Очищаем поля
                _descriptionController.clear();
                _addressController.clear();
                _phoneController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Создать заявку',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRequestIcon(String type) {
    switch (type) {
      case 'Аварийная служба':
        return Icons.warning;
      case 'Техническое обслуживание':
        return Icons.build;
      case 'Консультация':
        return Icons.help;
      default:
        return Icons.message;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Высокий':
        return AppColors.errorRed;
      case 'Средний':
        return AppColors.warningOrange;
      case 'Низкий':
        return AppColors.successGreen;
      default:
        return AppColors.gray;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Новый':
        return AppColors.primaryBlue;
      case 'В работе':
        return AppColors.warningOrange;
      case 'Завершено':
        return AppColors.successGreen;
      default:
        return AppColors.gray;
    }
  }

  String _getPriorityByType(String type) {
    switch (type) {
      case 'Аварийная служба':
        return 'Высокий';
      case 'Техническое обслуживание':
        return 'Средний';
      default:
        return 'Низкий';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
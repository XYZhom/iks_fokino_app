import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';

class ObjectsScreen extends StatefulWidget {
  const ObjectsScreen({super.key});

  @override
  State<ObjectsScreen> createState() => _ObjectsScreenState();
}

class _ObjectsScreenState extends State<ObjectsScreen> {
  final List<Map<String, dynamic>> _objects = [
    {
      'id': '1',
      'address': 'г. Фокино, ул. Ленина, д. 10, кв. 25',
      'type': 'Квартира',
      'area': '65 м²',
      'residents': 3,
      'accountNumber': '1234567890',
      'services': ['Отопление', 'ГВС', 'ХВС'],
    },
    {
      'id': '2',
      'address': 'г. Фокино, ул. Садовая, д. 15, кв. 42',
      'type': 'Квартира',
      'area': '48 м²',
      'residents': 2,
      'accountNumber': '1234567891',
      'services': ['Отопление', 'ГВС', 'ХВС'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои объекты'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _objects.length,
        itemBuilder: (context, index) {
          final object = _objects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        object['type'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Основной',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    object['address'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(Icons.area_chart, object['area']),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.people, '${object['residents']} чел.'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.receipt, object['accountNumber']),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Подключенные услуги:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (object['services'] as List<String>)
                        .map((service) => Chip(
                              label: Text(service),
                              backgroundColor: AppColors.lightBlue,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Переключение на объект
                      },
                      child: const Text('Выбрать основным'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddObjectDialog(context);
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      backgroundColor: AppColors.lightBlue,
    );
  }

  void _showAddObjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить объект'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Адрес',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Лицевой счет',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Площадь (м²)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
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
                  content: Text('Объект добавлен'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
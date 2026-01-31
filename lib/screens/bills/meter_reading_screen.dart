import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/meter_reading.dart';
import 'package:iks_fokino_app/widgets/meter_input_widget.dart';
import 'package:intl/intl.dart';

class MeterReadingScreen extends StatefulWidget {
  const MeterReadingScreen({super.key});

  @override
  _MeterReadingScreenState createState() => _MeterReadingScreenState();
}

class _MeterReadingScreenState extends State<MeterReadingScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, double> _previousReadings = {};
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _meters = [];
  List<MeterReading> _history = [];

  @override
  void initState() {
    super.initState();
    _initializeMeters();
    _loadHistory();
  }

  void _initializeMeters() {
    _meters = [
      {
        'id': 'heat_1',
        'name': 'Счетчик отопления',
        'number': 'ТР-123456',
        'unit': 'Гкал',
        'previous': 125.67,
      },
      {
        'id': 'hot_water_1',
        'name': 'Счетчик ГВС',
        'number': 'ВТ-789012',
        'unit': 'м³',
        'previous': 45.23,
      },
      {
        'id': 'cold_water_1',
        'name': 'Счетчик ХВС',
        'number': 'ВХ-345678',
        'unit': 'м³',
        'previous': 89.15,
      },
    ];

    for (var meter in _meters) {
      _controllers[meter['id']] = TextEditingController();
      _previousReadings[meter['id']] = meter['previous'];
    }
  }

  Future<void> _loadHistory() async {
    // Демо-данные вместо реальной БД
    await Future.delayed(const Duration(milliseconds: 300));
    
    final demoHistory = [
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
    ];

    setState(() {
      _history = demoHistory;
    });
  }

  Future<void> _submitReadings() async {
    // Проверяем, что все поля заполнены
    for (var controller in _controllers.values) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заполните показания для всех счетчиков'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    final now = DateTime.now();

    try {
      final newReadings = <MeterReading>[];

      for (var meter in _meters) {
        final controller = _controllers[meter['id']]!;
        final currentReading = double.tryParse(controller.text) ?? 0;

        if (currentReading < _previousReadings[meter['id']]!) {
          // Показания не могут быть меньше предыдущих
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Ошибка ввода'),
                content: Text(
                  'Текущие показания не могут быть меньше предыдущих (${_previousReadings[meter['id']]})',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          setState(() => _isSubmitting = false);
          return;
        }

        final reading = MeterReading(
          id: '${meter['id']}_${now.millisecondsSinceEpoch}',
          meterNumber: meter['number'],
          serviceType: meter['name'],
          previousReading: _previousReadings[meter['id']]!,
          currentReading: currentReading,
          readingDate: now,
          submissionDate: now,
          status: 'submitted',
        );

        newReadings.add(reading);
        
        // Обновляем предыдущие показания для следующего месяца
        _previousReadings[meter['id']] = currentReading;
      }

      // Добавляем новые показания в историю
      setState(() {
        _history.insertAll(0, newReadings);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Показания успешно отправлены'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        // Очищаем поля
        for (var controller in _controllers.values) {
          controller.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Информация о текущем периоде
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightBlue,
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Срок подачи показаний: с 15 по 25 число каждого месяца',
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ввод показаний счетчиков',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Форма ввода показаний
                  for (var meter in _meters)
                    MeterInputWidget(
                      meterName: meter['name'],
                      meterNumber: meter['number'],
                      unit: meter['unit'],
                      previousReading: meter['previous'],
                      controller: _controllers[meter['id']]!,
                    ),

                  const SizedBox(height: 20),

                  // Кнопка отправки
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReadings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Отправить показания',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // История показаний
                  const Text(
                    'История показаний',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (_history.isEmpty)
                    const Center(
                      child: Text('Нет отправленных показаний'),
                    )
                  else
                    ..._history.map((reading) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(reading.serviceType),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Показания: ${reading.previousReading} → ${reading.currentReading} ${_meters.firstWhere((m) => m['number'] == reading.meterNumber)['unit']}',
                              ),
                              Text(
                                'Дата: ${reading.formattedSubmissionDate}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: reading.status == 'verified'
                                  ? AppColors.successGreen.withOpacity(0.1)
                                  : AppColors.warningOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              reading.status == 'verified'
                                  ? 'Проверено'
                                  : 'На проверке',
                              style: TextStyle(
                                color: reading.status == 'verified'
                                    ? AppColors.successGreen
                                    : AppColors.warningOrange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
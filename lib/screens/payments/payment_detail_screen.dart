import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/payment.dart';
import 'package:intl/intl.dart';

class PaymentDetailScreen extends StatelessWidget {
  final Payment payment;

  const PaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали платежа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка с основной информацией
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Сумма:',
                          style: TextStyle(
                            color: AppColors.gray,
                          ),
                        ),
                        Text(
                          payment.formattedAmount,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Статус', _getStatusText(payment.status),
                        _getStatusColor(payment.status)),
                    _buildDetailRow('Дата и время', payment.formattedDate),
                    _buildDetailRow('Способ оплаты', payment.method),
                    if (payment.transactionId != null)
                      _buildDetailRow('Номер транзакции', payment.transactionId!),
                    _buildDetailRow('ЛС', payment.accountNumber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Дополнительная информация
            const Text(
              'Дополнительная информация',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Комиссия', '0 ₽'),
                    const Divider(),
                    _buildInfoRow('Итого к зачислению', payment.formattedAmount),
                    const Divider(),
                    _buildInfoRow('Время обработки', '1-2 рабочих дня'),
                    const Divider(),
                    _buildInfoRow('Получатель', 'ООО «ИКС – Фокино»'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Действия
            if (payment.status == 'pending')
              Column(
                children: [
                  const Text(
                    'Платеж находится в обработке',
                    style: TextStyle(
                      color: AppColors.warningOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Отмена платежа
                      },
                      child: const Text('Отменить платеж'),
                    ),
                  ),
                ],
              ),
            if (payment.status == 'failed')
              Column(
                children: [
                  const Text(
                    'Платеж не прошел',
                    style: TextStyle(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Повтор платежа
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                      child: const Text('Повторить платеж'),
                    ),
                  ),
                ],
              ),
            if (payment.status == 'completed')
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.successGreen),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Платеж успешно завершен. Квитанция отправлена на email.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Скачать квитанцию
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Скачать квитанцию'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.gray,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Успешно';
      case 'pending':
        return 'В обработке';
      case 'failed':
        return 'Ошибка';
      default:
        return 'Неизвестно';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.successGreen;
      case 'pending':
        return AppColors.warningOrange;
      case 'failed':
        return AppColors.errorRed;
      default:
        return AppColors.gray;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/bill.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends StatelessWidget {
  final Bill bill;

  const BillDetailScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Счет за ${bill.formattedPeriod}'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Общая информация о счете
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Период:',
                              style: TextStyle(
                                color: AppColors.gray,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              bill.formattedPeriod,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(bill.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(bill.status),
                            style: TextStyle(
                              color: _getStatusColor(bill.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Сумма к оплате:',
                              style: TextStyle(
                                color: AppColors.gray,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              currencyFormat.format(bill.amount),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (bill.previousBalance != null &&
                        bill.previousBalance! > 0)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Задолженность:',
                                style: TextStyle(
                                  color: AppColors.gray,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                currencyFormat.format(bill.previousBalance!),
                                style: const TextStyle(
                                  color: AppColors.errorRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итого к оплате:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          currencyFormat.format(bill.total),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Срок оплаты:',
                              style: TextStyle(
                                color: AppColors.gray,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              bill.formattedDueDate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'ЛС:',
                              style: TextStyle(
                                color: AppColors.gray,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              bill.accountNumber,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Детализация услуг
            const Text(
              'Детализация услуг',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildServiceRow(
                      'Отопление',
                      '1.5 Гкал',
                      '1,200.50 ₽/Гкал',
                      '1,800.75 ₽',
                    ),
                    const Divider(),
                    _buildServiceRow(
                      'Горячее водоснабжение',
                      '5.2 м³',
                      '150.25 ₽/м³',
                      '781.30 ₽',
                    ),
                    const Divider(),
                    _buildServiceRow(
                      'Холодное водоснабжение',
                      '3.8 м³',
                      '80.50 ₽/м³',
                      '305.90 ₽',
                    ),
                    const Divider(),
                    _buildServiceRow(
                      'Обслуживание',
                      '1 мес.',
                      '363.80 ₽/мес.',
                      '363.80 ₽',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Кнопки действий
            if (bill.status != 'paid')
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showPaymentOptions(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Оплатить счет',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _downloadBill(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: AppColors.primaryBlue),
                      ),
                      child: const Text(
                        'Скачать счет (PDF)',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Информация о перерасчетах
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Счет формируется на основе показаний счетчиков\n'
                    '• Оплата принимается до 10 числа следующего месяца\n'
                    '• При наличии задолженности начисляется пеня 0.1% в день\n'
                    '• Вопросы по начислениям: +7 4233 927 927',
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRow(
    String service,
    String consumption,
    String rate,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  consumption,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
                Text(
                  rate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.successGreen;
      case 'overdue':
        return AppColors.errorRed;
      case 'pending':
        return AppColors.warningOrange;
      default:
        return AppColors.gray;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'Оплачен';
      case 'overdue':
        return 'Просрочен';
      case 'pending':
        return 'К оплате';
      default:
        return 'Неизвестно';
    }
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Способы оплаты',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.credit_card, color: AppColors.primaryBlue),
                  title: const Text('Банковская карта'),
                  onTap: () {
                    Navigator.pop(context);
                    _processCardPayment(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance, color: AppColors.primaryBlue),
                  title: const Text('Сбербанк-Онлайн'),
                  onTap: () {
                    Navigator.pop(context);
                    _processSberPayment(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.qr_code, color: AppColors.primaryBlue),
                  title: const Text('По QR-коду'),
                  onTap: () {
                    Navigator.pop(context);
                    _showQRCode(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processCardPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оплата картой'),
        content: const Text('Демо-режим: оплата успешно проведена'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _processSberPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сбербанк-Онлайн'),
        content: const Text('Демо-режим: редирект на страницу Сбербанка'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    final qrText = '[QR-CODE]\n\nСумма: ${bill.total} ₽\nЛС: ${bill.accountNumber}';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR-код для оплаты'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  qrText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Отсканируйте QR-код в банковском приложении',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
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

  void _downloadBill(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Счет сохранен в галерее'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }
}
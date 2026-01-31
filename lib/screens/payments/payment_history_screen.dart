import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/payment.dart';
import 'package:iks_fokino_app/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<Payment> _payments = [];
  bool _isLoading = true;
  double _totalPaid = 0;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final payments = await dbService.getPayments('1234567890');
    
    double total = 0;
    for (var payment in payments) {
      if (payment.status == 'completed') {
        total += payment.amount;
      }
    }

    setState(() {
      _payments = payments;
      _totalPaid = total;
      _isLoading = false;
    });
  }

  Widget _buildPaymentCard(Payment payment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getMethodIcon(payment.method),
            color: AppColors.primaryBlue,
          ),
        ),
        title: Text(
          payment.formattedAmount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(payment.method),
            Text(
              payment.formattedDate,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(payment.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getStatusText(payment.status),
            style: TextStyle(
              color: _getStatusColor(payment.status),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'банковская карта':
        return Icons.credit_card;
      case 'сбербанк-онлайн':
        return Icons.account_balance;
      case 'наличные':
        return Icons.money;
      default:
        return Icons.payments;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPayments,
              child: CustomScrollView(
                slivers: [
                  // Статистика
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: AppColors.lightBlue,
                      child: Column(
                        children: [
                          const Text(
                            'Всего оплачено',
                            style: TextStyle(
                              color: AppColors.darkGray,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${_totalPaid.toStringAsFixed(2)} ₽',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.successGreen,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${_payments.where((p) => p.status == 'completed').length} успешных',
                                style: TextStyle(
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Список платежей
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPaymentCard(_payments[index]),
                      childCount: _payments.length,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Навигация на экран оплаты
        },
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/bill.dart';
import 'package:iks_fokino_app/screens/bills/bill_detail_screen.dart';
import 'package:iks_fokino_app/services/database_service.dart';
import 'package:iks_fokino_app/widgets/bill_card.dart';
import 'package:provider/provider.dart';
import 'package:iks_fokino_app/screens/payments/payment_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Bill> _bills = [];
  bool _isLoading = true;
  double _totalDebt = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBills();
    });
  }

  Future<void> _loadBills() async {
    try {
      final dbService = Provider.of<DatabaseService>(context, listen: false);
      
      // Имитация загрузки данных
      await Future.delayed(const Duration(milliseconds: 500));
      
      final bills = await dbService.getBills('1234567890');
      
      double totalDebt = 0;
      for (var bill in bills) {
        if (bill.status == 'pending' || bill.status == 'overdue') {
          totalDebt += bill.total;
        }
      }

      setState(() {
        _bills = bills;
        _totalDebt = totalDebt;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки счетов: $e');
      setState(() {
        _isLoading = false;
      });
      
      // Показываем демо-данные при ошибке
      _showDemoData();
    }
  }

  void _showDemoData() {
    final demoBills = [
      Bill(
        id: 'bill_1',
        accountNumber: '1234567890',
        period: DateTime(2024, 1, 1),
        amount: 3250.75,
        previousBalance: 0,
        total: 3250.75,
        dueDate: DateTime(2024, 2, 10),
        status: 'paid',
        items: [],
      ),
      Bill(
        id: 'bill_2',
        accountNumber: '1234567890',
        period: DateTime(2024, 2, 1),
        amount: 2980.50,
        previousBalance: 0,
        total: 2980.50,
        dueDate: DateTime(2024, 3, 10),
        status: 'pending',
        items: [],
      ),
    ];
    
    setState(() {
      _bills = demoBills;
      _totalDebt = 2980.50;
    });
  }

  void _showPaymentOptions(BuildContext context, Bill bill) {
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentScreen(bill: bill),
    ),
  );
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Оплатить счет',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Сумма: ${bill.formattedAmount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processPayment(context, bill);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Перейти к оплате'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processPayment(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оплата'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadBills,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: _totalDebt > 0
                          ? AppColors.errorRed.withOpacity(0.1)
                          : AppColors.successGreen.withOpacity(0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Общая задолженность',
                            style: TextStyle(
                              color: _totalDebt > 0
                                  ? AppColors.errorRed
                                  : AppColors.successGreen,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${_totalDebt.toStringAsFixed(2)} ₽',
                            style: TextStyle(
                              color: _totalDebt > 0
                                  ? AppColors.errorRed
                                  : AppColors.successGreen,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_totalDebt > 0) const SizedBox(height: 10),
                          if (_totalDebt > 0)
                            ElevatedButton(
                              onPressed: () {
                                // Навигация на экран оплаты всей задолженности
                                _showPaymentOptions(context, _bills.firstWhere(
                                  (b) => b.status == 'pending',
                                  orElse: () => _bills.first,
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.errorRed,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Оплатить задолженность'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final bill = _bills[index];
                        return BillCard(
                          bill: bill,
                          onPayPressed: () => _showPaymentOptions(context, bill),
                        );
                      },
                      childCount: _bills.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
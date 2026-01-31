import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/bill.dart';
import 'package:iks_fokino_app/screens/bills/bill_detail_screen.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onPayPressed;

  const BillCard({
    super.key,
    required this.bill,
    this.onPayPressed,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill.formattedPeriod,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(bill.status).withOpacity(0.1),
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
            
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Сумма к оплате:',
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
                ),
                Text(
                  bill.formattedAmount,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Срок оплаты: ${bill.formattedDueDate}',
              style: const TextStyle(
                color: AppColors.gray,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillDetailScreen(bill: bill),
                        ),
                      );
                    },
                    child: const Text('Подробнее'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPayPressed ?? () {
                      // Навигация к оплате
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Оплатить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
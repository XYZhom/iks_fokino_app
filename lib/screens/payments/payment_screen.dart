import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/models/bill.dart';

class PaymentScreen extends StatefulWidget {
  final Bill bill;

  const PaymentScreen({super.key, required this.bill});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _isPaying = false;
  
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 0,
      'title': 'Банковская карта',
      'icon': Icons.credit_card,
      'description': 'Visa, Mastercard, Мир',
    },
    {
      'id': 1,
      'title': 'Сбербанк Онлайн',
      'icon': Icons.account_balance,
      'description': 'Оплата через Сбербанк',
    },
    {
      'id': 2,
      'title': 'Тинькофф',
      'icon': Icons.account_balance_wallet,
      'description': 'Оплата через Тинькофф',
    },
    {
      'id': 3,
      'title': 'По QR-коду',
      'icon': Icons.qr_code,
      'description': 'Сканирование QR-кода',
    },
  ];

  final MaskedTextController _cardController = MaskedTextController(
    mask: '0000 0000 0000 0000',
  );
  final TextEditingController _expiryController = MaskedTextController(
    mask: '00/00',
  );
  final TextEditingController _cvvController = MaskedTextController(
    mask: '000',
  );

  Future<void> _processPayment() async {
    setState(() => _isPaying = true);
    
    // Имитация обработки платежа
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isPaying = false);
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Платеж успешно проведен'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Данные карты',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardController,
          decoration: const InputDecoration(
            labelText: 'Номер карты',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'ММ/ГГ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите способ оплаты',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._paymentMethods.map((method) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: _selectedMethod == method['id']
                ? AppColors.lightBlue
                : Colors.white,
            child: RadioListTile(
              title: Row(
                children: [
                  Icon(method['icon'], color: AppColors.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(method['title']),
                        Text(
                          method['description'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              value: method['id'],
              groupValue: _selectedMethod,
              onChanged: (value) {
                setState(() => _selectedMethod = value!);
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата счета'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о счете
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
                          'Счет за период:',
                          style: TextStyle(
                            color: AppColors.gray,
                          ),
                        ),
                        Text(
                          widget.bill.formattedPeriod,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
                          widget.bill.formattedAmount,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ЛС:',
                          style: TextStyle(
                            color: AppColors.gray,
                          ),
                        ),
                        Text(widget.bill.accountNumber),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Способы оплаты
            _buildPaymentMethod(),
            const SizedBox(height: 24),
            // Форма оплаты картой (если выбран)
            if (_selectedMethod == 0) ...[
              _buildCardPaymentForm(),
              const SizedBox(height: 24),
            ],
            // Кнопка оплаты
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPaying ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isPaying
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Оплатить',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Безопасность
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: AppColors.primaryBlue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Все платежи защищены. Данные карты не сохраняются в приложении.',
                      style: TextStyle(fontSize: 12),
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

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}
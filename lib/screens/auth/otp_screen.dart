import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/services/auth_service.dart';
import 'package:iks_fokino_app/screens/home/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({super.key, required this.phone});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _authService = AuthService();
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    // Автофокус на первое поле
    _focusNodes[0].requestFocus();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Проверяем, все ли поля заполнены
    if (_isAllFieldsFilled()) {
      _verifyOTP();
    }
  }

  bool _isAllFieldsFilled() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  String _getOTP() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final otp = _getOTP();
    final success = await _authService.verifyOTP(widget.phone, otp);

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        setState(() => _error = 'Неверный код подтверждения');
        // Очищаем поля при ошибке
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    }
  }

  Future<void> _resendCode() async {
    final success = await _authService.loginWithPhone(widget.phone);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Код отправлен повторно'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        title: const Text('Подтверждение номера'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Заголовок
              const Text(
                'Введите код из SMS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                'Отправлен на номер +7 ${widget.phone}',
                style: const TextStyle(
                  color: AppColors.gray,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Поля для ввода кода
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onChanged(index, value),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 20),
              
              // Сообщение об ошибке
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(
                    color: AppColors.errorRed,
                  ),
                ),
              
              const SizedBox(height: 30),
              
              // Кнопка подтверждения
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled() && !_isLoading ? _verifyOTP : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Подтвердить',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Кнопка повторной отправки
              Center(
                child: TextButton(
                  onPressed: _resendCode,
                  child: const Text(
                    'Отправить код повторно',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Подсказка
              const Center(
                child: Text(
                  'Демо-режим: используйте код 123456',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
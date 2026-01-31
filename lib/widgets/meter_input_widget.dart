// lib/widgets/meter_input_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iks_fokino_app/constants/colors.dart';

class MeterInputWidget extends StatelessWidget {
  final String meterName;
  final String meterNumber;
  final String unit;
  final double previousReading;
  final TextEditingController controller;

  const MeterInputWidget({
    super.key,
    required this.meterName,
    required this.meterNumber,
    required this.unit,
    required this.previousReading,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meterName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    meterNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Предыдущие показания: $previousReading $unit',
              style: const TextStyle(
                color: AppColors.gray,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Текущие показания ($unit)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {
                          final current = double.tryParse(controller.text) ?? 0;
                          controller.text = (current + 1).toString();
                        },
                      ),
                    ),
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
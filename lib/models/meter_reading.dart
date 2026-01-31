import 'package:intl/intl.dart';

class MeterReading {
  final String id;
  final String meterNumber;
  final String serviceType; // отопление, ГВС, ХВС
  final double previousReading;
  final double currentReading;
  final DateTime readingDate;
  final DateTime submissionDate;
  final String status; // submitted, verified, rejected

  MeterReading({
    required this.id,
    required this.meterNumber,
    required this.serviceType,
    required this.previousReading,
    required this.currentReading,
    required this.readingDate,
    required this.submissionDate,
    required this.status,
  });

  double get consumption => currentReading - previousReading;

  String get formattedReadingDate => DateFormat('dd.MM.yyyy').format(readingDate);
  String get formattedSubmissionDate => DateFormat('dd.MM.yyyy HH:mm').format(submissionDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meterNumber': meterNumber,
      'serviceType': serviceType,
      'previousReading': previousReading,
      'currentReading': currentReading,
      'readingDate': readingDate.toIso8601String(),
      'submissionDate': submissionDate.toIso8601String(),
      'status': status,
    };
  }
}
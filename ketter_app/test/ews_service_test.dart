import 'package:flutter_test/flutter_test.dart';
import 'package:ketter_app/services/ews_service.dart';

void main() {
  final ewsService = EWSService();

  group('NEWS2 Score Calculation', () {
    test('Healthy parameters should result in a score of 0', () {
      final score = ewsService.calculateNEWS2(
        respirationRate: 15,
        spo2: 98,
        onOxygen: false,
        systolicBP: 120,
        heartRate: 70,
        temperature: 37.0,
        consciousness: 'A',
      );
      expect(score, 0);
      expect(ewsService.getRiskLevel(score), 'Low');
    });

    test('Critical parameters should result in a high score', () {
      final score = ewsService.calculateNEWS2(
        respirationRate: 26, // +3
        spo2: 90,           // +3
        onOxygen: true,     // +2
        systolicBP: 80,     // +3
        heartRate: 135,     // +3
        temperature: 35.0,  // +3
        consciousness: 'V', // +3
      );
      // Total should be 3+3+2+3+3+3+3 = 20
      expect(score, 20);
      expect(ewsService.getRiskLevel(score), 'High');
    });

    test('Mild deterioration should result in low risk score', () {
      final score = ewsService.calculateNEWS2(
        respirationRate: 10, // +1
        spo2: 95,           // +1
        onOxygen: false,    // +0
        systolicBP: 115,    // +0
        heartRate: 55,      // +0
        temperature: 36.2,  // +0
        consciousness: 'A', // +0
      );
      expect(score, 2);
      expect(ewsService.getRiskLevel(score), 'Low');
    });
  });
}

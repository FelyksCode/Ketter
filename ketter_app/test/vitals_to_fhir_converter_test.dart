import 'package:flutter_test/flutter_test.dart';
import 'package:fhir/r4.dart';
import 'package:ketter_app/services/vitals_to_fhir_converter.dart';

void main() {
  final subject = Reference(reference: 'Patient/1', display: 'Jane Doe');
  final timestamp = DateTime(2026, 1, 31, 12, 0, 0);

  group('VitalsToFhirConverter Tests', () {
    test('createHeartRate generates valid Observation', () {
      final obs = VitalsToFhirConverter.createHeartRate(72.0, subject, timestamp);

      expect(obs.status, FhirCode('final'));
      expect(obs.code.coding!.first.code, FhirCode('8867-4'));
      expect(obs.valueQuantity!.value, FhirDecimal(72.0));
      expect(obs.valueQuantity!.unit, 'bpm');
      expect(obs.subject!.reference, 'Patient/1');
      expect(obs.effectiveDateTime.toString(), contains('2026-01-31T12:00:00'));
    });

    test('createBodyTemperature generates valid Observation', () {
      final obs = VitalsToFhirConverter.createBodyTemperature(36.6, subject, timestamp);

      expect(obs.code.coding!.first.code, FhirCode('8310-5'));
      expect(obs.valueQuantity!.value, FhirDecimal(36.6));
      expect(obs.valueQuantity!.unit, 'Cel');
    });

    test('createSpO2 generates valid Observation', () {
      final obs = VitalsToFhirConverter.createSpO2(98.0, subject, timestamp);

      expect(obs.code.coding!.first.code, FhirCode('2708-6'));
      expect(obs.valueQuantity!.value, FhirDecimal(98.0));
      expect(obs.valueQuantity!.unit, '%');
    });

    test('createSteps generates valid Observation', () {
      final obs = VitalsToFhirConverter.createSteps(5000, subject, timestamp);

      expect(obs.code.coding!.first.code, FhirCode('41950-7'));
      expect(obs.valueQuantity!.value, FhirDecimal(5000.0));
      expect(obs.valueQuantity!.unit, 'steps');
    });

    test('createBloodPressure generates valid Observation with components', () {
      final obs = VitalsToFhirConverter.createBloodPressure(
        systolic: 120.0,
        diastolic: 80.0,
        subject: subject,
        timestamp: timestamp,
      );

      expect(obs.code.coding!.first.code, FhirCode('85354-9'));
      expect(obs.component!.length, 2);

      final systolic = obs.component!.firstWhere((c) => c.code.coding!.first.code == FhirCode('8480-6'));
      final diastolic = obs.component!.firstWhere((c) => c.code.coding!.first.code == FhirCode('8462-4'));

      expect(systolic.valueQuantity!.value, FhirDecimal(120.0));
      expect(systolic.valueQuantity!.unit, 'mm[Hg]');

      expect(diastolic.valueQuantity!.value, FhirDecimal(80.0));
      expect(diastolic.valueQuantity!.unit, 'mm[Hg]');
    });
  });
}

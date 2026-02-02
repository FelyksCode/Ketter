import 'package:flutter_test/flutter_test.dart';
import 'package:fhir/r4.dart';
import 'package:ketter_app/services/symptom_service.dart';

void main() {
  final symptomService = SymptomService();
  final subject = Reference(reference: 'Patient/1', display: 'Jane Doe');

  group('SymptomService Tests', () {
    test('createSymptomResource generates valid Condition for Fatigue', () {
      final condition = symptomService.createSymptomResource(
        symptomName: 'Fatigue',
        severity: 'mild',
        subject: subject,
      );

      expect(condition.verificationStatus!.coding!.first.code, FhirCode('unconfirmed'));
      expect(condition.code!.coding!.first.code, FhirCode('84229001'));
      expect(condition.severity!.coding!.first.code, FhirCode('255604002'));
      expect(condition.subject!.reference, 'Patient/1');
      expect(condition.category!.first.coding!.first.code, FhirCode('health-concern'));
    });

    test('createSymptomResource handles different severities', () {
      final moderate = symptomService.createSymptomResource(
        symptomName: 'Nausea',
        severity: 'moderate',
        subject: subject,
      );
      expect(moderate.severity!.coding!.first.code, FhirCode('6736007'));

      final severe = symptomService.createSymptomResource(
        symptomName: 'Headache',
        severity: 'severe',
        subject: subject,
      );
      expect(severe.severity!.coding!.first.code, FhirCode('24484000'));
    });

    test('createSymptomResource throws on unknown symptom', () {
      expect(
        () => symptomService.createSymptomResource(
          symptomName: 'Magic Pixie Dust',
          severity: 'mild',
          subject: subject,
        ),
        throwsArgumentError,
      );
    });

    test('createSymptomResource handles added symptoms (Sexual dysfunction, Constipation, Dry eyes)', () {
      final sexual = symptomService.createSymptomResource(
        symptomName: 'Sexual dysfunction',
        severity: 'mild',
        subject: subject,
      );
      expect(sexual.code!.coding!.first.code, FhirCode('231532002'));

      final constipation = symptomService.createSymptomResource(
        symptomName: 'Constipation',
        severity: 'mild',
        subject: subject,
      );
      expect(constipation.code!.coding!.first.code, FhirCode('14760008'));

      final dryEyes = symptomService.createSymptomResource(
        symptomName: 'Dry eyes',
        severity: 'mild',
        subject: subject,
      );
      expect(dryEyes.code!.coding!.first.code, FhirCode('401111007'));
    });
  });
}

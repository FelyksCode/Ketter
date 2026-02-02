import 'package:fhir/r4.dart';
import 'package:ketter_app/models/symptom.dart';

class SymptomService {
  static const String snomedSystem = 'http://snomed.info/sct';

  /// Creates a FHIR R4 Condition resource for a patient-reported symptom.
  Condition createSymptomResource({
    required String symptomName,
    required String severity, // 'mild', 'moderate', 'severe'
    required Reference subject,
    DateTime? onsetDateTime,
  }) {
    final symptomCode = SymptomDefinitions.symptomToSnomed[symptomName];
    if (symptomCode == null) {
      throw ArgumentError('Unknown symptom: $symptomName');
    }

    final severityCode = SymptomDefinitions.severityToSnomed[severity.toLowerCase()];
    if (severityCode == null) {
      throw ArgumentError('Unknown severity: $severity');
    }

    return Condition(
      // Patient reported, so hardcoded to unconfirmed
      verificationStatus: CodeableConcept(
        coding: [
          Coding(
            system: FhirUri('http://terminology.hl7.org/CodeSystem/condition-ver-status'),
            code: FhirCode('unconfirmed'),
            display: 'Unconfirmed',
          )
        ],
      ),
      category: [
        CodeableConcept(
          coding: [
            Coding(
              system: FhirUri('http://terminology.hl7.org/CodeSystem/condition-category'),
              code: FhirCode('health-concern'),
              display: 'Health Concern',
            )
          ],
        )
      ],
      severity: CodeableConcept(
        coding: [
          Coding(
            system: FhirUri(snomedSystem),
            code: FhirCode(severityCode),
            display: severity,
          )
        ],
      ),
      code: CodeableConcept(
        coding: [
          Coding(
            system: FhirUri(snomedSystem),
            code: FhirCode(symptomCode),
            display: symptomName,
          )
        ],
      ),
      subject: subject,
      onsetDateTime: onsetDateTime != null ? FhirDateTime(onsetDateTime) : FhirDateTime(DateTime.now()),
      recordedDate: FhirDateTime(DateTime.now()),
    );
  }
}

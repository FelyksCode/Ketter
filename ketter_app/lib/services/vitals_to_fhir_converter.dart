import 'package:fhir/r4.dart';

/// Helper class to convert raw vital signs data into FHIR R4 Observation resources.
class VitalsToFhirConverter {
  static const String loincSystem = 'http://loinc.org';
  static const String ucumSystem = 'http://unitsofmeasure.org';

  /// Creates a basic Observation resource skeleton.
  static Observation _createBaseObservation({
    required String loincCode,
    required String display,
    required Reference subject,
    required DateTime effectiveDateTime,
  }) {
    return Observation(
      status: FhirCode('final'),
      category: [
        CodeableConcept(coding: [
          Coding(
            system: FhirUri('http://terminology.hl7.org/CodeSystem/observation-category'),
            code: FhirCode('vital-signs'),
            display: 'Vital Signs',
          )
        ])
      ],
      code: CodeableConcept(coding: [
        Coding(
          system: FhirUri(loincSystem),
          code: FhirCode(loincCode),
          display: display,
        )
      ]),
      subject: subject,
      effectiveDateTime: FhirDateTime(effectiveDateTime),
    );
  }

  /// Converts Heart Rate to FHIR Observation (LOINC 8867-4).
  static Observation createHeartRate(double value, Reference subject, DateTime timestamp) {
    final obs = _createBaseObservation(
      loincCode: '8867-4',
      display: 'Heart rate',
      subject: subject,
      effectiveDateTime: timestamp,
    );
    return obs.copyWith(
      valueQuantity: Quantity(
        value: FhirDecimal(value),
        unit: 'bpm',
        system: FhirUri(ucumSystem),
        code: FhirCode('bpm'),
      ),
    );
  }

  /// Converts Body Temperature to FHIR Observation (LOINC 8310-5).
  static Observation createBodyTemperature(double value, Reference subject, DateTime timestamp) {
    final obs = _createBaseObservation(
      loincCode: '8310-5',
      display: 'Body temperature',
      subject: subject,
      effectiveDateTime: timestamp,
    );
    return obs.copyWith(
      valueQuantity: Quantity(
        value: FhirDecimal(value),
        unit: 'Cel',
        system: FhirUri(ucumSystem),
        code: FhirCode('Cel'),
      ),
    );
  }

  /// Converts SpO2 to FHIR Observation (LOINC 2708-6).
  static Observation createSpO2(double value, Reference subject, DateTime timestamp) {
    final obs = _createBaseObservation(
      loincCode: '2708-6',
      display: 'Oxygen saturation in Arterial blood',
      subject: subject,
      effectiveDateTime: timestamp,
    );
    return obs.copyWith(
      valueQuantity: Quantity(
        value: FhirDecimal(value),
        unit: '%',
        system: FhirUri(ucumSystem),
        code: FhirCode('%'),
      ),
    );
  }

  /// Converts Steps to FHIR Observation (LOINC 41950-7).
  static Observation createSteps(int value, Reference subject, DateTime timestamp) {
    final obs = _createBaseObservation(
      loincCode: '41950-7',
      display: 'Number of steps in 24 hours',
      subject: subject,
      effectiveDateTime: timestamp,
    );
    return obs.copyWith(
      valueQuantity: Quantity(
        value: FhirDecimal(value.toDouble()),
        unit: 'steps',
        system: FhirUri(ucumSystem),
        code: FhirCode('steps'),
      ),
    );
  }

  /// Converts Blood Pressure to FHIR Observation (LOINC 85354-9).
  static Observation createBloodPressure({
    required double systolic,
    required double diastolic,
    required Reference subject,
    required DateTime timestamp,
  }) {
    final obs = _createBaseObservation(
      loincCode: '85354-9',
      display: 'Blood pressure panel',
      subject: subject,
      effectiveDateTime: timestamp,
    );

    return obs.copyWith(
      component: [
        // Systolic
        ObservationComponent(
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(loincSystem),
              code: FhirCode('8480-6'),
              display: 'Systolic blood pressure',
            )
          ]),
          valueQuantity: Quantity(
            value: FhirDecimal(systolic),
            unit: 'mm[Hg]',
            system: FhirUri(ucumSystem),
            code: FhirCode('mm[Hg]'),
          ),
        ),
        // Diastolic
        ObservationComponent(
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(loincSystem),
              code: FhirCode('8462-4'),
              display: 'Diastolic blood pressure',
            )
          ]),
          valueQuantity: Quantity(
            value: FhirDecimal(diastolic),
            unit: 'mm[Hg]',
            system: FhirUri(ucumSystem),
            code: FhirCode('mm[Hg]'),
          ),
        ),
      ],
    );
  }
}

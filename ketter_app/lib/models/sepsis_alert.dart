import 'package:fhir/r4.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sepsis_alert.freezed.dart';
part 'sepsis_alert.g.dart';

@freezed
class SepsisAlert with _$SepsisAlert {
  const factory SepsisAlert({
    required String id,
    required DateTime timestamp,
    required int score,
    required String riskLevel,
    required List<String> triggeredParameters,
  }) = _SepsisAlert;

  factory SepsisAlert.fromJson(Map<String, dynamic> json) => _$SepsisAlertFromJson(json);

  /// Converts the SepsisAlert to a FHIR Communication resource.
  Communication toFhirCommunication(Reference subject) {
    return Communication(
      fhirId: id,
      status: FhirCode('completed'),
      category: [
        CodeableConcept(coding: [
          Coding(
            system: FhirUri('http://terminology.hl7.org/CodeSystem/communication-category'),
            code: FhirCode('alert'),
            display: 'Alert',
          )
        ])
      ],
      subject: subject,
      sent: FhirDateTime(timestamp),
      payload: [
        CommunicationPayload(
          contentString: 'Sepsis Alert: Risk Level $riskLevel, NEWS2 Score $score. Triggered by: ${triggeredParameters.join(", ")}',
        )
      ],
    );
  }
}

import 'package:fhir/r4.dart';

class KetterPatient {
  final Patient fhirPatient;

  KetterPatient(this.fhirPatient);

  String get fullName {
    if (fhirPatient.name == null || fhirPatient.name!.isEmpty) return 'Unknown';
    final name = fhirPatient.name!.first;
    return '${name.given?.join(" ")} ${name.family}';
  }

  String get id => fhirPatient.id?.toString() ?? 'unknown';

  static KetterPatient fromFhir(Patient patient) => KetterPatient(patient);
}

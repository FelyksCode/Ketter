import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fhir/r4.dart';
import 'package:ketter_app/config.dart';

class FhirService {
  final String baseUrl = AppConfig.fhirBaseUrl;

  /// Uploads a FHIR resource to the server.
  Future<void> uploadResource(Resource resource) async {
    final resourceType = resource.resourceType.toString().split('.').last;
    final url = Uri.parse('$baseUrl/$resourceType');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/fhir+json',
        },
        body: jsonEncode(resource.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully uploaded $resourceType');
      } else {
        print('Failed to upload $resourceType: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error uploading $resourceType: $e');
    }
  }

  /// Fetches a Patient by ID.
  Future<Patient?> getPatient(String id) async {
    final url = Uri.parse('$baseUrl/Patient/$id');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Patient.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to fetch patient: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching patient: $e');
      return null;
    }
  }
}

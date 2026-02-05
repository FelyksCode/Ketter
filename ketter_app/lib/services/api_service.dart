import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to interact with the Dockerized Sepsis Prediction ML API.
class SepsisApiService {
  /// The API endpoint.
  ///
  /// DEVELOPMENT TIP:
  /// - If running Flutter Web: Use 'http://localhost:5000' (The browser connects to the host machine).
  /// - If running on Android Emulator: Use 'http://10.0.2.2:5000' (Special loopback IP to the host).
  /// - If running on physical device: Use the machine's local IP (e.g., 'http://192.168.1.10:5000').
  static const String _baseUrl = 'http://localhost:5000';

  /// Calls the /predict endpoint of the ML microservice.
  Future<Map<String, dynamic>> predictSepsis({
    required double hr,
    required double temp,
    required double steps,
    required int userScore,
  }) async {
    final url = Uri.parse('$_baseUrl/predict');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'hr': hr,
          'temp': temp,
          'steps': steps,
          'user_score': userScore,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Failed to reach API: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connectivity error: $e',
      };
    }
  }

  /// Checks the health of the ML service.
  Future<bool> checkHealth() async {
    final url = Uri.parse('$_baseUrl/health');
    try {
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

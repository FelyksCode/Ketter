import 'package:fhir/r4.dart';

/// Service to calculate Early Warning Scores (EWS), specifically NEWS2.
/// NEWS2 is the standard for detecting deterioration in acute illness.
class EWSService {
  /// Calculates the NEWS2 score based on a list of FHIR Observations.
  /// Parameters expected:
  /// - Respiration Rate (9279-1)
  /// - SpO2 (2708-6)
  /// - Supplemental Oxygen (set if applicable)
  /// - Systolic BP (8480-6)
  /// - Heart Rate (8867-4)
  /// - Temperature (8310-5)
  /// - Consciousness (Level of consciousness)
  int calculateNEWS2({
    required double respirationRate,
    required double spo2,
    required bool onOxygen,
    required double systolicBP,
    required double heartRate,
    required double temperature,
    required String consciousness, // 'A', 'V', 'P', 'U'
  }) {
    int score = 0;

    // Respiration Rate
    if (respirationRate <= 8 || respirationRate >= 25) score += 3;
    else if (respirationRate >= 21) score += 2;
    else if (respirationRate <= 11) score += 1;

    // SpO2 (Scale 1 - most common)
    if (spo2 <= 91) score += 3;
    else if (spo2 <= 93) score += 2;
    else if (spo2 <= 95) score += 1;

    // Supplemental Oxygen
    if (onOxygen) score += 2;

    // Systolic BP
    if (systolicBP <= 90 || systolicBP >= 220) score += 3;
    else if (systolicBP <= 100) score += 2;
    else if (systolicBP <= 110) score += 1;

    // Heart Rate
    if (heartRate <= 40 || heartRate >= 131) score += 3;
    else if (heartRate >= 111) score += 2;
    else if (heartRate >= 91) score += 1;
    else if (heartRate <= 50) score += 1;

    // Temperature
    if (temperature <= 35.0) score += 3;
    else if (temperature >= 39.1) score += 2;
    else if (temperature <= 36.0 || temperature >= 38.1) score += 1;

    // Consciousness
    if (consciousness != 'A') score += 3;

    return score;
  }

  /// Maps a NEWS2 score to a clinical risk level.
  String getRiskLevel(int score) {
    if (score == 0) return 'Low';
    if (score <= 4) return 'Low'; // Low risk
    if (score <= 6) return 'Medium'; // Medium risk
    return 'High'; // High risk
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:ketter_app/services/edge_ai_service.dart';

void main() {
  group('EdgeAIService Architecture Tests', () {
    test('Should perform inference using MockInferenceEngine', () async {
      // Use mock engine to avoid native TFLite dependencies in test environment
      final service = EdgeAIService(engine: MockInferenceEngine());

      // Input features: [HR, O2Sat, Temp, SBP, MAP, DBP, Resp, EtCO2]
      final vitals = [75.0, 98.0, 36.8, 120.0, 90.0, 80.0, 16.0, 40.0];

      final risk = await service.predictEarlySepsis(vitals);

      expect(risk, isNotNull);
      expect(risk, greaterThanOrEqualTo(0.0));
      expect(risk, lessThanOrEqualTo(1.0));
    });

    test('Should reflect higher risk for abnormal vitals (Mock)', () async {
      final service = EdgeAIService(engine: MockInferenceEngine());

      // Normal vitals
      final normalVitals = [75.0, 98.0, 36.8, 120.0, 90.0, 80.0, 16.0, 40.0];
      final normalRisk = await service.predictEarlySepsis(normalVitals);

      // Abnormal vitals (High HR, Low O2Sat, High Temp)
      final abnormalVitals = [110.0, 90.0, 39.0, 120.0, 90.0, 80.0, 16.0, 40.0];
      final abnormalRisk = await service.predictEarlySepsis(abnormalVitals);

      expect(abnormalRisk, greaterThan(normalRisk));
    });
  });
}

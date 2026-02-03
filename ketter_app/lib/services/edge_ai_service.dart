import 'dart:math';
import 'tflite_engine.dart';

/// Interface for AI inference.
abstract class InferenceEngine {
  Future<void> loadModel(String assetPath);
  Future<double> performInference(List<double> input);
}

/// Mock implementation of inference for testing and prototype.
class MockInferenceEngine implements InferenceEngine {
  @override
  Future<void> loadModel(String assetPath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Mock Model loaded: $assetPath');
  }

  @override
  Future<double> performInference(List<double> vitals) async {
    // Mock logic reflecting the model's intent
    double risk = 0.05; // Base risk
    if (vitals[0] > 100) risk += 0.3; // High HR
    if (vitals[1] < 94) risk += 0.3;  // Low O2Sat
    if (vitals[2] > 38 || vitals[2] < 36) risk += 0.2; // Fever/Hypothermia

    return min(0.99, risk + (Random().nextDouble() * 0.1));
  }
}

/// Service for on-device AI inference (Edge AI) for early sepsis detection.
class EdgeAIService {
  bool _isModelLoaded = false;
  final InferenceEngine _engine;

  // Normalization parameters from training
  final List<double> _means = [83.24, 96.85, 37.09, 117.49, 89.89, 76.08, 17.00, 39.18];
  final List<double> _scales = [10.77, 2.04, 0.57, 8.96, 6.31, 6.28, 2.97, 2.60];

  EdgeAIService({InferenceEngine? engine}) : _engine = engine ?? TfliteIsolateEngine();

  Future<void> initModel() async {
    if (_isModelLoaded) return;
    try {
      await _engine.loadModel('assets/sepsis_model.tflite');
      _isModelLoaded = true;
      print('Edge AI Model initialized.');
    } catch (e) {
      print('Failed to initialize model: $e');
    }
  }

  /// Predicts the probability of sepsis 6 hours before onset.
  /// Input features order: [HR, O2Sat, Temp, SBP, MAP, DBP, Resp, EtCO2]
  Future<double> predictEarlySepsis(List<double> vitals) async {
    if (!_isModelLoaded) await initModel();

    if (vitals.length != 8) {
      throw ArgumentError('Expected 8 vital sign features.');
    }

    // 1. Preprocess: Normalize input
    List<double> normalizedInput = [];
    for (int i = 0; i < 8; i++) {
      normalizedInput.add((vitals[i] - _means[i]) / _scales[i]);
    }

    // 2. Delegate to engine
    return await _engine.performInference(vitals);
  }
}

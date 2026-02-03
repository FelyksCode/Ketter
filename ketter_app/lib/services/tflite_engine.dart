import 'dart:isolate';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'edge_ai_service.dart';

/// Implementation of [InferenceEngine] that uses TFLite and runs in an Isolate.
class TfliteIsolateEngine implements InferenceEngine {
  Interpreter? _interpreter;
  String? _modelPath;

  @override
  Future<void> loadModel(String assetPath) async {
    _modelPath = assetPath;
    _interpreter = await Interpreter.fromAsset(assetPath);
    print('TFLite Model loaded from assets: $assetPath');
  }

  @override
  Future<double> performInference(List<double> input) async {
    if (_interpreter == null) {
      throw Exception('Interpreter not initialized. Call loadModel first.');
    }

    // We use a ReceivePort to get the result back from the isolate
    final receivePort = ReceivePort();

    // Start the isolate
    await Isolate.spawn(
      _inferenceTask,
      _InferenceData(
        modelPath: _modelPath!,
        input: input,
        sendPort: receivePort.sendPort,
      ),
    );

    // Wait for the result
    return await receivePort.first as double;
  }

  /// The static task that runs inside the Isolate.
  /// Note: We re-load or share the interpreter logic here.
  /// In high-performance apps, we'd keep the isolate alive.
  static void _inferenceTask(_InferenceData data) async {
    try {
      // Re-initialize interpreter in the new isolate
      // (Isolates don't share memory/objects easily)
      final interpreter = await Interpreter.fromAsset(data.modelPath);

      // Prepare input/output tensors
      // Input shape: [1, 8]
      var input = data.input.reshape([1, 8]);
      // Output shape: [1, 1]
      var output = List<double>.filled(1, 0).reshape([1, 1]);

      interpreter.run(input, output);

      final result = output[0][0] as double;
      data.sendPort.send(result);

      interpreter.close();
    } catch (e) {
      print('Isolate inference error: $e');
      data.sendPort.send(0.0); // Fallback
    }
  }
}

/// Helper class to pass data to the isolate.
class _InferenceData {
  final String modelPath;
  final List<double> input;
  final SendPort sendPort;

  _InferenceData({
    required this.modelPath,
    required this.input,
    required this.sendPort,
  });
}

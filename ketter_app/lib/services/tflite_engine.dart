import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'edge_ai_service.dart';

/// Implementation of [InferenceEngine] that uses TFLite and runs in an Isolate.
class TfliteIsolateEngine implements InferenceEngine {
  String? _modelPath;

  @override
  Future<void> loadModel(String assetPath) async {
    _modelPath = assetPath;
    // Just verify the asset exists or can be loaded in main isolate if needed
    print('TFLite Model path set: $assetPath');
  }

  @override
  Future<double> performInference(List<double> input) async {
    if (_modelPath == null) {
      throw Exception('Model path not set. Call loadModel first.');
    }

    final RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _inferenceTask,
      _InferenceData(
        modelPath: _modelPath!,
        input: input,
        sendPort: receivePort.sendPort,
        token: rootIsolateToken,
      ),
    );

    return await receivePort.first as double;
  }

  static void _inferenceTask(_InferenceData data) async {
    try {
      // Required for using plugins/assets in background isolates
      BackgroundIsolateBinaryMessenger.ensureInitialized(data.token);

      final interpreter = await Interpreter.fromAsset(data.modelPath);

      // Prepare input/output
      // Note: reshape is available as an extension in tflite_flutter
      var inputTensor = [data.input];
      var outputTensor = List<double>.filled(1, 0).reshape([1, 1]);

      interpreter.run(inputTensor, outputTensor);

      final result = outputTensor[0][0] as double;
      data.sendPort.send(result);

      interpreter.close();
    } catch (e) {
      print('Isolate inference error: $e');
      data.sendPort.send(0.0);
    }
  }
}

class _InferenceData {
  final String modelPath;
  final List<double> input;
  final SendPort sendPort;
  final RootIsolateToken token;

  _InferenceData({
    required this.modelPath,
    required this.input,
    required this.sendPort,
    required this.token,
  });
}

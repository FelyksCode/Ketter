import 'dart:async';
import 'package:fhir/r4.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HeartRateSample {
  final DateTime timestamp;
  final int value;
  HeartRateSample(this.timestamp, this.value);
}

class StepCountSample {
  final DateTime timestamp;
  final int value;
  StepCountSample(this.timestamp, this.value);
}

/// KetterGuardianService silently monitors incoming wearable data streams
/// to detect early signs of clinical deterioration (Sepsis Guard).
class KetterGuardianService {
  final List<HeartRateSample> _hrBuffer = [];
  final List<StepCountSample> _stepsBuffer = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  // Cooldown to prevent notification spam (e.g., 1 hour)
  DateTime? _lastAlertTime;
  static const Duration alertCooldown = Duration(hours: 1);

  // Monitoring window: 30 minutes
  static const int windowSizeMinutes = 30;

  KetterGuardianService([FlutterLocalNotificationsPlugin? notificationsPlugin])
      : _notificationsPlugin = notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  /// Ingests new heart rate and step count data points.
  void ingestData(int heartRate, int stepCount, {Reference? patientReference}) {
    final now = DateTime.now();
    _hrBuffer.add(HeartRateSample(now, heartRate));
    _stepsBuffer.add(StepCountSample(now, stepCount));

    _pruneBuffers(now);

    if (_detectRisk()) {
      _handleRiskDetected(patientReference);
    }
  }

  void _pruneBuffers(DateTime now) {
    final cutoff = now.subtract(const Duration(minutes: windowSizeMinutes));
    _hrBuffer.removeWhere((s) => s.timestamp.isBefore(cutoff));
    _stepsBuffer.removeWhere((s) => s.timestamp.isBefore(cutoff));
  }

  bool _detectRisk() {
    // We need a full window of 30 samples (assuming 1 per minute)
    if (_hrBuffer.length < windowSizeMinutes) return false;

    // Sliding window check: HR > 100 AND StepCount < 10 for the entire 30 mins
    bool isHRHigh = _hrBuffer.every((s) => s.value > 100);
    bool isStepsLow = _stepsBuffer.every((s) => s.value < 10);

    return isHRHigh && isStepsLow;
  }

  void _handleRiskDetected(Reference? patientReference) async {
    final now = DateTime.now();

    // Cooldown check
    if (_lastAlertTime != null && now.difference(_lastAlertTime!) < alertCooldown) {
      return;
    }

    _lastAlertTime = now;
    print('KetterGuardian: Risk detected based on sliding window analysis.');

    // 1. Generate FHIR RiskAssessment
    final riskAssessment = _generateRiskAssessment(patientReference ?? Reference(display: 'Patient'));
    print('Generated FHIR RiskAssessment: ${riskAssessment.toJson()}');

    // 2. Trigger Local Notification
    await _triggerNotification();
  }

  Future<void> _triggerNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sepsis_guard_channel',
      'Sepsis Guard Alerts',
      channelDescription: 'Gentle alerts regarding vital sign changes',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        0,
        'Ketter Notice',
        'Ketter notices a change in your vitals. Please do a symptom check-in.',
        platformDetails,
      );
    } catch (e) {
      print('Notification failed (expected in non-mobile environments): $e');
    }
  }

  RiskAssessment _generateRiskAssessment(Reference subject) {
    return RiskAssessment(
      fhirId: 'sepsis-guard-${DateTime.now().millisecondsSinceEpoch}',
      status: FhirCode('final'),
      subject: subject,
      occurrenceDateTime: FhirDateTime(DateTime.now()),
      prediction: [
        RiskAssessmentPrediction(
          outcome: CodeableConcept(text: 'Potential Sepsis/Clinical Deterioration'),
          probabilityDecimal: FhirDecimal(0.85),
          qualitativeRisk: CodeableConcept(text: 'High'),
        )
      ],
      note: [
        Annotation(text: FhirMarkdown('Triggered by sustained high heart rate (>100) and low activity (<10 steps) for 30 minutes.'))
      ],
    );
  }

  // Exposed for testing
  int get bufferSize => _hrBuffer.length;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sepsis_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SepsisAlertImpl _$$SepsisAlertImplFromJson(Map<String, dynamic> json) =>
    _$SepsisAlertImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      score: (json['score'] as num).toInt(),
      riskLevel: json['riskLevel'] as String,
      triggeredParameters: (json['triggeredParameters'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SepsisAlertImplToJson(_$SepsisAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'score': instance.score,
      'riskLevel': instance.riskLevel,
      'triggeredParameters': instance.triggeredParameters,
    };

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sepsis_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SepsisAlert _$SepsisAlertFromJson(Map<String, dynamic> json) {
  return _SepsisAlert.fromJson(json);
}

/// @nodoc
mixin _$SepsisAlert {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  String get riskLevel => throw _privateConstructorUsedError;
  List<String> get triggeredParameters => throw _privateConstructorUsedError;

  /// Serializes this SepsisAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SepsisAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SepsisAlertCopyWith<SepsisAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SepsisAlertCopyWith<$Res> {
  factory $SepsisAlertCopyWith(
    SepsisAlert value,
    $Res Function(SepsisAlert) then,
  ) = _$SepsisAlertCopyWithImpl<$Res, SepsisAlert>;
  @useResult
  $Res call({
    String id,
    DateTime timestamp,
    int score,
    String riskLevel,
    List<String> triggeredParameters,
  });
}

/// @nodoc
class _$SepsisAlertCopyWithImpl<$Res, $Val extends SepsisAlert>
    implements $SepsisAlertCopyWith<$Res> {
  _$SepsisAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SepsisAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? score = null,
    Object? riskLevel = null,
    Object? triggeredParameters = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            riskLevel: null == riskLevel
                ? _value.riskLevel
                : riskLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            triggeredParameters: null == triggeredParameters
                ? _value.triggeredParameters
                : triggeredParameters // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SepsisAlertImplCopyWith<$Res>
    implements $SepsisAlertCopyWith<$Res> {
  factory _$$SepsisAlertImplCopyWith(
    _$SepsisAlertImpl value,
    $Res Function(_$SepsisAlertImpl) then,
  ) = __$$SepsisAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime timestamp,
    int score,
    String riskLevel,
    List<String> triggeredParameters,
  });
}

/// @nodoc
class __$$SepsisAlertImplCopyWithImpl<$Res>
    extends _$SepsisAlertCopyWithImpl<$Res, _$SepsisAlertImpl>
    implements _$$SepsisAlertImplCopyWith<$Res> {
  __$$SepsisAlertImplCopyWithImpl(
    _$SepsisAlertImpl _value,
    $Res Function(_$SepsisAlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SepsisAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? score = null,
    Object? riskLevel = null,
    Object? triggeredParameters = null,
  }) {
    return _then(
      _$SepsisAlertImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        riskLevel: null == riskLevel
            ? _value.riskLevel
            : riskLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        triggeredParameters: null == triggeredParameters
            ? _value._triggeredParameters
            : triggeredParameters // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SepsisAlertImpl implements _SepsisAlert {
  const _$SepsisAlertImpl({
    required this.id,
    required this.timestamp,
    required this.score,
    required this.riskLevel,
    required final List<String> triggeredParameters,
  }) : _triggeredParameters = triggeredParameters;

  factory _$SepsisAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$SepsisAlertImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final int score;
  @override
  final String riskLevel;
  final List<String> _triggeredParameters;
  @override
  List<String> get triggeredParameters {
    if (_triggeredParameters is EqualUnmodifiableListView)
      return _triggeredParameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggeredParameters);
  }

  @override
  String toString() {
    return 'SepsisAlert(id: $id, timestamp: $timestamp, score: $score, riskLevel: $riskLevel, triggeredParameters: $triggeredParameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SepsisAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            const DeepCollectionEquality().equals(
              other._triggeredParameters,
              _triggeredParameters,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    timestamp,
    score,
    riskLevel,
    const DeepCollectionEquality().hash(_triggeredParameters),
  );

  /// Create a copy of SepsisAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SepsisAlertImplCopyWith<_$SepsisAlertImpl> get copyWith =>
      __$$SepsisAlertImplCopyWithImpl<_$SepsisAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SepsisAlertImplToJson(this);
  }
}

abstract class _SepsisAlert implements SepsisAlert {
  const factory _SepsisAlert({
    required final String id,
    required final DateTime timestamp,
    required final int score,
    required final String riskLevel,
    required final List<String> triggeredParameters,
  }) = _$SepsisAlertImpl;

  factory _SepsisAlert.fromJson(Map<String, dynamic> json) =
      _$SepsisAlertImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  int get score;
  @override
  String get riskLevel;
  @override
  List<String> get triggeredParameters;

  /// Create a copy of SepsisAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SepsisAlertImplCopyWith<_$SepsisAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

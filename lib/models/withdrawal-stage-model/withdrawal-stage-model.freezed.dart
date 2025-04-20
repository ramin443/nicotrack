// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawal-stage-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WithdrawalStageModel _$WithdrawalStageModelFromJson(Map<String, dynamic> json) {
  return _WithdrawalStageModel.fromJson(json);
}

/// @nodoc
mixin _$WithdrawalStageModel {
  int get intensityLevel => throw _privateConstructorUsedError;
  String get timeAfterQuitting => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get whatHappens =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get symptoms => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get howToCope =>
      throw _privateConstructorUsedError;

  /// Serializes this WithdrawalStageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawalStageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawalStageModelCopyWith<WithdrawalStageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawalStageModelCopyWith<$Res> {
  factory $WithdrawalStageModelCopyWith(WithdrawalStageModel value,
          $Res Function(WithdrawalStageModel) then) =
      _$WithdrawalStageModelCopyWithImpl<$Res, WithdrawalStageModel>;
  @useResult
  $Res call(
      {int intensityLevel,
      String timeAfterQuitting,
      List<Map<String, dynamic>> whatHappens,
      List<Map<String, dynamic>> symptoms,
      List<Map<String, dynamic>> howToCope});
}

/// @nodoc
class _$WithdrawalStageModelCopyWithImpl<$Res,
        $Val extends WithdrawalStageModel>
    implements $WithdrawalStageModelCopyWith<$Res> {
  _$WithdrawalStageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawalStageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensityLevel = null,
    Object? timeAfterQuitting = null,
    Object? whatHappens = null,
    Object? symptoms = null,
    Object? howToCope = null,
  }) {
    return _then(_value.copyWith(
      intensityLevel: null == intensityLevel
          ? _value.intensityLevel
          : intensityLevel // ignore: cast_nullable_to_non_nullable
              as int,
      timeAfterQuitting: null == timeAfterQuitting
          ? _value.timeAfterQuitting
          : timeAfterQuitting // ignore: cast_nullable_to_non_nullable
              as String,
      whatHappens: null == whatHappens
          ? _value.whatHappens
          : whatHappens // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      symptoms: null == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      howToCope: null == howToCope
          ? _value.howToCope
          : howToCope // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WithdrawalStageModelImplCopyWith<$Res>
    implements $WithdrawalStageModelCopyWith<$Res> {
  factory _$$WithdrawalStageModelImplCopyWith(_$WithdrawalStageModelImpl value,
          $Res Function(_$WithdrawalStageModelImpl) then) =
      __$$WithdrawalStageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int intensityLevel,
      String timeAfterQuitting,
      List<Map<String, dynamic>> whatHappens,
      List<Map<String, dynamic>> symptoms,
      List<Map<String, dynamic>> howToCope});
}

/// @nodoc
class __$$WithdrawalStageModelImplCopyWithImpl<$Res>
    extends _$WithdrawalStageModelCopyWithImpl<$Res, _$WithdrawalStageModelImpl>
    implements _$$WithdrawalStageModelImplCopyWith<$Res> {
  __$$WithdrawalStageModelImplCopyWithImpl(_$WithdrawalStageModelImpl _value,
      $Res Function(_$WithdrawalStageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WithdrawalStageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensityLevel = null,
    Object? timeAfterQuitting = null,
    Object? whatHappens = null,
    Object? symptoms = null,
    Object? howToCope = null,
  }) {
    return _then(_$WithdrawalStageModelImpl(
      intensityLevel: null == intensityLevel
          ? _value.intensityLevel
          : intensityLevel // ignore: cast_nullable_to_non_nullable
              as int,
      timeAfterQuitting: null == timeAfterQuitting
          ? _value.timeAfterQuitting
          : timeAfterQuitting // ignore: cast_nullable_to_non_nullable
              as String,
      whatHappens: null == whatHappens
          ? _value._whatHappens
          : whatHappens // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      symptoms: null == symptoms
          ? _value._symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      howToCope: null == howToCope
          ? _value._howToCope
          : howToCope // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WithdrawalStageModelImpl implements _WithdrawalStageModel {
  const _$WithdrawalStageModelImpl(
      {this.intensityLevel = 0,
      required this.timeAfterQuitting,
      required final List<Map<String, dynamic>> whatHappens,
      required final List<Map<String, dynamic>> symptoms,
      required final List<Map<String, dynamic>> howToCope})
      : _whatHappens = whatHappens,
        _symptoms = symptoms,
        _howToCope = howToCope;

  factory _$WithdrawalStageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WithdrawalStageModelImplFromJson(json);

  @override
  @JsonKey()
  final int intensityLevel;
  @override
  final String timeAfterQuitting;
  final List<Map<String, dynamic>> _whatHappens;
  @override
  List<Map<String, dynamic>> get whatHappens {
    if (_whatHappens is EqualUnmodifiableListView) return _whatHappens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_whatHappens);
  }

  final List<Map<String, dynamic>> _symptoms;
  @override
  List<Map<String, dynamic>> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  final List<Map<String, dynamic>> _howToCope;
  @override
  List<Map<String, dynamic>> get howToCope {
    if (_howToCope is EqualUnmodifiableListView) return _howToCope;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_howToCope);
  }

  @override
  String toString() {
    return 'WithdrawalStageModel(intensityLevel: $intensityLevel, timeAfterQuitting: $timeAfterQuitting, whatHappens: $whatHappens, symptoms: $symptoms, howToCope: $howToCope)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawalStageModelImpl &&
            (identical(other.intensityLevel, intensityLevel) ||
                other.intensityLevel == intensityLevel) &&
            (identical(other.timeAfterQuitting, timeAfterQuitting) ||
                other.timeAfterQuitting == timeAfterQuitting) &&
            const DeepCollectionEquality()
                .equals(other._whatHappens, _whatHappens) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality()
                .equals(other._howToCope, _howToCope));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      intensityLevel,
      timeAfterQuitting,
      const DeepCollectionEquality().hash(_whatHappens),
      const DeepCollectionEquality().hash(_symptoms),
      const DeepCollectionEquality().hash(_howToCope));

  /// Create a copy of WithdrawalStageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawalStageModelImplCopyWith<_$WithdrawalStageModelImpl>
      get copyWith =>
          __$$WithdrawalStageModelImplCopyWithImpl<_$WithdrawalStageModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WithdrawalStageModelImplToJson(
      this,
    );
  }
}

abstract class _WithdrawalStageModel implements WithdrawalStageModel {
  const factory _WithdrawalStageModel(
          {final int intensityLevel,
          required final String timeAfterQuitting,
          required final List<Map<String, dynamic>> whatHappens,
          required final List<Map<String, dynamic>> symptoms,
          required final List<Map<String, dynamic>> howToCope}) =
      _$WithdrawalStageModelImpl;

  factory _WithdrawalStageModel.fromJson(Map<String, dynamic> json) =
      _$WithdrawalStageModelImpl.fromJson;

  @override
  int get intensityLevel;
  @override
  String get timeAfterQuitting;
  @override
  List<Map<String, dynamic>> get whatHappens;
  @override
  List<Map<String, dynamic>> get symptoms;
  @override
  List<Map<String, dynamic>> get howToCope;

  /// Create a copy of WithdrawalStageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawalStageModelImplCopyWith<_$WithdrawalStageModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financialGoals-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancialGoalsModel _$FinancialGoalsModelFromJson(Map<String, dynamic> json) {
  return _FinancialGoalsModel.fromJson(json);
}

/// @nodoc
mixin _$FinancialGoalsModel {
  String get emoji => throw _privateConstructorUsedError;
  String get goalTitle => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;

  /// Serializes this FinancialGoalsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialGoalsModelCopyWith<FinancialGoalsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialGoalsModelCopyWith<$Res> {
  factory $FinancialGoalsModelCopyWith(
          FinancialGoalsModel value, $Res Function(FinancialGoalsModel) then) =
      _$FinancialGoalsModelCopyWithImpl<$Res, FinancialGoalsModel>;
  @useResult
  $Res call({String emoji, String goalTitle, double cost});
}

/// @nodoc
class _$FinancialGoalsModelCopyWithImpl<$Res, $Val extends FinancialGoalsModel>
    implements $FinancialGoalsModelCopyWith<$Res> {
  _$FinancialGoalsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? goalTitle = null,
    Object? cost = null,
  }) {
    return _then(_value.copyWith(
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      goalTitle: null == goalTitle
          ? _value.goalTitle
          : goalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialGoalsModelImplCopyWith<$Res>
    implements $FinancialGoalsModelCopyWith<$Res> {
  factory _$$FinancialGoalsModelImplCopyWith(_$FinancialGoalsModelImpl value,
          $Res Function(_$FinancialGoalsModelImpl) then) =
      __$$FinancialGoalsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String emoji, String goalTitle, double cost});
}

/// @nodoc
class __$$FinancialGoalsModelImplCopyWithImpl<$Res>
    extends _$FinancialGoalsModelCopyWithImpl<$Res, _$FinancialGoalsModelImpl>
    implements _$$FinancialGoalsModelImplCopyWith<$Res> {
  __$$FinancialGoalsModelImplCopyWithImpl(_$FinancialGoalsModelImpl _value,
      $Res Function(_$FinancialGoalsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? goalTitle = null,
    Object? cost = null,
  }) {
    return _then(_$FinancialGoalsModelImpl(
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      goalTitle: null == goalTitle
          ? _value.goalTitle
          : goalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialGoalsModelImpl implements _FinancialGoalsModel {
  _$FinancialGoalsModelImpl(
      {this.emoji = "", this.goalTitle = "", this.cost = 0.0});

  factory _$FinancialGoalsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialGoalsModelImplFromJson(json);

  @override
  @JsonKey()
  final String emoji;
  @override
  @JsonKey()
  final String goalTitle;
  @override
  @JsonKey()
  final double cost;

  @override
  String toString() {
    return 'FinancialGoalsModel(emoji: $emoji, goalTitle: $goalTitle, cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialGoalsModelImpl &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.goalTitle, goalTitle) ||
                other.goalTitle == goalTitle) &&
            (identical(other.cost, cost) || other.cost == cost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emoji, goalTitle, cost);

  /// Create a copy of FinancialGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialGoalsModelImplCopyWith<_$FinancialGoalsModelImpl> get copyWith =>
      __$$FinancialGoalsModelImplCopyWithImpl<_$FinancialGoalsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialGoalsModelImplToJson(
      this,
    );
  }
}

abstract class _FinancialGoalsModel implements FinancialGoalsModel {
  factory _FinancialGoalsModel(
      {final String emoji,
      final String goalTitle,
      final double cost}) = _$FinancialGoalsModelImpl;

  factory _FinancialGoalsModel.fromJson(Map<String, dynamic> json) =
      _$FinancialGoalsModelImpl.fromJson;

  @override
  String get emoji;
  @override
  String get goalTitle;
  @override
  double get cost;

  /// Create a copy of FinancialGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialGoalsModelImplCopyWith<_$FinancialGoalsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quickActions-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuickactionsModel _$QuickactionsModelFromJson(Map<String, dynamic> json) {
  return _QuickactionsModel.fromJson(json);
}

/// @nodoc
mixin _$QuickactionsModel {
  bool get firstActionDone => throw _privateConstructorUsedError;
  bool get secondActionDone => throw _privateConstructorUsedError;
  bool get thirdActionDone => throw _privateConstructorUsedError;
  bool get fourthActionDone => throw _privateConstructorUsedError;

  /// Serializes this QuickactionsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuickactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickactionsModelCopyWith<QuickactionsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickactionsModelCopyWith<$Res> {
  factory $QuickactionsModelCopyWith(
          QuickactionsModel value, $Res Function(QuickactionsModel) then) =
      _$QuickactionsModelCopyWithImpl<$Res, QuickactionsModel>;
  @useResult
  $Res call(
      {bool firstActionDone,
      bool secondActionDone,
      bool thirdActionDone,
      bool fourthActionDone});
}

/// @nodoc
class _$QuickactionsModelCopyWithImpl<$Res, $Val extends QuickactionsModel>
    implements $QuickactionsModelCopyWith<$Res> {
  _$QuickactionsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstActionDone = null,
    Object? secondActionDone = null,
    Object? thirdActionDone = null,
    Object? fourthActionDone = null,
  }) {
    return _then(_value.copyWith(
      firstActionDone: null == firstActionDone
          ? _value.firstActionDone
          : firstActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
      secondActionDone: null == secondActionDone
          ? _value.secondActionDone
          : secondActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
      thirdActionDone: null == thirdActionDone
          ? _value.thirdActionDone
          : thirdActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
      fourthActionDone: null == fourthActionDone
          ? _value.fourthActionDone
          : fourthActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuickactionsModelImplCopyWith<$Res>
    implements $QuickactionsModelCopyWith<$Res> {
  factory _$$QuickactionsModelImplCopyWith(_$QuickactionsModelImpl value,
          $Res Function(_$QuickactionsModelImpl) then) =
      __$$QuickactionsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool firstActionDone,
      bool secondActionDone,
      bool thirdActionDone,
      bool fourthActionDone});
}

/// @nodoc
class __$$QuickactionsModelImplCopyWithImpl<$Res>
    extends _$QuickactionsModelCopyWithImpl<$Res, _$QuickactionsModelImpl>
    implements _$$QuickactionsModelImplCopyWith<$Res> {
  __$$QuickactionsModelImplCopyWithImpl(_$QuickactionsModelImpl _value,
      $Res Function(_$QuickactionsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuickactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstActionDone = null,
    Object? secondActionDone = null,
    Object? thirdActionDone = null,
    Object? fourthActionDone = null,
  }) {
    return _then(_$QuickactionsModelImpl(
      firstActionDone: null == firstActionDone
          ? _value.firstActionDone
          : firstActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
      secondActionDone: null == secondActionDone
          ? _value.secondActionDone
          : secondActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
      thirdActionDone: null == thirdActionDone
          ? _value.thirdActionDone
          : thirdActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
      fourthActionDone: null == fourthActionDone
          ? _value.fourthActionDone
          : fourthActionDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickactionsModelImpl implements _QuickactionsModel {
  _$QuickactionsModelImpl(
      {this.firstActionDone = false,
      this.secondActionDone = false,
      this.thirdActionDone = false,
      this.fourthActionDone = false});

  factory _$QuickactionsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickactionsModelImplFromJson(json);

  @override
  @JsonKey()
  final bool firstActionDone;
  @override
  @JsonKey()
  final bool secondActionDone;
  @override
  @JsonKey()
  final bool thirdActionDone;
  @override
  @JsonKey()
  final bool fourthActionDone;

  @override
  String toString() {
    return 'QuickactionsModel(firstActionDone: $firstActionDone, secondActionDone: $secondActionDone, thirdActionDone: $thirdActionDone, fourthActionDone: $fourthActionDone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickactionsModelImpl &&
            (identical(other.firstActionDone, firstActionDone) ||
                other.firstActionDone == firstActionDone) &&
            (identical(other.secondActionDone, secondActionDone) ||
                other.secondActionDone == secondActionDone) &&
            (identical(other.thirdActionDone, thirdActionDone) ||
                other.thirdActionDone == thirdActionDone) &&
            (identical(other.fourthActionDone, fourthActionDone) ||
                other.fourthActionDone == fourthActionDone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstActionDone,
      secondActionDone, thirdActionDone, fourthActionDone);

  /// Create a copy of QuickactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickactionsModelImplCopyWith<_$QuickactionsModelImpl> get copyWith =>
      __$$QuickactionsModelImplCopyWithImpl<_$QuickactionsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickactionsModelImplToJson(
      this,
    );
  }
}

abstract class _QuickactionsModel implements QuickactionsModel {
  factory _QuickactionsModel(
      {final bool firstActionDone,
      final bool secondActionDone,
      final bool thirdActionDone,
      final bool fourthActionDone}) = _$QuickactionsModelImpl;

  factory _QuickactionsModel.fromJson(Map<String, dynamic> json) =
      _$QuickactionsModelImpl.fromJson;

  @override
  bool get firstActionDone;
  @override
  bool get secondActionDone;
  @override
  bool get thirdActionDone;
  @override
  bool get fourthActionDone;

  /// Create a copy of QuickactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickactionsModelImplCopyWith<_$QuickactionsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

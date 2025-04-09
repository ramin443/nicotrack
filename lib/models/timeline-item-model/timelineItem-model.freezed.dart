// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timelineItem-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimelineItemModel _$TimelineItemModelFromJson(Map<String, dynamic> json) {
  return _TimelineItemModel.fromJson(json);
}

/// @nodoc
mixin _$TimelineItemModel {
  int get dayNumber => throw _privateConstructorUsedError;
  int get streakNumber => throw _privateConstructorUsedError;
  String get streakImg => throw _privateConstructorUsedError;
  String get dayDuration => throw _privateConstructorUsedError;
  String get whatHappens => throw _privateConstructorUsedError;

  /// Serializes this TimelineItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineItemModelCopyWith<TimelineItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineItemModelCopyWith<$Res> {
  factory $TimelineItemModelCopyWith(
          TimelineItemModel value, $Res Function(TimelineItemModel) then) =
      _$TimelineItemModelCopyWithImpl<$Res, TimelineItemModel>;
  @useResult
  $Res call(
      {int dayNumber,
      int streakNumber,
      String streakImg,
      String dayDuration,
      String whatHappens});
}

/// @nodoc
class _$TimelineItemModelCopyWithImpl<$Res, $Val extends TimelineItemModel>
    implements $TimelineItemModelCopyWith<$Res> {
  _$TimelineItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? streakNumber = null,
    Object? streakImg = null,
    Object? dayDuration = null,
    Object? whatHappens = null,
  }) {
    return _then(_value.copyWith(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      streakNumber: null == streakNumber
          ? _value.streakNumber
          : streakNumber // ignore: cast_nullable_to_non_nullable
              as int,
      streakImg: null == streakImg
          ? _value.streakImg
          : streakImg // ignore: cast_nullable_to_non_nullable
              as String,
      dayDuration: null == dayDuration
          ? _value.dayDuration
          : dayDuration // ignore: cast_nullable_to_non_nullable
              as String,
      whatHappens: null == whatHappens
          ? _value.whatHappens
          : whatHappens // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelineItemModelImplCopyWith<$Res>
    implements $TimelineItemModelCopyWith<$Res> {
  factory _$$TimelineItemModelImplCopyWith(_$TimelineItemModelImpl value,
          $Res Function(_$TimelineItemModelImpl) then) =
      __$$TimelineItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayNumber,
      int streakNumber,
      String streakImg,
      String dayDuration,
      String whatHappens});
}

/// @nodoc
class __$$TimelineItemModelImplCopyWithImpl<$Res>
    extends _$TimelineItemModelCopyWithImpl<$Res, _$TimelineItemModelImpl>
    implements _$$TimelineItemModelImplCopyWith<$Res> {
  __$$TimelineItemModelImplCopyWithImpl(_$TimelineItemModelImpl _value,
      $Res Function(_$TimelineItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimelineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? streakNumber = null,
    Object? streakImg = null,
    Object? dayDuration = null,
    Object? whatHappens = null,
  }) {
    return _then(_$TimelineItemModelImpl(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      streakNumber: null == streakNumber
          ? _value.streakNumber
          : streakNumber // ignore: cast_nullable_to_non_nullable
              as int,
      streakImg: null == streakImg
          ? _value.streakImg
          : streakImg // ignore: cast_nullable_to_non_nullable
              as String,
      dayDuration: null == dayDuration
          ? _value.dayDuration
          : dayDuration // ignore: cast_nullable_to_non_nullable
              as String,
      whatHappens: null == whatHappens
          ? _value.whatHappens
          : whatHappens // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineItemModelImpl implements _TimelineItemModel {
  _$TimelineItemModelImpl(
      {required this.dayNumber,
      required this.streakNumber,
      required this.streakImg,
      required this.dayDuration,
      required this.whatHappens});

  factory _$TimelineItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineItemModelImplFromJson(json);

  @override
  final int dayNumber;
  @override
  final int streakNumber;
  @override
  final String streakImg;
  @override
  final String dayDuration;
  @override
  final String whatHappens;

  @override
  String toString() {
    return 'TimelineItemModel(dayNumber: $dayNumber, streakNumber: $streakNumber, streakImg: $streakImg, dayDuration: $dayDuration, whatHappens: $whatHappens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineItemModelImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.streakNumber, streakNumber) ||
                other.streakNumber == streakNumber) &&
            (identical(other.streakImg, streakImg) ||
                other.streakImg == streakImg) &&
            (identical(other.dayDuration, dayDuration) ||
                other.dayDuration == dayDuration) &&
            (identical(other.whatHappens, whatHappens) ||
                other.whatHappens == whatHappens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dayNumber, streakNumber,
      streakImg, dayDuration, whatHappens);

  /// Create a copy of TimelineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineItemModelImplCopyWith<_$TimelineItemModelImpl> get copyWith =>
      __$$TimelineItemModelImplCopyWithImpl<_$TimelineItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineItemModelImplToJson(
      this,
    );
  }
}

abstract class _TimelineItemModel implements TimelineItemModel {
  factory _TimelineItemModel(
      {required final int dayNumber,
      required final int streakNumber,
      required final String streakImg,
      required final String dayDuration,
      required final String whatHappens}) = _$TimelineItemModelImpl;

  factory _TimelineItemModel.fromJson(Map<String, dynamic> json) =
      _$TimelineItemModelImpl.fromJson;

  @override
  int get dayNumber;
  @override
  int get streakNumber;
  @override
  String get streakImg;
  @override
  String get dayDuration;
  @override
  String get whatHappens;

  /// Create a copy of TimelineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineItemModelImplCopyWith<_$TimelineItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

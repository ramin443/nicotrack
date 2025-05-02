// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'award-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AwardModel _$AwardModelFromJson(Map<String, dynamic> json) {
  return _AwardModel.fromJson(json);
}

/// @nodoc
mixin _$AwardModel {
  String get emojiImg => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;

  /// Serializes this AwardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AwardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AwardModelCopyWith<AwardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwardModelCopyWith<$Res> {
  factory $AwardModelCopyWith(
          AwardModel value, $Res Function(AwardModel) then) =
      _$AwardModelCopyWithImpl<$Res, AwardModel>;
  @useResult
  $Res call({String emojiImg, int day});
}

/// @nodoc
class _$AwardModelCopyWithImpl<$Res, $Val extends AwardModel>
    implements $AwardModelCopyWith<$Res> {
  _$AwardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AwardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emojiImg = null,
    Object? day = null,
  }) {
    return _then(_value.copyWith(
      emojiImg: null == emojiImg
          ? _value.emojiImg
          : emojiImg // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AwardModelImplCopyWith<$Res>
    implements $AwardModelCopyWith<$Res> {
  factory _$$AwardModelImplCopyWith(
          _$AwardModelImpl value, $Res Function(_$AwardModelImpl) then) =
      __$$AwardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String emojiImg, int day});
}

/// @nodoc
class __$$AwardModelImplCopyWithImpl<$Res>
    extends _$AwardModelCopyWithImpl<$Res, _$AwardModelImpl>
    implements _$$AwardModelImplCopyWith<$Res> {
  __$$AwardModelImplCopyWithImpl(
      _$AwardModelImpl _value, $Res Function(_$AwardModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AwardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emojiImg = null,
    Object? day = null,
  }) {
    return _then(_$AwardModelImpl(
      emojiImg: null == emojiImg
          ? _value.emojiImg
          : emojiImg // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AwardModelImpl implements _AwardModel {
  _$AwardModelImpl({required this.emojiImg, required this.day});

  factory _$AwardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AwardModelImplFromJson(json);

  @override
  final String emojiImg;
  @override
  final int day;

  @override
  String toString() {
    return 'AwardModel(emojiImg: $emojiImg, day: $day)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwardModelImpl &&
            (identical(other.emojiImg, emojiImg) ||
                other.emojiImg == emojiImg) &&
            (identical(other.day, day) || other.day == day));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emojiImg, day);

  /// Create a copy of AwardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwardModelImplCopyWith<_$AwardModelImpl> get copyWith =>
      __$$AwardModelImplCopyWithImpl<_$AwardModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AwardModelImplToJson(
      this,
    );
  }
}

abstract class _AwardModel implements AwardModel {
  factory _AwardModel(
      {required final String emojiImg,
      required final int day}) = _$AwardModelImpl;

  factory _AwardModel.fromJson(Map<String, dynamic> json) =
      _$AwardModelImpl.fromJson;

  @override
  String get emojiImg;
  @override
  int get day;

  /// Create a copy of AwardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwardModelImplCopyWith<_$AwardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

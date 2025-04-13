// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emojitext-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmojiTextModel _$EmojiTextModelFromJson(Map<String, dynamic> json) {
  return _EmojiTextModel.fromJson(json);
}

/// @nodoc
mixin _$EmojiTextModel {
  String get emoji => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Serializes this EmojiTextModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmojiTextModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmojiTextModelCopyWith<EmojiTextModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmojiTextModelCopyWith<$Res> {
  factory $EmojiTextModelCopyWith(
          EmojiTextModel value, $Res Function(EmojiTextModel) then) =
      _$EmojiTextModelCopyWithImpl<$Res, EmojiTextModel>;
  @useResult
  $Res call({String emoji, String text});
}

/// @nodoc
class _$EmojiTextModelCopyWithImpl<$Res, $Val extends EmojiTextModel>
    implements $EmojiTextModelCopyWith<$Res> {
  _$EmojiTextModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmojiTextModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmojiTextModelImplCopyWith<$Res>
    implements $EmojiTextModelCopyWith<$Res> {
  factory _$$EmojiTextModelImplCopyWith(_$EmojiTextModelImpl value,
          $Res Function(_$EmojiTextModelImpl) then) =
      __$$EmojiTextModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String emoji, String text});
}

/// @nodoc
class __$$EmojiTextModelImplCopyWithImpl<$Res>
    extends _$EmojiTextModelCopyWithImpl<$Res, _$EmojiTextModelImpl>
    implements _$$EmojiTextModelImplCopyWith<$Res> {
  __$$EmojiTextModelImplCopyWithImpl(
      _$EmojiTextModelImpl _value, $Res Function(_$EmojiTextModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmojiTextModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? text = null,
  }) {
    return _then(_$EmojiTextModelImpl(
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmojiTextModelImpl implements _EmojiTextModel {
  _$EmojiTextModelImpl({required this.emoji, required this.text});

  factory _$EmojiTextModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmojiTextModelImplFromJson(json);

  @override
  final String emoji;
  @override
  final String text;

  @override
  String toString() {
    return 'EmojiTextModel(emoji: $emoji, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmojiTextModelImpl &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emoji, text);

  /// Create a copy of EmojiTextModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmojiTextModelImplCopyWith<_$EmojiTextModelImpl> get copyWith =>
      __$$EmojiTextModelImplCopyWithImpl<_$EmojiTextModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmojiTextModelImplToJson(
      this,
    );
  }
}

abstract class _EmojiTextModel implements EmojiTextModel {
  factory _EmojiTextModel(
      {required final String emoji,
      required final String text}) = _$EmojiTextModelImpl;

  factory _EmojiTextModel.fromJson(Map<String, dynamic> json) =
      _$EmojiTextModelImpl.fromJson;

  @override
  String get emoji;
  @override
  String get text;

  /// Create a copy of EmojiTextModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmojiTextModelImplCopyWith<_$EmojiTextModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

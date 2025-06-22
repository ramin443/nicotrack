// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MoodModel _$MoodModelFromJson(Map<String, dynamic> json) {
  return _MoodModel.fromJson(json);
}

/// @nodoc
mixin _$MoodModel {
  Map<String, dynamic> get selfFeeling => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get moodAffecting =>
      throw _privateConstructorUsedError;
  int get anyCravingToday => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get craveTiming =>
      throw _privateConstructorUsedError;
  String get reflectionNote => throw _privateConstructorUsedError;

  /// Serializes this MoodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodModelCopyWith<MoodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodModelCopyWith<$Res> {
  factory $MoodModelCopyWith(MoodModel value, $Res Function(MoodModel) then) =
      _$MoodModelCopyWithImpl<$Res, MoodModel>;
  @useResult
  $Res call(
      {Map<String, dynamic> selfFeeling,
      List<Map<String, dynamic>> moodAffecting,
      int anyCravingToday,
      List<Map<String, dynamic>> craveTiming,
      String reflectionNote});
}

/// @nodoc
class _$MoodModelCopyWithImpl<$Res, $Val extends MoodModel>
    implements $MoodModelCopyWith<$Res> {
  _$MoodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selfFeeling = null,
    Object? moodAffecting = null,
    Object? anyCravingToday = null,
    Object? craveTiming = null,
    Object? reflectionNote = null,
  }) {
    return _then(_value.copyWith(
      selfFeeling: null == selfFeeling
          ? _value.selfFeeling
          : selfFeeling // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      moodAffecting: null == moodAffecting
          ? _value.moodAffecting
          : moodAffecting // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      anyCravingToday: null == anyCravingToday
          ? _value.anyCravingToday
          : anyCravingToday // ignore: cast_nullable_to_non_nullable
              as int,
      craveTiming: null == craveTiming
          ? _value.craveTiming
          : craveTiming // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      reflectionNote: null == reflectionNote
          ? _value.reflectionNote
          : reflectionNote // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodModelImplCopyWith<$Res>
    implements $MoodModelCopyWith<$Res> {
  factory _$$MoodModelImplCopyWith(
          _$MoodModelImpl value, $Res Function(_$MoodModelImpl) then) =
      __$$MoodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> selfFeeling,
      List<Map<String, dynamic>> moodAffecting,
      int anyCravingToday,
      List<Map<String, dynamic>> craveTiming,
      String reflectionNote});
}

/// @nodoc
class __$$MoodModelImplCopyWithImpl<$Res>
    extends _$MoodModelCopyWithImpl<$Res, _$MoodModelImpl>
    implements _$$MoodModelImplCopyWith<$Res> {
  __$$MoodModelImplCopyWithImpl(
      _$MoodModelImpl _value, $Res Function(_$MoodModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selfFeeling = null,
    Object? moodAffecting = null,
    Object? anyCravingToday = null,
    Object? craveTiming = null,
    Object? reflectionNote = null,
  }) {
    return _then(_$MoodModelImpl(
      selfFeeling: null == selfFeeling
          ? _value._selfFeeling
          : selfFeeling // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      moodAffecting: null == moodAffecting
          ? _value._moodAffecting
          : moodAffecting // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      anyCravingToday: null == anyCravingToday
          ? _value.anyCravingToday
          : anyCravingToday // ignore: cast_nullable_to_non_nullable
              as int,
      craveTiming: null == craveTiming
          ? _value._craveTiming
          : craveTiming // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      reflectionNote: null == reflectionNote
          ? _value.reflectionNote
          : reflectionNote // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodModelImpl implements _MoodModel {
  _$MoodModelImpl(
      {final Map<String, dynamic> selfFeeling = const {},
      final List<Map<String, dynamic>> moodAffecting = const [],
      this.anyCravingToday = -1,
      final List<Map<String, dynamic>> craveTiming = const [],
      this.reflectionNote = ""})
      : _selfFeeling = selfFeeling,
        _moodAffecting = moodAffecting,
        _craveTiming = craveTiming;

  factory _$MoodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodModelImplFromJson(json);

  final Map<String, dynamic> _selfFeeling;
  @override
  @JsonKey()
  Map<String, dynamic> get selfFeeling {
    if (_selfFeeling is EqualUnmodifiableMapView) return _selfFeeling;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selfFeeling);
  }

  final List<Map<String, dynamic>> _moodAffecting;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get moodAffecting {
    if (_moodAffecting is EqualUnmodifiableListView) return _moodAffecting;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moodAffecting);
  }

  @override
  @JsonKey()
  final int anyCravingToday;
  final List<Map<String, dynamic>> _craveTiming;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get craveTiming {
    if (_craveTiming is EqualUnmodifiableListView) return _craveTiming;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_craveTiming);
  }

  @override
  @JsonKey()
  final String reflectionNote;

  @override
  String toString() {
    return 'MoodModel(selfFeeling: $selfFeeling, moodAffecting: $moodAffecting, anyCravingToday: $anyCravingToday, craveTiming: $craveTiming, reflectionNote: $reflectionNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodModelImpl &&
            const DeepCollectionEquality()
                .equals(other._selfFeeling, _selfFeeling) &&
            const DeepCollectionEquality()
                .equals(other._moodAffecting, _moodAffecting) &&
            (identical(other.anyCravingToday, anyCravingToday) ||
                other.anyCravingToday == anyCravingToday) &&
            const DeepCollectionEquality()
                .equals(other._craveTiming, _craveTiming) &&
            (identical(other.reflectionNote, reflectionNote) ||
                other.reflectionNote == reflectionNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_selfFeeling),
      const DeepCollectionEquality().hash(_moodAffecting),
      anyCravingToday,
      const DeepCollectionEquality().hash(_craveTiming),
      reflectionNote);

  /// Create a copy of MoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodModelImplCopyWith<_$MoodModelImpl> get copyWith =>
      __$$MoodModelImplCopyWithImpl<_$MoodModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodModelImplToJson(
      this,
    );
  }
}

abstract class _MoodModel implements MoodModel {
  factory _MoodModel(
      {final Map<String, dynamic> selfFeeling,
      final List<Map<String, dynamic>> moodAffecting,
      final int anyCravingToday,
      final List<Map<String, dynamic>> craveTiming,
      final String reflectionNote}) = _$MoodModelImpl;

  factory _MoodModel.fromJson(Map<String, dynamic> json) =
      _$MoodModelImpl.fromJson;

  @override
  Map<String, dynamic> get selfFeeling;
  @override
  List<Map<String, dynamic>> get moodAffecting;
  @override
  int get anyCravingToday;
  @override
  List<Map<String, dynamic>> get craveTiming;
  @override
  String get reflectionNote;

  /// Create a copy of MoodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodModelImplCopyWith<_$MoodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

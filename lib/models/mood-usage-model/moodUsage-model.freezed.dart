// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moodUsage-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MoodUsageModel _$MoodUsageModelFromJson(Map<String, dynamic> json) {
  return _MoodUsageModel.fromJson(json);
}

/// @nodoc
mixin _$MoodUsageModel {
  int get totalMoodEntries => throw _privateConstructorUsedError;
  List<String> get moodEntryDates => throw _privateConstructorUsedError;
  bool get hasReachedLimit => throw _privateConstructorUsedError;
  String? get firstUsageDate => throw _privateConstructorUsedError;

  /// Serializes this MoodUsageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodUsageModelCopyWith<MoodUsageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodUsageModelCopyWith<$Res> {
  factory $MoodUsageModelCopyWith(
          MoodUsageModel value, $Res Function(MoodUsageModel) then) =
      _$MoodUsageModelCopyWithImpl<$Res, MoodUsageModel>;
  @useResult
  $Res call(
      {int totalMoodEntries,
      List<String> moodEntryDates,
      bool hasReachedLimit,
      String? firstUsageDate});
}

/// @nodoc
class _$MoodUsageModelCopyWithImpl<$Res, $Val extends MoodUsageModel>
    implements $MoodUsageModelCopyWith<$Res> {
  _$MoodUsageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMoodEntries = null,
    Object? moodEntryDates = null,
    Object? hasReachedLimit = null,
    Object? firstUsageDate = freezed,
  }) {
    return _then(_value.copyWith(
      totalMoodEntries: null == totalMoodEntries
          ? _value.totalMoodEntries
          : totalMoodEntries // ignore: cast_nullable_to_non_nullable
              as int,
      moodEntryDates: null == moodEntryDates
          ? _value.moodEntryDates
          : moodEntryDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasReachedLimit: null == hasReachedLimit
          ? _value.hasReachedLimit
          : hasReachedLimit // ignore: cast_nullable_to_non_nullable
              as bool,
      firstUsageDate: freezed == firstUsageDate
          ? _value.firstUsageDate
          : firstUsageDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodUsageModelImplCopyWith<$Res>
    implements $MoodUsageModelCopyWith<$Res> {
  factory _$$MoodUsageModelImplCopyWith(_$MoodUsageModelImpl value,
          $Res Function(_$MoodUsageModelImpl) then) =
      __$$MoodUsageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalMoodEntries,
      List<String> moodEntryDates,
      bool hasReachedLimit,
      String? firstUsageDate});
}

/// @nodoc
class __$$MoodUsageModelImplCopyWithImpl<$Res>
    extends _$MoodUsageModelCopyWithImpl<$Res, _$MoodUsageModelImpl>
    implements _$$MoodUsageModelImplCopyWith<$Res> {
  __$$MoodUsageModelImplCopyWithImpl(
      _$MoodUsageModelImpl _value, $Res Function(_$MoodUsageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoodUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMoodEntries = null,
    Object? moodEntryDates = null,
    Object? hasReachedLimit = null,
    Object? firstUsageDate = freezed,
  }) {
    return _then(_$MoodUsageModelImpl(
      totalMoodEntries: null == totalMoodEntries
          ? _value.totalMoodEntries
          : totalMoodEntries // ignore: cast_nullable_to_non_nullable
              as int,
      moodEntryDates: null == moodEntryDates
          ? _value._moodEntryDates
          : moodEntryDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasReachedLimit: null == hasReachedLimit
          ? _value.hasReachedLimit
          : hasReachedLimit // ignore: cast_nullable_to_non_nullable
              as bool,
      firstUsageDate: freezed == firstUsageDate
          ? _value.firstUsageDate
          : firstUsageDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodUsageModelImpl implements _MoodUsageModel {
  _$MoodUsageModelImpl(
      {this.totalMoodEntries = 0,
      final List<String> moodEntryDates = const [],
      this.hasReachedLimit = false,
      this.firstUsageDate})
      : _moodEntryDates = moodEntryDates;

  factory _$MoodUsageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodUsageModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalMoodEntries;
  final List<String> _moodEntryDates;
  @override
  @JsonKey()
  List<String> get moodEntryDates {
    if (_moodEntryDates is EqualUnmodifiableListView) return _moodEntryDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moodEntryDates);
  }

  @override
  @JsonKey()
  final bool hasReachedLimit;
  @override
  final String? firstUsageDate;

  @override
  String toString() {
    return 'MoodUsageModel(totalMoodEntries: $totalMoodEntries, moodEntryDates: $moodEntryDates, hasReachedLimit: $hasReachedLimit, firstUsageDate: $firstUsageDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodUsageModelImpl &&
            (identical(other.totalMoodEntries, totalMoodEntries) ||
                other.totalMoodEntries == totalMoodEntries) &&
            const DeepCollectionEquality()
                .equals(other._moodEntryDates, _moodEntryDates) &&
            (identical(other.hasReachedLimit, hasReachedLimit) ||
                other.hasReachedLimit == hasReachedLimit) &&
            (identical(other.firstUsageDate, firstUsageDate) ||
                other.firstUsageDate == firstUsageDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalMoodEntries,
      const DeepCollectionEquality().hash(_moodEntryDates),
      hasReachedLimit,
      firstUsageDate);

  /// Create a copy of MoodUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodUsageModelImplCopyWith<_$MoodUsageModelImpl> get copyWith =>
      __$$MoodUsageModelImplCopyWithImpl<_$MoodUsageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodUsageModelImplToJson(
      this,
    );
  }
}

abstract class _MoodUsageModel implements MoodUsageModel {
  factory _MoodUsageModel(
      {final int totalMoodEntries,
      final List<String> moodEntryDates,
      final bool hasReachedLimit,
      final String? firstUsageDate}) = _$MoodUsageModelImpl;

  factory _MoodUsageModel.fromJson(Map<String, dynamic> json) =
      _$MoodUsageModelImpl.fromJson;

  @override
  int get totalMoodEntries;
  @override
  List<String> get moodEntryDates;
  @override
  bool get hasReachedLimit;
  @override
  String? get firstUsageDate;

  /// Create a copy of MoodUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodUsageModelImplCopyWith<_$MoodUsageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

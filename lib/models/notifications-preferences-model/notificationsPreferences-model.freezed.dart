// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notificationsPreferences-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationsPreferencesModel _$NotificationsPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationsPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationsPreferencesModel {
  bool get pushNotificationsActivated => throw _privateConstructorUsedError;
  bool get manuallyDisabled =>
      throw _privateConstructorUsedError; // Track if user manually turned off notifications in settings
// Daily reminder time stored as separate components (following app's pattern)
  int get dailyReminderHour =>
      throw _privateConstructorUsedError; // 0-11 for 12-hour format
  int get dailyReminderMinute => throw _privateConstructorUsedError; // 0-59
  String get dailyReminderPeriod =>
      throw _privateConstructorUsedError; // " AM" or " PM" (with space to match app pattern)
// Weekly summary notification
  String get weeklyReminderDay =>
      throw _privateConstructorUsedError; // Full weekday name to match app pattern
  int get weeklyReminderHour =>
      throw _privateConstructorUsedError; // 0-11 for 12-hour format
  int get weeklyReminderMinute => throw _privateConstructorUsedError; // 0-59
  String get weeklyReminderPeriod => throw _privateConstructorUsedError;

  /// Serializes this NotificationsPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationsPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationsPreferencesModelCopyWith<NotificationsPreferencesModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsPreferencesModelCopyWith<$Res> {
  factory $NotificationsPreferencesModelCopyWith(
          NotificationsPreferencesModel value,
          $Res Function(NotificationsPreferencesModel) then) =
      _$NotificationsPreferencesModelCopyWithImpl<$Res,
          NotificationsPreferencesModel>;
  @useResult
  $Res call(
      {bool pushNotificationsActivated,
      bool manuallyDisabled,
      int dailyReminderHour,
      int dailyReminderMinute,
      String dailyReminderPeriod,
      String weeklyReminderDay,
      int weeklyReminderHour,
      int weeklyReminderMinute,
      String weeklyReminderPeriod});
}

/// @nodoc
class _$NotificationsPreferencesModelCopyWithImpl<$Res,
        $Val extends NotificationsPreferencesModel>
    implements $NotificationsPreferencesModelCopyWith<$Res> {
  _$NotificationsPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationsPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushNotificationsActivated = null,
    Object? manuallyDisabled = null,
    Object? dailyReminderHour = null,
    Object? dailyReminderMinute = null,
    Object? dailyReminderPeriod = null,
    Object? weeklyReminderDay = null,
    Object? weeklyReminderHour = null,
    Object? weeklyReminderMinute = null,
    Object? weeklyReminderPeriod = null,
  }) {
    return _then(_value.copyWith(
      pushNotificationsActivated: null == pushNotificationsActivated
          ? _value.pushNotificationsActivated
          : pushNotificationsActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      manuallyDisabled: null == manuallyDisabled
          ? _value.manuallyDisabled
          : manuallyDisabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyReminderHour: null == dailyReminderHour
          ? _value.dailyReminderHour
          : dailyReminderHour // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderMinute: null == dailyReminderMinute
          ? _value.dailyReminderMinute
          : dailyReminderMinute // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderPeriod: null == dailyReminderPeriod
          ? _value.dailyReminderPeriod
          : dailyReminderPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyReminderDay: null == weeklyReminderDay
          ? _value.weeklyReminderDay
          : weeklyReminderDay // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyReminderHour: null == weeklyReminderHour
          ? _value.weeklyReminderHour
          : weeklyReminderHour // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyReminderMinute: null == weeklyReminderMinute
          ? _value.weeklyReminderMinute
          : weeklyReminderMinute // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyReminderPeriod: null == weeklyReminderPeriod
          ? _value.weeklyReminderPeriod
          : weeklyReminderPeriod // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsPreferencesModelImplCopyWith<$Res>
    implements $NotificationsPreferencesModelCopyWith<$Res> {
  factory _$$NotificationsPreferencesModelImplCopyWith(
          _$NotificationsPreferencesModelImpl value,
          $Res Function(_$NotificationsPreferencesModelImpl) then) =
      __$$NotificationsPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool pushNotificationsActivated,
      bool manuallyDisabled,
      int dailyReminderHour,
      int dailyReminderMinute,
      String dailyReminderPeriod,
      String weeklyReminderDay,
      int weeklyReminderHour,
      int weeklyReminderMinute,
      String weeklyReminderPeriod});
}

/// @nodoc
class __$$NotificationsPreferencesModelImplCopyWithImpl<$Res>
    extends _$NotificationsPreferencesModelCopyWithImpl<$Res,
        _$NotificationsPreferencesModelImpl>
    implements _$$NotificationsPreferencesModelImplCopyWith<$Res> {
  __$$NotificationsPreferencesModelImplCopyWithImpl(
      _$NotificationsPreferencesModelImpl _value,
      $Res Function(_$NotificationsPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationsPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushNotificationsActivated = null,
    Object? manuallyDisabled = null,
    Object? dailyReminderHour = null,
    Object? dailyReminderMinute = null,
    Object? dailyReminderPeriod = null,
    Object? weeklyReminderDay = null,
    Object? weeklyReminderHour = null,
    Object? weeklyReminderMinute = null,
    Object? weeklyReminderPeriod = null,
  }) {
    return _then(_$NotificationsPreferencesModelImpl(
      pushNotificationsActivated: null == pushNotificationsActivated
          ? _value.pushNotificationsActivated
          : pushNotificationsActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      manuallyDisabled: null == manuallyDisabled
          ? _value.manuallyDisabled
          : manuallyDisabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyReminderHour: null == dailyReminderHour
          ? _value.dailyReminderHour
          : dailyReminderHour // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderMinute: null == dailyReminderMinute
          ? _value.dailyReminderMinute
          : dailyReminderMinute // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderPeriod: null == dailyReminderPeriod
          ? _value.dailyReminderPeriod
          : dailyReminderPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyReminderDay: null == weeklyReminderDay
          ? _value.weeklyReminderDay
          : weeklyReminderDay // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyReminderHour: null == weeklyReminderHour
          ? _value.weeklyReminderHour
          : weeklyReminderHour // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyReminderMinute: null == weeklyReminderMinute
          ? _value.weeklyReminderMinute
          : weeklyReminderMinute // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyReminderPeriod: null == weeklyReminderPeriod
          ? _value.weeklyReminderPeriod
          : weeklyReminderPeriod // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationsPreferencesModelImpl
    implements _NotificationsPreferencesModel {
  _$NotificationsPreferencesModelImpl(
      {this.pushNotificationsActivated = false,
      this.manuallyDisabled = false,
      this.dailyReminderHour = 8,
      this.dailyReminderMinute = 0,
      this.dailyReminderPeriod = " AM",
      this.weeklyReminderDay = "Monday",
      this.weeklyReminderHour = 6,
      this.weeklyReminderMinute = 0,
      this.weeklyReminderPeriod = " PM"});

  factory _$NotificationsPreferencesModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NotificationsPreferencesModelImplFromJson(json);

  @override
  @JsonKey()
  final bool pushNotificationsActivated;
  @override
  @JsonKey()
  final bool manuallyDisabled;
// Track if user manually turned off notifications in settings
// Daily reminder time stored as separate components (following app's pattern)
  @override
  @JsonKey()
  final int dailyReminderHour;
// 0-11 for 12-hour format
  @override
  @JsonKey()
  final int dailyReminderMinute;
// 0-59
  @override
  @JsonKey()
  final String dailyReminderPeriod;
// " AM" or " PM" (with space to match app pattern)
// Weekly summary notification
  @override
  @JsonKey()
  final String weeklyReminderDay;
// Full weekday name to match app pattern
  @override
  @JsonKey()
  final int weeklyReminderHour;
// 0-11 for 12-hour format
  @override
  @JsonKey()
  final int weeklyReminderMinute;
// 0-59
  @override
  @JsonKey()
  final String weeklyReminderPeriod;

  @override
  String toString() {
    return 'NotificationsPreferencesModel(pushNotificationsActivated: $pushNotificationsActivated, manuallyDisabled: $manuallyDisabled, dailyReminderHour: $dailyReminderHour, dailyReminderMinute: $dailyReminderMinute, dailyReminderPeriod: $dailyReminderPeriod, weeklyReminderDay: $weeklyReminderDay, weeklyReminderHour: $weeklyReminderHour, weeklyReminderMinute: $weeklyReminderMinute, weeklyReminderPeriod: $weeklyReminderPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsPreferencesModelImpl &&
            (identical(other.pushNotificationsActivated,
                    pushNotificationsActivated) ||
                other.pushNotificationsActivated ==
                    pushNotificationsActivated) &&
            (identical(other.manuallyDisabled, manuallyDisabled) ||
                other.manuallyDisabled == manuallyDisabled) &&
            (identical(other.dailyReminderHour, dailyReminderHour) ||
                other.dailyReminderHour == dailyReminderHour) &&
            (identical(other.dailyReminderMinute, dailyReminderMinute) ||
                other.dailyReminderMinute == dailyReminderMinute) &&
            (identical(other.dailyReminderPeriod, dailyReminderPeriod) ||
                other.dailyReminderPeriod == dailyReminderPeriod) &&
            (identical(other.weeklyReminderDay, weeklyReminderDay) ||
                other.weeklyReminderDay == weeklyReminderDay) &&
            (identical(other.weeklyReminderHour, weeklyReminderHour) ||
                other.weeklyReminderHour == weeklyReminderHour) &&
            (identical(other.weeklyReminderMinute, weeklyReminderMinute) ||
                other.weeklyReminderMinute == weeklyReminderMinute) &&
            (identical(other.weeklyReminderPeriod, weeklyReminderPeriod) ||
                other.weeklyReminderPeriod == weeklyReminderPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pushNotificationsActivated,
      manuallyDisabled,
      dailyReminderHour,
      dailyReminderMinute,
      dailyReminderPeriod,
      weeklyReminderDay,
      weeklyReminderHour,
      weeklyReminderMinute,
      weeklyReminderPeriod);

  /// Create a copy of NotificationsPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsPreferencesModelImplCopyWith<
          _$NotificationsPreferencesModelImpl>
      get copyWith => __$$NotificationsPreferencesModelImplCopyWithImpl<
          _$NotificationsPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationsPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationsPreferencesModel
    implements NotificationsPreferencesModel {
  factory _NotificationsPreferencesModel(
      {final bool pushNotificationsActivated,
      final bool manuallyDisabled,
      final int dailyReminderHour,
      final int dailyReminderMinute,
      final String dailyReminderPeriod,
      final String weeklyReminderDay,
      final int weeklyReminderHour,
      final int weeklyReminderMinute,
      final String weeklyReminderPeriod}) = _$NotificationsPreferencesModelImpl;

  factory _NotificationsPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$NotificationsPreferencesModelImpl.fromJson;

  @override
  bool get pushNotificationsActivated;
  @override
  bool
      get manuallyDisabled; // Track if user manually turned off notifications in settings
// Daily reminder time stored as separate components (following app's pattern)
  @override
  int get dailyReminderHour; // 0-11 for 12-hour format
  @override
  int get dailyReminderMinute; // 0-59
  @override
  String
      get dailyReminderPeriod; // " AM" or " PM" (with space to match app pattern)
// Weekly summary notification
  @override
  String get weeklyReminderDay; // Full weekday name to match app pattern
  @override
  int get weeklyReminderHour; // 0-11 for 12-hour format
  @override
  int get weeklyReminderMinute; // 0-59
  @override
  String get weeklyReminderPeriod;

  /// Create a copy of NotificationsPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationsPreferencesModelImplCopyWith<
          _$NotificationsPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

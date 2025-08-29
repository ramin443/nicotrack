// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appPreferences-model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppPreferencesModel _$AppPreferencesModelFromJson(Map<String, dynamic> json) {
  return _AppPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$AppPreferencesModel {
  @HiveField(0)
  String get currencyCode => throw _privateConstructorUsedError;
  @HiveField(1)
  String get currencySymbol => throw _privateConstructorUsedError;
  @HiveField(2)
  String get locale => throw _privateConstructorUsedError;
  @HiveField(3)
  String get languageName => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isQuickActionsExpanded => throw _privateConstructorUsedError;

  /// Serializes this AppPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppPreferencesModelCopyWith<AppPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppPreferencesModelCopyWith<$Res> {
  factory $AppPreferencesModelCopyWith(
          AppPreferencesModel value, $Res Function(AppPreferencesModel) then) =
      _$AppPreferencesModelCopyWithImpl<$Res, AppPreferencesModel>;
  @useResult
  $Res call(
      {@HiveField(0) String currencyCode,
      @HiveField(1) String currencySymbol,
      @HiveField(2) String locale,
      @HiveField(3) String languageName,
      @HiveField(4) DateTime? lastUpdated,
      @HiveField(5) bool isQuickActionsExpanded});
}

/// @nodoc
class _$AppPreferencesModelCopyWithImpl<$Res, $Val extends AppPreferencesModel>
    implements $AppPreferencesModelCopyWith<$Res> {
  _$AppPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? locale = null,
    Object? languageName = null,
    Object? lastUpdated = freezed,
    Object? isQuickActionsExpanded = null,
  }) {
    return _then(_value.copyWith(
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      languageName: null == languageName
          ? _value.languageName
          : languageName // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isQuickActionsExpanded: null == isQuickActionsExpanded
          ? _value.isQuickActionsExpanded
          : isQuickActionsExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppPreferencesModelImplCopyWith<$Res>
    implements $AppPreferencesModelCopyWith<$Res> {
  factory _$$AppPreferencesModelImplCopyWith(_$AppPreferencesModelImpl value,
          $Res Function(_$AppPreferencesModelImpl) then) =
      __$$AppPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String currencyCode,
      @HiveField(1) String currencySymbol,
      @HiveField(2) String locale,
      @HiveField(3) String languageName,
      @HiveField(4) DateTime? lastUpdated,
      @HiveField(5) bool isQuickActionsExpanded});
}

/// @nodoc
class __$$AppPreferencesModelImplCopyWithImpl<$Res>
    extends _$AppPreferencesModelCopyWithImpl<$Res, _$AppPreferencesModelImpl>
    implements _$$AppPreferencesModelImplCopyWith<$Res> {
  __$$AppPreferencesModelImplCopyWithImpl(_$AppPreferencesModelImpl _value,
      $Res Function(_$AppPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? locale = null,
    Object? languageName = null,
    Object? lastUpdated = freezed,
    Object? isQuickActionsExpanded = null,
  }) {
    return _then(_$AppPreferencesModelImpl(
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      languageName: null == languageName
          ? _value.languageName
          : languageName // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isQuickActionsExpanded: null == isQuickActionsExpanded
          ? _value.isQuickActionsExpanded
          : isQuickActionsExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppPreferencesModelImpl implements _AppPreferencesModel {
  _$AppPreferencesModelImpl(
      {@HiveField(0) this.currencyCode = "USD",
      @HiveField(1) this.currencySymbol = "\$",
      @HiveField(2) this.locale = "en_US",
      @HiveField(3) this.languageName = "English",
      @HiveField(4) this.lastUpdated,
      @HiveField(5) this.isQuickActionsExpanded = true});

  factory _$AppPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppPreferencesModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String currencyCode;
  @override
  @JsonKey()
  @HiveField(1)
  final String currencySymbol;
  @override
  @JsonKey()
  @HiveField(2)
  final String locale;
  @override
  @JsonKey()
  @HiveField(3)
  final String languageName;
  @override
  @HiveField(4)
  final DateTime? lastUpdated;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isQuickActionsExpanded;

  @override
  String toString() {
    return 'AppPreferencesModel(currencyCode: $currencyCode, currencySymbol: $currencySymbol, locale: $locale, languageName: $languageName, lastUpdated: $lastUpdated, isQuickActionsExpanded: $isQuickActionsExpanded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppPreferencesModelImpl &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.languageName, languageName) ||
                other.languageName == languageName) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isQuickActionsExpanded, isQuickActionsExpanded) ||
                other.isQuickActionsExpanded == isQuickActionsExpanded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currencyCode, currencySymbol,
      locale, languageName, lastUpdated, isQuickActionsExpanded);

  /// Create a copy of AppPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppPreferencesModelImplCopyWith<_$AppPreferencesModelImpl> get copyWith =>
      __$$AppPreferencesModelImplCopyWithImpl<_$AppPreferencesModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _AppPreferencesModel implements AppPreferencesModel {
  factory _AppPreferencesModel(
          {@HiveField(0) final String currencyCode,
          @HiveField(1) final String currencySymbol,
          @HiveField(2) final String locale,
          @HiveField(3) final String languageName,
          @HiveField(4) final DateTime? lastUpdated,
          @HiveField(5) final bool isQuickActionsExpanded}) =
      _$AppPreferencesModelImpl;

  factory _AppPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$AppPreferencesModelImpl.fromJson;

  @override
  @HiveField(0)
  String get currencyCode;
  @override
  @HiveField(1)
  String get currencySymbol;
  @override
  @HiveField(2)
  String get locale;
  @override
  @HiveField(3)
  String get languageName;
  @override
  @HiveField(4)
  DateTime? get lastUpdated;
  @override
  @HiveField(5)
  bool get isQuickActionsExpanded;

  /// Create a copy of AppPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppPreferencesModelImplCopyWith<_$AppPreferencesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

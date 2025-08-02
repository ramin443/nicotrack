// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationsPreferences-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationsPreferencesModelImpl
    _$$NotificationsPreferencesModelImplFromJson(Map<String, dynamic> json) =>
        _$NotificationsPreferencesModelImpl(
          pushNotificationsActivated:
              json['pushNotificationsActivated'] as bool? ?? false,
          manuallyDisabled: json['manuallyDisabled'] as bool? ?? false,
          dailyReminderHour: (json['dailyReminderHour'] as num?)?.toInt() ?? 8,
          dailyReminderMinute:
              (json['dailyReminderMinute'] as num?)?.toInt() ?? 0,
          dailyReminderPeriod: json['dailyReminderPeriod'] as String? ?? " AM",
          morningReminderHour:
              (json['morningReminderHour'] as num?)?.toInt() ?? 8,
          morningReminderMinute:
              (json['morningReminderMinute'] as num?)?.toInt() ?? 0,
          morningReminderPeriod:
              json['morningReminderPeriod'] as String? ?? " AM",
          eveningReminderHour:
              (json['eveningReminderHour'] as num?)?.toInt() ?? 8,
          eveningReminderMinute:
              (json['eveningReminderMinute'] as num?)?.toInt() ?? 0,
          eveningReminderPeriod:
              json['eveningReminderPeriod'] as String? ?? " PM",
          weeklyReminderDay: json['weeklyReminderDay'] as String? ?? "Monday",
          weeklyReminderHour:
              (json['weeklyReminderHour'] as num?)?.toInt() ?? 6,
          weeklyReminderMinute:
              (json['weeklyReminderMinute'] as num?)?.toInt() ?? 0,
          weeklyReminderPeriod:
              json['weeklyReminderPeriod'] as String? ?? " PM",
        );

Map<String, dynamic> _$$NotificationsPreferencesModelImplToJson(
        _$NotificationsPreferencesModelImpl instance) =>
    <String, dynamic>{
      'pushNotificationsActivated': instance.pushNotificationsActivated,
      'manuallyDisabled': instance.manuallyDisabled,
      'dailyReminderHour': instance.dailyReminderHour,
      'dailyReminderMinute': instance.dailyReminderMinute,
      'dailyReminderPeriod': instance.dailyReminderPeriod,
      'morningReminderHour': instance.morningReminderHour,
      'morningReminderMinute': instance.morningReminderMinute,
      'morningReminderPeriod': instance.morningReminderPeriod,
      'eveningReminderHour': instance.eveningReminderHour,
      'eveningReminderMinute': instance.eveningReminderMinute,
      'eveningReminderPeriod': instance.eveningReminderPeriod,
      'weeklyReminderDay': instance.weeklyReminderDay,
      'weeklyReminderHour': instance.weeklyReminderHour,
      'weeklyReminderMinute': instance.weeklyReminderMinute,
      'weeklyReminderPeriod': instance.weeklyReminderPeriod,
    };

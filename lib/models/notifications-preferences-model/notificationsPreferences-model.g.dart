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
          dailyReminderHour: (json['dailyReminderHour'] as num?)?.toInt() ?? 8,
          dailyReminderMinute:
              (json['dailyReminderMinute'] as num?)?.toInt() ?? 0,
          dailyReminderPeriod: json['dailyReminderPeriod'] as String? ?? " AM",
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
      'dailyReminderHour': instance.dailyReminderHour,
      'dailyReminderMinute': instance.dailyReminderMinute,
      'dailyReminderPeriod': instance.dailyReminderPeriod,
      'weeklyReminderDay': instance.weeklyReminderDay,
      'weeklyReminderHour': instance.weeklyReminderHour,
      'weeklyReminderMinute': instance.weeklyReminderMinute,
      'weeklyReminderPeriod': instance.weeklyReminderPeriod,
    };

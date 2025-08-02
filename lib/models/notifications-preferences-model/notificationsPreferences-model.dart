import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notificationsPreferences-model.freezed.dart';
part 'notificationsPreferences-model.g.dart';

@freezed
class NotificationsPreferencesModel with _$NotificationsPreferencesModel {
  // Define a factory constructor with required fields
  factory NotificationsPreferencesModel({
    @Default(false) bool pushNotificationsActivated,
    @Default(false) bool manuallyDisabled, // Track if user manually turned off notifications in settings
    // Daily reminder time stored as separate components (following app's pattern)
    @Default(8) int dailyReminderHour, // 0-11 for 12-hour format
    @Default(0) int dailyReminderMinute, // 0-59
    @Default(" AM") String dailyReminderPeriod, // " AM" or " PM" (with space to match app pattern)
    // Morning notification time
    @Default(8) int morningReminderHour, // 0-11 for 12-hour format (default 8 AM)
    @Default(0) int morningReminderMinute, // 0-59
    @Default(" AM") String morningReminderPeriod, // " AM" or " PM"
    // Evening notification time
    @Default(8) int eveningReminderHour, // 0-11 for 12-hour format (default 8 PM)
    @Default(0) int eveningReminderMinute, // 0-59
    @Default(" PM") String eveningReminderPeriod, // " AM" or " PM"
    // Weekly summary notification
    @Default("Monday") String weeklyReminderDay, // Full weekday name to match app pattern
    @Default(6) int weeklyReminderHour, // 0-11 for 12-hour format  
    @Default(0) int weeklyReminderMinute, // 0-59
    @Default(" PM") String weeklyReminderPeriod, // " AM" or " PM" (with space to match app pattern)
  }) = _NotificationsPreferencesModel;

  // Add a factory constructor for JSON serialization
  factory NotificationsPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPreferencesModelFromJson(json);
}
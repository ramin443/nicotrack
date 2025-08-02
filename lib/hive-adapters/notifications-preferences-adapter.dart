import 'package:hive/hive.dart';
import 'package:nicotrack/models/notifications-preferences-model/notificationsPreferences-model.dart';

class NotificationsPreferencesAdapter extends TypeAdapter<NotificationsPreferencesModel> {
  @override
  final int typeId = 5; // Assign a unique Type ID (using 5 as next available)

  @override
  NotificationsPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Handle backward compatibility with old format (8 fields) vs new format (15 fields)
    if (numOfFields == 8) {
      // Old format: 8 fields without morning/evening times
      return NotificationsPreferencesModel(
        pushNotificationsActivated: fields[0] as bool? ?? false,
        manuallyDisabled: false, // New field, default to false
        dailyReminderHour: fields[1] as int? ?? 8,
        dailyReminderMinute: fields[2] as int? ?? 0,
        dailyReminderPeriod: fields[3] as String? ?? " AM",
        morningReminderHour: 8, // New field, default to 8 AM
        morningReminderMinute: 0, // New field, default
        morningReminderPeriod: " AM", // New field, default
        eveningReminderHour: 8, // New field, default to 8 PM
        eveningReminderMinute: 0, // New field, default
        eveningReminderPeriod: " PM", // New field, default
        weeklyReminderDay: fields[4] as String? ?? "Monday",
        weeklyReminderHour: fields[5] as int? ?? 6,
        weeklyReminderMinute: fields[6] as int? ?? 0,
        weeklyReminderPeriod: fields[7] as String? ?? " PM",
      );
    } else {
      // New format: 15 fields with morning/evening times
      return NotificationsPreferencesModel(
        pushNotificationsActivated: fields[0] as bool? ?? false,
        manuallyDisabled: fields[1] as bool? ?? false,
        dailyReminderHour: fields[2] as int? ?? 8,
        dailyReminderMinute: fields[3] as int? ?? 0,
        dailyReminderPeriod: fields[4] as String? ?? " AM",
        morningReminderHour: fields[5] as int? ?? 8,
        morningReminderMinute: fields[6] as int? ?? 0,
        morningReminderPeriod: fields[7] as String? ?? " AM",
        eveningReminderHour: fields[8] as int? ?? 8,
        eveningReminderMinute: fields[9] as int? ?? 0,
        eveningReminderPeriod: fields[10] as String? ?? " PM",
        weeklyReminderDay: fields[11] as String? ?? "Monday",
        weeklyReminderHour: fields[12] as int? ?? 6,
        weeklyReminderMinute: fields[13] as int? ?? 0,
        weeklyReminderPeriod: fields[14] as String? ?? " PM",
      );
    }
  }

  @override
  void write(BinaryWriter writer, NotificationsPreferencesModel obj) {
    writer
      ..writeByte(15) // Current number of fields being written (increased from 8 to 15)

      ..writeByte(0) // Field index 0
      ..write(obj.pushNotificationsActivated)

      ..writeByte(1) // Field index 1
      ..write(obj.manuallyDisabled)

      ..writeByte(2) // Field index 2
      ..write(obj.dailyReminderHour)

      ..writeByte(3) // Field index 3
      ..write(obj.dailyReminderMinute)

      ..writeByte(4) // Field index 4
      ..write(obj.dailyReminderPeriod)

      ..writeByte(5) // Field index 5
      ..write(obj.morningReminderHour)

      ..writeByte(6) // Field index 6
      ..write(obj.morningReminderMinute)

      ..writeByte(7) // Field index 7
      ..write(obj.morningReminderPeriod)

      ..writeByte(8) // Field index 8
      ..write(obj.eveningReminderHour)

      ..writeByte(9) // Field index 9
      ..write(obj.eveningReminderMinute)

      ..writeByte(10) // Field index 10
      ..write(obj.eveningReminderPeriod)

      ..writeByte(11) // Field index 11
      ..write(obj.weeklyReminderDay)

      ..writeByte(12) // Field index 12
      ..write(obj.weeklyReminderHour)

      ..writeByte(13) // Field index 13
      ..write(obj.weeklyReminderMinute)

      ..writeByte(14) // Field index 14
      ..write(obj.weeklyReminderPeriod);
  }

  // Optional but good practice for TypeAdapter
  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NotificationsPreferencesAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
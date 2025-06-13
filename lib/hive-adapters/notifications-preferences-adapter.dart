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

    return NotificationsPreferencesModel(
      pushNotificationsActivated: fields[0] as bool? ?? false,
      dailyReminderHour: fields[1] as int? ?? 8,
      dailyReminderMinute: fields[2] as int? ?? 0,
      dailyReminderPeriod: fields[3] as String? ?? " AM",
      weeklyReminderDay: fields[4] as String? ?? "Monday",
      weeklyReminderHour: fields[5] as int? ?? 6,
      weeklyReminderMinute: fields[6] as int? ?? 0,
      weeklyReminderPeriod: fields[7] as String? ?? " PM",
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsPreferencesModel obj) {
    writer
      ..writeByte(8) // Current number of fields being written

      ..writeByte(0) // Field index 0
      ..write(obj.pushNotificationsActivated)

      ..writeByte(1) // Field index 1
      ..write(obj.dailyReminderHour)

      ..writeByte(2) // Field index 2
      ..write(obj.dailyReminderMinute)

      ..writeByte(3) // Field index 3
      ..write(obj.dailyReminderPeriod)

      ..writeByte(4) // Field index 4
      ..write(obj.weeklyReminderDay)

      ..writeByte(5) // Field index 5
      ..write(obj.weeklyReminderHour)

      ..writeByte(6) // Field index 6
      ..write(obj.weeklyReminderMinute)

      ..writeByte(7) // Field index 7
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
import 'package:hive/hive.dart';
import 'package:nicotrack/models/mood-usage-model/moodUsage-model.dart';

class MoodUsageAdapter extends TypeAdapter<MoodUsageModel> {
  @override
  final int typeId = 10; // Ensure this is unique among your adapters

  @override
  MoodUsageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodUsageModel(
      totalMoodEntries: fields[0] as int,
      moodEntryDates: (fields[1] as List).cast<String>(),
      hasReachedLimit: fields[2] as bool,
      firstUsageDate: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoodUsageModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalMoodEntries)
      ..writeByte(1)
      ..write(obj.moodEntryDates)
      ..writeByte(2)
      ..write(obj.hasReachedLimit)
      ..writeByte(3)
      ..write(obj.firstUsageDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
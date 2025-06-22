import 'package:hive/hive.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart'; // Replace 'your_app_name' with your actual project name

class MoodModelAdapter extends TypeAdapter<MoodModel> {
  @override
  final int typeId = 2; // Assign a unique Type ID (e.g., 2, different from others)

  @override
  MoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Helper to safely cast to Map<String, dynamic>
    Map<String, dynamic> _castMap(dynamic mapData) {
      if (mapData is Map) {
        return Map<String, dynamic>.from(mapData);
      }
      return <String, dynamic>{}; // Default to empty map if type is wrong or data is missing
    }

    // Helper to safely cast to List<Map<String, dynamic>> with backward compatibility
    List<Map<String, dynamic>> _castListOrConvertMap(dynamic data) {
      if (data is List) {
        // New format: already a list
        return data.map((item) => 
          item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{}
        ).toList();
      } else if (data is Map && data.isNotEmpty) {
        // Old format: single map, convert to list
        return [Map<String, dynamic>.from(data)];
      }
      return <Map<String, dynamic>>[]; // Default to empty list
    }

    return MoodModel(
      selfFeeling: _castMap(fields[0]),
      moodAffecting: _castListOrConvertMap(fields[1]),
      anyCravingToday: fields[2] as int? ?? -1,
      craveTiming: _castListOrConvertMap(fields[3]),
      reflectionNote: fields[4] as String? ?? "",
    );
  }

  @override
  void write(BinaryWriter writer, MoodModel obj) {
    writer
      ..writeByte(5) // Current number of fields being written

      ..writeByte(0) // Field index 0
      ..write(obj.selfFeeling) // Hive can store Map<String, dynamic>

      ..writeByte(1) // Field index 1
      ..write(obj.moodAffecting)

      ..writeByte(2) // Field index 2
      ..write(obj.anyCravingToday)

      ..writeByte(3) // Field index 3
      ..write(obj.craveTiming)

      ..writeByte(4) // Field index 4
      ..write(obj.reflectionNote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MoodModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
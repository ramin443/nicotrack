import 'package:hive/hive.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart'; // Replace 'your_app_name'

class DidYouSmokeAdapter extends TypeAdapter<DidYouSmokeModel> {
  @override
  final int typeId = 1; // Assign a unique Type ID (e.g., 1, different from OnboardingData's typeId)

  @override
  DidYouSmokeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Helper to safely cast List<dynamic> to List<Map<String, dynamic>>
    List<Map<String, dynamic>> _castListOfMaps(dynamic list) {
      if (list is List) {
        return list.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{}; // Or throw error, or handle as appropriate
        }).toList();
      }
      return [];
    }

    return DidYouSmokeModel(
      hasSmokedToday: fields[0] as int? ?? -1,
      howManyCigs: fields[1] as int? ?? -1,
      whatTriggerred: _castListOfMaps(fields[2]),
      howYouFeel: _castListOfMaps(fields[3]),
      avoidNext: _castListOfMaps(fields[4]),
      updateQuitDate: fields[5] as int? ?? -1,
    );
  }

  @override
  void write(BinaryWriter writer, DidYouSmokeModel obj) {
    writer
      ..writeByte(6) // Current number of fields being written

      ..writeByte(0) // Field index 0
      ..write(obj.hasSmokedToday)

      ..writeByte(1) // Field index 1
      ..write(obj.howManyCigs)

      ..writeByte(2) // Field index 2
      ..write(obj.whatTriggerred) // Hive can store List<Map<String, dynamic>>

      ..writeByte(3) // Field index 3
      ..write(obj.howYouFeel)

      ..writeByte(4) // Field index 4
      ..write(obj.avoidNext)

      ..writeByte(5) // Field index 5
      ..write(obj.updateQuitDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DidYouSmokeAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
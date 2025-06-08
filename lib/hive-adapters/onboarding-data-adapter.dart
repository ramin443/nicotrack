import 'package:hive/hive.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart'; // Replace 'your_app_name'

class OnboardingDataAdapter extends TypeAdapter<OnboardingData> {
  @override
  final int typeId = 0; // Assign a unique Type ID (e.g., 0 for the first one)

  @override
  OnboardingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return OnboardingData(
      lastSmokedDate: fields[0] as String? ?? "", // Default if null (e.g. old data)
      cigarettesPerDay: fields[1] as int? ?? -1,
      costOfAPack: fields[2] as String? ?? "",
      numberOfCigarettesIn1Pack: fields[3] as int? ?? -1,
      biggestMotivation: (fields[4] as List<dynamic>?)?.cast<String>() ?? [],
      craveSituations: (fields[5] as List<dynamic>?)?.cast<String>() ?? [],
      helpNeeded: (fields[6] as List<dynamic>?)?.cast<String>() ?? [],
      quitMethod: fields[7] as int? ?? -1,
      name: fields[8] as String? ?? "",
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingData obj) {
    writer
      ..writeByte(9) // Current number of fields being written

      ..writeByte(0) // Field index 0
      ..write(obj.lastSmokedDate)

      ..writeByte(1) // Field index 1
      ..write(obj.cigarettesPerDay)

      ..writeByte(2) // Field index 2
      ..write(obj.costOfAPack)

      ..writeByte(3) // Field index 3
      ..write(obj.numberOfCigarettesIn1Pack)

      ..writeByte(4) // Field index 4
      ..write(obj.biggestMotivation) // Hive handles List<String> directly

      ..writeByte(5) // Field index 5
      ..write(obj.craveSituations)

      ..writeByte(6) // Field index 6
      ..write(obj.helpNeeded)

      ..writeByte(7) // Field index 7
      ..write(obj.quitMethod)

      ..writeByte(8) // Field index 8
      ..write(obj.name);
  }

  // Optional but good practice for TypeAdapter
  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OnboardingDataAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
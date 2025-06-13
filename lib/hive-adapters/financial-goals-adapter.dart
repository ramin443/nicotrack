import 'package:hive/hive.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';

class FinancialGoalsAdapter extends TypeAdapter<FinancialGoalsModel> {
  @override
  final int typeId = 4; // Assign a unique Type ID (using 4 as next available)

  @override
  FinancialGoalsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return FinancialGoalsModel(
      emoji: fields[0] as String? ?? "", // Default if null
      goalTitle: fields[1] as String? ?? "",
      cost: fields[2] as double? ?? 0.0,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialGoalsModel obj) {
    writer
      ..writeByte(3) // Current number of fields being written

      ..writeByte(0) // Field index 0
      ..write(obj.emoji)

      ..writeByte(1) // Field index 1
      ..write(obj.goalTitle)

      ..writeByte(2) // Field index 2
      ..write(obj.cost);
  }

  // Optional but good practice for TypeAdapter
  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FinancialGoalsAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
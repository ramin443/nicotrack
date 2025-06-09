import 'package:hive/hive.dart';
import 'package:nicotrack/models/quick-actions-model/quickActions-model.dart'; // Replace 'your_app_name'

class QuickActionsAdapter extends TypeAdapter<QuickactionsModel> {
  @override
  final int typeId = 3; // Choose a unique Type ID (e.g., 0, 1, 2 were used before)

  @override
  QuickactionsModel read(BinaryReader reader) {

    final firstActionDone = reader.readBool();
    final secondActionDone = reader.readBool();
    final thirdActionDone = reader.readBool();
    final fourthActionDone = reader.readBool();

    return QuickactionsModel(
      firstActionDone: firstActionDone,
      secondActionDone: secondActionDone,
      thirdActionDone: thirdActionDone,
      fourthActionDone: fourthActionDone,
    );

  }

  @override
  void write(BinaryWriter writer, QuickactionsModel obj) {
    // Write fields in a specific order
    // Simple way:
    writer.writeBool(obj.firstActionDone);
    writer.writeBool(obj.secondActionDone);
    writer.writeBool(obj.thirdActionDone);
    writer.writeBool(obj.fourthActionDone);

  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QuickActionsAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
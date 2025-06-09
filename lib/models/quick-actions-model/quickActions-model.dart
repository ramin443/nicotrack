import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'quickActions-model.freezed.dart';
part 'quickActions-model.g.dart';

@freezed
class QuickactionsModel with _$QuickactionsModel {
  // Define a factory constructor with required fields
  factory QuickactionsModel({
    @Default(false) bool firstActionDone,
    @Default(false) bool secondActionDone,
    @Default(false) bool thirdActionDone,
    @Default(false) bool fourthActionDone,
  }) = _QuickactionsModel;


  // Add a factory constructor for JSON serialization
  factory QuickactionsModel.fromJson(Map<String, dynamic> json) =>
      _$QuickactionsModelFromJson(json);
}
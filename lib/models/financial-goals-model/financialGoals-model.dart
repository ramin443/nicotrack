import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'financialGoals-model.freezed.dart';
part 'financialGoals-model.g.dart';

@freezed
class FinancialGoalsModel with _$FinancialGoalsModel {
  // Define a factory constructor with required fields
  factory FinancialGoalsModel({
    @Default("") String emoji,
    @Default("") String goalTitle,
    @Default(0.0) double cost,
  }) = _FinancialGoalsModel;

  // Add a factory constructor for JSON serialization
  factory FinancialGoalsModel.fromJson(Map<String, dynamic> json) =>
      _$FinancialGoalsModelFromJson(json);
}
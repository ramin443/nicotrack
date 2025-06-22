import 'package:freezed_annotation/freezed_annotation.dart';

part 'mood-model.freezed.dart';

part 'mood-model.g.dart';

@freezed
class MoodModel with _$MoodModel {
  // Define a factory constructor with required fields
  factory MoodModel({
    @Default({}) Map<String, dynamic> selfFeeling,
    @Default([]) List<Map<String, dynamic>> moodAffecting,
    @Default(-1) int anyCravingToday,
    @Default([]) List<Map<String, dynamic>> craveTiming,
    @Default("") String reflectionNote,
  }) = _MoodModel;

  // Add a factory constructor for JSON serialization
  factory MoodModel.fromJson(Map<String, dynamic> json) =>
      _$MoodModelFromJson(json);
}
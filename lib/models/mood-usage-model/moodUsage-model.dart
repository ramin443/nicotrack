import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'moodUsage-model.freezed.dart';
part 'moodUsage-model.g.dart';

@freezed
class MoodUsageModel with _$MoodUsageModel {
  factory MoodUsageModel({
    @Default(0) int totalMoodEntries,
    @Default([]) List<String> moodEntryDates,
    @Default(false) bool hasReachedLimit,
    String? firstUsageDate,
  }) = _MoodUsageModel;

  factory MoodUsageModel.fromJson(Map<String, dynamic> json) =>
      _$MoodUsageModelFromJson(json);
}
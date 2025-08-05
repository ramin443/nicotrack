// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moodUsage-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoodUsageModelImpl _$$MoodUsageModelImplFromJson(Map<String, dynamic> json) =>
    _$MoodUsageModelImpl(
      totalMoodEntries: (json['totalMoodEntries'] as num?)?.toInt() ?? 0,
      moodEntryDates: (json['moodEntryDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasReachedLimit: json['hasReachedLimit'] as bool? ?? false,
      firstUsageDate: json['firstUsageDate'] as String?,
    );

Map<String, dynamic> _$$MoodUsageModelImplToJson(
        _$MoodUsageModelImpl instance) =>
    <String, dynamic>{
      'totalMoodEntries': instance.totalMoodEntries,
      'moodEntryDates': instance.moodEntryDates,
      'hasReachedLimit': instance.hasReachedLimit,
      'firstUsageDate': instance.firstUsageDate,
    };

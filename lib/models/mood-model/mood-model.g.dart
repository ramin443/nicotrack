// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoodModelImpl _$$MoodModelImplFromJson(Map<String, dynamic> json) =>
    _$MoodModelImpl(
      selfFeeling: json['selfFeeling'] as Map<String, dynamic>? ?? const {},
      moodAffecting: json['moodAffecting'] as Map<String, dynamic>? ?? const {},
      anyCravingToday: (json['anyCravingToday'] as num?)?.toInt() ?? -1,
      craveTiming: json['craveTiming'] as Map<String, dynamic>? ?? const {},
      reflectionNote: json['reflectionNote'] as String? ?? "",
    );

Map<String, dynamic> _$$MoodModelImplToJson(_$MoodModelImpl instance) =>
    <String, dynamic>{
      'selfFeeling': instance.selfFeeling,
      'moodAffecting': instance.moodAffecting,
      'anyCravingToday': instance.anyCravingToday,
      'craveTiming': instance.craveTiming,
      'reflectionNote': instance.reflectionNote,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timelineItem-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineItemModelImpl _$$TimelineItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TimelineItemModelImpl(
      dayNumber: (json['dayNumber'] as num).toInt(),
      streakNumber: (json['streakNumber'] as num).toInt(),
      streakImg: json['streakImg'] as String,
      dayDuration: json['dayDuration'] as String,
      whatHappens: json['whatHappens'] as String,
    );

Map<String, dynamic> _$$TimelineItemModelImplToJson(
        _$TimelineItemModelImpl instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'streakNumber': instance.streakNumber,
      'streakImg': instance.streakImg,
      'dayDuration': instance.dayDuration,
      'whatHappens': instance.whatHappens,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'award-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AwardModelImpl _$$AwardModelImplFromJson(Map<String, dynamic> json) =>
    _$AwardModelImpl(
      emojiImg: json['emojiImg'] as String,
      day: (json['day'] as num).toInt(),
    );

Map<String, dynamic> _$$AwardModelImplToJson(_$AwardModelImpl instance) =>
    <String, dynamic>{
      'emojiImg': instance.emojiImg,
      'day': instance.day,
    };

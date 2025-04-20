// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal-stage-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WithdrawalStageModelImpl _$$WithdrawalStageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WithdrawalStageModelImpl(
      timeAfterQuitting: json['timeAfterQuitting'] as String,
      whatHappens: (json['whatHappens'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      symptoms: (json['symptoms'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      howToCope: (json['howToCope'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$WithdrawalStageModelImplToJson(
        _$WithdrawalStageModelImpl instance) =>
    <String, dynamic>{
      'timeAfterQuitting': instance.timeAfterQuitting,
      'whatHappens': instance.whatHappens,
      'symptoms': instance.symptoms,
      'howToCope': instance.howToCope,
    };

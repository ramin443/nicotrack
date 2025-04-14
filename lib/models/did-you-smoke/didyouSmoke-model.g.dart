// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'didyouSmoke-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DidYouSmokeModelImpl _$$DidYouSmokeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DidYouSmokeModelImpl(
      hasSmokedToday: (json['hasSmokedToday'] as num?)?.toInt() ?? -1,
      howManyCigs: (json['howManyCigs'] as num?)?.toInt() ?? -1,
      whatTriggerred: (json['whatTriggerred'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      howYouFeel: (json['howYouFeel'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      avoidNext: (json['avoidNext'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      updateQuitDate: (json['updateQuitDate'] as num?)?.toInt() ?? -1,
    );

Map<String, dynamic> _$$DidYouSmokeModelImplToJson(
        _$DidYouSmokeModelImpl instance) =>
    <String, dynamic>{
      'hasSmokedToday': instance.hasSmokedToday,
      'howManyCigs': instance.howManyCigs,
      'whatTriggerred': instance.whatTriggerred,
      'howYouFeel': instance.howYouFeel,
      'avoidNext': instance.avoidNext,
      'updateQuitDate': instance.updateQuitDate,
    };

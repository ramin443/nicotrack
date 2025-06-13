// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financialGoals-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialGoalsModelImpl _$$FinancialGoalsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialGoalsModelImpl(
      emoji: json['emoji'] as String? ?? "",
      goalTitle: json['goalTitle'] as String? ?? "",
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$FinancialGoalsModelImplToJson(
        _$FinancialGoalsModelImpl instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'goalTitle': instance.goalTitle,
      'cost': instance.cost,
    };

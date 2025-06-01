// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboardingData-model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingDataAdapter extends TypeAdapter<_$OnboardingDataImpl> {
  @override
  final int typeId = 0;

  @override
  _$OnboardingDataImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$OnboardingDataImpl();
  }

  @override
  void write(BinaryWriter writer, _$OnboardingDataImpl obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingDataImpl _$$OnboardingDataImplFromJson(Map<String, dynamic> json) =>
    _$OnboardingDataImpl(
      lastSmokedDate: json['lastSmokedDate'] as String? ?? "",
      cigarettesPerDay: (json['cigarettesPerDay'] as num?)?.toInt() ?? -1,
      costOfAPack: json['costOfAPack'] as String? ?? "",
      numberOfCigarettesIn1Pack:
          (json['numberOfCigarettesIn1Pack'] as num?)?.toInt() ?? -1,
      biggestMotivation: (json['biggestMotivation'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      craveSituations: (json['craveSituations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      helpNeeded: (json['helpNeeded'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      quitMethod: (json['quitMethod'] as num?)?.toInt() ?? -1,
      name: json['name'] as String? ?? "",
    );

Map<String, dynamic> _$$OnboardingDataImplToJson(
        _$OnboardingDataImpl instance) =>
    <String, dynamic>{
      'lastSmokedDate': instance.lastSmokedDate,
      'cigarettesPerDay': instance.cigarettesPerDay,
      'costOfAPack': instance.costOfAPack,
      'numberOfCigarettesIn1Pack': instance.numberOfCigarettesIn1Pack,
      'biggestMotivation': instance.biggestMotivation,
      'craveSituations': instance.craveSituations,
      'helpNeeded': instance.helpNeeded,
      'quitMethod': instance.quitMethod,
      'name': instance.name,
    };

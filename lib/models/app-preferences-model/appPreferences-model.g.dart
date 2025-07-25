// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appPreferences-model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPreferencesModelAdapter extends TypeAdapter<AppPreferencesModel> {
  @override
  final int typeId = 100;

  @override
  AppPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPreferencesModel(
      currencyCode: fields[0] as String,
      currencySymbol: fields[1] as String,
      locale: fields[2] as String,
      languageName: fields[3] as String,
      lastUpdated: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppPreferencesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.currencyCode)
      ..writeByte(1)
      ..write(obj.currencySymbol)
      ..writeByte(2)
      ..write(obj.locale)
      ..writeByte(3)
      ..write(obj.languageName)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppPreferencesModelImpl _$$AppPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AppPreferencesModelImpl(
      currencyCode: json['currencyCode'] as String? ?? "USD",
      currencySymbol: json['currencySymbol'] as String? ?? "\$",
      locale: json['locale'] as String? ?? "en_US",
      languageName: json['languageName'] as String? ?? "English",
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$AppPreferencesModelImplToJson(
        _$AppPreferencesModelImpl instance) =>
    <String, dynamic>{
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
      'locale': instance.locale,
      'languageName': instance.languageName,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

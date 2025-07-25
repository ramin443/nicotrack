import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'appPreferences-model.freezed.dart';
part 'appPreferences-model.g.dart';

@freezed
@HiveType(typeId: 100) // Unique type ID for Hive
class AppPreferencesModel with _$AppPreferencesModel {
  // Define a factory constructor with required fields
  factory AppPreferencesModel({
    @HiveField(0) @Default("USD") String currencyCode,
    @HiveField(1) @Default("\$") String currencySymbol,
    @HiveField(2) @Default("en_US") String locale,
    @HiveField(3) @Default("English") String languageName,
    @HiveField(4) DateTime? lastUpdated,
  }) = _AppPreferencesModel;

  // Add a factory constructor for JSON serialization
  factory AppPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$AppPreferencesModelFromJson(json);
}
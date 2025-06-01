import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'onboardingData-model.freezed.dart';
part 'onboardingData-model.g.dart';

@freezed
class OnboardingData with _$OnboardingData {
  @HiveType(typeId: 0, adapterName: 'OnboardingDataAdapter') // 👈 Add adapter info
  // Define a factory constructor with required fields
  factory OnboardingData({
    @Default("") String lastSmokedDate,
    @Default(-1) int cigarettesPerDay,
    @Default("") String costOfAPack,
    @Default(-1) int numberOfCigarettesIn1Pack,
    @Default([]) List<String> biggestMotivation,
    @Default([]) List<String> craveSituations,
    @Default([]) List<String> helpNeeded,
    @Default(-1) int quitMethod,
    @Default("") String name,
  }) = _OnboardingData;


  // Add a factory constructor for JSON serialization
  factory OnboardingData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataFromJson(json);
}
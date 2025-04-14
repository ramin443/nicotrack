import 'package:freezed_annotation/freezed_annotation.dart';

part 'didyouSmoke-model.freezed.dart';

part 'didyouSmoke-model.g.dart';

@freezed
class DidYouSmokeModel with _$DidYouSmokeModel {
  // Define a factory constructor with required fields
  factory DidYouSmokeModel({
    @Default(-1) int hasSmokedToday,
    @Default(-1) int howManyCigs,
    @Default([]) List<Map<String, dynamic>> whatTriggerred,
    @Default([]) List<Map<String, dynamic>> howYouFeel,
    @Default([]) List<Map<String, dynamic>> avoidNext,
    @Default(-1) int updateQuitDate,
  }) = _DidYouSmokeModel;

  // Add a factory constructor for JSON serialization
  factory DidYouSmokeModel.fromJson(Map<String, dynamic> json) =>
      _$DidYouSmokeModelFromJson(json);
}
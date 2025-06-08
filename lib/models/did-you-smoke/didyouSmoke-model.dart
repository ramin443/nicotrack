import 'package:freezed_annotation/freezed_annotation.dart';

part 'didyouSmoke-model.freezed.dart';

part 'didyouSmoke-model.g.dart';

@freezed
class DidYouSmokeModel with _$DidYouSmokeModel {
  factory DidYouSmokeModel({
    @Default(-1) int hasSmokedToday,
    @Default(-1) int howManyCigs,
    @Default([]) List<Map<String, dynamic>> whatTriggerred,
    @Default([]) List<Map<String, dynamic>> howYouFeel,
    @Default([]) List<Map<String, dynamic>> avoidNext,
    @Default(-1) int updateQuitDate,
  }) = _DidYouSmokeModel;

  factory DidYouSmokeModel.fromJson(Map<String, dynamic> json) =>
      _$DidYouSmokeModelFromJson(json);
}
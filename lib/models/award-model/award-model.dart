import 'package:freezed_annotation/freezed_annotation.dart';

part 'award-model.freezed.dart';

part 'award-model.g.dart';

@freezed
class AwardModel with _$AwardModel {
  // Define a factory constructor with required fields
  factory AwardModel({
    required String emojiImg,
    required int day,

  }) = _AwardModel;

  // Add a factory constructor for JSON serialization
  factory AwardModel.fromJson(Map<String, dynamic> json) =>
      _$AwardModelFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timelineItem-model.freezed.dart';
part 'timelineItem-model.g.dart';

@freezed
class TimelineItemModel with _$TimelineItemModel {
  // Define a factory constructor with required fields
  factory TimelineItemModel({
    required int dayNumber,
    required int streakNumber,
    required String streakImg,
    required String dayDuration,
    required String whatHappens,
  }) = _TimelineItemModel;

  // Add a factory constructor for JSON serialization
  factory TimelineItemModel.fromJson(Map<String, dynamic> json) => _$TimelineItemModelFromJson(json);
}
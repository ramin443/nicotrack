import 'package:freezed_annotation/freezed_annotation.dart';

part 'emojitext-model.freezed.dart';

part 'emojitext-model.g.dart';

@freezed
class EmojiTextModel with _$EmojiTextModel {
  // Define a factory constructor with required fields
  factory EmojiTextModel({
    required String emoji,
    required String text,
  }) = _EmojiTextModel;

  // Add a factory constructor for JSON serialization
  factory EmojiTextModel.fromJson(Map<String, dynamic> json) =>
      _$EmojiTextModelFromJson(json);
}
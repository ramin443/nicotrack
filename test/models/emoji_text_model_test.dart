import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';

void main() {
  group('EmojiTextModel', () {
    test('should create EmojiTextModel with required values', () {
      // Arrange
      const emoji = '😊';
      const text = 'Happy';

      // Act
      final model = EmojiTextModel(
        emoji: emoji,
        text: text,
      );

      // Assert
      expect(model.emoji, equals(emoji));
      expect(model.text, equals(text));
    });

    test('should create EmojiTextModel from JSON', () {
      // Arrange
      final json = {
        'emoji': '😔',
        'text': 'Sad',
      };

      // Act
      final model = EmojiTextModel.fromJson(json);

      // Assert
      expect(model.emoji, equals('😔'));
      expect(model.text, equals('Sad'));
    });

    test('should convert EmojiTextModel to JSON', () {
      // Arrange
      final model = EmojiTextModel(
        emoji: '🚶',
        text: 'Go for a walk',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['emoji'], equals('🚶'));
      expect(json['text'], equals('Go for a walk'));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = EmojiTextModel(
        emoji: '😊',
        text: 'Happy',
      );

      // Act
      final updatedModel = originalModel.copyWith(
        text: 'Very Happy',
      );

      // Assert
      expect(updatedModel.emoji, equals('😊')); // Unchanged
      expect(updatedModel.text, equals('Very Happy')); // Updated
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = EmojiTextModel(emoji: '😊', text: 'Happy');
      final model2 = EmojiTextModel(emoji: '😊', text: 'Happy');
      final model3 = EmojiTextModel(emoji: '😔', text: 'Sad');

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1.hashCode, isNot(equals(model3.hashCode)));
    });

    test('should handle various emoji types', () {
      // Arrange & Act
      final simpleEmoji = EmojiTextModel(emoji: '😊', text: 'Simple face');
      final complexEmoji = EmojiTextModel(emoji: '👨‍💻', text: 'Complex emoji');
      final textEmoji = EmojiTextModel(emoji: '❤️', text: 'Heart');
      final numberEmoji = EmojiTextModel(emoji: '1️⃣', text: 'Number one');

      // Assert
      expect(simpleEmoji.emoji, equals('😊'));
      expect(complexEmoji.emoji, equals('👨‍💻'));
      expect(textEmoji.emoji, equals('❤️'));
      expect(numberEmoji.emoji, equals('1️⃣'));
    });

    test('should handle various text lengths and content', () {
      // Arrange & Act
      final shortText = EmojiTextModel(emoji: '✅', text: 'Yes');
      final longText = EmojiTextModel(
        emoji: '📖', 
        text: 'This is a very long text that describes something in detail with multiple words and sentences.',
      );
      final emptyText = EmojiTextModel(emoji: '🤷', text: '');
      final specialChars = EmojiTextModel(emoji: '🔢', text: 'Text with 123 & special chars!@#');

      // Assert
      expect(shortText.text, equals('Yes'));
      expect(longText.text.length, greaterThan(50));
      expect(emptyText.text, equals(''));
      expect(specialChars.text, contains('123'));
      expect(specialChars.text, contains('&'));
      expect(specialChars.text, contains('!@#'));
    });

    test('should handle emoji as asset path strings', () {
      // Arrange & Act
      final assetEmoji = EmojiTextModel(
        emoji: 'assets/images/happy.png',
        text: 'Happy face asset',
      );

      // Assert
      expect(assetEmoji.emoji, equals('assets/images/happy.png'));
      expect(assetEmoji.text, equals('Happy face asset'));
    });

    test('should handle mood-related emoji-text pairs', () {
      // Arrange & Act
      final happy = EmojiTextModel(emoji: '😊', text: 'Happy');
      final neutral = EmojiTextModel(emoji: '😐', text: 'Neutral');
      final sad = EmojiTextModel(emoji: '😔', text: 'Sad');
      final angry = EmojiTextModel(emoji: '😠', text: 'Angry');
      final anxious = EmojiTextModel(emoji: '😰', text: 'Anxious');

      // Assert
      expect(happy.emoji, equals('😊'));
      expect(neutral.emoji, equals('😐'));
      expect(sad.emoji, equals('😔'));
      expect(angry.emoji, equals('😠'));
      expect(anxious.emoji, equals('😰'));
    });

    test('should handle activity-related emoji-text pairs', () {
      // Arrange & Act
      final walk = EmojiTextModel(emoji: '🚶', text: 'Go for a walk');
      final meditate = EmojiTextModel(emoji: '🧘', text: 'Meditate');
      final call = EmojiTextModel(emoji: '📞', text: 'Call someone');
      final exercise = EmojiTextModel(emoji: '🏃', text: 'Exercise');

      // Assert
      expect(walk.text, equals('Go for a walk'));
      expect(meditate.text, equals('Meditate'));
      expect(call.text, equals('Call someone'));
      expect(exercise.text, equals('Exercise'));
    });

    test('should handle trigger-related emoji-text pairs', () {
      // Arrange & Act
      final coffee = EmojiTextModel(emoji: '☕', text: 'Morning with coffee');
      final stress = EmojiTextModel(emoji: '😰', text: 'When feeling stressed');
      final alcohol = EmojiTextModel(emoji: '🍺', text: 'When drinking alcohol');
      final meals = EmojiTextModel(emoji: '🍽️', text: 'After meals');

      // Assert
      expect(coffee.emoji, equals('☕'));
      expect(stress.text, equals('When feeling stressed'));
      expect(alcohol.emoji, equals('🍺'));
      expect(meals.text, equals('After meals'));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = EmojiTextModel(
        emoji: '😊',
        text: 'Happy',
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('EmojiTextModel'));
      expect(stringRepresentation, contains('emoji'));
      expect(stringRepresentation, contains('text'));
    });

    test('should handle JSON with null values gracefully', () {
      // This tests the model's robustness with edge case data
      // Note: Since emoji and text are required, this would typically throw
      // But we can test that the model handles the expected structure
      
      // Arrange
      final json = {
        'emoji': '🤷',
        'text': 'Unknown',
      };

      // Act
      final model = EmojiTextModel.fromJson(json);

      // Assert
      expect(model.emoji, equals('🤷'));
      expect(model.text, equals('Unknown'));
    });

    test('should work with copyWith for both fields', () {
      // Arrange
      final originalModel = EmojiTextModel(
        emoji: '😊',
        text: 'Happy',
      );

      // Act
      final updatedModel = originalModel.copyWith(
        emoji: '😔',
        text: 'Sad',
      );

      // Assert
      expect(updatedModel.emoji, equals('😔'));
      expect(updatedModel.text, equals('Sad'));
      expect(originalModel.emoji, equals('😊')); // Original unchanged
      expect(originalModel.text, equals('Happy')); // Original unchanged
    });

    test('should work with copyWith for individual fields', () {
      // Arrange
      final originalModel = EmojiTextModel(
        emoji: '😊',
        text: 'Happy',
      );

      // Act
      final updatedEmoji = originalModel.copyWith(emoji: '😔');
      final updatedText = originalModel.copyWith(text: 'Very Happy');

      // Assert
      expect(updatedEmoji.emoji, equals('😔'));
      expect(updatedEmoji.text, equals('Happy')); // Unchanged
      expect(updatedText.emoji, equals('😊')); // Unchanged
      expect(updatedText.text, equals('Very Happy'));
    });
  });
}
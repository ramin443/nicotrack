import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';

void main() {
  group('MoodModel', () {
    test('should create MoodModel with default values', () {
      // Arrange & Act
      final moodModel = MoodModel();

      // Assert
      expect(moodModel.selfFeeling, equals({}));
      expect(moodModel.moodAffecting, equals({}));
      expect(moodModel.anyCravingToday, equals(-1));
      expect(moodModel.craveTiming, equals({}));
      expect(moodModel.reflectionNote, equals(""));
    });

    test('should create MoodModel with custom values', () {
      // Arrange
      const selfFeeling = {"emoji": "😊", "text": "Happy"};
      const moodAffecting = {"emoji": "☕", "text": "Morning coffee"};
      const anyCravingToday = 1;
      const craveTiming = {"emoji": "🌅", "text": "Morning"};
      const reflectionNote = "Feeling good today!";

      // Act
      final moodModel = MoodModel(
        selfFeeling: selfFeeling,
        moodAffecting: moodAffecting,
        anyCravingToday: anyCravingToday,
        craveTiming: craveTiming,
        reflectionNote: reflectionNote,
      );

      // Assert
      expect(moodModel.selfFeeling, equals(selfFeeling));
      expect(moodModel.moodAffecting, equals(moodAffecting));
      expect(moodModel.anyCravingToday, equals(anyCravingToday));
      expect(moodModel.craveTiming, equals(craveTiming));
      expect(moodModel.reflectionNote, equals(reflectionNote));
    });

    test('should create MoodModel from JSON', () {
      // Arrange
      final json = {
        'selfFeeling': {"emoji": "😊", "text": "Happy"},
        'moodAffecting': {"emoji": "☕", "text": "Morning coffee"},
        'anyCravingToday': 1,
        'craveTiming': {"emoji": "🌅", "text": "Morning"},
        'reflectionNote': "Feeling good today!",
      };

      // Act
      final moodModel = MoodModel.fromJson(json);

      // Assert
      expect(moodModel.selfFeeling, equals({"emoji": "😊", "text": "Happy"}));
      expect(moodModel.moodAffecting, equals({"emoji": "☕", "text": "Morning coffee"}));
      expect(moodModel.anyCravingToday, equals(1));
      expect(moodModel.craveTiming, equals({"emoji": "🌅", "text": "Morning"}));
      expect(moodModel.reflectionNote, equals("Feeling good today!"));
    });

    test('should convert MoodModel to JSON', () {
      // Arrange
      final moodModel = MoodModel(
        selfFeeling: {"emoji": "😊", "text": "Happy"},
        moodAffecting: {"emoji": "☕", "text": "Morning coffee"},
        anyCravingToday: 1,
        craveTiming: {"emoji": "🌅", "text": "Morning"},
        reflectionNote: "Feeling good today!",
      );

      // Act
      final json = moodModel.toJson();

      // Assert
      expect(json['selfFeeling'], equals({"emoji": "😊", "text": "Happy"}));
      expect(json['moodAffecting'], equals({"emoji": "☕", "text": "Morning coffee"}));
      expect(json['anyCravingToday'], equals(1));
      expect(json['craveTiming'], equals({"emoji": "🌅", "text": "Morning"}));
      expect(json['reflectionNote'], equals("Feeling good today!"));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = MoodModel(
        selfFeeling: {"emoji": "😊", "text": "Happy"},
        anyCravingToday: 0,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        anyCravingToday: 1,
        reflectionNote: "Updated note",
      );

      // Assert
      expect(updatedModel.selfFeeling, equals({"emoji": "😊", "text": "Happy"}));
      expect(updatedModel.anyCravingToday, equals(1));
      expect(updatedModel.reflectionNote, equals("Updated note"));
      expect(updatedModel.moodAffecting, equals({})); // Default unchanged
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = MoodModel(
        selfFeeling: {"emoji": "😊", "text": "Happy"},
        anyCravingToday: 1,
      );
      final model2 = MoodModel(
        selfFeeling: {"emoji": "😊", "text": "Happy"},
        anyCravingToday: 1,
      );
      final model3 = MoodModel(
        selfFeeling: {"emoji": "😢", "text": "Sad"},
        anyCravingToday: 1,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1.hashCode, isNot(equals(model3.hashCode)));
    });

    test('should handle JSON with missing fields', () {
      // Arrange
      final json = {
        'selfFeeling': {"emoji": "😊", "text": "Happy"},
        // Missing other fields should use defaults
      };

      // Act
      final moodModel = MoodModel.fromJson(json);

      // Assert
      expect(moodModel.selfFeeling, equals({"emoji": "😊", "text": "Happy"}));
      expect(moodModel.moodAffecting, equals({}));
      expect(moodModel.anyCravingToday, equals(-1));
      expect(moodModel.craveTiming, equals({}));
      expect(moodModel.reflectionNote, equals(""));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final moodModel = MoodModel(
        selfFeeling: {"emoji": "😊", "text": "Happy"},
        anyCravingToday: 1,
      );

      // Act
      final stringRepresentation = moodModel.toString();

      // Assert
      expect(stringRepresentation, contains('MoodModel'));
      expect(stringRepresentation, contains('selfFeeling'));
      expect(stringRepresentation, contains('anyCravingToday'));
    });
  });
}
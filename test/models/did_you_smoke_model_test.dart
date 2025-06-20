import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';

void main() {
  group('DidYouSmokeModel', () {
    test('should create DidYouSmokeModel with default values', () {
      // Arrange & Act
      final model = DidYouSmokeModel();

      // Assert
      expect(model.hasSmokedToday, equals(-1));
      expect(model.howManyCigs, equals(-1));
      expect(model.whatTriggerred, equals([]));
      expect(model.howYouFeel, equals([]));
      expect(model.avoidNext, equals([]));
      expect(model.updateQuitDate, equals(-1));
    });

    test('should create DidYouSmokeModel with custom values', () {
      // Arrange
      const hasSmokedToday = 1;
      const howManyCigs = 5;
      final whatTriggerred = [
        {"emoji": "☕", "text": "Morning coffee"}
      ];
      final howYouFeel = [
        {"emoji": "😔", "text": "Guilty"}
      ];
      final avoidNext = [
        {"emoji": "🚶", "text": "Go for a walk"}
      ];
      const updateQuitDate = 0;

      // Act
      final model = DidYouSmokeModel(
        hasSmokedToday: hasSmokedToday,
        howManyCigs: howManyCigs,
        whatTriggerred: whatTriggerred,
        howYouFeel: howYouFeel,
        avoidNext: avoidNext,
        updateQuitDate: updateQuitDate,
      );

      // Assert
      expect(model.hasSmokedToday, equals(hasSmokedToday));
      expect(model.howManyCigs, equals(howManyCigs));
      expect(model.whatTriggerred, equals(whatTriggerred));
      expect(model.howYouFeel, equals(howYouFeel));
      expect(model.avoidNext, equals(avoidNext));
      expect(model.updateQuitDate, equals(updateQuitDate));
    });

    test('should create DidYouSmokeModel from JSON', () {
      // Arrange
      final json = {
        'hasSmokedToday': 1,
        'howManyCigs': 3,
        'whatTriggerred': [
          {"emoji": "☕", "text": "Morning coffee"},
          {"emoji": "😰", "text": "Stress"}
        ],
        'howYouFeel': [
          {"emoji": "😔", "text": "Guilty"}
        ],
        'avoidNext': [
          {"emoji": "🚶", "text": "Go for a walk"},
          {"emoji": "🧘", "text": "Meditate"}
        ],
        'updateQuitDate': 0,
      };

      // Act
      final model = DidYouSmokeModel.fromJson(json);

      // Assert
      expect(model.hasSmokedToday, equals(1));
      expect(model.howManyCigs, equals(3));
      expect(model.whatTriggerred.length, equals(2));
      expect(model.whatTriggerred[0], equals({"emoji": "☕", "text": "Morning coffee"}));
      expect(model.howYouFeel.length, equals(1));
      expect(model.avoidNext.length, equals(2));
      expect(model.updateQuitDate, equals(0));
    });

    test('should convert DidYouSmokeModel to JSON', () {
      // Arrange
      final model = DidYouSmokeModel(
        hasSmokedToday: 1,
        howManyCigs: 2,
        whatTriggerred: [
          {"emoji": "☕", "text": "Morning coffee"}
        ],
        howYouFeel: [
          {"emoji": "😔", "text": "Guilty"}
        ],
        avoidNext: [
          {"emoji": "🚶", "text": "Go for a walk"}
        ],
        updateQuitDate: 0,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['hasSmokedToday'], equals(1));
      expect(json['howManyCigs'], equals(2));
      expect(json['whatTriggerred'], isA<List>());
      expect(json['whatTriggerred'].length, equals(1));
      expect(json['howYouFeel'], isA<List>());
      expect(json['avoidNext'], isA<List>());
      expect(json['updateQuitDate'], equals(0));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = DidYouSmokeModel(
        hasSmokedToday: 0,
        howManyCigs: 0,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        hasSmokedToday: 1,
        howManyCigs: 3,
        whatTriggerred: [
          {"emoji": "☕", "text": "Morning coffee"}
        ],
      );

      // Assert
      expect(updatedModel.hasSmokedToday, equals(1));
      expect(updatedModel.howManyCigs, equals(3));
      expect(updatedModel.whatTriggerred.length, equals(1));
      expect(updatedModel.howYouFeel, equals([])); // Default unchanged
      expect(updatedModel.updateQuitDate, equals(-1)); // Default unchanged
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = DidYouSmokeModel(
        hasSmokedToday: 1,
        howManyCigs: 3,
        whatTriggerred: [
          {"emoji": "☕", "text": "Morning coffee"}
        ],
      );
      final model2 = DidYouSmokeModel(
        hasSmokedToday: 1,
        howManyCigs: 3,
        whatTriggerred: [
          {"emoji": "☕", "text": "Morning coffee"}
        ],
      );
      final model3 = DidYouSmokeModel(
        hasSmokedToday: 0,
        howManyCigs: 3,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
    });

    test('should handle JSON with missing fields using defaults', () {
      // Arrange
      final json = {
        'hasSmokedToday': 1,
        // Other fields should use defaults
      };

      // Act
      final model = DidYouSmokeModel.fromJson(json);

      // Assert
      expect(model.hasSmokedToday, equals(1));
      expect(model.howManyCigs, equals(-1));
      expect(model.whatTriggerred, equals([]));
      expect(model.howYouFeel, equals([]));
      expect(model.avoidNext, equals([]));
      expect(model.updateQuitDate, equals(-1));
    });

    test('should handle empty lists in JSON', () {
      // Arrange
      final json = {
        'hasSmokedToday': 0,
        'howManyCigs': 0,
        'whatTriggerred': [],
        'howYouFeel': [],
        'avoidNext': [],
        'updateQuitDate': 1,
      };

      // Act
      final model = DidYouSmokeModel.fromJson(json);

      // Assert
      expect(model.hasSmokedToday, equals(0));
      expect(model.howManyCigs, equals(0));
      expect(model.whatTriggerred, isEmpty);
      expect(model.howYouFeel, isEmpty);
      expect(model.avoidNext, isEmpty);
      expect(model.updateQuitDate, equals(1));
    });

    test('should handle multiple triggers, feelings, and avoidance strategies', () {
      // Arrange
      final triggers = [
        {"emoji": "☕", "text": "Morning coffee"},
        {"emoji": "😰", "text": "Work stress"},
        {"emoji": "🍺", "text": "Social drinking"}
      ];
      final feelings = [
        {"emoji": "😔", "text": "Guilty"},
        {"emoji": "😤", "text": "Frustrated"}
      ];
      final avoidStrategies = [
        {"emoji": "🚶", "text": "Go for a walk"},
        {"emoji": "🧘", "text": "Meditate"},
        {"emoji": "📞", "text": "Call someone"}
      ];

      // Act
      final model = DidYouSmokeModel(
        hasSmokedToday: 1,
        howManyCigs: 4,
        whatTriggerred: triggers,
        howYouFeel: feelings,
        avoidNext: avoidStrategies,
      );

      // Assert
      expect(model.whatTriggerred.length, equals(3));
      expect(model.howYouFeel.length, equals(2));
      expect(model.avoidNext.length, equals(3));
      expect(model.whatTriggerred[2]["text"], equals("Social drinking"));
      expect(model.avoidNext[1]["emoji"], equals("🧘"));
    });
  });
}
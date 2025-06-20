import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/withdrawal-stage-model/withdrawal-stage-model.dart';

void main() {
  group('WithdrawalStageModel', () {
    test('should create WithdrawalStageModel with default intensityLevel', () {
      // Arrange
      const timeAfterQuitting = '0-72 hours';
      final whatHappens = [
        {"emoji": "❤️", "text": "Heart rate normalizes"},
        {"emoji": "🫁", "text": "Carbon monoxide levels drop"}
      ];
      final symptoms = [
        {"emoji": "😰", "text": "Anxiety"},
        {"emoji": "😤", "text": "Irritability"}
      ];
      final howToCope = [
        {"emoji": "🚶", "text": "Go for a walk"},
        {"emoji": "💧", "text": "Drink water"}
      ];

      // Act
      final model = WithdrawalStageModel(
        timeAfterQuitting: timeAfterQuitting,
        whatHappens: whatHappens,
        symptoms: symptoms,
        howToCope: howToCope,
      );

      // Assert
      expect(model.intensityLevel, equals(0)); // Default value
      expect(model.timeAfterQuitting, equals(timeAfterQuitting));
      expect(model.whatHappens, equals(whatHappens));
      expect(model.symptoms, equals(symptoms));
      expect(model.howToCope, equals(howToCope));
    });

    test('should create WithdrawalStageModel with custom intensityLevel', () {
      // Arrange
      const intensityLevel = 5;
      const timeAfterQuitting = '3-4 days';
      final whatHappens = [
        {"emoji": "🧠", "text": "Brain fog clears"}
      ];
      final symptoms = [
        {"emoji": "😴", "text": "Fatigue"},
        {"emoji": "🤯", "text": "Headaches"}
      ];
      final howToCope = [
        {"emoji": "🧘", "text": "Meditate"}
      ];

      // Act
      final model = WithdrawalStageModel(
        intensityLevel: intensityLevel,
        timeAfterQuitting: timeAfterQuitting,
        whatHappens: whatHappens,
        symptoms: symptoms,
        howToCope: howToCope,
      );

      // Assert
      expect(model.intensityLevel, equals(intensityLevel));
      expect(model.timeAfterQuitting, equals(timeAfterQuitting));
      expect(model.whatHappens, equals(whatHappens));
      expect(model.symptoms, equals(symptoms));
      expect(model.howToCope, equals(howToCope));
    });

    test('should create WithdrawalStageModel from JSON', () {
      // Arrange
      final json = {
        'intensityLevel': 8,
        'timeAfterQuitting': '1-2 weeks',
        'whatHappens': [
          {"emoji": "👃", "text": "Sense of smell improves"},
          {"emoji": "👅", "text": "Taste improves"}
        ],
        'symptoms': [
          {"emoji": "😰", "text": "Cravings"},
          {"emoji": "😠", "text": "Mood swings"}
        ],
        'howToCope': [
          {"emoji": "📞", "text": "Call support"},
          {"emoji": "🏃", "text": "Exercise"}
        ],
      };

      // Act
      final model = WithdrawalStageModel.fromJson(json);

      // Assert
      expect(model.intensityLevel, equals(8));
      expect(model.timeAfterQuitting, equals('1-2 weeks'));
      expect(model.whatHappens.length, equals(2));
      expect(model.whatHappens[0], equals({"emoji": "👃", "text": "Sense of smell improves"}));
      expect(model.symptoms.length, equals(2));
      expect(model.symptoms[1], equals({"emoji": "😠", "text": "Mood swings"}));
      expect(model.howToCope.length, equals(2));
    });

    test('should convert WithdrawalStageModel to JSON', () {
      // Arrange
      final model = WithdrawalStageModel(
        intensityLevel: 6,
        timeAfterQuitting: '1 month',
        whatHappens: [
          {"emoji": "🫁", "text": "Lung function improves"}
        ],
        symptoms: [
          {"emoji": "😔", "text": "Depression"}
        ],
        howToCope: [
          {"emoji": "🎵", "text": "Listen to music"}
        ],
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['intensityLevel'], equals(6));
      expect(json['timeAfterQuitting'], equals('1 month'));
      expect(json['whatHappens'], isA<List>());
      expect(json['whatHappens'].length, equals(1));
      expect(json['symptoms'], isA<List>());
      expect(json['howToCope'], isA<List>());
      expect(json['whatHappens'][0], equals({"emoji": "🫁", "text": "Lung function improves"}));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = WithdrawalStageModel(
        intensityLevel: 3,
        timeAfterQuitting: '24 hours',
        whatHappens: [
          {"emoji": "❤️", "text": "Heart rate normalizes"}
        ],
        symptoms: [
          {"emoji": "😰", "text": "Anxiety"}
        ],
        howToCope: [
          {"emoji": "🚶", "text": "Go for a walk"}
        ],
      );

      // Act
      final updatedModel = originalModel.copyWith(
        intensityLevel: 7,
        timeAfterQuitting: '48 hours',
        symptoms: [
          {"emoji": "😤", "text": "Irritability"},
          {"emoji": "😴", "text": "Fatigue"}
        ],
      );

      // Assert
      expect(updatedModel.intensityLevel, equals(7)); // Updated
      expect(updatedModel.timeAfterQuitting, equals('48 hours')); // Updated
      expect(updatedModel.whatHappens, equals([{"emoji": "❤️", "text": "Heart rate normalizes"}])); // Unchanged
      expect(updatedModel.symptoms.length, equals(2)); // Updated
      expect(updatedModel.symptoms[0], equals({"emoji": "😤", "text": "Irritability"}));
      expect(updatedModel.howToCope, equals([{"emoji": "🚶", "text": "Go for a walk"}])); // Unchanged
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = WithdrawalStageModel(
        intensityLevel: 5,
        timeAfterQuitting: '1 week',
        whatHappens: [{"emoji": "👃", "text": "Smell improves"}],
        symptoms: [{"emoji": "😰", "text": "Cravings"}],
        howToCope: [{"emoji": "🧘", "text": "Meditate"}],
      );
      final model2 = WithdrawalStageModel(
        intensityLevel: 5,
        timeAfterQuitting: '1 week',
        whatHappens: [{"emoji": "👃", "text": "Smell improves"}],
        symptoms: [{"emoji": "😰", "text": "Cravings"}],
        howToCope: [{"emoji": "🧘", "text": "Meditate"}],
      );
      final model3 = WithdrawalStageModel(
        intensityLevel: 3,
        timeAfterQuitting: '1 week',
        whatHappens: [{"emoji": "👃", "text": "Smell improves"}],
        symptoms: [{"emoji": "😰", "text": "Cravings"}],
        howToCope: [{"emoji": "🧘", "text": "Meditate"}],
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1.hashCode, isNot(equals(model3.hashCode)));
    });

    test('should handle JSON with missing intensityLevel using default', () {
      // Arrange
      final json = {
        'timeAfterQuitting': '3 days',
        'whatHappens': [
          {"emoji": "🧠", "text": "Mental clarity improves"}
        ],
        'symptoms': [
          {"emoji": "😴", "text": "Sleep disturbances"}
        ],
        'howToCope': [
          {"emoji": "☕", "text": "Herbal tea"}
        ],
        // intensityLevel missing - should use default 0
      };

      // Act
      final model = WithdrawalStageModel.fromJson(json);

      // Assert
      expect(model.intensityLevel, equals(0)); // Default value
      expect(model.timeAfterQuitting, equals('3 days'));
      expect(model.whatHappens.length, equals(1));
      expect(model.symptoms.length, equals(1));
      expect(model.howToCope.length, equals(1));
    });

    test('should handle empty lists', () {
      // Arrange
      final model = WithdrawalStageModel(
        intensityLevel: 1,
        timeAfterQuitting: '0 minutes',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );

      // Act & Assert
      expect(model.whatHappens, isEmpty);
      expect(model.symptoms, isEmpty);
      expect(model.howToCope, isEmpty);
      expect(model.intensityLevel, equals(1));
      expect(model.timeAfterQuitting, equals('0 minutes'));
    });

    test('should handle multiple items in each list', () {
      // Arrange
      final whatHappens = [
        {"emoji": "❤️", "text": "Heart rate drops"},
        {"emoji": "🫁", "text": "Oxygen levels improve"},
        {"emoji": "🧠", "text": "Nicotine leaves system"}
      ];
      final symptoms = [
        {"emoji": "😰", "text": "Anxiety"},
        {"emoji": "😤", "text": "Irritability"},
        {"emoji": "😴", "text": "Fatigue"},
        {"emoji": "🤯", "text": "Headaches"}
      ];
      final howToCope = [
        {"emoji": "🚶", "text": "Take a walk"},
        {"emoji": "💧", "text": "Drink water"},
        {"emoji": "🧘", "text": "Deep breathing"},
        {"emoji": "📞", "text": "Call friend"},
        {"emoji": "🎵", "text": "Listen to music"}
      ];

      // Act
      final model = WithdrawalStageModel(
        intensityLevel: 9,
        timeAfterQuitting: 'Peak withdrawal (3-4 days)',
        whatHappens: whatHappens,
        symptoms: symptoms,
        howToCope: howToCope,
      );

      // Assert
      expect(model.whatHappens.length, equals(3));
      expect(model.symptoms.length, equals(4));
      expect(model.howToCope.length, equals(5));
      expect(model.intensityLevel, equals(9));
      expect(model.symptoms[2], equals({"emoji": "😴", "text": "Fatigue"}));
      expect(model.howToCope[4], equals({"emoji": "🎵", "text": "Listen to music"}));
    });

    test('should handle various time periods', () {
      // Arrange & Act
      final immediate = WithdrawalStageModel(
        timeAfterQuitting: '20 minutes',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );
      final shortTerm = WithdrawalStageModel(
        timeAfterQuitting: '72 hours',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );
      final mediumTerm = WithdrawalStageModel(
        timeAfterQuitting: '2-12 weeks',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );
      final longTerm = WithdrawalStageModel(
        timeAfterQuitting: '3-9 months',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );

      // Assert
      expect(immediate.timeAfterQuitting, equals('20 minutes'));
      expect(shortTerm.timeAfterQuitting, equals('72 hours'));
      expect(mediumTerm.timeAfterQuitting, equals('2-12 weeks'));
      expect(longTerm.timeAfterQuitting, equals('3-9 months'));
    });

    test('should handle different intensity levels', () {
      // Arrange & Act
      final low = WithdrawalStageModel(
        intensityLevel: 1,
        timeAfterQuitting: '3+ months',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );
      final medium = WithdrawalStageModel(
        intensityLevel: 5,
        timeAfterQuitting: '1-2 weeks',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );
      final high = WithdrawalStageModel(
        intensityLevel: 10,
        timeAfterQuitting: '3-4 days',
        whatHappens: [],
        symptoms: [],
        howToCope: [],
      );

      // Assert
      expect(low.intensityLevel, equals(1));
      expect(medium.intensityLevel, equals(5));
      expect(high.intensityLevel, equals(10));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = WithdrawalStageModel(
        intensityLevel: 7,
        timeAfterQuitting: '1 week',
        whatHappens: [{"emoji": "👃", "text": "Smell improves"}],
        symptoms: [{"emoji": "😰", "text": "Cravings"}],
        howToCope: [{"emoji": "🧘", "text": "Meditate"}],
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('WithdrawalStageModel'));
      expect(stringRepresentation, contains('intensityLevel'));
      expect(stringRepresentation, contains('timeAfterQuitting'));
      expect(stringRepresentation, contains('whatHappens'));
      expect(stringRepresentation, contains('symptoms'));
      expect(stringRepresentation, contains('howToCope'));
    });
  });
}
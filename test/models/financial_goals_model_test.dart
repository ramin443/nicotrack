import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';

void main() {
  group('FinancialGoalsModel', () {
    test('should create FinancialGoalsModel with default values', () {
      // Arrange & Act
      final model = FinancialGoalsModel();

      // Assert
      expect(model.emoji, equals(""));
      expect(model.goalTitle, equals(""));
      expect(model.cost, equals(0.0));
    });

    test('should create FinancialGoalsModel with custom values', () {
      // Arrange
      const emoji = "🏠";
      const goalTitle = "Buy a new house";
      const cost = 250000.0;

      // Act
      final model = FinancialGoalsModel(
        emoji: emoji,
        goalTitle: goalTitle,
        cost: cost,
      );

      // Assert
      expect(model.emoji, equals(emoji));
      expect(model.goalTitle, equals(goalTitle));
      expect(model.cost, equals(cost));
    });

    test('should create FinancialGoalsModel from JSON', () {
      // Arrange
      final json = {
        'emoji': '🚗',
        'goalTitle': 'Buy a new car',
        'cost': 35000.50,
      };

      // Act
      final model = FinancialGoalsModel.fromJson(json);

      // Assert
      expect(model.emoji, equals('🚗'));
      expect(model.goalTitle, equals('Buy a new car'));
      expect(model.cost, equals(35000.50));
    });

    test('should convert FinancialGoalsModel to JSON', () {
      // Arrange
      final model = FinancialGoalsModel(
        emoji: '✈️',
        goalTitle: 'Vacation to Europe',
        cost: 5000.75,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['emoji'], equals('✈️'));
      expect(json['goalTitle'], equals('Vacation to Europe'));
      expect(json['cost'], equals(5000.75));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = FinancialGoalsModel(
        emoji: '📱',
        goalTitle: 'New smartphone',
        cost: 800.0,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        goalTitle: 'Latest iPhone',
        cost: 1200.0,
      );

      // Assert
      expect(updatedModel.emoji, equals('📱')); // Unchanged
      expect(updatedModel.goalTitle, equals('Latest iPhone')); // Updated
      expect(updatedModel.cost, equals(1200.0)); // Updated
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = FinancialGoalsModel(
        emoji: '🏠',
        goalTitle: 'Buy a house',
        cost: 300000.0,
      );
      final model2 = FinancialGoalsModel(
        emoji: '🏠',
        goalTitle: 'Buy a house',
        cost: 300000.0,
      );
      final model3 = FinancialGoalsModel(
        emoji: '🚗',
        goalTitle: 'Buy a car',
        cost: 30000.0,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1.hashCode, isNot(equals(model3.hashCode)));
    });

    test('should handle JSON with missing fields using defaults', () {
      // Arrange
      final json = {
        'goalTitle': 'Emergency fund',
        'cost': 10000.0,
        // Missing emoji - should use default
      };

      // Act
      final model = FinancialGoalsModel.fromJson(json);

      // Assert
      expect(model.emoji, equals("")); // Default
      expect(model.goalTitle, equals('Emergency fund'));
      expect(model.cost, equals(10000.0));
    });

    test('should handle various financial goal types', () {
      // Arrange & Act
      final house = FinancialGoalsModel(
        emoji: '🏠',
        goalTitle: 'Down payment for house',
        cost: 50000.0,
      );
      final car = FinancialGoalsModel(
        emoji: '🚗',
        goalTitle: 'New car',
        cost: 25000.0,
      );
      final vacation = FinancialGoalsModel(
        emoji: '✈️',
        goalTitle: 'Dream vacation',
        cost: 8000.0,
      );
      final emergency = FinancialGoalsModel(
        emoji: '🚨',
        goalTitle: 'Emergency fund',
        cost: 15000.0,
      );
      final education = FinancialGoalsModel(
        emoji: '🎓',
        goalTitle: 'College tuition',
        cost: 40000.0,
      );

      // Assert
      expect(house.emoji, equals('🏠'));
      expect(car.goalTitle, equals('New car'));
      expect(vacation.cost, equals(8000.0));
      expect(emergency.emoji, equals('🚨'));
      expect(education.goalTitle, equals('College tuition'));
    });

    test('should handle various cost ranges', () {
      // Arrange & Act
      final smallGoal = FinancialGoalsModel(
        emoji: '📱',
        goalTitle: 'New phone case',
        cost: 25.99,
      );
      final mediumGoal = FinancialGoalsModel(
        emoji: '💻',
        goalTitle: 'New laptop',
        cost: 1500.0,
      );
      final largeGoal = FinancialGoalsModel(
        emoji: '🏠',
        goalTitle: 'House purchase',
        cost: 500000.0,
      );
      final zeroGoal = FinancialGoalsModel(
        emoji: '🎯',
        goalTitle: 'Free goal',
        cost: 0.0,
      );

      // Assert
      expect(smallGoal.cost, equals(25.99));
      expect(mediumGoal.cost, equals(1500.0));
      expect(largeGoal.cost, equals(500000.0));
      expect(zeroGoal.cost, equals(0.0));
    });

    test('should handle decimal precision in costs', () {
      // Arrange & Act
      final preciseGoal = FinancialGoalsModel(
        emoji: '💰',
        goalTitle: 'Investment goal',
        cost: 12345.67,
      );

      // Act
      final json = preciseGoal.toJson();
      final deserializedModel = FinancialGoalsModel.fromJson(json);

      // Assert
      expect(deserializedModel.cost, equals(12345.67));
      expect(deserializedModel.cost, closeTo(12345.67, 0.01));
    });

    test('should handle various emoji types', () {
      // Arrange & Act
      final simpleEmoji = FinancialGoalsModel(emoji: '🎯');
      final complexEmoji = FinancialGoalsModel(emoji: '👨‍💻');
      final flagEmoji = FinancialGoalsModel(emoji: '🇺🇸');
      final symbolEmoji = FinancialGoalsModel(emoji: '💰');
      final transportEmoji = FinancialGoalsModel(emoji: '🚗');

      // Assert
      expect(simpleEmoji.emoji, equals('🎯'));
      expect(complexEmoji.emoji, equals('👨‍💻'));
      expect(flagEmoji.emoji, equals('🇺🇸'));
      expect(symbolEmoji.emoji, equals('💰'));
      expect(transportEmoji.emoji, equals('🚗'));
    });

    test('should handle empty and special character strings', () {
      // Arrange & Act
      final emptyTitle = FinancialGoalsModel(
        emoji: '❓',
        goalTitle: '',
        cost: 1000.0,
      );
      final specialChars = FinancialGoalsModel(
        emoji: '💵',
        goalTitle: 'Goal with \$pecial ch@rs & numbers 123!',
        cost: 999.99,
      );
      final longTitle = FinancialGoalsModel(
        emoji: '🏖️',
        goalTitle: 'This is a very long goal title that describes a comprehensive financial objective with many details',
        cost: 25000.0,
      );

      // Assert
      expect(emptyTitle.goalTitle, equals(''));
      expect(specialChars.goalTitle, contains('\$pecial'));
      expect(specialChars.goalTitle, contains('@rs'));
      expect(specialChars.goalTitle, contains('123!'));
      expect(longTitle.goalTitle.length, greaterThan(50));
    });

    test('should handle copyWith for all fields', () {
      // Arrange
      final originalModel = FinancialGoalsModel(
        emoji: '🎯',
        goalTitle: 'Original goal',
        cost: 1000.0,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        emoji: '💰',
        goalTitle: 'Updated goal',
        cost: 2000.0,
      );

      // Assert
      expect(updatedModel.emoji, equals('💰'));
      expect(updatedModel.goalTitle, equals('Updated goal'));
      expect(updatedModel.cost, equals(2000.0));
      // Original should be unchanged
      expect(originalModel.emoji, equals('🎯'));
      expect(originalModel.goalTitle, equals('Original goal'));
      expect(originalModel.cost, equals(1000.0));
    });

    test('should handle copyWith for individual fields', () {
      // Arrange
      final originalModel = FinancialGoalsModel(
        emoji: '🎯',
        goalTitle: 'Original goal',
        cost: 1000.0,
      );

      // Act
      final emojiUpdated = originalModel.copyWith(emoji: '💰');
      final titleUpdated = originalModel.copyWith(goalTitle: 'New title');
      final costUpdated = originalModel.copyWith(cost: 5000.0);

      // Assert
      expect(emojiUpdated.emoji, equals('💰'));
      expect(emojiUpdated.goalTitle, equals('Original goal')); // Unchanged
      expect(emojiUpdated.cost, equals(1000.0)); // Unchanged

      expect(titleUpdated.emoji, equals('🎯')); // Unchanged
      expect(titleUpdated.goalTitle, equals('New title'));
      expect(titleUpdated.cost, equals(1000.0)); // Unchanged

      expect(costUpdated.emoji, equals('🎯')); // Unchanged
      expect(costUpdated.goalTitle, equals('Original goal')); // Unchanged
      expect(costUpdated.cost, equals(5000.0));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = FinancialGoalsModel(
        emoji: '🏠',
        goalTitle: 'Buy a house',
        cost: 300000.0,
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('FinancialGoalsModel'));
      expect(stringRepresentation, contains('emoji'));
      expect(stringRepresentation, contains('goalTitle'));
      expect(stringRepresentation, contains('cost'));
    });

    test('should handle JSON serialization round trip', () {
      // Arrange
      final originalModel = FinancialGoalsModel(
        emoji: '🚗',
        goalTitle: 'New Tesla Model 3',
        cost: 42000.99,
      );

      // Act
      final json = originalModel.toJson();
      final deserializedModel = FinancialGoalsModel.fromJson(json);

      // Assert
      expect(deserializedModel, equals(originalModel));
      expect(deserializedModel.emoji, equals(originalModel.emoji));
      expect(deserializedModel.goalTitle, equals(originalModel.goalTitle));
      expect(deserializedModel.cost, equals(originalModel.cost));
    });
  });
}
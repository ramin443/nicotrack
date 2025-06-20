import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/quick-actions-model/quickactions-model.dart';

void main() {
  group('QuickactionsModel', () {
    test('should create QuickactionsModel with default values', () {
      // Arrange & Act
      final model = QuickactionsModel();

      // Assert
      expect(model.firstActionDone, equals(false));
      expect(model.secondActionDone, equals(false));
      expect(model.thirdActionDone, equals(false));
      expect(model.fourthActionDone, equals(false));
    });

    test('should create QuickactionsModel with custom values', () {
      // Arrange
      const firstActionDone = true;
      const secondActionDone = false;
      const thirdActionDone = true;
      const fourthActionDone = true;

      // Act
      final model = QuickactionsModel(
        firstActionDone: firstActionDone,
        secondActionDone: secondActionDone,
        thirdActionDone: thirdActionDone,
        fourthActionDone: fourthActionDone,
      );

      // Assert
      expect(model.firstActionDone, equals(firstActionDone));
      expect(model.secondActionDone, equals(secondActionDone));
      expect(model.thirdActionDone, equals(thirdActionDone));
      expect(model.fourthActionDone, equals(fourthActionDone));
    });

    test('should create QuickactionsModel from JSON', () {
      // Arrange
      final json = {
        'firstActionDone': true,
        'secondActionDone': true,
        'thirdActionDone': false,
        'fourthActionDone': true,
      };

      // Act
      final model = QuickactionsModel.fromJson(json);

      // Assert
      expect(model.firstActionDone, equals(true));
      expect(model.secondActionDone, equals(true));
      expect(model.thirdActionDone, equals(false));
      expect(model.fourthActionDone, equals(true));
    });

    test('should convert QuickactionsModel to JSON', () {
      // Arrange
      final model = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['firstActionDone'], equals(true));
      expect(json['secondActionDone'], equals(false));
      expect(json['thirdActionDone'], equals(true));
      expect(json['fourthActionDone'], equals(false));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = QuickactionsModel(
        firstActionDone: false,
        secondActionDone: false,
        thirdActionDone: false,
        fourthActionDone: false,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        firstActionDone: true,
        thirdActionDone: true,
      );

      // Assert
      expect(updatedModel.firstActionDone, equals(true)); // Updated
      expect(updatedModel.secondActionDone, equals(false)); // Unchanged
      expect(updatedModel.thirdActionDone, equals(true)); // Updated
      expect(updatedModel.fourthActionDone, equals(false)); // Unchanged
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
      );
      final model2 = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
      );
      final model3 = QuickactionsModel(
        firstActionDone: false,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
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
        'firstActionDone': true,
        'thirdActionDone': true,
        // Missing secondActionDone and fourthActionDone - should use defaults
      };

      // Act
      final model = QuickactionsModel.fromJson(json);

      // Assert
      expect(model.firstActionDone, equals(true));
      expect(model.secondActionDone, equals(false)); // Default
      expect(model.thirdActionDone, equals(true));
      expect(model.fourthActionDone, equals(false)); // Default
    });

    test('should handle all actions completed state', () {
      // Arrange & Act
      final allCompleted = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: true,
        thirdActionDone: true,
        fourthActionDone: true,
      );

      // Assert
      expect(allCompleted.firstActionDone, isTrue);
      expect(allCompleted.secondActionDone, isTrue);
      expect(allCompleted.thirdActionDone, isTrue);
      expect(allCompleted.fourthActionDone, isTrue);
    });

    test('should handle no actions completed state', () {
      // Arrange & Act
      final noneCompleted = QuickactionsModel(
        firstActionDone: false,
        secondActionDone: false,
        thirdActionDone: false,
        fourthActionDone: false,
      );
      final defaultState = QuickactionsModel(); // Should default to all false

      // Assert
      expect(noneCompleted.firstActionDone, isFalse);
      expect(noneCompleted.secondActionDone, isFalse);
      expect(noneCompleted.thirdActionDone, isFalse);
      expect(noneCompleted.fourthActionDone, isFalse);
      expect(defaultState.firstActionDone, isFalse);
      expect(defaultState.secondActionDone, isFalse);
      expect(defaultState.thirdActionDone, isFalse);
      expect(defaultState.fourthActionDone, isFalse);
    });

    test('should handle partial completion states', () {
      // Arrange & Act
      final firstTwoCompleted = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: true,
        thirdActionDone: false,
        fourthActionDone: false,
      );
      final alternatingCompleted = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
      );
      final lastTwoCompleted = QuickactionsModel(
        firstActionDone: false,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: true,
      );

      // Assert
      expect(firstTwoCompleted.firstActionDone, isTrue);
      expect(firstTwoCompleted.secondActionDone, isTrue);
      expect(firstTwoCompleted.thirdActionDone, isFalse);
      expect(firstTwoCompleted.fourthActionDone, isFalse);

      expect(alternatingCompleted.firstActionDone, isTrue);
      expect(alternatingCompleted.secondActionDone, isFalse);
      expect(alternatingCompleted.thirdActionDone, isTrue);
      expect(alternatingCompleted.fourthActionDone, isFalse);

      expect(lastTwoCompleted.firstActionDone, isFalse);
      expect(lastTwoCompleted.secondActionDone, isFalse);
      expect(lastTwoCompleted.thirdActionDone, isTrue);
      expect(lastTwoCompleted.fourthActionDone, isTrue);
    });

    test('should handle copyWith for individual actions', () {
      // Arrange
      final originalModel = QuickactionsModel();

      // Act
      final firstCompleted = originalModel.copyWith(firstActionDone: true);
      final secondCompleted = originalModel.copyWith(secondActionDone: true);
      final thirdCompleted = originalModel.copyWith(thirdActionDone: true);
      final fourthCompleted = originalModel.copyWith(fourthActionDone: true);

      // Assert
      expect(firstCompleted.firstActionDone, isTrue);
      expect(firstCompleted.secondActionDone, isFalse); // Unchanged
      expect(firstCompleted.thirdActionDone, isFalse); // Unchanged
      expect(firstCompleted.fourthActionDone, isFalse); // Unchanged

      expect(secondCompleted.firstActionDone, isFalse); // Unchanged
      expect(secondCompleted.secondActionDone, isTrue);
      expect(secondCompleted.thirdActionDone, isFalse); // Unchanged
      expect(secondCompleted.fourthActionDone, isFalse); // Unchanged

      expect(thirdCompleted.firstActionDone, isFalse); // Unchanged
      expect(thirdCompleted.secondActionDone, isFalse); // Unchanged
      expect(thirdCompleted.thirdActionDone, isTrue);
      expect(thirdCompleted.fourthActionDone, isFalse); // Unchanged

      expect(fourthCompleted.firstActionDone, isFalse); // Unchanged
      expect(fourthCompleted.secondActionDone, isFalse); // Unchanged
      expect(fourthCompleted.thirdActionDone, isFalse); // Unchanged
      expect(fourthCompleted.fourthActionDone, isTrue);
    });

    test('should handle copyWith for multiple actions at once', () {
      // Arrange
      final originalModel = QuickactionsModel();

      // Act
      final multipleUpdated = originalModel.copyWith(
        firstActionDone: true,
        thirdActionDone: true,
        fourthActionDone: true,
      );

      // Assert
      expect(multipleUpdated.firstActionDone, isTrue);
      expect(multipleUpdated.secondActionDone, isFalse); // Unchanged
      expect(multipleUpdated.thirdActionDone, isTrue);
      expect(multipleUpdated.fourthActionDone, isTrue);
    });

    test('should handle resetting completed actions', () {
      // Arrange
      final completedModel = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: true,
        thirdActionDone: true,
        fourthActionDone: true,
      );

      // Act
      final resetModel = completedModel.copyWith(
        firstActionDone: false,
        secondActionDone: false,
        thirdActionDone: false,
        fourthActionDone: false,
      );

      // Assert
      expect(resetModel.firstActionDone, isFalse);
      expect(resetModel.secondActionDone, isFalse);
      expect(resetModel.thirdActionDone, isFalse);
      expect(resetModel.fourthActionDone, isFalse);
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('QuickactionsModel'));
      expect(stringRepresentation, contains('firstActionDone'));
      expect(stringRepresentation, contains('secondActionDone'));
      expect(stringRepresentation, contains('thirdActionDone'));
      expect(stringRepresentation, contains('fourthActionDone'));
    });

    test('should handle JSON serialization round trip', () {
      // Arrange
      final originalModel = QuickactionsModel(
        firstActionDone: true,
        secondActionDone: false,
        thirdActionDone: true,
        fourthActionDone: false,
      );

      // Act
      final json = originalModel.toJson();
      final deserializedModel = QuickactionsModel.fromJson(json);

      // Assert
      expect(deserializedModel, equals(originalModel));
      expect(deserializedModel.firstActionDone, equals(originalModel.firstActionDone));
      expect(deserializedModel.secondActionDone, equals(originalModel.secondActionDone));
      expect(deserializedModel.thirdActionDone, equals(originalModel.thirdActionDone));
      expect(deserializedModel.fourthActionDone, equals(originalModel.fourthActionDone));
    });

    test('should handle empty JSON object with defaults', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final model = QuickactionsModel.fromJson(json);

      // Assert
      expect(model.firstActionDone, equals(false));
      expect(model.secondActionDone, equals(false));
      expect(model.thirdActionDone, equals(false));
      expect(model.fourthActionDone, equals(false));
    });
  });
}
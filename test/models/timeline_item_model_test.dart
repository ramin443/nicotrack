import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/timeline-item-model/timelineItem-model.dart';

void main() {
  group('TimelineItemModel', () {
    test('should create TimelineItemModel with required values', () {
      // Arrange
      const dayNumber = 1;
      const streakNumber = 1;
      const streakImg = 'assets/images/streak_1.png';
      const dayDuration = '20 minutes';
      const whatHappens = 'Your heart rate and blood pressure drop.';

      // Act
      final model = TimelineItemModel(
        dayNumber: dayNumber,
        streakNumber: streakNumber,
        streakImg: streakImg,
        dayDuration: dayDuration,
        whatHappens: whatHappens,
      );

      // Assert
      expect(model.dayNumber, equals(dayNumber));
      expect(model.streakNumber, equals(streakNumber));
      expect(model.streakImg, equals(streakImg));
      expect(model.dayDuration, equals(dayDuration));
      expect(model.whatHappens, equals(whatHappens));
    });

    test('should create TimelineItemModel from JSON', () {
      // Arrange
      final json = {
        'dayNumber': 7,
        'streakNumber': 2,
        'streakImg': 'assets/images/streak_2.png',
        'dayDuration': '1 week',
        'whatHappens': 'Your sense of taste and smell begin to improve.',
      };

      // Act
      final model = TimelineItemModel.fromJson(json);

      // Assert
      expect(model.dayNumber, equals(7));
      expect(model.streakNumber, equals(2));
      expect(model.streakImg, equals('assets/images/streak_2.png'));
      expect(model.dayDuration, equals('1 week'));
      expect(model.whatHappens, equals('Your sense of taste and smell begin to improve.'));
    });

    test('should convert TimelineItemModel to JSON', () {
      // Arrange
      final model = TimelineItemModel(
        dayNumber: 30,
        streakNumber: 3,
        streakImg: 'assets/images/streak_3.png',
        dayDuration: '1 month',
        whatHappens: 'Your circulation improves and your lung function increases.',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['dayNumber'], equals(30));
      expect(json['streakNumber'], equals(3));
      expect(json['streakImg'], equals('assets/images/streak_3.png'));
      expect(json['dayDuration'], equals('1 month'));
      expect(json['whatHappens'], equals('Your circulation improves and your lung function increases.'));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '20 minutes',
        whatHappens: 'Your heart rate and blood pressure drop.',
      );

      // Act
      final updatedModel = originalModel.copyWith(
        dayNumber: 365,
        dayDuration: '1 year',
        whatHappens: 'Your risk of coronary heart disease is about half that of a smoker.',
      );

      // Assert
      expect(updatedModel.dayNumber, equals(365));
      expect(updatedModel.streakNumber, equals(1)); // Unchanged
      expect(updatedModel.streakImg, equals('assets/images/streak_1.png')); // Unchanged
      expect(updatedModel.dayDuration, equals('1 year')); // Updated
      expect(updatedModel.whatHappens, equals('Your risk of coronary heart disease is about half that of a smoker.')); // Updated
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '20 minutes',
        whatHappens: 'Your heart rate and blood pressure drop.',
      );
      final model2 = TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '20 minutes',
        whatHappens: 'Your heart rate and blood pressure drop.',
      );
      final model3 = TimelineItemModel(
        dayNumber: 7,
        streakNumber: 2,
        streakImg: 'assets/images/streak_2.png',
        dayDuration: '1 week',
        whatHappens: 'Your sense of taste and smell begin to improve.',
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1.hashCode, isNot(equals(model3.hashCode)));
    });

    test('should handle various timeline milestones', () {
      // Arrange & Act
      final minute20 = TimelineItemModel(
        dayNumber: 0,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '20 minutes',
        whatHappens: 'Your heart rate and blood pressure drop.',
      );
      final hour12 = TimelineItemModel(
        dayNumber: 0,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '12 hours',
        whatHappens: 'Carbon monoxide level in your blood drops to normal.',
      );
      final weeks2 = TimelineItemModel(
        dayNumber: 14,
        streakNumber: 2,
        streakImg: 'assets/images/streak_2.png',
        dayDuration: '2 weeks',
        whatHappens: 'Your circulation improves and your lung function increases.',
      );

      // Assert
      expect(minute20.dayDuration, equals('20 minutes'));
      expect(hour12.dayDuration, equals('12 hours'));
      expect(weeks2.dayDuration, equals('2 weeks'));
      expect(weeks2.dayNumber, equals(14));
    });

    test('should handle different streak numbers and images', () {
      // Arrange & Act
      final streak1 = TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '1 day',
        whatHappens: 'First day milestone.',
      );
      final streak5 = TimelineItemModel(
        dayNumber: 30,
        streakNumber: 5,
        streakImg: 'assets/images/streak_5.png',
        dayDuration: '1 month',
        whatHappens: 'One month milestone.',
      );
      final streak10 = TimelineItemModel(
        dayNumber: 365,
        streakNumber: 10,
        streakImg: 'assets/images/streak_10.png',
        dayDuration: '1 year',
        whatHappens: 'One year milestone.',
      );

      // Assert
      expect(streak1.streakNumber, equals(1));
      expect(streak5.streakNumber, equals(5));
      expect(streak10.streakNumber, equals(10));
      expect(streak1.streakImg, contains('streak_1'));
      expect(streak5.streakImg, contains('streak_5'));
      expect(streak10.streakImg, contains('streak_10'));
    });

    test('should handle various health improvement descriptions', () {
      // Arrange & Act
      final shortTerm = TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '24 hours',
        whatHappens: 'Your risk of heart attack begins to decrease.',
      );
      final mediumTerm = TimelineItemModel(
        dayNumber: 90,
        streakNumber: 4,
        streakImg: 'assets/images/streak_4.png',
        dayDuration: '3 months',
        whatHappens: 'Your circulation improves. Your lung function increases up to 30%.',
      );
      final longTerm = TimelineItemModel(
        dayNumber: 5475,
        streakNumber: 15,
        streakImg: 'assets/images/streak_15.png',
        dayDuration: '15 years',
        whatHappens: 'Your risk of coronary heart disease is now the same as a non-smoker.',
      );

      // Assert
      expect(shortTerm.whatHappens, contains('heart attack'));
      expect(mediumTerm.whatHappens, contains('circulation'));
      expect(mediumTerm.whatHappens, contains('30%'));
      expect(longTerm.whatHappens, contains('non-smoker'));
      expect(longTerm.dayNumber, equals(5475));
    });

    test('should handle edge cases for day numbers', () {
      // Arrange & Act
      final dayZero = TimelineItemModel(
        dayNumber: 0,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '0 minutes',
        whatHappens: 'You made the decision to quit!',
      );
      final largeDay = TimelineItemModel(
        dayNumber: 10000,
        streakNumber: 20,
        streakImg: 'assets/images/streak_20.png',
        dayDuration: '27+ years',
        whatHappens: 'Congratulations on your long-term success!',
      );

      // Assert
      expect(dayZero.dayNumber, equals(0));
      expect(largeDay.dayNumber, equals(10000));
      expect(dayZero.dayDuration, equals('0 minutes'));
      expect(largeDay.dayDuration, contains('27+'));
    });

    test('should handle copyWith for all fields', () {
      // Arrange
      final originalModel = TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        streakImg: 'assets/images/streak_1.png',
        dayDuration: '1 day',
        whatHappens: 'Original description.',
      );

      // Act
      final updatedModel = originalModel.copyWith(
        dayNumber: 7,
        streakNumber: 2,
        streakImg: 'assets/images/streak_2.png',
        dayDuration: '1 week',
        whatHappens: 'Updated description.',
      );

      // Assert
      expect(updatedModel.dayNumber, equals(7));
      expect(updatedModel.streakNumber, equals(2));
      expect(updatedModel.streakImg, equals('assets/images/streak_2.png'));
      expect(updatedModel.dayDuration, equals('1 week'));
      expect(updatedModel.whatHappens, equals('Updated description.'));
      // Original should be unchanged
      expect(originalModel.dayNumber, equals(1));
      expect(originalModel.streakNumber, equals(1));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = TimelineItemModel(
        dayNumber: 30,
        streakNumber: 3,
        streakImg: 'assets/images/streak_3.png',
        dayDuration: '1 month',
        whatHappens: 'Your circulation improves.',
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('TimelineItemModel'));
      expect(stringRepresentation, contains('dayNumber'));
      expect(stringRepresentation, contains('streakNumber'));
      expect(stringRepresentation, contains('dayDuration'));
      expect(stringRepresentation, contains('whatHappens'));
    });

    test('should handle JSON with all required fields', () {
      // Arrange
      final json = {
        'dayNumber': 1095,
        'streakNumber': 8,
        'streakImg': 'assets/images/streak_8.png',
        'dayDuration': '3 years',
        'whatHappens': 'Your risk of stroke is reduced to that of a non-smoker 2-5 years after quitting.',
      };

      // Act
      final model = TimelineItemModel.fromJson(json);

      // Assert
      expect(model.dayNumber, equals(1095));
      expect(model.streakNumber, equals(8));
      expect(model.streakImg, equals('assets/images/streak_8.png'));
      expect(model.dayDuration, equals('3 years'));
      expect(model.whatHappens, contains('stroke'));
    });
  });
}
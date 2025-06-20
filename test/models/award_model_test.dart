import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/award-model/award-model.dart';

void main() {
  group('AwardModel', () {
    test('should create AwardModel with required values', () {
      // Arrange
      const emojiImg = 'assets/images/award_1_day.png';
      const day = 1;

      // Act
      final model = AwardModel(
        emojiImg: emojiImg,
        day: day,
      );

      // Assert
      expect(model.emojiImg, equals(emojiImg));
      expect(model.day, equals(day));
    });

    test('should create AwardModel from JSON', () {
      // Arrange
      final json = {
        'emojiImg': 'assets/images/award_7_days.png',
        'day': 7,
      };

      // Act
      final model = AwardModel.fromJson(json);

      // Assert
      expect(model.emojiImg, equals('assets/images/award_7_days.png'));
      expect(model.day, equals(7));
    });

    test('should convert AwardModel to JSON', () {
      // Arrange
      final model = AwardModel(
        emojiImg: 'assets/images/award_30_days.png',
        day: 30,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['emojiImg'], equals('assets/images/award_30_days.png'));
      expect(json['day'], equals(30));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = AwardModel(
        emojiImg: 'assets/images/award_1_day.png',
        day: 1,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        emojiImg: 'assets/images/award_1_week.png',
        day: 7,
      );

      // Assert
      expect(updatedModel.emojiImg, equals('assets/images/award_1_week.png')); // Updated
      expect(updatedModel.day, equals(7)); // Updated
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = AwardModel(
        emojiImg: 'assets/images/award_1_day.png',
        day: 1,
      );
      final model2 = AwardModel(
        emojiImg: 'assets/images/award_1_day.png',
        day: 1,
      );
      final model3 = AwardModel(
        emojiImg: 'assets/images/award_7_days.png',
        day: 7,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1.hashCode, isNot(equals(model3.hashCode)));
    });

    test('should handle various milestone days', () {
      // Arrange & Act
      final firstDay = AwardModel(
        emojiImg: 'assets/images/award_1_day.png',
        day: 1,
      );
      final oneWeek = AwardModel(
        emojiImg: 'assets/images/award_1_week.png',
        day: 7,
      );
      final oneMonth = AwardModel(
        emojiImg: 'assets/images/award_1_month.png',
        day: 30,
      );
      final threeMonths = AwardModel(
        emojiImg: 'assets/images/award_3_months.png',
        day: 90,
      );
      final sixMonths = AwardModel(
        emojiImg: 'assets/images/award_6_months.png',
        day: 180,
      );
      final oneYear = AwardModel(
        emojiImg: 'assets/images/award_1_year.png',
        day: 365,
      );

      // Assert
      expect(firstDay.day, equals(1));
      expect(oneWeek.day, equals(7));
      expect(oneMonth.day, equals(30));
      expect(threeMonths.day, equals(90));
      expect(sixMonths.day, equals(180));
      expect(oneYear.day, equals(365));
    });

    test('should handle various award image paths', () {
      // Arrange & Act
      final basicAward = AwardModel(
        emojiImg: 'assets/images/award_basic.png',
        day: 1,
      );
      final bronzeAward = AwardModel(
        emojiImg: 'assets/images/award_bronze.png',
        day: 7,
      );
      final silverAward = AwardModel(
        emojiImg: 'assets/images/award_silver.png',
        day: 30,
      );
      final goldAward = AwardModel(
        emojiImg: 'assets/images/award_gold.png',
        day: 90,
      );
      final platinumAward = AwardModel(
        emojiImg: 'assets/images/award_platinum.png',
        day: 365,
      );

      // Assert
      expect(basicAward.emojiImg, contains('basic'));
      expect(bronzeAward.emojiImg, contains('bronze'));
      expect(silverAward.emojiImg, contains('silver'));
      expect(goldAward.emojiImg, contains('gold'));
      expect(platinumAward.emojiImg, contains('platinum'));
    });

    test('should handle copyWith for individual fields', () {
      // Arrange
      final originalModel = AwardModel(
        emojiImg: 'assets/images/award_original.png',
        day: 14,
      );

      // Act
      final imageUpdated = originalModel.copyWith(
        emojiImg: 'assets/images/award_updated.png',
      );
      final dayUpdated = originalModel.copyWith(
        day: 21,
      );

      // Assert
      expect(imageUpdated.emojiImg, equals('assets/images/award_updated.png'));
      expect(imageUpdated.day, equals(14)); // Unchanged

      expect(dayUpdated.emojiImg, equals('assets/images/award_original.png')); // Unchanged
      expect(dayUpdated.day, equals(21));
    });

    test('should handle edge case day values', () {
      // Arrange & Act
      final zeroDay = AwardModel(
        emojiImg: 'assets/images/award_start.png',
        day: 0,
      );
      final largeDay = AwardModel(
        emojiImg: 'assets/images/award_milestone.png',
        day: 10000,
      );
      final negativeDay = AwardModel(
        emojiImg: 'assets/images/award_negative.png',
        day: -1,
      );

      // Assert
      expect(zeroDay.day, equals(0));
      expect(largeDay.day, equals(10000));
      expect(negativeDay.day, equals(-1));
    });

    test('should handle various file extensions and paths', () {
      // Arrange & Act
      final pngImage = AwardModel(
        emojiImg: 'assets/images/award.png',
        day: 1,
      );
      final jpgImage = AwardModel(
        emojiImg: 'assets/images/award.jpg',
        day: 7,
      );
      final svgImage = AwardModel(
        emojiImg: 'assets/icons/award.svg',
        day: 30,
      );
      final nestedPath = AwardModel(
        emojiImg: 'assets/images/awards/milestones/award_1_year.png',
        day: 365,
      );

      // Assert
      expect(pngImage.emojiImg, endsWith('.png'));
      expect(jpgImage.emojiImg, endsWith('.jpg'));
      expect(svgImage.emojiImg, endsWith('.svg'));
      expect(nestedPath.emojiImg, contains('awards/milestones'));
    });

    test('should handle sequential milestone progression', () {
      // Arrange & Act
      final milestones = [
        AwardModel(emojiImg: 'assets/images/award_day_1.png', day: 1),
        AwardModel(emojiImg: 'assets/images/award_day_3.png', day: 3),
        AwardModel(emojiImg: 'assets/images/award_day_7.png', day: 7),
        AwardModel(emojiImg: 'assets/images/award_day_14.png', day: 14),
        AwardModel(emojiImg: 'assets/images/award_day_30.png', day: 30),
        AwardModel(emojiImg: 'assets/images/award_day_60.png', day: 60),
        AwardModel(emojiImg: 'assets/images/award_day_90.png', day: 90),
      ];

      // Assert
      expect(milestones.length, equals(7));
      expect(milestones[0].day, equals(1));
      expect(milestones[1].day, equals(3));
      expect(milestones[2].day, equals(7));
      expect(milestones[3].day, equals(14));
      expect(milestones[4].day, equals(30));
      expect(milestones[5].day, equals(60));
      expect(milestones[6].day, equals(90));
      
      // Check that days are in ascending order
      for (int i = 1; i < milestones.length; i++) {
        expect(milestones[i].day, greaterThan(milestones[i - 1].day));
      }
    });

    test('should handle empty and special character paths', () {
      // Arrange & Act
      final emptyPath = AwardModel(
        emojiImg: '',
        day: 1,
      );
      final spacePath = AwardModel(
        emojiImg: 'assets/images/award with spaces.png',
        day: 7,
      );
      final specialChars = AwardModel(
        emojiImg: 'assets/images/award-special_chars@123.png',
        day: 30,
      );

      // Assert
      expect(emptyPath.emojiImg, equals(''));
      expect(spacePath.emojiImg, contains('spaces'));
      expect(specialChars.emojiImg, contains('special_chars@123'));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = AwardModel(
        emojiImg: 'assets/images/award_1_month.png',
        day: 30,
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('AwardModel'));
      expect(stringRepresentation, contains('emojiImg'));
      expect(stringRepresentation, contains('day'));
    });

    test('should handle JSON serialization round trip', () {
      // Arrange
      final originalModel = AwardModel(
        emojiImg: 'assets/images/award_special.png',
        day: 42,
      );

      // Act
      final json = originalModel.toJson();
      final deserializedModel = AwardModel.fromJson(json);

      // Assert
      expect(deserializedModel, equals(originalModel));
      expect(deserializedModel.emojiImg, equals(originalModel.emojiImg));
      expect(deserializedModel.day, equals(originalModel.day));
    });

    test('should handle awards sorting by day', () {
      // Arrange
      final awards = [
        AwardModel(emojiImg: 'assets/images/award_365.png', day: 365),
        AwardModel(emojiImg: 'assets/images/award_1.png', day: 1),
        AwardModel(emojiImg: 'assets/images/award_30.png', day: 30),
        AwardModel(emojiImg: 'assets/images/award_7.png', day: 7),
      ];

      // Act
      awards.sort((a, b) => a.day.compareTo(b.day));

      // Assert
      expect(awards[0].day, equals(1));
      expect(awards[1].day, equals(7));
      expect(awards[2].day, equals(30));
      expect(awards[3].day, equals(365));
    });

    test('should handle awards filtering by day threshold', () {
      // Arrange
      final allAwards = [
        AwardModel(emojiImg: 'assets/images/award_1.png', day: 1),
        AwardModel(emojiImg: 'assets/images/award_7.png', day: 7),
        AwardModel(emojiImg: 'assets/images/award_30.png', day: 30),
        AwardModel(emojiImg: 'assets/images/award_90.png', day: 90),
        AwardModel(emojiImg: 'assets/images/award_365.png', day: 365),
      ];
      const daysSinceQuit = 45;

      // Act
      final earnedAwards = allAwards.where((award) => award.day <= daysSinceQuit).toList();
      final upcomingAwards = allAwards.where((award) => award.day > daysSinceQuit).toList();

      // Assert
      expect(earnedAwards.length, equals(3)); // Days 1, 7, 30
      expect(upcomingAwards.length, equals(2)); // Days 90, 365
      expect(earnedAwards.every((award) => award.day <= daysSinceQuit), isTrue);
      expect(upcomingAwards.every((award) => award.day > daysSinceQuit), isTrue);
    });
  });
}
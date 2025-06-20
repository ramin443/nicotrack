import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/notifications-preferences-model/notificationsPreferences-model.dart';

void main() {
  group('NotificationsPreferencesModel', () {
    test('should create NotificationsPreferencesModel with default values', () {
      // Arrange & Act
      final model = NotificationsPreferencesModel();

      // Assert
      expect(model.pushNotificationsActivated, equals(false));
      expect(model.dailyReminderHour, equals(8));
      expect(model.dailyReminderMinute, equals(0));
      expect(model.dailyReminderPeriod, equals(" AM"));
      expect(model.weeklyReminderDay, equals("Monday"));
      expect(model.weeklyReminderHour, equals(6));
      expect(model.weeklyReminderMinute, equals(0));
      expect(model.weeklyReminderPeriod, equals(" PM"));
    });

    test('should create NotificationsPreferencesModel with custom values', () {
      // Arrange
      const pushNotificationsActivated = true;
      const dailyReminderHour = 10;
      const dailyReminderMinute = 30;
      const dailyReminderPeriod = " PM";
      const weeklyReminderDay = "Friday";
      const weeklyReminderHour = 3;
      const weeklyReminderMinute = 15;
      const weeklyReminderPeriod = " AM";

      // Act
      final model = NotificationsPreferencesModel(
        pushNotificationsActivated: pushNotificationsActivated,
        dailyReminderHour: dailyReminderHour,
        dailyReminderMinute: dailyReminderMinute,
        dailyReminderPeriod: dailyReminderPeriod,
        weeklyReminderDay: weeklyReminderDay,
        weeklyReminderHour: weeklyReminderHour,
        weeklyReminderMinute: weeklyReminderMinute,
        weeklyReminderPeriod: weeklyReminderPeriod,
      );

      // Assert
      expect(model.pushNotificationsActivated, equals(pushNotificationsActivated));
      expect(model.dailyReminderHour, equals(dailyReminderHour));
      expect(model.dailyReminderMinute, equals(dailyReminderMinute));
      expect(model.dailyReminderPeriod, equals(dailyReminderPeriod));
      expect(model.weeklyReminderDay, equals(weeklyReminderDay));
      expect(model.weeklyReminderHour, equals(weeklyReminderHour));
      expect(model.weeklyReminderMinute, equals(weeklyReminderMinute));
      expect(model.weeklyReminderPeriod, equals(weeklyReminderPeriod));
    });

    test('should create NotificationsPreferencesModel from JSON', () {
      // Arrange
      final json = {
        'pushNotificationsActivated': true,
        'dailyReminderHour': 9,
        'dailyReminderMinute': 45,
        'dailyReminderPeriod': ' AM',
        'weeklyReminderDay': 'Wednesday',
        'weeklyReminderHour': 7,
        'weeklyReminderMinute': 30,
        'weeklyReminderPeriod': ' PM',
      };

      // Act
      final model = NotificationsPreferencesModel.fromJson(json);

      // Assert
      expect(model.pushNotificationsActivated, equals(true));
      expect(model.dailyReminderHour, equals(9));
      expect(model.dailyReminderMinute, equals(45));
      expect(model.dailyReminderPeriod, equals(' AM'));
      expect(model.weeklyReminderDay, equals('Wednesday'));
      expect(model.weeklyReminderHour, equals(7));
      expect(model.weeklyReminderMinute, equals(30));
      expect(model.weeklyReminderPeriod, equals(' PM'));
    });

    test('should convert NotificationsPreferencesModel to JSON', () {
      // Arrange
      final model = NotificationsPreferencesModel(
        pushNotificationsActivated: true,
        dailyReminderHour: 11,
        dailyReminderMinute: 59,
        dailyReminderPeriod: ' PM',
        weeklyReminderDay: 'Sunday',
        weeklyReminderHour: 1,
        weeklyReminderMinute: 5,
        weeklyReminderPeriod: ' AM',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['pushNotificationsActivated'], equals(true));
      expect(json['dailyReminderHour'], equals(11));
      expect(json['dailyReminderMinute'], equals(59));
      expect(json['dailyReminderPeriod'], equals(' PM'));
      expect(json['weeklyReminderDay'], equals('Sunday'));
      expect(json['weeklyReminderHour'], equals(1));
      expect(json['weeklyReminderMinute'], equals(5));
      expect(json['weeklyReminderPeriod'], equals(' AM'));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalModel = NotificationsPreferencesModel(
        pushNotificationsActivated: false,
        dailyReminderHour: 8,
        dailyReminderMinute: 0,
        weeklyReminderDay: 'Monday',
      );

      // Act
      final updatedModel = originalModel.copyWith(
        pushNotificationsActivated: true,
        dailyReminderHour: 10,
        dailyReminderMinute: 30,
        weeklyReminderDay: 'Saturday',
      );

      // Assert
      expect(updatedModel.pushNotificationsActivated, equals(true)); // Updated
      expect(updatedModel.dailyReminderHour, equals(10)); // Updated
      expect(updatedModel.dailyReminderMinute, equals(30)); // Updated
      expect(updatedModel.dailyReminderPeriod, equals(' AM')); // Unchanged
      expect(updatedModel.weeklyReminderDay, equals('Saturday')); // Updated
      expect(updatedModel.weeklyReminderHour, equals(6)); // Unchanged (default)
      expect(updatedModel.weeklyReminderMinute, equals(0)); // Unchanged (default)
      expect(updatedModel.weeklyReminderPeriod, equals(' PM')); // Unchanged (default)
    });

    test('should handle equality correctly', () {
      // Arrange
      final model1 = NotificationsPreferencesModel(
        pushNotificationsActivated: true,
        dailyReminderHour: 9,
        dailyReminderMinute: 30,
        weeklyReminderDay: 'Friday',
      );
      final model2 = NotificationsPreferencesModel(
        pushNotificationsActivated: true,
        dailyReminderHour: 9,
        dailyReminderMinute: 30,
        weeklyReminderDay: 'Friday',
      );
      final model3 = NotificationsPreferencesModel(
        pushNotificationsActivated: false,
        dailyReminderHour: 9,
        dailyReminderMinute: 30,
        weeklyReminderDay: 'Friday',
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
        'pushNotificationsActivated': true,
        'dailyReminderHour': 7,
        // Other fields should use defaults
      };

      // Act
      final model = NotificationsPreferencesModel.fromJson(json);

      // Assert
      expect(model.pushNotificationsActivated, equals(true));
      expect(model.dailyReminderHour, equals(7));
      expect(model.dailyReminderMinute, equals(0)); // Default
      expect(model.dailyReminderPeriod, equals(' AM')); // Default
      expect(model.weeklyReminderDay, equals('Monday')); // Default
      expect(model.weeklyReminderHour, equals(6)); // Default
      expect(model.weeklyReminderMinute, equals(0)); // Default
      expect(model.weeklyReminderPeriod, equals(' PM')); // Default
    });

    test('should handle various weekday names', () {
      // Arrange & Act
      final monday = NotificationsPreferencesModel(weeklyReminderDay: 'Monday');
      final tuesday = NotificationsPreferencesModel(weeklyReminderDay: 'Tuesday');
      final wednesday = NotificationsPreferencesModel(weeklyReminderDay: 'Wednesday');
      final thursday = NotificationsPreferencesModel(weeklyReminderDay: 'Thursday');
      final friday = NotificationsPreferencesModel(weeklyReminderDay: 'Friday');
      final saturday = NotificationsPreferencesModel(weeklyReminderDay: 'Saturday');
      final sunday = NotificationsPreferencesModel(weeklyReminderDay: 'Sunday');

      // Assert
      expect(monday.weeklyReminderDay, equals('Monday'));
      expect(tuesday.weeklyReminderDay, equals('Tuesday'));
      expect(wednesday.weeklyReminderDay, equals('Wednesday'));
      expect(thursday.weeklyReminderDay, equals('Thursday'));
      expect(friday.weeklyReminderDay, equals('Friday'));
      expect(saturday.weeklyReminderDay, equals('Saturday'));
      expect(sunday.weeklyReminderDay, equals('Sunday'));
    });

    test('should handle 12-hour time format with AM/PM periods', () {
      // Arrange & Act
      final morningDaily = NotificationsPreferencesModel(
        dailyReminderHour: 7,
        dailyReminderMinute: 30,
        dailyReminderPeriod: ' AM',
      );
      final eveningDaily = NotificationsPreferencesModel(
        dailyReminderHour: 11,
        dailyReminderMinute: 45,
        dailyReminderPeriod: ' PM',
      );
      final morningWeekly = NotificationsPreferencesModel(
        weeklyReminderHour: 9,
        weeklyReminderMinute: 15,
        weeklyReminderPeriod: ' AM',
      );
      final eveningWeekly = NotificationsPreferencesModel(
        weeklyReminderHour: 8,
        weeklyReminderMinute: 0,
        weeklyReminderPeriod: ' PM',
      );

      // Assert
      expect(morningDaily.dailyReminderPeriod, equals(' AM'));
      expect(eveningDaily.dailyReminderPeriod, equals(' PM'));
      expect(morningWeekly.weeklyReminderPeriod, equals(' AM'));
      expect(eveningWeekly.weeklyReminderPeriod, equals(' PM'));
    });

    test('should handle hour range validation (0-11 for 12-hour format)', () {
      // Arrange & Act
      final midnight = NotificationsPreferencesModel(
        dailyReminderHour: 0, // 12:XX AM
        weeklyReminderHour: 0, // 12:XX AM
      );
      final noon = NotificationsPreferencesModel(
        dailyReminderHour: 11, // 11:XX (could be AM or PM)
        weeklyReminderHour: 11, // 11:XX (could be AM or PM)
      );

      // Assert
      expect(midnight.dailyReminderHour, equals(0));
      expect(midnight.weeklyReminderHour, equals(0));
      expect(noon.dailyReminderHour, equals(11));
      expect(noon.weeklyReminderHour, equals(11));
    });

    test('should handle minute range validation (0-59)', () {
      // Arrange & Act
      final exactHour = NotificationsPreferencesModel(
        dailyReminderMinute: 0,
        weeklyReminderMinute: 0,
      );
      final quarterPast = NotificationsPreferencesModel(
        dailyReminderMinute: 15,
        weeklyReminderMinute: 15,
      );
      final halfPast = NotificationsPreferencesModel(
        dailyReminderMinute: 30,
        weeklyReminderMinute: 30,
      );
      final quarterTo = NotificationsPreferencesModel(
        dailyReminderMinute: 45,
        weeklyReminderMinute: 45,
      );
      final lastMinute = NotificationsPreferencesModel(
        dailyReminderMinute: 59,
        weeklyReminderMinute: 59,
      );

      // Assert
      expect(exactHour.dailyReminderMinute, equals(0));
      expect(quarterPast.dailyReminderMinute, equals(15));
      expect(halfPast.dailyReminderMinute, equals(30));
      expect(quarterTo.dailyReminderMinute, equals(45));
      expect(lastMinute.dailyReminderMinute, equals(59));
    });

    test('should handle notification activation states', () {
      // Arrange & Act
      final activated = NotificationsPreferencesModel(pushNotificationsActivated: true);
      final deactivated = NotificationsPreferencesModel(pushNotificationsActivated: false);
      final defaultState = NotificationsPreferencesModel(); // Should default to false

      // Assert
      expect(activated.pushNotificationsActivated, isTrue);
      expect(deactivated.pushNotificationsActivated, isFalse);
      expect(defaultState.pushNotificationsActivated, isFalse);
    });

    test('should handle period format with leading space', () {
      // This tests the specific format used in the app (" AM" / " PM" with space)
      // Arrange & Act
      final modelAM = NotificationsPreferencesModel(
        dailyReminderPeriod: ' AM',
        weeklyReminderPeriod: ' AM',
      );
      final modelPM = NotificationsPreferencesModel(
        dailyReminderPeriod: ' PM',
        weeklyReminderPeriod: ' PM',
      );

      // Assert
      expect(modelAM.dailyReminderPeriod, equals(' AM'));
      expect(modelAM.weeklyReminderPeriod, equals(' AM'));
      expect(modelPM.dailyReminderPeriod, equals(' PM'));
      expect(modelPM.weeklyReminderPeriod, equals(' PM'));
      expect(modelAM.dailyReminderPeriod, startsWith(' '));
      expect(modelPM.weeklyReminderPeriod, startsWith(' '));
    });

    test('should toString provide meaningful representation', () {
      // Arrange
      final model = NotificationsPreferencesModel(
        pushNotificationsActivated: true,
        dailyReminderHour: 9,
        dailyReminderMinute: 30,
        weeklyReminderDay: 'Friday',
      );

      // Act
      final stringRepresentation = model.toString();

      // Assert
      expect(stringRepresentation, contains('NotificationsPreferencesModel'));
      expect(stringRepresentation, contains('pushNotificationsActivated'));
      expect(stringRepresentation, contains('dailyReminderHour'));
      expect(stringRepresentation, contains('weeklyReminderDay'));
    });

    test('should handle copyWith for individual fields', () {
      // Arrange
      final originalModel = NotificationsPreferencesModel();

      // Act
      final notificationsEnabled = originalModel.copyWith(pushNotificationsActivated: true);
      final timeChanged = originalModel.copyWith(dailyReminderHour: 10, dailyReminderMinute: 45);
      final dayChanged = originalModel.copyWith(weeklyReminderDay: 'Sunday');

      // Assert
      expect(notificationsEnabled.pushNotificationsActivated, isTrue);
      expect(notificationsEnabled.dailyReminderHour, equals(8)); // Unchanged
      expect(timeChanged.dailyReminderHour, equals(10));
      expect(timeChanged.dailyReminderMinute, equals(45));
      expect(timeChanged.pushNotificationsActivated, isFalse); // Unchanged
      expect(dayChanged.weeklyReminderDay, equals('Sunday'));
      expect(dayChanged.dailyReminderHour, equals(8)); // Unchanged
    });
  });
}
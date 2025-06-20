import 'package:flutter_test/flutter_test.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';

void main() {
  group('OnboardingData', () {
    test('should create OnboardingData with default values', () {
      // Arrange & Act
      final onboardingData = OnboardingData();

      // Assert
      expect(onboardingData.lastSmokedDate, equals(""));
      expect(onboardingData.cigarettesPerDay, equals(-1));
      expect(onboardingData.costOfAPack, equals(""));
      expect(onboardingData.numberOfCigarettesIn1Pack, equals(-1));
      expect(onboardingData.biggestMotivation, equals([]));
      expect(onboardingData.craveSituations, equals([]));
      expect(onboardingData.helpNeeded, equals([]));
      expect(onboardingData.quitMethod, equals(-1));
      expect(onboardingData.name, equals(""));
    });

    test('should create OnboardingData with custom values', () {
      // Arrange
      const lastSmokedDate = "2024-01-15";
      const cigarettesPerDay = 10;
      const costOfAPack = "12.50";
      const numberOfCigarettesIn1Pack = 20;
      final biggestMotivation = ["Health benefits", "Save Money"];
      final craveSituations = ["Morning with coffee", "After meals"];
      final helpNeeded = ["Handling cravings & withdrawal"];
      const quitMethod = 1;
      const name = "John Doe";

      // Act
      final onboardingData = OnboardingData(
        lastSmokedDate: lastSmokedDate,
        cigarettesPerDay: cigarettesPerDay,
        costOfAPack: costOfAPack,
        numberOfCigarettesIn1Pack: numberOfCigarettesIn1Pack,
        biggestMotivation: biggestMotivation,
        craveSituations: craveSituations,
        helpNeeded: helpNeeded,
        quitMethod: quitMethod,
        name: name,
      );

      // Assert
      expect(onboardingData.lastSmokedDate, equals(lastSmokedDate));
      expect(onboardingData.cigarettesPerDay, equals(cigarettesPerDay));
      expect(onboardingData.costOfAPack, equals(costOfAPack));
      expect(onboardingData.numberOfCigarettesIn1Pack, equals(numberOfCigarettesIn1Pack));
      expect(onboardingData.biggestMotivation, equals(biggestMotivation));
      expect(onboardingData.craveSituations, equals(craveSituations));
      expect(onboardingData.helpNeeded, equals(helpNeeded));
      expect(onboardingData.quitMethod, equals(quitMethod));
      expect(onboardingData.name, equals(name));
    });

    test('should create OnboardingData from JSON', () {
      // Arrange
      final json = {
        'lastSmokedDate': '2024-01-15',
        'cigarettesPerDay': 10,
        'costOfAPack': '12.50',
        'numberOfCigarettesIn1Pack': 20,
        'biggestMotivation': ['Health benefits', 'Save Money', 'Family & loved ones'],
        'craveSituations': ['Morning with coffee', 'After meals', 'When feeling stressed'],
        'helpNeeded': ['Handling cravings & withdrawal', 'Support & motivation'],
        'quitMethod': 1,
        'name': 'Jane Smith',
      };

      // Act
      final onboardingData = OnboardingData.fromJson(json);

      // Assert
      expect(onboardingData.lastSmokedDate, equals('2024-01-15'));
      expect(onboardingData.cigarettesPerDay, equals(10));
      expect(onboardingData.costOfAPack, equals('12.50'));
      expect(onboardingData.numberOfCigarettesIn1Pack, equals(20));
      expect(onboardingData.biggestMotivation.length, equals(3));
      expect(onboardingData.craveSituations.length, equals(3));
      expect(onboardingData.helpNeeded.length, equals(2));
      expect(onboardingData.quitMethod, equals(1));
      expect(onboardingData.name, equals('Jane Smith'));
    });

    test('should convert OnboardingData to JSON', () {
      // Arrange
      final onboardingData = OnboardingData(
        lastSmokedDate: '2024-01-15',
        cigarettesPerDay: 15,
        costOfAPack: '14.75',
        numberOfCigarettesIn1Pack: 25,
        biggestMotivation: ['Health benefits', 'Personal challenge'],
        craveSituations: ['Morning with coffee', 'Social setting'],
        helpNeeded: ['Tracking my progress'],
        quitMethod: 1,
        name: 'Alex Johnson',
      );

      // Act
      final json = onboardingData.toJson();

      // Assert
      expect(json['lastSmokedDate'], equals('2024-01-15'));
      expect(json['cigarettesPerDay'], equals(15));
      expect(json['costOfAPack'], equals('14.75'));
      expect(json['numberOfCigarettesIn1Pack'], equals(25));
      expect(json['biggestMotivation'], isA<List<String>>());
      expect(json['biggestMotivation'].length, equals(2));
      expect(json['craveSituations'], isA<List<String>>());
      expect(json['helpNeeded'], isA<List<String>>());
      expect(json['quitMethod'], equals(1));
      expect(json['name'], equals('Alex Johnson'));
    });

    test('should create a copy with updated values', () {
      // Arrange
      final originalData = OnboardingData(
        lastSmokedDate: '2024-01-15',
        cigarettesPerDay: 10,
        name: 'John',
      );

      // Act
      final updatedData = originalData.copyWith(
        cigarettesPerDay: 15,
        costOfAPack: '12.50',
        biggestMotivation: ['Health benefits'],
      );

      // Assert
      expect(updatedData.lastSmokedDate, equals('2024-01-15')); // Unchanged
      expect(updatedData.cigarettesPerDay, equals(15)); // Updated
      expect(updatedData.costOfAPack, equals('12.50')); // Updated
      expect(updatedData.biggestMotivation, equals(['Health benefits'])); // Updated
      expect(updatedData.name, equals('John')); // Unchanged
      expect(updatedData.numberOfCigarettesIn1Pack, equals(-1)); // Default unchanged
    });

    test('should handle equality correctly', () {
      // Arrange
      final data1 = OnboardingData(
        lastSmokedDate: '2024-01-15',
        cigarettesPerDay: 10,
        name: 'John',
        biggestMotivation: ['Health benefits'],
      );
      final data2 = OnboardingData(
        lastSmokedDate: '2024-01-15',
        cigarettesPerDay: 10,
        name: 'John',
        biggestMotivation: ['Health benefits'],
      );
      final data3 = OnboardingData(
        lastSmokedDate: '2024-01-16',
        cigarettesPerDay: 10,
        name: 'John',
      );

      // Assert
      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
      expect(data1.hashCode, equals(data2.hashCode));
    });

    test('should handle JSON with missing fields using defaults', () {
      // Arrange
      final json = {
        'name': 'Test User',
        'cigarettesPerDay': 5,
        // Other fields should use defaults
      };

      // Act
      final onboardingData = OnboardingData.fromJson(json);

      // Assert
      expect(onboardingData.name, equals('Test User'));
      expect(onboardingData.cigarettesPerDay, equals(5));
      expect(onboardingData.lastSmokedDate, equals(""));
      expect(onboardingData.costOfAPack, equals(""));
      expect(onboardingData.numberOfCigarettesIn1Pack, equals(-1));
      expect(onboardingData.biggestMotivation, equals([]));
      expect(onboardingData.craveSituations, equals([]));
      expect(onboardingData.helpNeeded, equals([]));
      expect(onboardingData.quitMethod, equals(-1));
    });

    test('should handle empty lists in JSON', () {
      // Arrange
      final json = {
        'lastSmokedDate': '2024-01-15',
        'cigarettesPerDay': 10,
        'costOfAPack': '12.50',
        'numberOfCigarettesIn1Pack': 20,
        'biggestMotivation': [],
        'craveSituations': [],
        'helpNeeded': [],
        'quitMethod': 1,
        'name': 'Test User',
      };

      // Act
      final onboardingData = OnboardingData.fromJson(json);

      // Assert
      expect(onboardingData.biggestMotivation, isEmpty);
      expect(onboardingData.craveSituations, isEmpty);
      expect(onboardingData.helpNeeded, isEmpty);
    });

    test('should handle multiple motivations, situations, and help needs', () {
      // Arrange
      final motivations = [
        'Health benefits',
        'Save Money',
        'Personal challenge',
        'Family & loved ones',
        'Break the addiction'
      ];
      final situations = [
        'Morning with coffee',
        'After meals',
        'When drinking alcohol',
        'When feeling stressed',
        'Boredom or habit'
      ];
      final helpAreas = [
        'Handling cravings & withdrawal',
        'Sticking to my quit plan',
        'Support & motivation',
        'Tracking my progress'
      ];

      // Act
      final onboardingData = OnboardingData(
        biggestMotivation: motivations,
        craveSituations: situations,
        helpNeeded: helpAreas,
      );

      // Assert
      expect(onboardingData.biggestMotivation.length, equals(5));
      expect(onboardingData.craveSituations.length, equals(5));
      expect(onboardingData.helpNeeded.length, equals(4));
      expect(onboardingData.biggestMotivation.contains('Health benefits'), isTrue);
      expect(onboardingData.craveSituations.contains('Morning with coffee'), isTrue);
      expect(onboardingData.helpNeeded.contains('Tracking my progress'), isTrue);
    });

    test('should handle various quit methods', () {
      // Arrange & Act
      final instantQuit = OnboardingData(quitMethod: 1);
      final stepDown = OnboardingData(quitMethod: 2);
      final notSet = OnboardingData(); // Default -1

      // Assert
      expect(instantQuit.quitMethod, equals(1));
      expect(stepDown.quitMethod, equals(2));
      expect(notSet.quitMethod, equals(-1));
    });

    test('should handle edge cases for numeric fields', () {
      // Arrange & Act
      final data = OnboardingData(
        cigarettesPerDay: 0, // Minimum valid value
        numberOfCigarettesIn1Pack: 1, // Minimum pack size
        quitMethod: 0, // Edge case method
      );

      // Assert
      expect(data.cigarettesPerDay, equals(0));
      expect(data.numberOfCigarettesIn1Pack, equals(1));
      expect(data.quitMethod, equals(0));
    });

    test('should handle cost as string with various formats', () {
      // Arrange & Act
      final data1 = OnboardingData(costOfAPack: '10.00');
      final data2 = OnboardingData(costOfAPack: '15.5');
      final data3 = OnboardingData(costOfAPack: '20');

      // Assert
      expect(data1.costOfAPack, equals('10.00'));
      expect(data2.costOfAPack, equals('15.5'));
      expect(data3.costOfAPack, equals('20'));
    });
  });
}
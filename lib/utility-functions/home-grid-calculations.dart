import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

const int minutesRegainedPerCigarette = 11;
const int minutesInDay = 24 * 60;

int getDaysSinceLastSmoked(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData.lastSmokedDate;
  
  // Handle invalid or empty dates
  if (lastSmokedDate.isEmpty) {
    return 0; // No data available, return 0 days
  }
  
  try {
    DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
    DateTime certainDateTime = DateTime(
        selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
    Duration difference = certainDateTime.difference(parsedStoredDate);
    int smokeFreeDays = difference.inDays;
    
    // Ensure we don't return negative days
    return smokeFreeDays > 0 ? smokeFreeDays : 0;
  } catch (e) {
    print('Error parsing last smoked date: $lastSmokedDate - $e');
    return 0; // Return 0 if date parsing fails
  }
}

double getMoneySaved(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData.lastSmokedDate;
  
  // Handle invalid or empty dates
  if (lastSmokedDate.isEmpty) {
    return 0.0; // No data available, return 0
  }
  
  // Handle invalid cigarettes per day
  if (userOnboardingData.cigarettesPerDay <= 0) {
    return 0.0; // Invalid data, return 0
  }
  
  // Handle invalid cost per pack
  if (userOnboardingData.costOfAPack.isEmpty) {
    return 0.0; // No cost data, return 0
  }
  
  // Handle invalid cigarettes per pack
  if (userOnboardingData.numberOfCigarettesIn1Pack <= 0) {
    return 0.0; // Invalid pack size, return 0
  }
  
  try {
    DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
    DateTime certainDateTime = DateTime(
        selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
    Duration difference = certainDateTime.difference(parsedStoredDate);
    int smokeFreeDays = difference.inDays;
    
    // Ensure we don't calculate with negative days
    if (smokeFreeDays <= 0) {
      return 0.0;
    }

    double costOfPack = double.tryParse(userOnboardingData.costOfAPack) ?? 0.0;
    if (costOfPack <= 0) {
      return 0.0; // Invalid cost, return 0
    }
    
    int cigarettesNotSmoked = (smokeFreeDays * userOnboardingData.cigarettesPerDay);
    double costPerCigarette = costOfPack / userOnboardingData.numberOfCigarettesIn1Pack;
    double moneySaved = cigarettesNotSmoked.toDouble() * costPerCigarette;
    
    return moneySaved >= 0 ? moneySaved : 0.0; // Ensure no negative values
  } catch (e) {
    print('Error calculating money saved: $e');
    return 0.0; // Return 0 if calculation fails
  }
}

double getdaysOfLifeRegained(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData.lastSmokedDate;
  
  // Handle invalid or empty dates
  if (lastSmokedDate.isEmpty) {
    return 0.0; // No data available, return 0
  }
  
  // Handle invalid cigarettes per day
  if (userOnboardingData.cigarettesPerDay <= 0) {
    return 0.0; // Invalid data, return 0
  }
  
  try {
    DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
    DateTime certainDateTime = DateTime(
        selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
    Duration difference = certainDateTime.difference(parsedStoredDate);
    int smokeFreeDays = difference.inDays;
    
    // Ensure we don't calculate with negative days
    if (smokeFreeDays <= 0) {
      return 0.0;
    }

    int cigarettesNotSmoked = (smokeFreeDays * userOnboardingData.cigarettesPerDay);
    int totalMinutesRegained = cigarettesNotSmoked * minutesRegainedPerCigarette;
    double daysOfLifeRegained = totalMinutesRegained / minutesInDay;
    
    return daysOfLifeRegained >= 0 ? daysOfLifeRegained : 0.0; // Ensure no negative values
  } catch (e) {
    print('Error calculating life regained: $e');
    return 0.0; // Return 0 if calculation fails
  }
}

int getcigarettesNotSmoked(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData.lastSmokedDate;
  
  // Handle invalid or empty dates
  if (lastSmokedDate.isEmpty) {
    return 0; // No data available, return 0
  }
  
  // Handle invalid cigarettes per day
  if (userOnboardingData.cigarettesPerDay <= 0) {
    return 0; // Invalid data, return 0
  }
  
  try {
    DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
    DateTime certainDateTime = DateTime(
        selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
    Duration difference = certainDateTime.difference(parsedStoredDate);
    int smokeFreeDays = difference.inDays;
    
    // Ensure we don't calculate with negative days
    if (smokeFreeDays <= 0) {
      return 0;
    }

    int totalCigarettesNotSmoked = (smokeFreeDays * userOnboardingData.cigarettesPerDay);
    
    return totalCigarettesNotSmoked >= 0 ? totalCigarettesNotSmoked : 0; // Ensure no negative values
  } catch (e) {
    print('Error calculating cigarettes not smoked: $e');
    return 0; // Return 0 if calculation fails
  }
}

int getWholeDigits(double value) {
  return value < 1
      ? 1
      : value < 9
          ? 1
          : 2;
}

int getFractionDigits(double value) {
  return value < 1 ? 2 : 0;
}
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

  String lastSmokedDate = userOnboardingData?.lastSmokedDate ??
      DateFormat.yMMMd().format(DateTime.now());
  DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
  DateTime certainDateTime = DateTime(
      selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
  Duration difference = certainDateTime.difference(parsedStoredDate);
  int smokeFreeDays = difference.inDays;

  return smokeFreeDays;
}
double getMoneySaved(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData?.lastSmokedDate ??
      DateFormat.yMMMd().format(DateTime.now());
  DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
  DateTime certainDateTime = DateTime(
      selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
  Duration difference = certainDateTime.difference(parsedStoredDate);
  int smokeFreeDays = difference.inDays;

  double costOfPack = double.parse(userOnboardingData.costOfAPack);
  int cigarettesNotSmoked =
      (smokeFreeDays * userOnboardingData.cigarettesPerDay).toInt();
  double costPerCigarette =
      costOfPack / userOnboardingData.numberOfCigarettesIn1Pack;
  double moneySaved = cigarettesNotSmoked.toDouble() * costPerCigarette;
  return moneySaved;
}

double getdaysOfLifeRegained(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData?.lastSmokedDate ??
      DateFormat.yMMMd().format(DateTime.now());
  DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
  DateTime certainDateTime = DateTime(
      selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
  Duration difference = certainDateTime.difference(parsedStoredDate);
  int smokeFreeDays = difference.inDays;

  int cigarettesNotSmoked =
      (smokeFreeDays * userOnboardingData.cigarettesPerDay).toInt();
  int totalMinutesRegained = cigarettesNotSmoked * minutesRegainedPerCigarette;
  double daysOfLifeRegained = totalMinutesRegained / minutesInDay;
  return daysOfLifeRegained;
}

int getcigarettesNotSmoked(DateTime selectedDateTime) {
  final box = Hive.box<OnboardingData>(
      'onboardingCompletedData'); // Specify the type of values in the box
  OnboardingData userOnboardingData =
      box.get('currentUserOnboarding') ?? OnboardingData();

  String lastSmokedDate = userOnboardingData?.lastSmokedDate ??
      DateFormat.yMMMd().format(DateTime.now());
  DateTime parsedStoredDate = DateTime.parse(lastSmokedDate);
  DateTime certainDateTime = DateTime(
      selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
  Duration difference = certainDateTime.difference(parsedStoredDate);
  int smokeFreeDays = difference.inDays;

  int totalCigarettesNotSmoke =
      (smokeFreeDays * userOnboardingData.cigarettesPerDay);
  return totalCigarettesNotSmoke;
}
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/models/mood-usage-model/moodUsage-model.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';

class MoodUsageService {
  static const String _boxName = 'moodUsageData';
  static const String _usageKey = 'moodUsage';
  static const int _freeUsageLimit = 2;

  static Box<MoodUsageModel>? _box;

  static Box<MoodUsageModel> get box {
    _box ??= Hive.box<MoodUsageModel>(_boxName);
    return _box!;
  }

  static MoodUsageModel getMoodUsage() {
    return box.get(_usageKey, defaultValue: MoodUsageModel()) ?? MoodUsageModel();
  }

  static Future<void> saveMoodUsage(MoodUsageModel usage) async {
    await box.put(_usageKey, usage);
  }

  static bool canUseMoodFeature() {
    // Check if user is premium
    final premiumController = Get.find<PremiumController>();
    if (premiumController.isPremium.value) {
      return true;
    }

    // Check existing mood data directly from Hive
    final moodBox = Hive.box<MoodModel>('moodData');
    final allMoodEntries = moodBox.keys.toList();
    final todayDate = DateFormat.yMMMd().format(DateTime.now());
    
    // Count unique days with mood entries
    int uniqueDaysWithMood = 0;
    List<String> daysWithMood = [];
    
    for (var key in allMoodEntries) {
      final moodData = moodBox.get(key);
      if (moodData != null && moodData.selfFeeling.isNotEmpty) {
        uniqueDaysWithMood++;
        daysWithMood.add(key.toString());
      }
    }
    
    // If they've already used it on 2 or more different days
    if (uniqueDaysWithMood >= _freeUsageLimit) {
      // Check if today is one of those days they already used it
      // If yes, allow them to continue using it today
      // If no, block them as they've exhausted their 2-day trial
      return daysWithMood.contains(todayDate);
    }
    
    // They haven't reached the 2-day limit yet, allow usage
    return true;
  }

  static Future<void> recordMoodUsage() async {
    // Don't track for premium users
    final premiumController = Get.find<PremiumController>();
    if (premiumController.isPremium.value) {
      return;
    }

    final usage = getMoodUsage();
    final todayDate = DateFormat.yMMMd().format(DateTime.now());
    
    // Create a new list to avoid modifying frozen object
    List<String> updatedDates = List<String>.from(usage.moodEntryDates);
    
    // Add today's date if not already present
    if (!updatedDates.contains(todayDate)) {
      updatedDates.add(todayDate);
    }

    // Update the usage model
    final updatedUsage = usage.copyWith(
      totalMoodEntries: usage.totalMoodEntries + 1,
      moodEntryDates: updatedDates,
      hasReachedLimit: updatedDates.length >= 2,
      firstUsageDate: usage.firstUsageDate ?? todayDate,
    );

    await saveMoodUsage(updatedUsage);
  }

  static int getRemainingDays() {
    final premiumController = Get.find<PremiumController>();
    if (premiumController.isPremium.value) {
      return -1; // Unlimited for premium users
    }

    final usage = getMoodUsage();
    final uniqueDaysUsed = usage.moodEntryDates.length;
    final remaining = _freeUsageLimit - uniqueDaysUsed;
    return remaining > 0 ? remaining : 0;
  }

  static bool hasUsedTodaysFreeEntry() {
    final usage = getMoodUsage();
    final todayDate = DateFormat.yMMMd().format(DateTime.now());
    return usage.moodEntryDates.contains(todayDate);
  }

  static void resetUsageForTesting() {
    // Only for testing purposes
    box.delete(_usageKey);
  }

  static void debugPrintUsage() {
    final usage = getMoodUsage();
    print('🐛 DEBUG Mood Usage:');
    print('   - Total entries: ${usage.totalMoodEntries}');
    print('   - Unique days used: ${usage.moodEntryDates.length}');
    print('   - Days: ${usage.moodEntryDates}');
    print('   - Has reached limit: ${usage.hasReachedLimit}');
    print('   - Can use mood feature: ${canUseMoodFeature()}');
    print('   - Remaining days: ${getRemainingDays()}');
  }
}
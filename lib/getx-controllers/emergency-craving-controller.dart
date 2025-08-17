import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/exercise_model.dart';
import '../models/onboarding-data/onboardingData-model.dart';
import '../utility-functions/home-grid-calculations.dart';
import '../extensions/app_localizations_extension.dart';
import 'app-preferences-controller.dart';

class EmergencyCravingController extends GetxController {
  final Random _random = Random();
  String? _lastShownMessageId;
  ExerciseModel? _currentExercise;
  
  // Quick craving-busting exercises (under 3 minutes, Phase 1 priority)
  final List<String> _cravingExerciseIds = [
    '1', // 4-7-8 Breathing (2-3 min)
    '2', // Cold Water Shock (60 sec)
    '3', // 3-Minute Rule (3 min)
    '4', // 5-4-3-2-1 Grounding (2-3 min)
    '7', // Finger Pressure Points (60 sec)
    '8', // Rapid distraction (60 sec)
    '9', // Stop-Drop-Roll (30 sec)
    '12', // Hand Warming (1 min)
  ];
  
  Map<String, dynamic> getRandomMotivation(BuildContext context) {
    final hour = DateTime.now().hour;
    final isEvening = hour >= 18 || hour < 6;
    
    final onboardingBox = Hive.box<OnboardingData>('onboardingCompletedData');
    final userData = onboardingBox.get('currentUserOnboarding') ?? OnboardingData();
    
    // Calculate user's progress
    final daysSinceStopped = getDaysSinceLastSmoked(DateTime.now());
    final moneySaved = getMoneySaved(DateTime.now());
    final cigarettesAvoided = getcigarettesNotSmoked(DateTime.now());
    
    final messages = _buildMotivationMessages(
      context: context,
      userData: userData,
      daysSinceStopped: daysSinceStopped,
      moneySaved: moneySaved,
      cigarettesAvoided: cigarettesAvoided,
      isEvening: isEvening,
    );
    
    // Filter out the last shown message
    final availableMessages = messages.where((msg) => msg['id'] != _lastShownMessageId).toList();
    
    if (availableMessages.isEmpty) {
      // Reset if all messages have been shown
      _lastShownMessageId = null;
      return messages[_random.nextInt(messages.length)];
    }
    
    final selectedMessage = availableMessages[_random.nextInt(availableMessages.length)];
    _lastShownMessageId = selectedMessage['id'];
    
    return selectedMessage;
  }
  
  List<Map<String, dynamic>> _buildMotivationMessages({
    required BuildContext context,
    required OnboardingData userData,
    required int daysSinceStopped,
    required double moneySaved,
    required int cigarettesAvoided,
    required bool isEvening,
  }) {
    final currencySymbol = Get.find<AppPreferencesController>().currencySymbol;
    final yearlyMoneySaved = moneySaved * (365 / max(daysSinceStopped, 1));
    
    return [
      // Immediate Empowerment
      {
        'id': 'emp1',
        'category': 'empowerment',
        'message': context.l10n.emergency_motivation_emp1_message,
        'detail': context.l10n.emergency_motivation_emp1_detail,
      },
      {
        'id': 'emp2',
        'category': 'empowerment',
        'message': context.l10n.emergency_motivation_emp2_message,
        'detail': context.l10n.emergency_motivation_emp2_detail,
      },
      {
        'id': 'emp3',
        'category': 'empowerment',
        'message': context.l10n.emergency_motivation_emp3_message,
        'detail': context.l10n.emergency_motivation_emp3_detail,
      },
      if (cigarettesAvoided > 0)
        {
          'id': 'emp4',
          'category': 'empowerment',
          'message': context.l10n.emergency_motivation_emp4_message(cigarettesAvoided),
          'detail': context.l10n.emergency_motivation_emp4_detail,
        },
      {
        'id': 'emp5',
        'category': 'empowerment',
        'message': context.l10n.emergency_motivation_emp5_message,
        'detail': context.l10n.emergency_motivation_emp5_detail,
      },
      
      // Time-Based Reality Checks
      {
        'id': 'time1',
        'category': 'time',
        'message': context.l10n.emergency_motivation_time1_message,
        'detail': context.l10n.emergency_motivation_time1_detail,
      },
      {
        'id': 'time2',
        'category': 'time',
        'message': context.l10n.emergency_motivation_time2_message,
        'detail': context.l10n.emergency_motivation_time2_detail,
      },
      {
        'id': 'time3',
        'category': 'time',
        'message': context.l10n.emergency_motivation_time3_message,
        'detail': context.l10n.emergency_motivation_time3_detail,
      },
      if (daysSinceStopped > 0)
        {
          'id': 'time4',
          'category': 'time',
          'message': context.l10n.emergency_motivation_time4_message(daysSinceStopped),
          'detail': context.l10n.emergency_motivation_time4_detail,
        },
      
      // Financial Motivation
      if (moneySaved > 0)
        {
          'id': 'money1',
          'category': 'money',
          'message': context.l10n.emergency_motivation_money1_message(currencySymbol, moneySaved.toStringAsFixed(0)),
          'detail': context.l10n.emergency_motivation_money1_detail,
        },
      {
        'id': 'money2',
        'category': 'money',
        'message': context.l10n.emergency_motivation_money2_message,
        'detail': context.l10n.emergency_motivation_money2_detail,
      },
      if (yearlyMoneySaved > 0)
        {
          'id': 'money3',
          'category': 'money',
          'message': context.l10n.emergency_motivation_money3_message(currencySymbol, yearlyMoneySaved.toStringAsFixed(0)),
          'detail': context.l10n.emergency_motivation_money3_detail,
        },
      
      // Personal Connection
      if (userData.name.isNotEmpty)
        {
          'id': 'personal1',
          'category': 'personal',
          'message': context.l10n.emergency_motivation_personal1_message(userData.name.split(' ')[0]),
          'detail': context.l10n.emergency_motivation_personal1_detail,
        },
      {
        'id': 'personal2',
        'category': 'personal',
        'message': context.l10n.emergency_motivation_personal2_message,
        'detail': context.l10n.emergency_motivation_personal2_detail,
      },
      {
        'id': 'personal3',
        'category': 'personal',
        'message': context.l10n.emergency_motivation_personal3_message,
        'detail': context.l10n.emergency_motivation_personal3_detail,
      },
      {
        'id': 'personal4',
        'category': 'personal',
        'message': context.l10n.emergency_motivation_personal4_message,
        'detail': context.l10n.emergency_motivation_personal4_detail,
      },
      
      // Time-specific messages
      if (isEvening)
        {
          'id': 'evening1',
          'category': 'time',
          'message': context.l10n.emergency_motivation_evening1_message,
          'detail': context.l10n.emergency_motivation_evening1_detail,
        }
      else
        {
          'id': 'morning1',
          'category': 'time',
          'message': context.l10n.emergency_motivation_morning1_message,
          'detail': context.l10n.emergency_motivation_morning1_detail,
        },
    ];
  }
  
  String getEmojiForCategory(String category) {
    switch (category) {
      case 'empowerment':
        return '💪';
      case 'time':
        return '🕙';
      case 'money':
        return '💳';
      case 'personal':
        return '❤️';
      default:
        return '🌟';
    }
  }
  
  ExerciseModel getRandomCravingExercise() {
    if (_currentExercise != null) {
      return _currentExercise!;
    }
    
    final exerciseId = _cravingExerciseIds[_random.nextInt(_cravingExerciseIds.length)];
    _currentExercise = allExercises.firstWhere(
      (exercise) => exercise.id == exerciseId,
      orElse: () => allExercises[0],
    );
    
    return _currentExercise!;
  }
  
  void refreshRandomExercise() {
    // Get a different exercise
    ExerciseModel newExercise;
    do {
      final exerciseId = _cravingExerciseIds[_random.nextInt(_cravingExerciseIds.length)];
      newExercise = allExercises.firstWhere(
        (exercise) => exercise.id == exerciseId,
        orElse: () => allExercises[0],
      );
    } while (newExercise.id == _currentExercise?.id && _cravingExerciseIds.length > 1);
    
    _currentExercise = newExercise;
    update();
  }
  
  @override
  void onClose() {
    _currentExercise = null;
    super.onClose();
  }
}
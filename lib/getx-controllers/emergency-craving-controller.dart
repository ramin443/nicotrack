import 'dart:math';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/exercise_model.dart';
import '../models/onboarding-data/onboardingData-model.dart';
import '../utility-functions/home-grid-calculations.dart';
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
  
  Map<String, dynamic> getRandomMotivation() {
    final hour = DateTime.now().hour;
    final isEvening = hour >= 18 || hour < 6;
    
    final onboardingBox = Hive.box<OnboardingData>('onboardingCompletedData');
    final userData = onboardingBox.get('currentUserOnboarding') ?? OnboardingData();
    
    // Calculate user's progress
    final daysSinceStopped = getDaysSinceLastSmoked(DateTime.now());
    final moneySaved = getMoneySaved(DateTime.now());
    final cigarettesAvoided = getcigarettesNotSmoked(DateTime.now());
    
    final messages = _buildMotivationMessages(
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
        'message': 'You are stronger than this craving!',
        'detail': 'It will pass in just 3-5 minutes. You\'ve got this!',
      },
      {
        'id': 'emp2',
        'category': 'empowerment',
        'message': 'Every "NO" to smoking is a "YES" to your health',
        'detail': 'This moment defines your strength.',
      },
      {
        'id': 'emp3',
        'category': 'empowerment',
        'message': 'This discomfort is your strength building',
        'detail': 'Each craving you beat makes you more powerful.',
      },
      if (cigarettesAvoided > 0)
        {
          'id': 'emp4',
          'category': 'empowerment',
          'message': 'You\'ve already beaten $cigarettesAvoided cravings!',
          'detail': 'You\'re a champion - one more won\'t defeat you.',
        },
      {
        'id': 'emp5',
        'category': 'empowerment',
        'message': 'Right now, your lungs are healing',
        'detail': 'Your body is thanking you for staying strong.',
      },
      
      // Time-Based Reality Checks
      {
        'id': 'time1',
        'category': 'time',
        'message': 'In 20 minutes, your heart rate improves',
        'detail': 'Blood pressure drops to normal levels.',
      },
      {
        'id': 'time2',
        'category': 'time',
        'message': 'In 12 hours, carbon monoxide normalizes',
        'detail': 'Your blood oxygen is returning to healthy levels.',
      },
      {
        'id': 'time3',
        'category': 'time',
        'message': 'In 2 weeks, circulation improves dramatically',
        'detail': 'Lung function increases by up to 30%.',
      },
      if (daysSinceStopped > 0)
        {
          'id': 'time4',
          'category': 'time',
          'message': 'You\'re $daysSinceStopped days smoke-free!',
          'detail': 'Don\'t reset that amazing progress now.',
        },
      
      // Financial Motivation
      if (moneySaved > 0)
        {
          'id': 'money1',
          'category': 'money',
          'message': 'You\'ve saved $currencySymbol${moneySaved.toStringAsFixed(0)}!',
          'detail': 'Don\'t waste it by giving in now.',
        },
      {
        'id': 'money2',
        'category': 'money',
        'message': 'This craving costs money if you give in',
        'detail': 'Keep your hard-earned cash in your pocket.',
      },
      if (yearlyMoneySaved > 0)
        {
          'id': 'money3',
          'category': 'money',
          'message': 'You\'ll save $currencySymbol${yearlyMoneySaved.toStringAsFixed(0)} this year!',
          'detail': 'Stay strong and watch your savings grow.',
        },
      
      // Personal Connection
      if (userData.name.isNotEmpty)
        {
          'id': 'personal1',
          'category': 'personal',
          'message': 'Remember why you started, ${userData.name.split(' ')[0]}',
          'detail': 'Your future self will thank you.',
        },
      {
        'id': 'personal2',
        'category': 'personal',
        'message': 'Your loved ones believe in you',
        'detail': 'You can do this - they\'re counting on you.',
      },
      {
        'id': 'personal3',
        'category': 'personal',
        'message': 'Future you will be grateful',
        'detail': 'Every craving you beat is a gift to yourself.',
      },
      {
        'id': 'personal4',
        'category': 'personal',
        'message': 'You\'re setting an amazing example',
        'detail': 'Your strength inspires others around you.',
      },
      
      // Time-specific messages
      if (isEvening)
        {
          'id': 'evening1',
          'category': 'time',
          'message': 'End your day with a victory',
          'detail': 'Go to bed proud of staying smoke-free.',
        }
      else
        {
          'id': 'morning1',
          'category': 'time',
          'message': 'Start your day with strength',
          'detail': 'Set the tone for a smoke-free day.',
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
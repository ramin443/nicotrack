import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase Analytics instance (lazy initialization)
  FirebaseAnalytics? _analytics;
  FirebaseFirestore? _firestore;
  FirebaseAnalyticsObserver? _analyticsObserver;

  // Check if Firebase is initialized
  bool get isInitialized => _analytics != null;

  // Initialize Firebase services
  void initialize() {
    _analytics = FirebaseAnalytics.instance;
    _firestore = FirebaseFirestore.instance;
    _analyticsObserver = FirebaseAnalyticsObserver(analytics: _analytics!);
  }

  // Analytics getters (safe)
  FirebaseAnalytics get analytics {
    if (_analytics == null) {
      throw StateError('Firebase not initialized. Call FirebaseService().initialize() first.');
    }
    return _analytics!;
  }
  
  FirebaseAnalyticsObserver get analyticsObserver {
    if (_analyticsObserver == null) {
      throw StateError('Firebase not initialized. Call FirebaseService().initialize() first.');
    }
    return _analyticsObserver!;
  }

  // Firestore getter (safe)
  FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw StateError('Firebase not initialized. Call FirebaseService().initialize() first.');
    }
    return _firestore!;
  }

  // Analytics methods (safe)
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!isInitialized) {
      print('⚠️ Firebase not initialized, skipping event: $name');
      return;
    }
    
    // Debug print to help track events
    print('🔥 Firebase Analytics Event: $name');
    if (parameters != null && parameters.isNotEmpty) {
      print('📊 Parameters: $parameters');
    } else {
      print('📊 Parameters: (no parameters)');
    }
    
    await _analytics!.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> setUserId(String? id) async {
    if (!isInitialized) return;
    await _analytics!.setUserId(id: id);
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!isInitialized) return;
    await _analytics!.setUserProperty(name: name, value: value);
  }

  // Note: setCurrentScreen is deprecated in newer Firebase Analytics versions
  // Screen tracking is now handled automatically by FirebaseAnalyticsObserver

  // Common analytics events for your app
  Future<void> logAppOpen() async {
    await logEvent(
      name: 'app_open',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'flutter',
      },
    );
  }
  
  // Test method to verify analytics are working
  Future<void> logTestEvent() async {
    await logEvent(
      name: 'test_analytics_working',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
        'test_parameter': 'analytics_test',
        'app_version': '1.0.0',
      },
    );
  }

  Future<void> logQuitSmoking({
    required DateTime quitDate,
    String? method,
  }) async {
    await logEvent(
      name: 'quit_smoking',
      parameters: {
        'quit_date': quitDate.toIso8601String(),
        if (method != null) 'quit_method': method,
      },
    );
  }

  Future<void> logMilestoneReached({
    required int dayNumber,
    required String milestone,
  }) async {
    await logEvent(
      name: 'milestone_reached',
      parameters: {
        'day_number': dayNumber,
        'milestone': milestone,
      },
    );
  }

  Future<void> logMoodTracked({
    required String mood,
    required int daysSinceQuit,
  }) async {
    await logEvent(
      name: 'mood_tracked',
      parameters: {
        'mood': mood,
        'days_since_quit': daysSinceQuit,
      },
    );
  }

  Future<void> logSmokeEvent({
    required bool didSmoke,
    required int daysSinceQuit,
  }) async {
    await logEvent(
      name: 'smoke_event',
      parameters: {
        'did_smoke': didSmoke.toString(),
        'days_since_quit': daysSinceQuit,
      },
    );
  }

  Future<void> logPremiumPurchase({
    required String productId,
    required double price,
    required String currency,
  }) async {
    await logEvent(
      name: 'premium_purchase',
      parameters: {
        'product_id': productId,
        'price': price,
        'currency': currency,
      },
    );
  }

  // Onboarding events
  Future<void> logOnboardingStepCompleted({
    required int stepNumber,
    required String stepName,
  }) async {
    await logEvent(
      name: 'onboarding_step_completed',
      parameters: {
        'step_number': stepNumber,
        'step_name': stepName,
      },
    );
  }

  Future<void> logOnboardingCompleted({
    required String lastSmokedDate,
    required int cigarettesPerDay,
    required String costPerPack,
    required List<String> motivations,
    required List<String> craveSituations,
    required List<String> helpNeeded,
    required String userName,
  }) async {
    await logEvent(
      name: 'onboarding_completed',
      parameters: {
        'last_smoked_date': lastSmokedDate,
        'cigarettes_per_day': cigarettesPerDay,
        'cost_per_pack': costPerPack,
        'motivations_count': motivations.length,
        'crave_situations_count': craveSituations.length,
        'help_needed_count': helpNeeded.length,
        'user_name_provided': userName.isNotEmpty.toString(),
      },
    );
  }

  // Daily tracking events
  Future<void> logQuickActionToggled({
    required int actionNumber,
    required String actionText,
    required bool completed,
  }) async {
    await logEvent(
      name: 'quick_action_toggled',
      parameters: {
        'action_number': actionNumber,
        'action_text': actionText,
        'completed': completed.toString(),
      },
    );
  }

  Future<void> logSmokingSessionCompleted({
    required bool smokedToday,
    required int cigaretteCount,
    required bool quitDateUpdated,
    List<String>? triggers,
    List<String>? feelings,
    List<String>? avoidanceStrategies,
  }) async {
    await logEvent(
      name: 'smoking_session_completed',
      parameters: {
        'smoked_today': smokedToday.toString(),
        'cigarette_count': cigaretteCount,
        'quit_date_updated': quitDateUpdated.toString(),
        'triggers_count': triggers?.length ?? 0,
        'feelings_count': feelings?.length ?? 0,
        'avoidance_strategies_count': avoidanceStrategies?.length ?? 0,
      },
    );
  }

  Future<void> logMoodSessionCompleted({
    required String feeling,
    required int affectingFactorsCount,
    required String cravingIntensity,
    required bool hasReflection,
    required int cravingTimesCount,
  }) async {
    await logEvent(
      name: 'mood_session_completed',
      parameters: {
        'feeling': feeling,
        'affecting_factors_count': affectingFactorsCount,
        'craving_intensity': cravingIntensity,
        'has_reflection': hasReflection.toString(),
        'craving_times_count': cravingTimesCount,
      },
    );
  }

  // Premium events
  Future<void> logPremiumPlanSelected({
    required int planIndex,
    required String planType,
    required String planPrice,
  }) async {
    await logEvent(
      name: 'premium_plan_selected',
      parameters: {
        'plan_index': planIndex,
        'plan_type': planType,
        'plan_price': planPrice,
      },
    );
  }

  Future<void> logPremiumPurchaseAttempted({
    required String planType,
    required int planIndex,
  }) async {
    await logEvent(
      name: 'premium_purchase_attempted',
      parameters: {
        'plan_type': planType,
        'plan_index': planIndex,
      },
    );
  }

  // Progress events
  Future<void> logProgressTabViewed({
    required int tabIndex,
    required String tabName,
  }) async {
    await logEvent(
      name: 'progress_tab_viewed',
      parameters: {
        'tab_index': tabIndex,
        'tab_name': tabName,
      },
    );
  }

  Future<void> logFinancialGoalCreated({
    required String emoji,
    required String goalTitle,
    required String cost,
  }) async {
    await logEvent(
      name: 'financial_goal_created',
      parameters: {
        'emoji': emoji,
        'goal_title': goalTitle,
        'cost': cost,
      },
    );
  }

  // Daily task events
  Future<void> logDailyTaskAccessed({
    required String taskType,
    required bool taskCompleted,
    required bool isPremiumRequired,
  }) async {
    await logEvent(
      name: 'daily_task_accessed',
      parameters: {
        'task_type': taskType,
        'task_completed': taskCompleted.toString(),
        'is_premium_required': isPremiumRequired.toString(),
      },
    );
  }

  // Settings events
  Future<void> logSettingsChanged({
    required String settingType,
    required String newValue,
  }) async {
    await logEvent(
      name: 'settings_changed',
      parameters: {
        'setting_type': settingType,
        'new_value': newValue,
      },
    );
  }

  // Firestore methods for user data
  Future<void> saveUserData({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    if (!isInitialized) return;
    await _firestore!.collection('users').doc(userId).set(
      userData,
      SetOptions(merge: true),
    );
  }

  Future<DocumentSnapshot?> getUserData(String userId) async {
    if (!isInitialized) return null;
    return await _firestore!.collection('users').doc(userId).get();
  }

  Future<void> saveQuitSession({
    required String userId,
    required Map<String, dynamic> sessionData,
  }) async {
    if (!isInitialized) return;
    await _firestore!
        .collection('users')
        .doc(userId)
        .collection('quit_sessions')
        .add(sessionData);
  }

  Future<void> saveMoodEntry({
    required String userId,
    required Map<String, dynamic> moodData,
  }) async {
    if (!isInitialized) return;
    await _firestore!
        .collection('users')
        .doc(userId)
        .collection('mood_entries')
        .add(moodData);
  }

  Future<void> saveSmokeEntry({
    required String userId,
    required Map<String, dynamic> smokeData,
  }) async {
    if (!isInitialized) return;
    await _firestore!
        .collection('users')
        .doc(userId)
        .collection('smoke_entries')
        .add(smokeData);
  }

  // Query methods
  Stream<QuerySnapshot>? getUserMoodEntries(String userId) {
    if (!isInitialized) return null;
    return _firestore!
        .collection('users')
        .doc(userId)
        .collection('mood_entries')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot>? getUserSmokeEntries(String userId) {
    if (!isInitialized) return null;
    return _firestore!
        .collection('users')
        .doc(userId)
        .collection('smoke_entries')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Contact Support and Feedback methods
  Future<void> saveContactSupport({
    required String userId,
    required String email,
    required String details,
    required String deviceInfo,
    required String appVersion,
  }) async {
    if (!isInitialized) return;
    
    final supportData = {
      'email': email,
      'details': details,
      'device_info': deviceInfo,
      'app_version': appVersion,
      'timestamp': FieldValue.serverTimestamp(),
      'created_at': DateTime.now().toIso8601String(),
      'status': 'new',
      'priority': _calculateSupportPriority(details),
      'category': _categorizeSupportRequest(details),
      'user_id': userId,
      'platform': 'flutter_ios',
    };

    await _firestore!
        .collection('contact_support')
        .add(supportData);
  }

  Future<void> saveFeedback({
    required String userId,
    required String feedback,
    required int rating,
    required String feedbackType,
    required String deviceInfo,
    required String appVersion,
    Map<String, dynamic>? userContext,
  }) async {
    if (!isInitialized) return;
    
    final feedbackData = {
      'feedback': feedback,
      'rating': rating,
      'feedback_type': feedbackType,
      'device_info': deviceInfo,
      'app_version': appVersion,
      'timestamp': FieldValue.serverTimestamp(),
      'created_at': DateTime.now().toIso8601String(),
      'user_id': userId,
      'platform': 'flutter_ios',
      'sentiment': _analyzeFeedbackSentiment(feedback),
      'word_count': feedback.split(' ').length,
      'user_context': userContext ?? {},
    };

    await _firestore!
        .collection('feedback')
        .add(feedbackData);
  }

  // Helper methods for categorization and analysis
  String _calculateSupportPriority(String details) {
    final urgentKeywords = ['crash', 'bug', 'error', 'broken', 'not working', 'urgent', 'critical'];
    final mediumKeywords = ['slow', 'issue', 'problem', 'feature request'];
    
    final lowerDetails = details.toLowerCase();
    
    if (urgentKeywords.any((keyword) => lowerDetails.contains(keyword))) {
      return 'high';
    } else if (mediumKeywords.any((keyword) => lowerDetails.contains(keyword))) {
      return 'medium';
    }
    return 'low';
  }

  String _categorizeSupportRequest(String details) {
    final lowerDetails = details.toLowerCase();
    
    final categories = {
      'technical': ['crash', 'bug', 'error', 'not working', 'broken', 'slow'],
      'account': ['login', 'account', 'password', 'premium', 'subscription'],
      'feature': ['feature', 'request', 'suggestion', 'add', 'new'],
      'data': ['sync', 'lost', 'missing', 'backup', 'restore'],
      'payment': ['payment', 'billing', 'refund', 'purchase', 'charged'],
    };
    
    for (final category in categories.keys) {
      if (categories[category]!.any((keyword) => lowerDetails.contains(keyword))) {
        return category;
      }
    }
    
    return 'general';
  }

  String _analyzeFeedbackSentiment(String feedback) {
    final positiveKeywords = ['great', 'love', 'amazing', 'excellent', 'good', 'helpful', 'awesome', 'fantastic'];
    final negativeKeywords = ['hate', 'bad', 'terrible', 'awful', 'worst', 'useless', 'annoying', 'frustrating'];
    
    final lowerFeedback = feedback.toLowerCase();
    
    final positiveCount = positiveKeywords.where((keyword) => lowerFeedback.contains(keyword)).length;
    final negativeCount = negativeKeywords.where((keyword) => lowerFeedback.contains(keyword)).length;
    
    if (positiveCount > negativeCount) return 'positive';
    if (negativeCount > positiveCount) return 'negative';
    return 'neutral';
  }

  // Query methods for admin dashboard
  Stream<QuerySnapshot>? getAllContactSupport() {
    if (!isInitialized) return null;
    return _firestore!
        .collection('contact_support')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot>? getAllFeedback() {
    if (!isInitialized) return null;
    return _firestore!
        .collection('feedback')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot>? getContactSupportByStatus(String status) {
    if (!isInitialized) return null;
    return _firestore!
        .collection('contact_support')
        .where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot>? getFeedbackByRating(int minRating) {
    if (!isInitialized) return null;
    return _firestore!
        .collection('feedback')
        .where('rating', isGreaterThanOrEqualTo: minRating)
        .orderBy('rating', descending: true)
        .snapshots();
  }

  // Helper method to get device and app info
  Future<Map<String, String>> getDeviceAndAppInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      
      String deviceModel = 'Unknown';
      String osVersion = 'Unknown';
      String platform = 'Unknown';
      
      if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = '${iosInfo.name} ${iosInfo.model}';
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        platform = 'iOS';
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        osVersion = 'Android ${androidInfo.version.release}';
        platform = 'Android';
      }
      
      return {
        'device_model': deviceModel,
        'os_version': osVersion,
        'platform': platform,
        'app_version': packageInfo.version,
        'app_build': packageInfo.buildNumber,
        'app_name': packageInfo.appName,
      };
    } catch (e) {
      return {
        'device_model': 'Unknown',
        'os_version': 'Unknown', 
        'platform': Platform.isIOS ? 'iOS' : 'Android',
        'app_version': '1.0.0',
        'app_build': '1',
        'app_name': 'Nicotrack',
      };
    }
  }
}
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isInitialized = false;

  // Notification IDs
  static const int morningNotificationId = 1;
  static const int eveningNotificationId = 2;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to appropriate screen
    if (response.id == morningNotificationId) {
      // Navigate to mood logging screen
      Get.toNamed('/mood'); // Adjust route as needed
    } else if (response.id == eveningNotificationId) {
      // Navigate to mood/smoke logging screen
      Get.toNamed('/mood'); // Adjust route as needed
    }
  }


  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  Future<bool> areNotificationsEnabled() async {
    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      
      if (iosImplementation != null) {
        final NotificationsEnabledOptions? permissions = 
            await iosImplementation.checkPermissions();
        return permissions?.isEnabled ?? false;
      }
      return false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      final bool? granted = await androidImplementation?.areNotificationsEnabled();
      return granted ?? false;
    }
    return false;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'nicotrack_reminders',
      'Nicotrack Reminders',
      channelDescription: 'Reminders for your quit smoking journey',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'nicotrack_daily_reminders',
      'Daily Reminders',
      channelDescription: 'Daily reminders for your quit smoking journey',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleDefaultDailyNotifications() async {
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 Notifications not enabled, skipping scheduling');
      return;
    }

    // Schedule morning notification at 8:00 AM
    await scheduleDailyNotification(
      id: morningNotificationId,
      title: '🌅 Good Morning!',
      body: 'How are you feeling today? Log your mood and start your smoke-free day strong! 💪',
      hour: 8,
      minute: 0,
    );

    // Schedule evening notification at 8:00 PM
    await scheduleDailyNotification(
      id: eveningNotificationId,
      title: '🌙 Evening Check-in',
      body: 'Did you smoke today? Track your progress and log your mood. You\'re doing great! 🎉',
      hour: 20,
      minute: 0,
    );

    print('🔔 Default daily notifications scheduled (8:00 AM & 8:00 PM)');
  }

  Future<void> updateMorningNotificationTime(int hour, int minute) async {
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 Notifications not enabled, cannot update morning notification time');
      return;
    }

    // Cancel existing morning notification
    await flutterLocalNotificationsPlugin.cancel(morningNotificationId);

    // Schedule new morning notification with updated time
    await scheduleDailyNotification(
      id: morningNotificationId,
      title: '🌅 Good Morning!',
      body: 'How are you feeling today? Log your mood and start your smoke-free day strong! 💪',
      hour: hour,
      minute: minute,
    );

    print('🔔 Updated morning notification time to $hour:${minute.toString().padLeft(2, '0')}');
  }

  Future<void> updateEveningNotificationTime(int hour, int minute) async {
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 Notifications not enabled, cannot update evening notification time');
      return;
    }

    // Cancel existing evening notification
    await flutterLocalNotificationsPlugin.cancel(eveningNotificationId);

    // Schedule new evening notification with updated time
    await scheduleDailyNotification(
      id: eveningNotificationId,
      title: '🌙 Evening Check-in',
      body: 'Did you smoke today? Track your progress and log your mood. You\'re doing great! 🎉',
      hour: hour,
      minute: minute,
    );

    print('🔔 Updated evening notification time to $hour:${minute.toString().padLeft(2, '0')}');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('🔔 All notifications cancelled');
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Check and request permissions, then schedule notifications if granted
  Future<void> checkPermissionsAndScheduleNotifications() async {
    final bool currentlyEnabled = await areNotificationsEnabled();
    
    if (currentlyEnabled) {
      print('🔔 Notifications already enabled, scheduling default notifications');
      await scheduleDefaultDailyNotifications();
      await debugPendingNotifications();
    } else {
      print('🔔 Notifications not enabled, not scheduling any notifications');
      // Don't request permissions automatically - let user do it through settings
    }
  }

  // Debug method to check pending notifications
  Future<void> debugPendingNotifications() async {
    final List<PendingNotificationRequest> pending = await getPendingNotifications();
    print('🔔 DEBUG: ${pending.length} pending notifications:');
    for (final notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }

  // Test immediate notification (for debugging)
  Future<void> scheduleTestNotification() async {
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 Notifications not enabled, cannot schedule test notification');
      return;
    }

    try {
      await showNotification(
        id: 999,
        title: '🧪 Test Notification',
        body: 'This is a test notification sent immediately!',
      );
      print('🔔 Test notification sent immediately');
    } catch (e) {
      print('🔔 ERROR sending test notification: $e');
    }
  }

  // Schedule notification for a few seconds later (better for testing)
  Future<void> scheduleTestNotificationDelayed() async {
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 Notifications not enabled, cannot schedule delayed test notification');
      return;
    }

    try {
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = now.add(Duration(seconds: 5));
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        997,
        '🧪 5-Second Test',
        'This notification was scheduled 5 seconds ago!',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_notifications',
            'Test Notifications',
            channelDescription: 'Test notifications for debugging',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'default.caf',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      print('🔔 Scheduled test notification for 5 seconds from now: ${scheduledTime.toString()}');
    } catch (e) {
      print('🔔 ERROR scheduling delayed test notification: $e');
    }
  }
}
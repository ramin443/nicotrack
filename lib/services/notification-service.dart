import 'dart:io';
import 'package:flutter/foundation.dart';
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
    
    // Set local timezone - use system default
    try {
      // Get the local timezone
      final String timeZoneName = DateTime.now().timeZoneName;
      print('🔔 System timezone name: $timeZoneName');
      
      // For iOS simulator/device, timeZoneName might be an abbreviation like "PST", "EST", etc.
      // We need to map these to proper timezone identifiers
      String? locationName;
      
      // Try common timezone mappings
      switch (timeZoneName) {
        case 'PST':
        case 'PDT':
          locationName = 'America/Los_Angeles';
          break;
        case 'EST':
        case 'EDT':
          locationName = 'America/New_York';
          break;
        case 'CST':
        case 'CDT':
          locationName = 'America/Chicago';
          break;
        case 'MST':
        case 'MDT':
          locationName = 'America/Denver';
          break;
        case 'GMT':
        case 'UTC':
          locationName = 'UTC';
          break;
        case 'BST':
          locationName = 'Europe/London';
          break;
        case 'CET':
        case 'CEST':
          locationName = 'Europe/Berlin';
          break;
        default:
          // If we can't map it, we'll use UTC offset approach
          locationName = null;
      }
      
      if (locationName != null) {
        tz.setLocalLocation(tz.getLocation(locationName));
        print('🔔 Timezone set to: $locationName');
      } else {
        // Fallback: Use UTC offset
        final now = DateTime.now();
        final offset = now.timeZoneOffset;
        print('🔔 Using UTC offset: ${offset.inHours} hours');
        // Note: This is a limitation - we can't perfectly set timezone without proper detection
      }
    } catch (e) {
      print('🔔 Error setting timezone: $e, notifications will use device local time');
    }

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

  // Check Android exact alarm permissions
  Future<bool> checkAndRequestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? canScheduleExactNotifications = await androidImplementation.canScheduleExactNotifications();
        
        if (canScheduleExactNotifications == false) {
          print('🔔 WARNING: App cannot schedule exact notifications on Android');
          // Note: We can't automatically request this permission, user must grant it manually
          return false;
        }
        
        return canScheduleExactNotifications ?? true;
      }
    } catch (e) {
      print('🔔 Error checking exact alarm permissions: $e');
    }
    
    return true; // Assume it's fine if we can't check
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    print('🔔 DEBUG scheduleDailyNotification: $title at $hour:${minute.toString().padLeft(2, '0')}');
    
    // Check Android exact alarm permissions
    final canScheduleExact = await checkAndRequestExactAlarmPermission();
    if (!canScheduleExact) {
      print('🔔 ERROR: Cannot schedule exact notifications - permission denied');
      return;
    }
    
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

    try {
      final scheduledTime = _nextInstanceOfTime(hour, minute);
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      
      print('🔔 ✅ Successfully scheduled notification ID $id for ${scheduledTime.toString()}');
      
    } catch (e) {
      print('🔔 ERROR scheduling notification: $e');
    }
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
    print('🔔 DEBUG updateMorningNotificationTime called with: $hour:${minute.toString().padLeft(2, '0')}');
    
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 ERROR: Notifications not enabled, cannot update morning notification time');
      return;
    }

    // Validate time parameters
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      print('🔔 ERROR: Invalid time parameters - hour: $hour, minute: $minute');
      return;
    }

    try {
      // Cancel existing morning notification
      await flutterLocalNotificationsPlugin.cancel(morningNotificationId);
      print('🔔 Cancelled existing morning notification (ID: $morningNotificationId)');

      // Schedule new morning notification with updated time
      await scheduleDailyNotification(
        id: morningNotificationId,
        title: '🌅 Good Morning!',
        body: 'How are you feeling today? Log your mood and start your smoke-free day strong! 💪',
        hour: hour,
        minute: minute,
      );

      // Verify the notification was scheduled
      final pendingNotifications = await getPendingNotifications();
      final morningNotification = pendingNotifications.where((n) => n.id == morningNotificationId).toList();
      
      if (morningNotification.isNotEmpty) {
        print('🔔 ✅ SUCCESS: Morning notification updated to $hour:${minute.toString().padLeft(2, '0')}');
      } else {
        print('🔔 ❌ WARNING: Morning notification may not have been scheduled properly');
      }
      
      // Debug: Show all pending notifications
      await debugPendingNotifications();
      
    } catch (e) {
      print('🔔 ERROR updating morning notification: $e');
    }
  }

  Future<void> updateEveningNotificationTime(int hour, int minute) async {
    print('🔔 DEBUG updateEveningNotificationTime called with: $hour:${minute.toString().padLeft(2, '0')}');
    
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 ERROR: Notifications not enabled, cannot update evening notification time');
      return;
    }

    // Validate time parameters
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      print('🔔 ERROR: Invalid time parameters - hour: $hour, minute: $minute');
      return;
    }

    try {
      // Cancel existing evening notification
      await flutterLocalNotificationsPlugin.cancel(eveningNotificationId);
      print('🔔 Cancelled existing evening notification (ID: $eveningNotificationId)');

      // Schedule new evening notification with updated time
      await scheduleDailyNotification(
        id: eveningNotificationId,
        title: '🌙 Evening Check-in',
        body: 'Did you smoke today? Track your progress and log your mood. You\'re doing great! 🎉',
        hour: hour,
        minute: minute,
      );

      // Verify the notification was scheduled
      final pendingNotifications = await getPendingNotifications();
      final eveningNotification = pendingNotifications.where((n) => n.id == eveningNotificationId).toList();
      
      if (eveningNotification.isNotEmpty) {
        print('🔔 ✅ SUCCESS: Evening notification updated to $hour:${minute.toString().padLeft(2, '0')}');
      } else {
        print('🔔 ❌ WARNING: Evening notification may not have been scheduled properly');
      }
      
      // Debug: Show all pending notifications
      await debugPendingNotifications();
      
    } catch (e) {
      print('🔔 ERROR updating evening notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('🔔 All notifications cancelled');
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    // First try to get the current time in local timezone
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    
    // Also get system DateTime for comparison
    final DateTime systemNow = DateTime.now();
    
    print('🔔 DEBUG _nextInstanceOfTime:');
    print('  System DateTime.now(): ${systemNow.toString()}');
    print('  TZDateTime.now(tz.local): ${now.toString()}');
    print('  Timezone offset: ${systemNow.timeZoneOffset}');
    print('  Requested time: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
    
    // Create scheduled date in local timezone
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0, // seconds
      0, // milliseconds
    );
    
    print('  Initial scheduled: ${scheduledDate.toString()}');
    print('  Initial scheduled (local): ${scheduledDate.toLocal().toString()}');

    // Add buffer time (30 seconds) to avoid edge cases with immediate scheduling
    final nowWithBuffer = now.add(Duration(seconds: 30));
    
    // If the scheduled time has already passed today (including buffer), schedule for tomorrow
    if (scheduledDate.isBefore(nowWithBuffer)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      print('  Time has passed, moved to tomorrow: ${scheduledDate.toString()}');
    } else {
      print('  Scheduled for today: ${scheduledDate.toString()}');
    }
    
    print('  Final scheduled time: ${scheduledDate.toString()}');
    print('  Final scheduled time (local): ${scheduledDate.toLocal().toString()}');

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

  // Schedule a test notification to verify settings change worked
  Future<void> scheduleSettingsTestNotification(int hour, int minute) async {
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      print('🔔 Notifications not enabled, cannot schedule settings test notification');
      return;
    }

    try {
      // Schedule for 1 minute from now to verify the new time setting
      final now = DateTime.now();
      final testTime = now.add(Duration(minutes: 1));
      
      await scheduleDailyNotification(
        id: 996, // Unique ID for settings test
        title: '⚙️ Settings Test',
        body: 'Your notification time was successfully updated to ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}!',
        hour: testTime.hour,
        minute: testTime.minute,
      );
      
      print('🔔 Settings test notification scheduled for 1 minute from now');
    } catch (e) {
      print('🔔 ERROR scheduling settings test notification: $e');
    }
  }

}
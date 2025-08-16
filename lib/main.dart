import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/initial/splash-screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/hive-adapters/onboarding-data-adapter.dart';
import 'package:nicotrack/hive-adapters/did-you-smoke-adapter.dart';
import 'package:nicotrack/hive-adapters/mood-data-adapter.dart';
import 'package:nicotrack/hive-adapters/quick-actions-adapter.dart';
import 'package:nicotrack/hive-adapters/financial-goals-adapter.dart';
import 'package:nicotrack/hive-adapters/notifications-preferences-adapter.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/models/quick-actions-model/quickActions-model.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';
import 'package:nicotrack/models/notifications-preferences-model/notificationsPreferences-model.dart';
import 'package:nicotrack/models/mood-usage-model/moodUsage-model.dart';
import 'package:nicotrack/hive-adapters/mood-usage-adapter.dart';
import 'package:nicotrack/services/notification-service.dart';
import 'package:nicotrack/services/purchase-service.dart';
import 'package:nicotrack/services/premium-persistence-service.dart';
import 'package:nicotrack/services/firebase-service.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';
import 'package:nicotrack/getx-controllers/settings-controller.dart';
import 'package:nicotrack/models/app-preferences-model/appPreferences-model.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize critical services first - minimal blocking
  await Hive.initFlutter();
  
  // Register all adapters at once (synchronous)
  Hive.registerAdapter(OnboardingDataAdapter());
  Hive.registerAdapter(DidYouSmokeAdapter());
  Hive.registerAdapter(MoodModelAdapter());
  Hive.registerAdapter(QuickActionsAdapter());
  Hive.registerAdapter(FinancialGoalsAdapter());
  Hive.registerAdapter(NotificationsPreferencesAdapter());
  Hive.registerAdapter(AppPreferencesModelAdapter());
  Hive.registerAdapter(MoodUsageAdapter());
  
  // Open only essential boxes for app start
  await Future.wait([
    Hive.openBox<OnboardingData>('onboardingCompletedData'),
    Hive.openBox<AppPreferencesModel>('appPreferences'),
  ]);
  
  // Initialize essential controllers
  Get.put(ProgressController());
  Get.put(PremiumController());
  Get.put(AppPreferencesController());
  
  // Start the app immediately
  runApp(const MyApp());
  
  // Initialize non-critical services after app starts
  _initializeBackgroundServices();
}

// Initialize non-critical services in background
Future<void> _initializeBackgroundServices() async {
  try {
    // Initialize Firebase (non-blocking)
    final firebaseFuture = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((_) {
      FirebaseService().initialize();
      FirebaseService().analytics.setAnalyticsCollectionEnabled(true);
      FirebaseService().logAppOpen();
      print('🚀 Firebase Analytics initialized');
    });
    
    // Open remaining Hive boxes in parallel
    final hiveBoxesFuture = Future.wait([
      Hive.openBox<DidYouSmokeModel>('didYouSmokeData'),
      Hive.openBox<MoodModel>('moodData'),
      Hive.openBox<QuickactionsModel>('quickActionsData'),
      Hive.openBox<FinancialGoalsModel>('financialGoalsData'),
      Hive.openBox<NotificationsPreferencesModel>('notificationsPreferencesData'),
      Hive.openBox<MoodUsageModel>('moodUsageData'),
    ]);
    
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Wait for Hive boxes before initializing services that depend on them
    await hiveBoxesFuture;
    
    // Initialize settings controller after boxes are ready
    Get.put(SettingsController());
    
    // Wait a moment for SettingsController to fully initialize
    await Future.delayed(Duration(milliseconds: 100));
    
    // Initialize premium and purchase services
    await PremiumPersistenceService.initialize();
    await PurchaseService().initialize();
    
    // Verify subscription in background
    PurchaseService().verifySubscriptionOnStartup().then((_) {
      Get.find<PremiumController>().debugPremiumStatus();
    });
    
    // Initialize notifications last (after SettingsController is ready)
    await NotificationService().initialize();
    await NotificationService().checkPermissionsAndScheduleNotifications();
    
    // Wait for Firebase to complete
    await firebaseFuture;
    
  } catch (e) {
    print('Error initializing background services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPreferencesController>(
      builder: (appPrefsController) {
        // Parse locale from stored preference, default to English
        Locale appLocale = const Locale('en'); // Default to English
        if (appPrefsController.isInitialized && appPrefsController.locale.isNotEmpty) {
          try {
            // The locale is stored as language code only (e.g., 'en', 'es')
            appLocale = Locale(appPrefsController.locale);
          } catch (e) {
            print('Error parsing locale: $e');
            appLocale = const Locale('en'); // Fallback to English on error
          }
        }

        return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
              return MaterialApp(
                title: 'Nicotrack',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                navigatorObservers: FirebaseService().isInitialized 
                  ? [FirebaseService().analyticsObserver]
                  : [],
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: appLocale, // Always English by default, prevents RTL issues
                localeResolutionCallback: (locale, supportedLocales) {
                  // Force English if no preference is set or on fresh install
                  if (!appPrefsController.isInitialized || appPrefsController.locale.isEmpty) {
                    return const Locale('en');
                  }
                  // Check if the preferred locale is supported
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == appLocale.languageCode) {
                      return appLocale;
                    }
                  }
                  // Fallback to English if preferred locale isn't supported
                  return const Locale('en');
                },
                home: SplashScreen(),
                // home: BadgeEarned(),
              );
            });
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
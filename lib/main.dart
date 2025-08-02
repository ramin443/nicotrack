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
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Enable Firebase Analytics debug mode for development
  FirebaseService().analytics.setAnalyticsCollectionEnabled(true);
  
  // Log app launch event
  await FirebaseService().logAppOpen();
  
  print('🚀 App launched - Firebase Analytics initialized');
  
  Get.put(ProgressController()); // now accessible globally
  Get.put(PremiumController()); // Initialize premium controller
  
  await Hive.initFlutter();

  // Initialize Hive adapter(s)
  Hive.registerAdapter(OnboardingDataAdapter());
  Hive.registerAdapter(DidYouSmokeAdapter());
  Hive.registerAdapter(MoodModelAdapter());
  Hive.registerAdapter(QuickActionsAdapter());
  Hive.registerAdapter(FinancialGoalsAdapter());
  Hive.registerAdapter(NotificationsPreferencesAdapter());
  Hive.registerAdapter(AppPreferencesModelAdapter());

  // Open your Hive box(es)
  await Hive.openBox<OnboardingData>('onboardingCompletedData');
  await Hive.openBox<DidYouSmokeModel>('didYouSmokeData');
  await Hive.openBox<MoodModel>('moodData');
  await Hive.openBox<QuickactionsModel>('quickActionsData');
  await Hive.openBox<FinancialGoalsModel>('financialGoalsData');
  await Hive.openBox<NotificationsPreferencesModel>('notificationsPreferencesData');
  await Hive.openBox<AppPreferencesModel>('appPreferences');

  // Initialize timezone 
  tz.initializeTimeZones();
  
  // Initialize premium persistence
  await PremiumPersistenceService.initialize();
  
  // Initialize purchase service
  await PurchaseService().initialize();
  
  // Initialize app preferences controller after Hive is ready
  Get.put(AppPreferencesController()); // Initialize app preferences controller
  
  // Initialize settings controller after Hive is ready - MUST be before NotificationService
  Get.put(SettingsController()); // Initialize settings controller
  
  // Initialize notification service AFTER SettingsController to ensure data is properly loaded
  await NotificationService().initialize();
  
  // Check permissions and schedule notifications if enabled
  await NotificationService().checkPermissionsAndScheduleNotifications();
  
  // Log app open event
  await FirebaseService().logAppOpen();

  runApp(const MyApp());
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
                navigatorObservers: [
                  FirebaseService().analyticsObserver,
                ],
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
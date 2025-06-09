import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/initial/splash-screen.dart';
import 'package:nicotrack/screens/base/base.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/hive-adapters/onboarding-data-adapter.dart';
import 'package:nicotrack/hive-adapters/did-you-smoke-adapter.dart';
import 'package:nicotrack/hive-adapters/mood-data-adapter.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/models/quick-actions-model/quickActions-model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ProgressController()); // now accessible globally
  await Hive.initFlutter();

  // Initialize Hive adapter(s)
  Hive.registerAdapter(OnboardingDataAdapter());
  Hive.registerAdapter(DidYouSmokeAdapter());
  Hive.registerAdapter(MoodModelAdapter());

  // Open your Hive box(es)
  await Hive.openBox<OnboardingData>('onboardingCompletedData');
  await Hive.openBox<DidYouSmokeModel>('didYouSmokeData');
  await Hive.openBox<MoodModel>('moodData');
  await Hive.openBox<QuickactionsModel>('quickActionsData');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
            home: SplashScreen(),
          );
        });
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
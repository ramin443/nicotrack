import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import '../../../../../constants/font-constants.dart';
import '../../../../elements/gradient-text.dart';
import '../../../../elements/data-cubes.dart';
import '../../../../elements/linear-progress-bar.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/base/base.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class NoSmokeCongratsPage extends StatefulWidget {
  final DateTime selectedDate;
  
  const NoSmokeCongratsPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<NoSmokeCongratsPage> createState() => _NoSmokeCongratsPageState();
}

class _NoSmokeCongratsPageState extends State<NoSmokeCongratsPage> {
  //congrats page variables
  ConfettiController controllerTopCenter =
      ConfettiController(duration: const Duration(milliseconds: 2000));
  List<Color> confettiColor = [
    const Color(0xff2fb5ff),
    const Color(0xffad46ff),
    const Color(0xffff723d),
    const Color(0xffdd00c0),
    const Color(0xffff3400),
    const Color(0xffCBF1E5),
    const Color(0xffffdd0e),
  ];

  // Real data variables
  int daysSinceQuit = 0;
  int smokeFreeStreak = 0;
  double moneySaved = 0.0;
  FinancialGoalsModel? topFinancialGoal;
  double goalProgress = 0.0;

  @override
  void initState() {
    super.initState();
    startConfetti();
    _loadRealData();
  }

  Future<void> _loadRealData() async {
    await _calculateDaysSinceQuit();
    await _calculateSmokeFreeStreak();
    await _calculateMoneySaved();
    await _loadTopFinancialGoal();
    print('Real data loaded - Days since quit: $daysSinceQuit, Money saved: $moneySaved');
    setState(() {});
  }

  Future<void> _calculateDaysSinceQuit() async {
    try {
      final onboardingBox = await Hive.openBox<OnboardingData>('onboardingCompletedData');
      final onboardingData = onboardingBox.get('currentUserOnboarding');
      
      if (onboardingData != null && onboardingData.lastSmokedDate.isNotEmpty) {
        print('Found onboarding data with quit date: ${onboardingData.lastSmokedDate}');
        final quitDate = DateFormat('yyyy-MM-dd').parse(onboardingData.lastSmokedDate);
        // Use selected date instead of current date
        daysSinceQuit = widget.selectedDate.difference(quitDate).inDays;
        if (daysSinceQuit < 0) daysSinceQuit = 0; // Ensure non-negative
        print('Calculated days since quit: $daysSinceQuit');
      } else {
        print('No onboarding data found or empty quit date');
        daysSinceQuit = 1; // Default if no quit date found
      }
    } catch (e) {
      print('Error calculating days since quit: $e');
      try {
        // Try alternative date format
        final onboardingBox = await Hive.openBox<OnboardingData>('onboardingCompletedData');
        final onboardingData = onboardingBox.get('currentUserOnboarding');
        if (onboardingData != null && onboardingData.lastSmokedDate.isNotEmpty) {
          // Try parsing with different formats
          DateTime? quitDate;
          final dateFormats = ['yyyy-MM-dd', 'MM/dd/yyyy', 'dd/MM/yyyy', 'MMM d, yyyy'];
          for (final format in dateFormats) {
            try {
              quitDate = DateFormat(format).parse(onboardingData.lastSmokedDate);
              break;
            } catch (_) {
              continue;
            }
          }
          if (quitDate != null) {
            // Use selected date instead of current date
            daysSinceQuit = widget.selectedDate.difference(quitDate).inDays;
            if (daysSinceQuit < 0) daysSinceQuit = 0;
          } else {
            daysSinceQuit = 1;
          }
        } else {
          daysSinceQuit = 1;
        }
      } catch (e2) {
        print('Error with alternative parsing: $e2');
        daysSinceQuit = 1;
      }
    }
  }

  Future<void> _calculateSmokeFreeStreak() async {
    try {
      final smokingBox = await Hive.openBox<DidYouSmokeModel>('didYouSmokeData');
      // Use selected date instead of current date
      final selectedDate = widget.selectedDate;
      int streak = 0;
      
      // Count consecutive smoke-free days backwards from selected date
      for (int i = 0; i < 365; i++) { // Check up to a year back
        final checkDate = selectedDate.subtract(Duration(days: i));
        final dateKey = DateFormat.yMMMd().format(checkDate);
        final smokingData = smokingBox.get(dateKey);
        
        if (smokingData == null) {
          // No data for this day, assume smoke-free if it's today (just logged)
          if (i == 0) {
            streak++;
          } else {
            break; // No data for past days, stop counting
          }
        } else if (smokingData.hasSmokedToday == 1) {
          // Smoke-free day
          streak++;
        } else {
          // Smoked this day
          break;
        }
      }
      
      smokeFreeStreak = streak;
    } catch (e) {
      print('Error calculating smoke-free streak: $e');
      smokeFreeStreak = 1; // Default to 1 if error
    }
  }

  Future<void> _calculateMoneySaved() async {
    try {
      final onboardingBox = await Hive.openBox<OnboardingData>('onboardingCompletedData');
      final onboardingData = onboardingBox.get('currentUserOnboarding');
      
      if (onboardingData != null) {
        final costPerPack = double.tryParse(onboardingData.costOfAPack) ?? 0.0;
        final cigsPerPack = onboardingData.numberOfCigarettesIn1Pack;
        final cigsPerDay = onboardingData.cigarettesPerDay;
        
        if (costPerPack > 0 && cigsPerPack > 0 && cigsPerDay > 0) {
          final costPerCig = costPerPack / cigsPerPack;
          final dailyCost = costPerCig * cigsPerDay;
          moneySaved = dailyCost * daysSinceQuit;
        }
      }
    } catch (e) {
      print('Error calculating money saved: $e');
      moneySaved = 0.0; // Default to 0 if error
    }
  }

  Future<void> _loadTopFinancialGoal() async {
    try {
      final goalsBox = Hive.box<FinancialGoalsModel>('financialGoalsData');
      final goals = goalsBox.values.toList();
      print('Financial goals found: ${goals.length} goals');
      
      if (goals.isNotEmpty) {
        // Get first financial goal
        topFinancialGoal = goals.first;
        print('Loaded financial goal: ${topFinancialGoal?.goalTitle} - Cost: ${topFinancialGoal?.cost}');
        
        if (topFinancialGoal != null && topFinancialGoal!.cost > 0) {
          goalProgress = (moneySaved / topFinancialGoal!.cost).clamp(0.0, 1.0);
          print('Goal progress: ${(goalProgress * 100).round()}%');
        }
      } else {
        print('No financial goals found - section will be hidden');
        topFinancialGoal = null;
      }
    } catch (e) {
      print('Error loading financial goal: $e');
      topFinancialGoal = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        builder: (didYouSmokeController) {
          return Scaffold(
            backgroundColor: Colors.white,
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            // floatingActionButton:
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.0),
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            surfaceTintColor: Colors.transparent,
                            automaticallyImplyLeading: false,
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  // Save smoke-free data and navigate to home using selected date
                                  final controller = Get.find<DidYouSmokeController>();
                                  controller.addDatatoHiveandNavigate(widget.selectedDate, context);
                                },
                                child: Container(
                                  height: 36.w,
                                  width: 36.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFF611D).withOpacity(0.20)),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.xmark,
                                      color: Color(0xffFF611D),
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    awardBg2,
                                    width: 220.w,
                                  ),
                                  Image.asset(
                                    celebrateImg,
                                    width: 120.w,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        GradientText(
                          text: context.l10n.amazing_congratulations,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xff3217C3), Color(0xffFF4B4B)],
                          ),
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: const Color(0xFFA1A1A1),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        SizedBox(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontFamily: circularMedium,
                                    height: 1.1,
                                    color: nicotrackBlack1,
                                  ),
                                  children: [
                                    TextSpan(text: context.l10n.smoke_free_day_message),
                                    TextSpan(
                                      text: '${daysSinceQuit}${_getDaySuffix(daysSinceQuit)}\n',
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontFamily: circularBold,
                                        height: 1.1,
                                        color: Color(0xffFF4B4B),
                                      ),
                                    ),
                                    TextSpan(text: context.l10n.smoke_free_day_suffix),
                                  ])),
                        ),
                        SizedBox(
                          height: 36.h,
                        ),
                        _buildFinancialGoalProgressBar(),
                        _buildDataCubes(),
                        SizedBox(
                          height: 140.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildGoToHomeButton(),
                      SizedBox(
                        height: 12.h,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    minimumSize: const Size(6, 1),
                    maximumSize: const Size(12, 2),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.45,
                    // set a lower max blast force
                    minBlastForce: 0.4,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 100,
                    // a lot of particles at once
                    gravity: 0.14,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(12, 12),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.45,
                    // set a lower max blast force
                    minBlastForce: 0.1,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 100,
                    // a lot of particles at once
                    gravity: 0.14,
                    createParticlePath: drawCircle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConfettiWidget(
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(12, 12),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.45,
                    // set a lower max blast force
                    minBlastForce: 0.1,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 100,
                    // a lot of particles at once
                    gravity: 0.14,
                    createParticlePath: drawCircle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ConfettiWidget(
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(12, 12),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.9,
                    // set a lower max blast force
                    minBlastForce: 0.4,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 100,
                    // a lot of particles at once
                    gravity: 0.14,
                    createParticlePath: drawCircle,
                  ),
                ),
              ],
            ),
          );
        });
  }

  String _getDaySuffix(int day) {
    if (day <= 0) return 'th'; // Handle 0 or negative days
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Widget _buildFinancialGoalProgressBar() {
    if (topFinancialGoal == null) {
      return SizedBox.shrink();
    }

    final progressPercentage = (goalProgress * 100).round();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: circularMedium,
                          height: 1.1,
                          color: nicotrackBlack1,
                        ),
                        children: [
                          TextSpan(text:
                          // '${context.l10n.financial_goal_prefix}'
                              '${topFinancialGoal!.emoji} ${topFinancialGoal!.goalTitle} '),
                          TextSpan(
                            text: '$progressPercentage%',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularBold,
                              height: 1.1,
                              color: Color(0xff6D9C32),
                            ),
                          ),
                          TextSpan(text: context.l10n.financial_goal_completed),
                        ])),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: StyledProgressBar(progress: goalProgress),
        ),
        SizedBox(
          height: 18.h,
        ),
      ],
    );
  }

  Widget _buildDataCubes() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.w,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: 1.58,
        children: [
          _buildDaysCard(),
          _buildMoneySavedCard(),
        ],
      ),
    );
  }

  Widget _buildDaysCard() {
    return Container(
      width: 186.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(homeMainBG), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            bicepsEmoji,
            width: 48.w,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedFlipCounter(
                wholeDigits: daysSinceQuit.toString().length > 2 ? daysSinceQuit.toString().length : 2,
                duration: Duration(seconds: 2),
                value: daysSinceQuit,
                fractionDigits: 0,
                textStyle: TextStyle(
                  fontSize: 33.sp,
                  fontFamily: circularBold,
                  color: nicotrackBlack1
                )
              ),
              SizedBox(
                width: 80.w,
                child: TextAutoSize(
                  context.l10n.home_days_since_last_smoked,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 12.5.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoneySavedCard() {
    final moneyValue = moneySaved.round();
    return Container(
      width: 186.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            moneyEmoji,
            width: 48.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedFlipCounter(
                prefix: Get.find<AppPreferencesController>().currencySymbol,
                wholeDigits: moneyValue.toString().length > 2 ? moneyValue.toString().length : 2,
                duration: Duration(seconds: 2),
                value: moneyValue,
                fractionDigits: 0,
                textStyle: TextStyle(
                  fontSize: 33.sp,
                  fontFamily: circularBold,
                  color: nicotrackBlack1
                )
              ),
              SizedBox(
                width: 80.w,
                child: TextAutoSize(
                  context.l10n.home_money_saved,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 12.5.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoToHomeButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to base using the same method as close button
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Base(),
              ),
                  (route) => false,
            );          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                fullButtonBg,
                width: 346.w,
              ),
              Text(
                context.l10n.go_home_button,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.h,
        )
      ],
    );
  }

  void startConfetti() {
    // Start confetti immediately when screen loads
    Future.delayed(const Duration(milliseconds: 300), () {
      controllerTopCenter.play();
      HapticFeedback.heavyImpact();
    });
  }

  Path drawCircle(Size size) {
    final path = Path();

    path.addOval(Rect.fromCircle(
      center: const Offset(0, 0),
      radius: size.width / 2,
    ));

    return path;
  }
}
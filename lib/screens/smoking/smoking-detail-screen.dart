import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/base/base.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/elements/gradient-text.dart';
import 'package:nicotrack/screens/elements/linear-progress-bar.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

enum SmokingDetailRouteSource {
  fromHome,
  afterSmokingCompletion,
}

class SmokingDetailScreen extends StatefulWidget {
  final DateTime selectedDate;
  final SmokingDetailRouteSource routeSource;
  
  const SmokingDetailScreen({
    super.key, 
    required this.selectedDate,
    this.routeSource = SmokingDetailRouteSource.fromHome,
  });

  @override
  State<SmokingDetailScreen> createState() => _SmokingDetailScreenState();
}

class _SmokingDetailScreenState extends State<SmokingDetailScreen> {
  DidYouSmokeModel? smokingData;
  bool isLoading = true;
  int currentTriggersPage = 0;
  int currentFeelingsPage = 0;
  int currentAvoidancePage = 0;
  
  // Congratulations section data
  int daysSinceQuit = 0;
  int smokeFreeStreak = 0;
  double moneySaved = 0.0;
  FinancialGoalsModel? topFinancialGoal;
  double goalProgress = 0.0;
  
  // Confetti controller
  ConfettiController controllerTopCenter = ConfettiController(duration: const Duration(milliseconds: 2000));
  List<Color> confettiColor = [
    const Color(0xff2fb5ff),
    const Color(0xffad46ff),
    const Color(0xffff723d),
    const Color(0xffdd00c0),
    const Color(0xffff3400),
    const Color(0xffCBF1E5),
    const Color(0xffffdd0e),
  ];

  @override
  void initState() {
    super.initState();
    _loadSmokingData();
    _loadCongratsData();
  }
  
  @override
  void dispose() {
    controllerTopCenter.dispose();
    super.dispose();
  }

  Future<void> _loadSmokingData() async {
    try {
      final box = await Hive.openBox<DidYouSmokeModel>('didYouSmokeData');
      final dateKey = DateFormat.yMMMd().format(widget.selectedDate);
      
      setState(() {
        smokingData = box.get(dateKey);
        isLoading = false;
      });
      
      // Start confetti if it's a smoke-free day
      if (smokingData != null && smokingData!.hasSmokedToday == 1) {
        _startConfetti();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleCloseNavigation() {
    switch (widget.routeSource) {
      case SmokingDetailRouteSource.fromHome:
        // Coming from home daily page - use pop
        Navigator.of(context).pop();
        break;
      case SmokingDetailRouteSource.afterSmokingCompletion:
        // Coming after completing smoking questionnaire - navigate back to home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Base(),
          ),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: nicotrackGreen,
          ),
        ),
      );
    }
    
    if (smokingData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _buildNoDataSection(),
        ),
      );
    }
    
    // No automatic redirect - show the combined view for all cases
    
    // Show combined view with smoking details and congratulations
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildSmokingContent(),
                  // Only add extra space if Go to home button is shown (smoke-free days)
                  if (smokingData != null && smokingData!.hasSmokedToday == 1)
                    SizedBox(height: 100.h)
                  else
                    SizedBox(height: 60.h),
                ],
              ),
            ),
            // Only show Go to home button for smoke-free days
            if (smokingData != null && smokingData!.hasSmokedToday == 1)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildGoToHomeButton(),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            // Confetti widgets for smoke-free days (lighter intensity)
            if (smokingData != null && smokingData!.hasSmokedToday == 1) ...[
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  minimumSize: const Size(4, 1),
                  maximumSize: const Size(8, 2),
                  colors: confettiColor,
                  confettiController: controllerTopCenter,
                  blastDirection: pi / 2,
                  maxBlastForce: 0.25,  // Reduced from 0.45
                  minBlastForce: 0.2,   // Reduced from 0.4
                  emissionFrequency: 0.15,  // Reduced from 0.4
                  numberOfParticles: 80,    // Reduced from 240
                  gravity: 0.18,  // Slightly increased for faster fall
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  minimumSize: const Size(3, 3),
                  maximumSize: const Size(8, 8),
                  colors: confettiColor,
                  confettiController: controllerTopCenter,
                  blastDirection: pi / 2,
                  maxBlastForce: 0.25,  // Reduced from 0.45
                  minBlastForce: 0.05,  // Reduced from 0.1
                  emissionFrequency: 0.15,  // Reduced from 0.4
                  numberOfParticles: 60,    // Reduced from 240
                  gravity: 0.18,
                  createParticlePath: _drawCircle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSmokingContent() {
    // Format date
    String dateDisplay;
    if (widget.selectedDate.isToday) {
      dateDisplay = context.l10n.smoking_detail_today;
    } else if (widget.selectedDate.isYesterday) {
      dateDisplay = context.l10n.smoking_detail_yesterday;
    } else {
      dateDisplay = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(widget.selectedDate);
    }
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
      child: Column(
        children: [
          // Header with date and close button
          _buildHeader(dateDisplay),
          
          SizedBox(height: 18.w),
          
          // Did you smoke section with Yes/No buttons
          _buildSmokingStatusSection(),
          
          SizedBox(height: 32.h),
          
          // Show content based on smoking status
          if (smokingData!.hasSmokedToday == 0) ...[
            // Smoking day content
            _buildCigaretteCountSection(),
          ] else ...[
            // Smoke-free day content 
            _buildSmokeFreeSection(),
          ],
          
          SizedBox(height: 40.h),
          
          // Show smoking details only for smoking days
          if (smokingData!.hasSmokedToday == 0) ...[
            // Triggers section
            if (smokingData!.whatTriggerred.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                context.l10n.trigger_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
            ]),
            SizedBox(height: 14.h),
            _buildMultipleItemsGrid(
              smokingData!.whatTriggerred,
              currentTriggersPage,
              (page) => setState(() => currentTriggersPage = page),
            ),
            SizedBox(height: 32.h),
          ],
          
          // Feelings section
          if (smokingData!.howYouFeel.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                context.l10n.feeling_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
            ]),
            SizedBox(height: 14.h),
            _buildMultipleItemsGrid(
              smokingData!.howYouFeel,
              currentFeelingsPage,
              (page) => setState(() => currentFeelingsPage = page),
            ),
            SizedBox(height: 32.h),
          ],
          
          // Avoidance strategies section
          if (smokingData!.avoidNext.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                context.l10n.smoking_detail_avoidance_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                  height: 1.3,
                ),
              ),
            ]),
            SizedBox(height: 14.h),
            _buildMultipleItemsGrid(
              smokingData!.avoidNext,
              currentAvoidancePage,
              (page) => setState(() => currentAvoidancePage = page),
            ),
            SizedBox(height: 32.h),
          ],
          ],
          
          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget _buildHeader(String dateDisplay) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: TextAutoSize(
        dateDisplay,
        style: TextStyle(
          fontSize: 18.sp,
          fontFamily: circularMedium,
          color: Color(0xffFF611D),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            _handleCloseNavigation();
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFF611D).withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                Icons.close,
                color: Color(0xffFF611D),
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSmokingStatusSection() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextAutoSize(
            context.l10n.did_you_smoke_today,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
            ),
          ),
        ]),
        SizedBox(height: 14.h),
        SizedBox(
          width: 260.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildStatusButton(
                  icon: '👎',
                  text: context.l10n.smoking_detail_yes,
                  isSelected: smokingData!.hasSmokedToday == 0, // 0 means smoked
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _buildStatusButton(
                  icon: '👍',
                  text: context.l10n.smoking_detail_no,
                  isSelected: smokingData!.hasSmokedToday == 1, // 1 means didn't smoke
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusButton({
    required String icon,
    required String text,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? nicotrackBlack1 : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? nicotrackBlack1 : Color(0xFFE8EAED),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(width: 8.w),
          TextAutoSize(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularMedium,
              color: isSelected ? Colors.white : nicotrackBlack1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataSection() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x192196F3),
            ),
            child: Center(
              child: Text(
                "📝",
                style: TextStyle(fontSize: 56.sp),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          TextAutoSize(
            context.l10n.no_smoking_data,
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
          SizedBox(height: 8.h),
          TextAutoSize(
            context.l10n.no_smoking_recorded,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required dynamic icon,
    required String text,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFE8EAED),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon.toString().startsWith('assets/')
              ? Image.asset(
                  icon,
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                )
              : Text(
                  icon,
                  style: TextStyle(fontSize: 28.sp),
                ),
          SizedBox(height: 10.w),
          TextAutoSize(
            text,
            style: TextStyle(
              height: 1.2,
              fontSize: 14.sp,
              fontFamily: circularMedium,
              color: nicotrackBlack1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleItemsGrid(List<Map<String, dynamic>> items,
      int currentPage, Function(int) onPageChanged) {
    final pages = _chunkItems(items, 2); // 2 items per scroll "page"
    final showIndicator = pages.length > 1;

    return StatefulBuilder(
      builder: (context, setState) {
        final scrollController = ScrollController();

        void _onScroll() {
          if (!scrollController.hasClients) return;
          final page = (scrollController.offset /
                  (MediaQuery.sizeOf(context).width - 40.w))
              .round();
          if (page != currentPage && page >= 0 && page < pages.length) {
            onPageChanged(page);
          }
        }

        scrollController.addListener(_onScroll);

        return Column(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pages.asMap().entries.map((entry) {
                  final pageItems = entry.value;
                  return Container(
                    width: MediaQuery.sizeOf(context).width -
                        40.w, // Account for padding
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 0.w,
                        mainAxisSpacing: 0.h,
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        final item = pageItems[index];
                        return _buildInfoCard(
                          icon: item['emoji'],
                          text: item['text'] ?? '',
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            if (showIndicator) ...[
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color:
                          index == currentPage ? Colors.black : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ],
        );
      },
    );
  }

  List<List<Map<String, dynamic>>> _chunkItems(
      List<Map<String, dynamic>> items, int chunkSize) {
    List<List<Map<String, dynamic>>> chunks = [];
    for (var i = 0; i < items.length; i += chunkSize) {
      chunks.add(items.sublist(i, (i + chunkSize).clamp(0, items.length)));
    }
    return chunks;
  }

  Future<void> _loadCongratsData() async {
    await _calculateDaysSinceQuit();
    await _calculateSmokeFreeStreak();
    await _calculateMoneySaved();
    await _loadTopFinancialGoal();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _calculateDaysSinceQuit() async {
    try {
      final onboardingBox = await Hive.openBox<OnboardingData>('onboardingCompletedData');
      final onboardingData = onboardingBox.get('currentUserOnboarding');
      
      if (onboardingData != null && onboardingData.lastSmokedDate.isNotEmpty) {
        final quitDate = DateFormat('yyyy-MM-dd').parse(onboardingData.lastSmokedDate);
        // Use the selected date instead of current date
        daysSinceQuit = widget.selectedDate.difference(quitDate).inDays;
        if (daysSinceQuit < 0) daysSinceQuit = 0;
      } else {
        daysSinceQuit = 1;
      }
    } catch (e) {
      daysSinceQuit = 1;
    }
  }

  Future<void> _calculateSmokeFreeStreak() async {
    try {
      final smokingBox = await Hive.openBox<DidYouSmokeModel>('didYouSmokeData');
      // Use selected date instead of current date
      final selectedDate = widget.selectedDate;
      int streak = 0;
      
      for (int i = 0; i < 365; i++) {
        final checkDate = selectedDate.subtract(Duration(days: i));
        final dateKey = DateFormat.yMMMd().format(checkDate);
        final smokingData = smokingBox.get(dateKey);
        
        if (smokingData == null) {
          if (i == 0) {
            streak++;
          } else {
            break;
          }
        } else if (smokingData.hasSmokedToday == 1) {
          streak++;
        } else {
          break;
        }
      }
      
      smokeFreeStreak = streak;
    } catch (e) {
      smokeFreeStreak = 1;
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
      moneySaved = 0.0;
    }
  }

  Future<void> _loadTopFinancialGoal() async {
    try {
      final goalsBox = Hive.box<FinancialGoalsModel>('financialGoalsData');
      final goals = goalsBox.values.toList();
      
      if (goals.isNotEmpty) {
        topFinancialGoal = goals.first;
        
        if (topFinancialGoal != null && topFinancialGoal!.cost > 0) {
          goalProgress = (moneySaved / topFinancialGoal!.cost).clamp(0.0, 1.0);
        }
      } else {
        topFinancialGoal = null;
      }
    } catch (e) {
      topFinancialGoal = null;
    }
  }

  Widget _buildCigaretteCountSection() {
    if (smokingData!.howManyCigs <= 0) return Container();
    
    // Determine the date text
    String dateText;
    if (widget.selectedDate.isToday) {
      dateText = context.l10n.today.toLowerCase();
    } else if (widget.selectedDate.isYesterday) {
      dateText = context.l10n.yesterday.toLowerCase();
    } else {
      // Format as "June 25th, 2025"
      final day = widget.selectedDate.day;
      final suffix = _getDaySuffix(day);
      dateText = "${context.l10n.smoking_detail_on} \n${DateFormat('MMMM d', Localizations.localeOf(context).languageCode).format(widget.selectedDate)}$suffix, ${widget.selectedDate.year}";
    }
    
    return Column(
      children: [
        Container(
          width: 160.w,
          height: 160.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffFFE4D9),
          ),
          child: Center(
            child: TextAutoSize(
              smokingData!.howManyCigs.toString(),
              style: TextStyle(
                fontSize: 85.sp,
                fontFamily: circularMedium,
                color: Color(0xffFF611D),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 22.w,
              fontFamily: circularBold,
              color: nicotrackBlack1,
              height: 1.1
            ),
            children: [
              TextSpan(text: context.l10n.smoking_detail_cigarettes_smoked_prefix),
              TextSpan(
                text: "🚬\n${context.l10n.smoking_detail_cigarettes}",
                style: TextStyle(
                  color: Color(0xffFF611D),
                  fontSize: 22.w,
                  fontFamily: circularBold,
                ),
              ),
              TextSpan(text: "${context.l10n.smoking_detail_you_smoked}$dateText"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmokeFreeSection() {
    return Column(
      children: [
        // Award background with celebrate image
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
        SizedBox(height: 14.h),
        
        // Amazing text with gradient
        GradientText(
          text: context.l10n.smoking_detail_amazing,
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
        SizedBox(height: 8.h),
        
        // Days since quit text
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 22.sp,
              fontFamily: circularMedium,
              height: 1.1,
              color: nicotrackBlack1,
            ),
            children: [
              TextSpan(text: context.l10n.smoking_detail_youre_on_your),
              TextSpan(
                text: '${daysSinceQuit}${_getDaySuffix(daysSinceQuit)}\n',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: circularBold,
                  height: 1.1,
                  color: Color(0xffFF4B4B),
                ),
              ),
              TextSpan(text: context.l10n.smoking_detail_smoke_free_day),
            ],
          ),
        ),
        SizedBox(height: 36.h),
        
        // Financial goal progress bar
        _buildFinancialGoalProgressBar(),
      ],
    );
  }


  String _getDaySuffix(int day) {
    if (day <= 0) return context.l10n.ordinal_suffix_th;
    if (day >= 11 && day <= 13) {
      return context.l10n.ordinal_suffix_th;
    }
    switch (day % 10) {
      case 1:
        return context.l10n.ordinal_suffix_st;
      case 2:
        return context.l10n.ordinal_suffix_nd;
      case 3:
        return context.l10n.ordinal_suffix_rd;
      default:
        return context.l10n.ordinal_suffix_th;
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
                          // '${context.l10n.smoking_detail_financial_goal}\n'
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
                          TextSpan(text: context.l10n.smoking_detail_completed),
                        ])),
              ),
            ],
          ),
        ),
        SizedBox(height: 9.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: StyledProgressBar(progress: goalProgress),
        ),
        SizedBox(height: 18.h),
      ],
    );
  }

  Widget _buildDataCubes() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
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
            width: 51.w,
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
              TextAutoSize(
                context.l10n.smoking_detail_days_since_last_smoked,
                textAlign: TextAlign.right,
                style: TextStyle(
                  height: 1.1,
                  fontSize: 12.5.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1
                ),
              ),
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
            width: 51.w,
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
              TextAutoSize(
                context.l10n.smoking_detail_money_saved,
                textAlign: TextAlign.right,
                style: TextStyle(
                  height: 1.1,
                  fontSize: 12.5.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1
                ),
              ),
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
            // Navigate to home using the same method as close button
            _handleCloseNavigation();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                fullButtonBg,
                width: 346.w,
              ),
              Text(
                context.l10n.smoking_detail_go_to_home,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ),

      ],
    );
  }
  
  void _startConfetti() {
    // Start confetti immediately when screen loads
    Future.delayed(const Duration(milliseconds: 300), () {
      controllerTopCenter.play();
      HapticFeedback.heavyImpact();
    });
  }
  
  Path _drawCircle(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: const Offset(0, 0),
      radius: size.width / 2,
    ));
    return path;
  }
}

// Extension to check if date is today or yesterday
extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}
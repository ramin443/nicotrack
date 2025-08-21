import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../elements/textAutoSize.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../extensions/app_localizations_extension.dart';
import '../../models/exercise_model.dart';
import '../exercises/exercise_overview_screen.dart';
import '../elements/info_bottom_sheet.dart';
import '../elements/activity_info_content.dart';
import '../../services/exercise_translation_service.dart';
import '../../getx-controllers/premium-controller.dart';
import '../premium/reusables/premium-widgets.dart';
import '../premium/premium-paywall-screen.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> with SingleTickerProviderStateMixin {
  final List<ExerciseModel> exercises = allExercises;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();
  bool _showFloatingButton = false;
  
  // Filter state
  int _selectedFilterIndex = 0;
  late TabController _tabController;
  
  final List<Map<String, String>> _filterTabs = [
    {"key": "all", "emoji": "📱"},
    {"key": "phase1", "emoji": "1️⃣"},
    {"key": "phase2", "emoji": "2️⃣"},
    {"key": "phase3", "emoji": "3️⃣"},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: _filterTabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedFilterIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
    } else if (_scrollController.offset <= 200 && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  List<ExerciseModel> _getFilteredExercises() {
    switch (_selectedFilterIndex) {
      case 0: // All
        return exercises;
      case 1: // Phase 1
        return exercises.where((exercise) => exercise.phase == 'Phase 1').toList();
      case 2: // Phase 2
        return exercises.where((exercise) => exercise.phase == 'Phase 2').toList();
      case 3: // Phase 3
        return exercises.where((exercise) => exercise.phase == 'Phase 3').toList();
      default:
        return exercises;
    }
  }
  
  String _getTabLabel(BuildContext context, int index) {
    switch (_filterTabs[index]["key"]) {
      case "all":
        return context.l10n.activity_filter_all;
      case "phase1":
        return context.l10n.activity_filter_phase_one;
      case "phase2":
        return context.l10n.activity_filter_phase_two;
      case "phase3":
        return context.l10n.activity_filter_phase_three;
      default:
        return "";
    }
  }

  Widget _buildFilterTab(int index) {
    final isSelected = _selectedFilterIndex == index;
    final tab = _filterTabs[index];
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedFilterIndex = index;
          _tabController.animateTo(index);
        });
        
        // Scroll to the tapped tab's position (same as progress tabs)
        final tabWidth = 140.w; // Approximate tab width
        double targetOffset = (tabWidth + 8.w) * index - 34.w;
        
        if (targetOffset < 0) targetOffset = 0;
        if (targetOffset > _tabScrollController.position.maxScrollExtent) {
          targetOffset = _tabScrollController.position.maxScrollExtent;
        }
        
        _tabScrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: index == 0 ? 16.w : 0,
          right: index == _filterTabs.length - 1 ? 16.w : 0
        ),
        padding: EdgeInsets.only(
          right: 18.w, left: 8.w, top: 14.h, bottom: 14.w
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Row(
          children: [
            TextAutoSize(
              '  ${tab["emoji"]!}',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: circularBold,
                height: 1.1,
                color: isSelected ? Colors.white : nicotrackBlack1
              ),
            ),
            SizedBox(width: 6.w),
            TextAutoSize(
              _getTabLabel(context, index),
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBold,
                height: 1.1,
                color: isSelected ? Colors.white : nicotrackBlack1
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                // Top spacing
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 12.h,
                  ),
                ),

                // Header section with activity button
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                activityBGBtn,
                                width: 140.w,
                              ),
                              Positioned.fill(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextAutoSize(
                                      "🎮",
                                      style: TextStyle(
                                          fontSize: 50.sp,
                                          fontFamily: circularBold,
                                          height: 1.1,
                                          color: nicotrackBlack1),
                                    ),
                                    SizedBox(
                                      height: 8.w,
                                    ),
                                    TextAutoSize(
                                      context.l10n.activity_screen_title,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontFamily: circularBold,
                                          height: 1.1,
                                          color: nicotrackBlack1),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 10.h,
                        width: 1.w,
                        decoration: BoxDecoration(color: nicotrackBlack1),
                      ),
                      Container(
                        width: 256.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 14.h),
                        decoration: BoxDecoration(
                            color: nicotrackBlack1,
                            borderRadius: BorderRadius.circular(26.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              instantQuitEmoji,
                              width: 24.w,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 190.w,
                              child: TextAutoSize(
                                context.l10n.activity_screen_subtitle,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularMedium,
                                    height: 1.1,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          InfoBottomSheet.show(
                            context,
                            content: ActivityInfoContent(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FeatherIcons.info,
                              weight: 14.sp,
                              color: const Color(0xFFA1A1A1),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            TextAutoSize(
                              context.l10n.info_button,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: circularBook,
                                height: 1.1,
                                color: const Color(0xFFA1A1A1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.w,
                      ),
                    ],
                  ),
                ),

                // Filter tabs
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _tabScrollController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_filterTabs.length, (index) {
                        return _buildFilterTab(index);
                      }),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 18.w),
                ),
                // Grid view as sliver
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.w,
                      childAspectRatio: 0.76,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final filteredExercises = _getFilteredExercises();
                        return _buildTechniqueCard(filteredExercises[index]);
                      },
                      childCount: _getFilteredExercises().length,
                    ),
                  ),
                ),

                // Bottom padding to make space for the emergency button
                SliverToBoxAdapter(
                  child: SizedBox(height: 120.h),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _scrollToTop();
              },
              backgroundColor: nicotrackBlack1,
              elevation: 8,
              heroTag: "activityScrollToTop",
              child: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 28.w,
              ),
            )
          : null,
    );
  }

  Widget _buildTechniqueCard(ExerciseModel exercise) {
    final premiumController = Get.find<PremiumController>();
    final bool isPremium = premiumController.effectivePremiumStatus;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        
        // Check if user is premium or not
        if (!isPremium) {
          // If not premium, navigate to premium paywall screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PremiumPaywallScreen(),
            ),
          );
        } else {
          // If premium, proceed normally to exercise
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseOverviewScreen(exercise: exercise),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFF1F1F1), width: 1.sp),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.icon,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 56.sp),
                  ),
                  SizedBox(height: 12.h),
                  TextAutoSize(
                    ExerciseTranslationService.getPhase(context, exercise.id),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: circularMedium,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextAutoSize(
                    ExerciseTranslationService.getTitle(context, exercise.id),
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: circularBold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.clock,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      TextAutoSize(
                        ExerciseTranslationService.getDuration(context, exercise.id),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: circularMedium,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                width: 36.w,
                height: 36.w,
                padding: EdgeInsets.only(left: 1.w),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
            // Show lock for non-premium users
            if (!isPremium)
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: smallLockBox(),
              ),
          ],
        ),
      ),
    );
  }
}
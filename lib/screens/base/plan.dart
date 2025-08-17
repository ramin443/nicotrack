import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/plan-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/all-badges-section.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../elements/textAutoSize.dart';
import '../../extensions/app_localizations_extension.dart';
import '../elements/info_bottom_sheet.dart';
import '../elements/plan_info_content.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;
  bool _showCurrentPositionButton = false;
  double _currentTimelinePosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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
    
    // Check if user is viewing their current timeline position
    _checkCurrentPositionVisibility();
  }
  
  void _checkCurrentPositionVisibility() {
    try {
      final planController = Get.find<PlanController>();
      final currentIndex = planController.getCurrentTimelineIndex(context);
      
      // Calculate approximate position of current timeline item
      // Timeline starts after header content (approximately 520px) + (index * item height)
      // Each timeline item is roughly 200px tall including spacing
      final headerHeight = 520.0;
      final itemHeight = 200.0;
      final targetPosition = headerHeight + (currentIndex * itemHeight);
      
      _currentTimelinePosition = targetPosition;
      
      // Check if current position is visible on screen
      final viewportHeight = MediaQuery.of(context).size.height;
      final currentScrollOffset = _scrollController.offset;
      
      // Add buffer zone to make button appear earlier
      final bufferZone = 100.0;
      final isCurrentPositionVisible = (targetPosition >= (currentScrollOffset - bufferZone)) && 
                                       (targetPosition <= (currentScrollOffset + viewportHeight + bufferZone));
      
      // Always show the button when scrolled past the header
      final shouldShowButton = currentScrollOffset > 300.0 && !isCurrentPositionVisible;
      
      if (shouldShowButton != _showCurrentPositionButton) {
        setState(() {
          _showCurrentPositionButton = shouldShowButton;
        });
      }
    } catch (e) {
      // If controller not found, show button when scrolled down
      final shouldShowButton = _scrollController.offset > 300.0;
      if (shouldShowButton != _showCurrentPositionButton) {
        setState(() {
          _showCurrentPositionButton = shouldShowButton;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  void _scrollToCurrentPosition() {
    _scrollController.animateTo(
      _currentTimelinePosition,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, y', Localizations.localeOf(context).languageCode).format(DateTime.now());
    return GetBuilder<PlanController>(
        init: PlanController(),
        builder: (planController) {
          return Scaffold(
           key: planController.scaffoldState,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextAutoSize(
                          context.l10n.plan_today(todayDate),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularBook,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          planBtnBg,
                          width: 240.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              coffeeEmoji,
                              width: 52.w,
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            SizedBox(
                              width: 120.w,
                              child: TextAutoSize(
                                context.l10n.personalized_quit_routine,
                                style: TextStyle(
                                    fontSize: 19.sp,
                                    fontFamily: circularBold,
                                    height: 1.1,
                                    color: nicotrackBlack1),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 10.h,
                      width: 1.w,
                      decoration: BoxDecoration(color: nicotrackBlack1),
                    ),
                    Container(
                      width: 206.w,
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
                          TextAutoSize(
                            context.l10n.instant_quit_plan,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularMedium,
                                height: 1.1,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        InfoBottomSheet.show(
                          context,
                          content: PlanInfoContent(),
                          heightRatio: 0.7,
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

                    Column(
                      children: [
                        SizedBox(height: 0),
                        planController.withdrawalTimeline(context),
                        SizedBox(height: 34.w),
                        AllBadgesSection(),
                        SizedBox(height: 24.w),
                      ],
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: (_showFloatingButton || _showCurrentPositionButton)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current position button (appears when not viewing current timeline position)
                      if (_showCurrentPositionButton)
                        FloatingActionButton(
                          onPressed: _scrollToCurrentPosition,
                          backgroundColor: nicotrackPurple,
                          elevation: 8,
                          heroTag: "currentPosition",
                          child: Icon(
                            Icons.my_location,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                      // Add spacing only if both buttons are showing
                      if (_showCurrentPositionButton && _showFloatingButton)
                        SizedBox(height: 12.h),
                      // Scroll to top button (appears when scrolled down)
                      if (_showFloatingButton)
                        FloatingActionButton(
                          onPressed: _scrollToTop,
                          backgroundColor: nicotrackBlack1,
                          elevation: 8,
                          heroTag: "scrollToTop",
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        ),
                    ],
                  )
                : null,
          );
        });
  }
}
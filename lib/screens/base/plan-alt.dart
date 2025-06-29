import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/plan-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/all-badges-section.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/quick-function-constants.dart';
import '../elements/sliver-header-delegate.dart';
import '../elements/textAutoSize.dart';

class PlanAlt extends StatefulWidget {
  const PlanAlt({super.key});

  @override
  State<PlanAlt> createState() => _PlanAltState();
}

class _PlanAltState extends State<PlanAlt> {
  bool _showFloatingButton = false;
  bool _showCurrentPositionButton = true; // Start as visible
  double _currentTimelinePosition = 0.0;

  @override
  void initState() {
    super.initState();
    // Calculate initial position after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateInitialPosition();
    });
  }

  void _calculateInitialPosition() {
    try {
      final planController = Get.find<PlanController>();
      final currentIndex = planController.getCurrentTimelineIndex();
      
      // Accurate calculation based on plan-alt.dart structure:
      // Header section: SizedBox(12.h) + today date + SizedBox(8.h) + plan button stack + SizedBox(10.h) + 
      // instant quit container + SizedBox(10.h) + info section + SizedBox(28.h) = ~580px
      // Each timeline item: 
      // - Day text (~20px) + SizedBox(9w) + icon stack (100w ≈ 100px) + SizedBox(5w) + gradient text (~20px)
      // - Plus spacing: SizedBox(8w) + connector (20w) + SizedBox(8h) = ~160px per item
      final headerHeight = 580.0;
      final itemHeight = 160.0;
      final targetPosition = headerHeight + (currentIndex * itemHeight);
      
      setState(() {
        _currentTimelinePosition = targetPosition;
      });
    } catch (e) {
      // Default position if calculation fails
      setState(() {
        _currentTimelinePosition = 580.0;
      });
    }
  }

  void _scrollListener(ScrollController controller) {
    if (controller.offset > 200 && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
    } else if (controller.offset <= 200 && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
    }
    
    // Check if user is viewing their current timeline position
    _checkCurrentPositionVisibility(controller);
  }
  
  void _checkCurrentPositionVisibility(ScrollController controller) {
    try {
      final planController = Get.find<PlanController>();
      final currentIndex = planController.getCurrentTimelineIndex();
      
      // Use same calculation as initial position
      final headerHeight = 580.0;
      final itemHeight = 160.0;
      final targetPosition = headerHeight + (currentIndex * itemHeight);
      
      _currentTimelinePosition = targetPosition;
      
      // Check if current position is visible on screen
      final viewportHeight = MediaQuery.of(context).size.height;
      final currentScrollOffset = controller.offset;
      
      // Create a buffer zone around the current position - the green dotted line area
      final bufferZone = 80.0; // Larger buffer to account for the timeline item height
      final isCurrentPositionVisible = (targetPosition >= (currentScrollOffset - bufferZone)) && 
                                       (targetPosition <= (currentScrollOffset + viewportHeight + bufferZone));
      
      // Always show button unless we're viewing the current position
      final shouldShowButton = !isCurrentPositionVisible;
      
      if (shouldShowButton != _showCurrentPositionButton) {
        setState(() {
          _showCurrentPositionButton = shouldShowButton;
        });
      }
    } catch (e) {
      // If controller not found, always show button
      if (!_showCurrentPositionButton) {
        setState(() {
          _showCurrentPositionButton = true;
        });
      }
    }
  }

  void _scrollToTop(ScrollController controller) {
    controller.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  void _scrollToCurrentPosition(ScrollController controller) {
    // Calculate the viewport height to center the target position
    final viewportHeight = MediaQuery.of(context).size.height;
    final centeredPosition = _currentTimelinePosition - (viewportHeight / 2) + 80; // 80px offset for better centering
    
    controller.animateTo(
      centeredPosition.clamp(0.0, controller.position.maxScrollExtent),
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, y').format(DateTime.now());
    return GetBuilder<PlanController>(
        init: PlanController(),
        builder: (planController) {
          // Add scroll listener
          planController.scrollController.removeListener(() => _scrollListener(planController.scrollController));
          planController.scrollController.addListener(() => _scrollListener(planController.scrollController));
          
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                    child: CustomScrollView(
                  controller: planController.scrollController,
                  slivers: [
                    // Bottom padding
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                      ),
                    ),
                    // Third section with sticky header
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: SliverHeaderDelegate(
                        minHeight: getDynamicPlanHeader(context),
                        maxHeight: getDynamicPlanHeader(context),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextAutoSize(
                                    "Today • $todayDate",
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        planBtnBg,
                                        width: 240.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              "Personalized Quit Routine",
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
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
                                  "Instant Quit Plan",
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
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: false,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40.r),
                                        topRight: Radius.circular(40.r),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20.h),
                                          Container(
                                            width: 52.w,
                                            height: 5.w,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(24.r),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  height: 36.w,
                                                  width: 36.w,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xffFF611D).withOpacity(0.20)),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Color(0xffFF611D),
                                                      size: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 24.w,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          // Header Section
                                          Container(
                                            width: 86.w,
                                            height: 86.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: nicotrackLightGreen.withOpacity(0.2),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "📋",
                                                style: TextStyle(fontSize: 48.sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Text(
                                            "Your Quit Journey",
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              fontFamily: circularBold,
                                              color: nicotrackBlack1,
                                              height: 1.1,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                            decoration: BoxDecoration(
                                              color: nicotrackGreen.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              "Personalized Plan",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackGreen,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 24.h),
                                          // Main Content
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                                            padding: EdgeInsets.all(20.w),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF8F8F8),
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Column(
                                              children: [
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontFamily: circularBook,
                                                      height: 1.4,
                                                      color: nicotrackBlack1,
                                                    ),
                                                    children: [
                                                      TextSpan(text: "This plan is "),
                                                      TextSpan(
                                                        text: "designed specifically for you",
                                                        style: TextStyle(
                                                          fontFamily: circularBold,
                                                          color: nicotrackGreen,
                                                        ),
                                                      ),
                                                      TextSpan(text: " to help you successfully quit smoking. Follow the "),
                                                      TextSpan(
                                                        text: "timeline",
                                                        style: TextStyle(
                                                          fontFamily: circularMedium,
                                                          color: nicotrackOrange,
                                                        ),
                                                      ),
                                                      TextSpan(text: " to understand what to expect during your journey."),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 20.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 48.w,
                                                          height: 48.w,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: nicotrackOrange.withOpacity(0.15),
                                                          ),
                                                          child: Center(
                                                            child: Text("🎯", style: TextStyle(fontSize: 24.sp)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        Text(
                                                          "Track Progress",
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontFamily: circularMedium,
                                                            color: nicotrackBlack1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 48.w,
                                                          height: 48.w,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: nicotracklightBlue.withOpacity(0.15),
                                                          ),
                                                          child: Center(
                                                            child: Text("🏆", style: TextStyle(fontSize: 24.sp)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        Text(
                                                          "Earn Badges",
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontFamily: circularMedium,
                                                            color: nicotrackBlack1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 48.w,
                                                          height: 48.w,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: nicotrackPurple.withOpacity(0.15),
                                                          ),
                                                          child: Center(
                                                            child: Text("💪", style: TextStyle(fontSize: 24.sp)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        Text(
                                                          "Stay Strong",
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontFamily: circularMedium,
                                                            color: nicotrackBlack1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          // Disclaimer Section
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                                            padding: EdgeInsets.all(16.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16.r),
                                              border: Border.all(
                                                color: Color(0xFFE0E0E0),
                                                width: 1.w,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 32.w,
                                                  height: 32.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: nicotrackLightGreen.withOpacity(0.3),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "💡",
                                                      style: TextStyle(fontSize: 16.sp),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Important Note",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontFamily: circularBold,
                                                          color: nicotrackBlack1,
                                                          height: 1.1,
                                                        ),
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Text(
                                                        "Symptoms and effects vary from person to person. This timeline shows common experiences, but your journey is unique!",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontFamily: circularBook,
                                                          height: 1.3,
                                                          color: nicotrackBlack1.withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 54.w),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                                  "Info",
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
                          SizedBox(height: 28.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // planController.timelineTab('Timeline', 0),
                              SizedBox(width: 20.w),
                              // planController.timelineTab('Stage', 1),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 0),
                              planController.withdrawalTimeline(context),
                              SizedBox(height: 34.h),
                              AllBadgesSection(),
                              SizedBox(height: 24.h),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )),
              ],
            ),
            floatingActionButton: (_showFloatingButton || _showCurrentPositionButton)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Current position button (appears when not viewing current timeline position)
                      AnimatedOpacity(
                        opacity: _showCurrentPositionButton ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: AnimatedScale(
                          scale: _showCurrentPositionButton ? 1.0 : 0.8,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _showCurrentPositionButton
                              ? FloatingActionButton(
                                  onPressed: () => _scrollToCurrentPosition(planController.scrollController),
                                  backgroundColor: nicotrackBlack1,
                                  elevation: 8,
                                  heroTag: "currentPosition",
                                  child: Icon(
                                    FeatherIcons.target,
                                    color: Colors.white,
                                    size: 22.w,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                      // Add spacing only if both buttons are showing
                      if (_showCurrentPositionButton && _showFloatingButton)
                        SizedBox(width: 12.w),
                      // Scroll to top button (appears when scrolled down)
                      AnimatedOpacity(
                        opacity: _showFloatingButton ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: AnimatedScale(
                          scale: _showFloatingButton ? 1.0 : 0.8,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _showFloatingButton
                              ? FloatingActionButton(
                                  onPressed: () => _scrollToTop(planController.scrollController),
                                  backgroundColor: nicotrackBlack1,
                                  elevation: 8,
                                  heroTag: "scrollToTop",
                                  child: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                    size: 28.w,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                    ],
                  )
                : null,
          );
        });
  }
}
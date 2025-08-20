import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/emergency/emergency_craving_exercise_screen.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../../getx-controllers/emergency-craving-controller.dart';
import '../elements/textAutoSize.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class EmergencyCravingMotivationScreen extends StatefulWidget {
  const EmergencyCravingMotivationScreen({super.key});

  @override
  State<EmergencyCravingMotivationScreen> createState() =>
      _EmergencyCravingMotivationScreenState();
}

class _EmergencyCravingMotivationScreenState
    extends State<EmergencyCravingMotivationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 30,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmergencyCravingController>(
      init: EmergencyCravingController(),
      builder: (controller) {
        final motivationMessage = controller.getRandomMotivation(context);
        final emoji =
            controller.getEmojiForCategory(motivationMessage['category'] ?? '');

        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFFFAFAFA),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Emergency Badge
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      nicotrackOrange,
                                      // Color(0xFFFF6B6B),
                                      Color(0xFFFF8787),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFF6B6B).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.emergency,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    TextAutoSize(
                                      context.l10n.emergency_badge,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: circularBold,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // Close button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFEFEFEF),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              FeatherIcons.x,
                              size: 20.sp,
                              color: nicotrackBlack1.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated emoji with background
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Container(
                                  width: 140.w,
                                  height: 140.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        nicotrackGreen.withOpacity(0.1),
                                        nicotrackGreen.withOpacity(0.05),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer ring
                                      Container(
                                        width: 120.w,
                                        height: 120.w,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: nicotrackBlack1),
                                      ),
                                      // Emoji
                                      Text(
                                        emoji,
                                        style: TextStyle(fontSize: 60.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 40.h),

                          // Motivation message card
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _slideAnimation.value),
                                child: Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(24.w),
                                    decoration: BoxDecoration(
                                      color: nicotrackBlack1,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Color(0xFFEFEFEF),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 20,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // Quote icon
                                        Icon(
                                          Icons.format_quote,
                                          size: 28.sp,
                                          color:
                                              nicotrackGreen,
                                        ),
                                        SizedBox(height: 16.h),
                                        // Main message
                                        TextAutoSize(
                                          motivationMessage['message'] ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontFamily: circularBold,
                                            color: Colors.white,
                                            height: 1.2,
                                          ),
                                        ),
                                        if (motivationMessage['detail'] !=
                                            null) ...[
                                          SizedBox(height: 16.h),
                                          Container(
                                            width: 60.w,
                                            height: 2.h,
                                            decoration: BoxDecoration(
                                              color: nicotrackGreen,
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          TextAutoSize(
                                            motivationMessage['detail'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontFamily: circularBook,
                                              color: Colors.white
                                                  .withOpacity(0.7),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 32.h),

                          // Progress dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: 24.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: nicotrackBlack1,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE5E5E5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom CTA section
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Timer indicator
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FeatherIcons.clock,
                                size: 14.sp,
                                color: Colors.deepPurple.shade800,
                              ),
                              SizedBox(width: 6.w),
                              TextAutoSize(
                                context.l10n.emergency_motivation_duration,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: circularMedium,
                                  color: Colors.deepPurple.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Main CTA button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EmergencyCravingExerciseScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  nicotrackBlack1,
                                  nicotrackBlack1.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: nicotrackBlack1.withOpacity(0.2),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 10.w),
                                TextAutoSize(
                                  context.l10n.emergency_motivation_cta,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontFamily: circularBold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  FeatherIcons.arrowRight,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../../models/exercise_model.dart';
import '../../getx-controllers/emergency-craving-controller.dart';
import '../elements/textAutoSize.dart';
import '../exercises/guided_exercise_screen.dart';
import 'package:feather_icons/feather_icons.dart';
import 'dart:math' as math;
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import '../../services/exercise_translation_service.dart';

class EmergencyCravingExerciseScreen extends StatefulWidget {
  const EmergencyCravingExerciseScreen({super.key});

  @override
  State<EmergencyCravingExerciseScreen> createState() =>
      _EmergencyCravingExerciseScreenState();
}

class _EmergencyCravingExerciseScreenState
    extends State<EmergencyCravingExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.easeIn),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmergencyCravingController>(
      builder: (controller) {
        final ExerciseModel selectedExercise = controller.getRandomCravingExercise();
        
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
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Column(
                    children: [
                      // Header with back and close buttons
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.of(context).pop();
                              },
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
                                  FeatherIcons.arrowLeft,
                                  size: 20.sp,
                                  color: nicotrackBlack1,
                                ),
                              ),
                            ),
                            // Duration badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: nicotrackBlack1,
                                borderRadius: BorderRadius.circular(30),

                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    FeatherIcons.clock,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6.w),
                                  TextAutoSize(
                                    ExerciseTranslationService.getDuration(context, selectedExercise.id),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: circularBold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
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
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                children: [
                                  SizedBox(height: 20.h),
                                  
                                  // Title Section
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0F9FF),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextAutoSize(
                                      context.l10n.emergency_exercise_title,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: circularBold,
                                        color: Color(0xFF0EA5E9),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TextAutoSize(
                                    context.l10n.emergency_exercise_subtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: circularMedium,
                                      color: nicotrackBlack1.withOpacity(0.6),
                                      height: 1.3,
                                    ),
                                  ),
                                  
                                  SizedBox(height: 32.h),
                                  
                                  // Exercise Card
                                  Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: Color(0xFFEFEFEF),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 24,
                                            offset: Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // Exercise Header with Icon
                                          Container(
                                            padding: EdgeInsets.all(24.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(28),
                                                topRight: Radius.circular(28),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                // Animated Icon Container
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // Rotating background circle
                                                    AnimatedBuilder(
                                                      animation: _rotationAnimation,
                                                      builder: (context, child) {
                                                        return Transform.rotate(
                                                          angle: _rotationAnimation.value,
                                                          child: Container(
                                                            width: 120.w,
                                                            height: 120.w,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  nicotrackGreen.withOpacity(0.2),
                                                                  Colors.transparent,
                                                                  nicotrackOrange.withOpacity(0.2),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    // Main icon container
                                                    Container(
                                                      width: 100.w,
                                                      height: 100.w,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: nicotrackGreen.withOpacity(0.15),
                                                            blurRadius: 20,
                                                            offset: Offset(0, 8),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          selectedExercise.icon,
                                                          style: TextStyle(fontSize: 50.sp),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                
                                                SizedBox(height: 20.h),
                                                
                                                // Exercise Title
                                                TextAutoSize(
                                                  ExerciseTranslationService.getTitle(context, selectedExercise.id),
                                                  style: TextStyle(
                                                    fontSize: 24.sp,
                                                    fontFamily: circularBold,
                                                    color: nicotrackBlack1,
                                                  ),
                                                ),
                                                
                                                SizedBox(height: 8.h),
                                                
                                                // Phase indicator
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: nicotrackBlack1.withOpacity(0.05),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: TextAutoSize(
                                                    ExerciseTranslationService.getPhase(context, selectedExercise.id),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: circularMedium,
                                                      color: nicotrackBlack1.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Exercise Description
                                          Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: Column(
                                              children: [
                                                TextAutoSize(
                                                  ExerciseTranslationService.getDescription(context, selectedExercise.id),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontFamily: circularBook,
                                                    color: nicotrackBlack1.withOpacity(0.7),
                                                    height: 1.5,
                                                  ),
                                                ),
                                                
                                                SizedBox(height: 20.h),
                                                
                                                // Science Section
                                                Container(
                                                  padding: EdgeInsets.all(16.w),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        Color(0xFFF0F9FF),
                                                        Color(0xFFE0F2FE),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(16),
                                                    border: Border.all(
                                                      color: Color(0xFF0EA5E9).withOpacity(0.1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: 32.w,
                                                            height: 32.w,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.psychology_outlined,
                                                              size: 18.sp,
                                                              color: Color(0xFF0EA5E9),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.w),
                                                          TextAutoSize(
                                                            context.l10n.emergency_exercise_why_works,
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontFamily: circularBold,
                                                              color: Color(0xFF0EA5E9),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 12.h),
                                                      TextAutoSize(
                                                        ExerciseTranslationService.getScience(context, selectedExercise.id),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13.sp,
                                                          fontFamily: circularBook,
                                                          color: nicotrackBlack1.withOpacity(0.6),
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 24.h),
                                  
                                  // Progress indicator
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE5E5E5),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: 24.w,
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: nicotrackGreen,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 100.h), // Space for bottom buttons
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Bottom Action Section
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            // Start Exercise Button
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => GuidedExerciseScreen(
                                      exercise: selectedExercise,
                                    ),
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
                                    Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    TextAutoSize(
                                      context.l10n.emergency_exercise_start,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontFamily: circularBold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 12.h),
                            
                            // Try Different Exercise Button
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                controller.refreshRandomExercise();
                                setState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Color(0xFFEFEFEF),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FeatherIcons.refreshCw,
                                      color: nicotrackBlack1.withOpacity(0.6),
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 10.w),
                                    TextAutoSize(
                                      context.l10n.emergency_exercise_try_different,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: circularMedium,
                                        color: nicotrackBlack1.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
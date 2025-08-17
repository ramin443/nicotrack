import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../models/exercise_model.dart';
import '../elements/textAutoSize.dart';
import 'exercise_preparation_screen.dart';
import '../../services/exercise_translation_service.dart';
import '../../extensions/app_localizations_extension.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const ExerciseOverviewScreen({super.key, required this.exercise});

  @override
  State<ExerciseOverviewScreen> createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen>
    with SingleTickerProviderStateMixin {
  bool _learnMoreExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50,
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
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // Back button and title
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 60.w),
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
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
                                    FeatherIcons.chevronLeft,
                                    size: 18.sp,
                                    color: nicotrackBlack1.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      nicotrackBlack1,
                                      nicotrackBlack1.withOpacity(0.9),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: nicotrackBlack1.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FeatherIcons.zap,
                                      color: Colors.white,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    TextAutoSize(
                                      ExerciseTranslationService.getPhase(context, widget.exercise.id).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontFamily: circularBold,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.w),

                  // Exercise Icon and Title
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 160.w,
                          height: 160.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                nicotrackLightGreen.withOpacity(0.0),
                                nicotrackGreen.withOpacity(0.00),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring
                              Container(
                                width: 140.w,
                                height: 140.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: nicotrackGreen.withOpacity(0.0),
                                    width: 2,
                                  ),
                                ),
                              ),
                              // Emoji
                              Text(
                                widget.exercise.icon,
                                style: TextStyle(fontSize: 100.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            child: TextAutoSize(
                              ExerciseTranslationService.getTitle(context, widget.exercise.id),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontFamily: circularBold,
                                color: nicotrackBlack1,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.w),
                ],
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 0.5),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // What it does section
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    nicotrackBlack1,
                                    nicotrackBlack1.withOpacity(0.9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: nicotrackBlack1.withOpacity(0.15),
                                    blurRadius: 16,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36.w,
                                        height: 36.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '📖',
                                            style: TextStyle(fontSize: 18.sp),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      TextAutoSize(
                                        'What it does',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontFamily: circularBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.w),
                                  TextAutoSize(
                                    ExerciseTranslationService.getDescription(context, widget.exercise.id),
                                    style: TextStyle(
                                      fontSize: 14.5.sp,
                                      fontFamily: circularBook,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.w),

                            // The Science section
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: nicotrackBlack1,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: nicotrackLightGreen.withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: nicotrackGreen.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36.w,
                                        height: 36.w,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              nicotrackOrange.withOpacity(0.2),
                                              nicotrackGreen.withOpacity(0.1),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '🧠',
                                            style: TextStyle(fontSize: 18.sp),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      TextAutoSize(
                                        'The Science',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontFamily: circularBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.w),
                                  TextAutoSize(
                                    ExerciseTranslationService.getScience(context, widget.exercise.id),
                                    style: TextStyle(
                                      fontSize: 14.5.sp,
                                      fontFamily: circularBook,
                                      color: Colors.white,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.w),

                            // Duration section
                            Container(
                              padding: EdgeInsets.all(22.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    nicotrackOrange.withOpacity(0.1),
                                    nicotrackOrange.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: nicotrackOrange.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: nicotrackOrange.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        FeatherIcons.clock,
                                        size: 18.sp,
                                        color: nicotrackOrange,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                              height: 1.3,
                                              fontSize: 17.sp,
                                              fontFamily: circularMedium,
                                              color: nicotrackBlack1,
                                            ),
                                            children: [
                                          TextSpan(text: 'Duration: '),
                                          TextSpan(
                                            text: widget
                                                .exercise.detailedDuration,
                                            style: TextStyle(
                                              height: 1.3,
                                              fontSize: 17.sp,
                                              fontFamily: circularBold,
                                              color: nicotrackOrange,
                                            ),
                                          ),
                                        ])),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.w),

                            // Learn More expandable
                            if (_learnMoreExpanded) ...[
                              Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextAutoSize(
                                      'Exercise Steps',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: circularBold,
                                        color: nicotrackBlack1,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    ...widget.exercise.exerciseSteps
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final step = entry.value;
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 24.w,
                                              height: 24.w,
                                              decoration: BoxDecoration(
                                                color: nicotrackBlack1,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: TextAutoSize(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily: circularBold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextAutoSize(
                                                    ExerciseTranslationService.getExerciseSteps(context, widget.exercise.id)[index],
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily:
                                                          circularMedium,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  if (step.durationSeconds > 0)
                                                    TextAutoSize(
                                                      '${step.durationSeconds} seconds',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontFamily:
                                                            circularBook,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                            ],

                            // Learn More button
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _learnMoreExpanded = !_learnMoreExpanded;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: nicotrackBlack1.withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _learnMoreExpanded
                                          ? FeatherIcons.eyeOff
                                          : FeatherIcons.eye,
                                      color: nicotrackBlack1.withOpacity(0.7),
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 10.w),
                                    TextAutoSize(
                                      _learnMoreExpanded
                                          ? 'Show Less'
                                          : 'Learn More',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: circularMedium,
                                        color: nicotrackBlack1,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      _learnMoreExpanded
                                          ? FeatherIcons.chevronUp
                                          : FeatherIcons.chevronDown,
                                      color: nicotrackBlack1.withOpacity(0.5),
                                      size: 18.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 24,
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Duration indicator
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FeatherIcons.clock,
                      size: 14.sp,
                      color: nicotrackBlack1.withOpacity(0.5),
                    ),
                    SizedBox(width: 6.w),
                    TextAutoSize(
                      ExerciseTranslationService.getDetailedDuration(context, widget.exercise.id),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: circularMedium,
                        color: nicotrackBlack1.withOpacity(0.6),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExercisePreparationScreen(exercise: widget.exercise),
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
                        FeatherIcons.play,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      TextAutoSize(
                        'Start Exercise',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: circularBold,
                          color: Colors.white,
                          letterSpacing: 0.3,
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
      ),
    );
  }
}
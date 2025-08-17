import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../models/exercise_model.dart';
import '../elements/textAutoSize.dart';
import 'guided_exercise_screen.dart';
import 'package:flutter/services.dart';
import '../../services/exercise_translation_service.dart';
import '../../extensions/app_localizations_extension.dart';

class ExercisePreparationScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const ExercisePreparationScreen({super.key, required this.exercise});

  @override
  State<ExercisePreparationScreen> createState() =>
      _ExercisePreparationScreenState();
}

class _ExercisePreparationScreenState extends State<ExercisePreparationScreen> 
    with TickerProviderStateMixin {
  List<bool> _checkedSteps = [];
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    
    _checkedSteps = List.generate(
      3 + 1, // 3 preparation steps + 1 for the default step
      (index) => false,
    );

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
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
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 40,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allStepsChecked = _checkedSteps.every((checked) => checked);

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
              // Header
              SizedBox(height: 20.h),
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
                                FeatherIcons.x,
                                size: 18.sp,
                                color: nicotrackBlack1.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.w),

              // Get Ready Icon and Title
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            nicotrackOrange.withOpacity(0.15),
                            nicotrackOrange.withOpacity(0.08),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: nicotrackOrange.withOpacity(0.15),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: nicotrackOrange.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          // Emoji with pulse animation
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Text(
                                  '🎯',
                                  style: TextStyle(fontSize: 50.sp),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 22.w),
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          TextAutoSize(
                            'Get Ready',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextAutoSize(
                            'Prepare for ${ExerciseTranslationService.getTitle(context, widget.exercise.id)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularMedium,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40.h),

              // Preparation Steps
              Expanded(
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.5),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              // Default preparation step
                              _buildChecklistItem(
                                0,
                                'Take a moment to focus on your intention',
                                isDefault: true,
                              ),
                              SizedBox(height: 8.w),

                              // Exercise-specific preparation steps
                              ...ExerciseTranslationService.getPreparationSteps(context, widget.exercise.id)
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key + 1; // +1 because of default step
                                final step = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.w),
                                  child: _buildChecklistItem(index, step),
                                );
                              }),

                              SizedBox(height: 20.h),

                              // Tips section
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
                                              '💡',
                                              style: TextStyle(fontSize: 18.sp),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        TextAutoSize(
                                          'Pro Tip',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: circularBold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    TextAutoSize(
                                      'This exercise works best when you\'re fully present. Take your time with each step and breathe deeply.',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: circularBook,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
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
              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: allStepsChecked 
                          ? nicotrackLightGreen
                          : Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          allStepsChecked ? FeatherIcons.checkCircle : FeatherIcons.clock,
                          size: 14.sp,
                          color: allStepsChecked 
                              ? nicotrackGreen
                              : nicotrackBlack1.withOpacity(0.5),
                        ),
                        SizedBox(width: 6.w),
                        TextAutoSize(
                          allStepsChecked 
                              ? 'All steps completed'
                              : '${_checkedSteps.where((c) => c).length}/${_checkedSteps.length} completed',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: circularMedium,
                            color: allStepsChecked 
                                ? nicotrackGreen
                                : nicotrackBlack1.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Main CTA button
              GestureDetector(
                onTap: allStepsChecked
                    ? () {
                        HapticFeedback.heavyImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GuidedExerciseScreen(exercise: widget.exercise),
                          ),
                        );
                      }
                    : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: allStepsChecked
                        ? LinearGradient(
                            colors: [
                              nicotrackBlack1,
                              nicotrackBlack1.withOpacity(0.9),
                            ],
                          )
                        : null,
                    color: allStepsChecked ? null : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: allStepsChecked
                        ? [
                            BoxShadow(
                              color: nicotrackBlack1.withOpacity(0.2),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (allStepsChecked) ...[
                        Icon(
                          FeatherIcons.zap,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                      ],
                      TextAutoSize(
                        allStepsChecked ? 'I\'m Ready' : 'Complete all steps first',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: circularBold,
                          color: allStepsChecked ? Colors.white : Colors.grey[500],
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (allStepsChecked) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          FeatherIcons.arrowRight,
                          color: Colors.white.withOpacity(0.8),
                          size: 18.sp,
                        ),
                      ],
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

  Widget _buildChecklistItem(int index, String text, {bool isDefault = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() {
          _checkedSteps[index] = !_checkedSteps[index];
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: _checkedSteps[index]
              ? LinearGradient(
                  colors: [
                    nicotrackBlack1,
                    nicotrackBlack1.withOpacity(0.9),
                  ],
                )
              : null,
          color: _checkedSteps[index] ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _checkedSteps[index] 
                ? nicotrackLightGreen.withOpacity(0.3)
                : Colors.grey[200]!,
            width: _checkedSteps[index] ? 1.5 : 1.0,
          ),
          boxShadow: _checkedSteps[index]
              ? [
                  BoxShadow(
                    color: nicotrackBlack1.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                gradient: _checkedSteps[index]
                    ? LinearGradient(
                        colors: [
                          nicotrackLightGreen,
                          nicotrackGreen,
                        ],
                      )
                    : null,
                color: _checkedSteps[index] ? null : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _checkedSteps[index]
                      ? Colors.transparent
                      : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: _checkedSteps[index]
                    ? [
                        BoxShadow(
                          color: nicotrackLightGreen.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: _checkedSteps[index]
                  ? Icon(
                      FeatherIcons.check,
                      size: 14.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAutoSize(
                    text,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: _checkedSteps[index] 
                          ? circularMedium 
                          : circularBook,
                      color: _checkedSteps[index] 
                          ? Colors.white 
                          : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  if (isDefault && !_checkedSteps[index])
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: TextAutoSize(
                        'Essential first step',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: circularBook,
                          color: nicotrackOrange.withOpacity(0.8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_checkedSteps[index])
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  FeatherIcons.checkCircle,
                  size: 16.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
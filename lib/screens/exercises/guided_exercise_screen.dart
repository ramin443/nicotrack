import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../models/exercise_model.dart';
import '../elements/textAutoSize.dart';
import '../../services/exercise_translation_service.dart';
import '../../extensions/app_localizations_extension.dart';

class GuidedExerciseScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const GuidedExerciseScreen({super.key, required this.exercise});

  @override
  State<GuidedExerciseScreen> createState() => _GuidedExerciseScreenState();
}

class _GuidedExerciseScreenState extends State<GuidedExerciseScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _currentStepIndex = 0;
  int _currentStepTime = 0;
  int _totalElapsedTime = 0;
  bool _isPaused = false;
  bool _isCompleted = false;
  
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startExercise();
  }
  
  void _setupAnimation() {
    _breathingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    // Setup progress animation controller
    _progressController = AnimationController(
      duration: Duration(seconds: 1), // 1 second for smooth transitions
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.exercise.timerType == ExerciseTimerType.cycle) {
      _breathingController.repeat(reverse: true);
    }
  }
  
  void _startExercise() {
    // Trigger haptic feedback when exercise starts
    HapticFeedback.heavyImpact();
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentStepTime++;
          _totalElapsedTime++;
          
          // Animate progress to new value
          _animateProgressToCurrentValue();
          
          final currentStep = widget.exercise.exerciseSteps[_currentStepIndex];
          if (_currentStepTime >= currentStep.durationSeconds) {
            if (_currentStepIndex < widget.exercise.exerciseSteps.length - 1) {
              _currentStepIndex++;
              _currentStepTime = 0;
              
              // Trigger heavy haptic feedback when step changes
              HapticFeedback.heavyImpact();
              
              // For cycle exercises, restart when reaching the end
              if (widget.exercise.timerType == ExerciseTimerType.cycle &&
                  _currentStepIndex == widget.exercise.exerciseSteps.length - 1) {
                // Check if we should continue cycling
                if (_totalElapsedTime < 180) { // 3 minutes max
                  Future.delayed(Duration(seconds: currentStep.durationSeconds), () {
                    if (mounted) {
                      setState(() {
                        _currentStepIndex = 0;
                        _currentStepTime = 0;
                        _animateProgressToCurrentValue();
                        // Trigger haptic feedback for cycle restart too
                        HapticFeedback.heavyImpact();
                      });
                    }
                  });
                }
              }
            } else {
              _completeExercise();
            }
          }
        });
      }
    });
  }
  
  void _animateProgressToCurrentValue() {
    final newProgress = _calculateProgress();
    
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _progressController.reset();
    _progressController.forward();
  }
  
  double _calculateProgress() {
    final totalDuration = widget.exercise.exerciseSteps
        .fold(0, (sum, step) => sum + step.durationSeconds);
    final elapsedInCurrentCycle = widget.exercise.exerciseSteps
        .take(_currentStepIndex)
        .fold(0, (sum, step) => sum + step.durationSeconds) + _currentStepTime;
    return elapsedInCurrentCycle / totalDuration;
  }
  
  void _completeExercise() {
    _timer?.cancel();
    setState(() {
      _isCompleted = true;
    });
    // Trigger celebratory haptic feedback when exercise completes
    HapticFeedback.heavyImpact();
    _showCompletionDialog();
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎉',
                style: TextStyle(fontSize: 60.sp),
              ),
              SizedBox(height: 16.h),
              TextAutoSize(
                'Great Job!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: circularBold,
                  color: nicotrackBlack1,
                ),
              ),
              SizedBox(height: 8.h),
              TextAutoSize(
                'You\'ve completed ${ExerciseTranslationService.getTitle(context, widget.exercise.id)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  // Use a delay to ensure the dialog is fully closed
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted) {
                      Navigator.of(context).pop(); // Go back to overview
                      Navigator.of(context).pop(); // Go back to activity
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: nicotrackBlack1,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: TextAutoSize(
                      'Done',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _breathingController.stop();
      } else {
        _breathingController.repeat(reverse: true);
      }
    });
  }
  
  void _restart() {
    setState(() {
      _currentStepIndex = 0;
      _currentStepTime = 0;
      _totalElapsedTime = 0;
      _isPaused = false;
      _isCompleted = false;
    });
    _timer?.cancel();
    _progressController.reset();
    _animateProgressToCurrentValue();
    _startExercise();
  }
  
  void _stop() {
    // Cancel timer first to prevent any state updates
    _timer?.cancel();
    _breathingController.stop();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: TextAutoSize(
          'Stop Exercise?',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
          ),
        ),
        content: TextAutoSize(
          'Are you sure you want to stop this exercise?',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: circularBook,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Restart the timer if continuing
              _startExercise();
              if (widget.exercise.timerType == ExerciseTimerType.cycle && !_isPaused) {
                _breathingController.repeat(reverse: true);
              }
            },
            child: TextAutoSize(
              'Continue',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: circularMedium,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Use a delay to ensure the dialog is fully closed
              Future.delayed(Duration(milliseconds: 100), () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              });
            },
            child: TextAutoSize(
              'Stop',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: circularMedium,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _breathingController.dispose();
    _progressController.dispose();
    super.dispose();
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  
  
  @override
  Widget build(BuildContext context) {
    final currentStep = widget.exercise.exerciseSteps[_currentStepIndex];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextAutoSize(
                    ExerciseTranslationService.getTitle(context, widget.exercise.id),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  GestureDetector(
                    onTap: _stop,
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            
            // Main Timer Display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visual Animation (for breathing exercises)
                  if (widget.exercise.timerType == ExerciseTimerType.cycle)
                    AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _breathingAnimation.value,
                          child: Container(
                            width: 150.w,
                            height: 150.w,
                            decoration: BoxDecoration(
                              color: nicotrackGreen.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  color: nicotrackGreen.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.exercise.icon,
                                    style: TextStyle(fontSize: 50.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Text(
                      widget.exercise.icon,
                      style: TextStyle(fontSize: 80.sp),
                    ),
                  
                  SizedBox(height: 40.h),
                  
                  // Timer Display
                  TextAutoSize(
                    _formatTime(_currentStepTime),
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Progress Bar
                  Container(
                    width: 280.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              nicotrackBlack1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Current Step Instruction
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '📝',
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            SizedBox(width: 8.w),
                            TextAutoSize(
                              'Current Step',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: circularMedium,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        TextAutoSize(
                          ExerciseTranslationService.getExerciseSteps(context, widget.exercise.id)[_currentStepIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: circularBold,
                            color: nicotrackBlack1,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Control Buttons
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Restart Button
                  GestureDetector(
                    onTap: _restart,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.refresh,
                        size: 28.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  
                  // Pause/Play Button
                  GestureDetector(
                    onTap: _togglePause,
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: nicotrackBlack1,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPaused ? Icons.play_arrow : Icons.pause,
                        size: 36.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  
                  // Stop Button
                  GestureDetector(
                    onTap: _stop,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.stop,
                        size: 28.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
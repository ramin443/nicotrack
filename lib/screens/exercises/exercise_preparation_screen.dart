import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../models/exercise_model.dart';
import '../elements/textAutoSize.dart';
import 'guided_exercise_screen.dart';
import 'package:flutter/services.dart';

class ExercisePreparationScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const ExercisePreparationScreen({super.key, required this.exercise});

  @override
  State<ExercisePreparationScreen> createState() =>
      _ExercisePreparationScreenState();
}

class _ExercisePreparationScreenState extends State<ExercisePreparationScreen> {
  List<bool> _checkedSteps = [];

  @override
  void initState() {
    super.initState();
    _checkedSteps = List.generate(
      widget.exercise.preparationSteps.length + 1, // +1 for the default step
      (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allStepsChecked = _checkedSteps.every((checked) => checked);

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
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Get Ready Icon and Title
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: nicotrackOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '🎯',
                  style: TextStyle(fontSize: 40.sp),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextAutoSize(
              'Get Ready',
              style: TextStyle(
                fontSize: 28.sp,
                fontFamily: circularBold,
                color: nicotrackBlack1,
              ),
            ),
            SizedBox(height: 8.h),
            TextAutoSize(
              'Prepare for ${widget.exercise.title}',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: circularMedium,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40.h),

            // Preparation Steps
            Expanded(
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
                    SizedBox(height: 6.w),

                    // Exercise-specific preparation steps
                    ...widget.exercise.preparationSteps
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key + 1; // +1 because of default step
                      final step = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6.w),
                        child: _buildChecklistItem(index, step),
                      );
                    }).toList(),

                    SizedBox(height: 20.h),

                    // Tips section
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: nicotrackBlack1,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: nicotrackLightGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   '💡',
                          //   style: TextStyle(fontSize: 26.sp),
                          // ),
                          // SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextAutoSize(
                                  '💡 Tip',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: circularBold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.w),
                                TextAutoSize(
                                  'This exercise works best when you\'re fully present. Take your time with each step.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: circularBook,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              ],
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 20,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: allStepsChecked
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GuidedExerciseScreen(exercise: widget.exercise),
                      ),
                    );
                  }
                : null,
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: allStepsChecked ? nicotrackBlack1 : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: TextAutoSize(
                  'I\'m Ready',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: allStepsChecked ? Colors.white : Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
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
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: _checkedSteps[index] ? nicotrackBlack1 : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                _checkedSteps[index] ? nicotrackLightGreen : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color:
                    _checkedSteps[index] ? nicotrackLightGreen : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _checkedSteps[index]
                      ? nicotrackLightGreen
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: _checkedSteps[index]
                  ? Icon(
                      Icons.check,
                      size: 14.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextAutoSize(
                text,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily:
                      _checkedSteps[index] ? circularMedium : circularBook,
                  color: _checkedSteps[index] ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
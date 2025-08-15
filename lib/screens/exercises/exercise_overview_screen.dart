import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../models/exercise_model.dart';
import '../elements/textAutoSize.dart';
import 'exercise_preparation_screen.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const ExerciseOverviewScreen({super.key, required this.exercise});

  @override
  State<ExerciseOverviewScreen> createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  bool _learnMoreExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // Back button and title
            SliverToBoxAdapter(
              child: Column(
                children: [
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
                              Icons.arrow_back_ios_new,
                              size: 18.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: nicotrackBlack1.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextAutoSize(
                            widget.exercise.phase,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.w),

                  // Exercise Icon and Title
                  Text(
                    widget.exercise.icon,
                    style: TextStyle(fontSize: 120.sp),
                  ),
                  SizedBox(height: 5.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: TextAutoSize(
                      widget.exercise.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.w),
                ],
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // What it does section
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 16.w, bottom: 22.w),
                      decoration: BoxDecoration(
                        color: nicotrackBlack1,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '📖',
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              SizedBox(width: 8.w),
                              TextAutoSize(
                                'What it does',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: circularBold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.w),
                          TextAutoSize(
                            widget.exercise.description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularBook,
                              color: Colors.white.withOpacity(0.87),
                              height: 1.2,
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
                        color: nicotrackLightGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '🧠',
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              SizedBox(width: 8.w),
                              TextAutoSize(
                                'The Science',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: circularBold,
                                  color: nicotrackBlack1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.w),
                          TextAutoSize(
                            widget.exercise.science,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularBook,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.w),

                    // Duration section
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: nicotrackOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '⏱️',
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      height: 1.2,
                                      fontSize: 16.sp,
                                      fontFamily: circularMedium,
                                      color: nicotrackBlack1,
                                    ),
                                    children: [
                                      TextSpan(text: 'Duration: '),
                                      TextSpan(
                                        text: widget.exercise.detailedDuration,
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: 16.sp,
                                          fontFamily: circularMedium,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            step.instruction,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: circularMedium,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (step.durationSeconds > 0)
                                            TextAutoSize(
                                              '${step.durationSeconds} seconds',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularBook,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Learn More button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _learnMoreExpanded = !_learnMoreExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: nicotrackBlack1),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextAutoSize(
                              _learnMoreExpanded ? '     Show Less' : '    Learn More',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: circularMedium,
                                color: nicotrackBlack1,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              _learnMoreExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: nicotrackBlack1,
                              size: 20.sp,
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ExercisePreparationScreen(exercise: widget.exercise),
                ),
              );
            },
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: nicotrackBlack1,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: TextAutoSize(
                  'Start Exercise',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: Colors.white,
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
}
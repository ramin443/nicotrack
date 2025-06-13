import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-section.dart';

class ProgressSavings extends StatefulWidget {
  const ProgressSavings({super.key});

  @override
  State<ProgressSavings> createState() => _ProgressSavingsState();
}

class _ProgressSavingsState extends State<ProgressSavings> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        builder: (progressController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              progressController.savingsDisplayCards(),
              SizedBox(
                height: 26.h,
              ),
              FinancialGoalsSection(),
              SizedBox(
                height: 26.h,
              ),
            ],
          );
        });
  }
}
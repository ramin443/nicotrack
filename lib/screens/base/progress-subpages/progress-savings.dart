import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-section.dart';

class ProgressSavings extends StatefulWidget {
  final bool isUserPremium;
  
  const ProgressSavings({super.key, required this.isUserPremium});

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
              progressController.savingsDisplayCards(context),
              SizedBox(
                height: 26.h,
              ),
              FinancialGoalsSection(isUserPremium: widget.isUserPremium),
              SizedBox(
                height: 26.h,
              ),
            ],
          );
        });
  }
}
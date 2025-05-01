import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/4x4-alt-scroll-view.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/dummy-data-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../elements/textAutoSize.dart';

class SymptomsHealedFrom extends StatefulWidget {
  const SymptomsHealedFrom({super.key});

  @override
  State<SymptomsHealedFrom> createState() => _SymptomsHealedFromState();
}

class _SymptomsHealedFromState extends State<SymptomsHealedFrom> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18.w,
                  ),
                  SizedBox(
                    width: 150.w,
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: const Color(0xFFFF611D)),
                            children: [
                              TextSpan(
                                text: "📈 Symptoms ",
                              ),
                              TextSpan(
                                text: "eased & healed from",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularBold,
                                    height: 1.1,
                                    color: nicotrackBlack1),
                              ),
                            ])),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              FourxFourAltScrollView(
                scrollController:
                progressController.symptomsHealedScrollController,
                items: symptomsEasedOrHealedFromDummyData,
                childAspectRatio: 2.6,
              ),

            ],
          );
        });
  }
}
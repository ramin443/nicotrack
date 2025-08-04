import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';

class EnterName extends StatefulWidget {
  const EnterName({super.key});

  @override
  State<EnterName> createState() => _EnterNameState();
}

class _EnterNameState extends State<EnterName> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        builder: (onboardingController) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 64.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 6.w,
                      ),
                      TextAutoSize(
                        context.l10n.enter_name_subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          height: 1.2,
                          fontFamily: circularMedium,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  TextAutoSize(
                    context.l10n.enter_name_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.sp,
                      height: 1.2,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  SizedBox(height: 18.h,),
                  onboardingController.nameTextField(),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                ],
              ));
        });
  }
}

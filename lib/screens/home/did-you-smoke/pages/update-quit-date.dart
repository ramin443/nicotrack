import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class UpdateQuitDate extends StatefulWidget {
  const UpdateQuitDate({super.key});

  @override
  State<UpdateQuitDate> createState() => _UpdateQuitDateState();
}

class _UpdateQuitDateState extends State<UpdateQuitDate> {
  String getActualQuitDate() {
    final box = Hive.box<OnboardingData>('onboardingCompletedData');
    OnboardingData? userOnboardingData = box.get('currentUserOnboarding');
    
    if (userOnboardingData != null && userOnboardingData.lastSmokedDate != "") {
      DateTime parsedDate = DateTime.parse(userOnboardingData.lastSmokedDate);
      return DateFormat('MMMM d, yyyy').format(parsedDate);
    }
    
    // Fallback to current date if no data found
    return DateFormat('MMMM d, yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        builder: (didYouSmokeController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 18.h,
              ),
              SizedBox(
                width: 227.w,
                child: TextAutoSize(
                  context.l10n.update_quit_date_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 26.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              SizedBox(
                width: 220.w,
                child: RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(children: [
                  TextSpan(
                      text: context.l10n.update_quit_date_description,
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 13.sp,
                          fontFamily: circularBook,
                          color: Color(0xff979797))),
                  TextSpan(
                      text: getActualQuitDate(),
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 13.sp,
                          fontFamily: circularBold,
                          color: Colors.black87)),
                  TextSpan(
                      text: context.l10n.update_quit_date_question,
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 13.sp,
                          fontFamily: circularBook,
                          color: Color(0xff979797))),
                ])),
              ),
              SizedBox(
                height: 46.h,
              ),
              didYouSmokeController.updateQuitDateSelection(context),
              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}
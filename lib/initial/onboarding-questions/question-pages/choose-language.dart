import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        builder: (onboardingController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 26.h,
              ),
              SizedBox(
                width: 340.w,
                child: TextAutoSize(
                  context.l10n.onboarding_choose_language,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 24.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Container(
                height: 420.w,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.transparent, width: 1),
                ),
                child: CupertinoPicker(
                  scrollController: onboardingController.languageController,
                  itemExtent: 60.w,
                  onSelectedItemChanged: (index) {
                    onboardingController.selectedLanguageIndex = index;
                    onboardingController.getCurrentPageStatus();
                  },
                  children:
                      onboardingController.supportedLanguages.map((language) {
                    return Center(
                      child: TextAutoSize(
                        '${language['flag']} ${language['name']}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: circularMedium,
                          color: nicotrackBlack1,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SizedBox(
                    width: 250.w,
                    child: TextAutoSize(
                      context.l10n.onboarding_language_subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 16.sp,
                        fontFamily: circularBook,
                        color: Colors.grey[600],
                      ),
                    ),
                  )),
            ],
          );
        });
  }
}
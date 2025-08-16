import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/initial/welcome-info/info-slider-main.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/screens/base/base.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  OnboardingData? onboardingData;

  @override
  void initState() {
    super.initState();
    navigateToBaseorHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              splashLogo,
              width: 164.w,
            ),
            SizedBox(height: 18.h),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 34.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1,
                ),
                children: [
                  TextSpan(
                    text: "Nico",
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontFamily: circularMedium,
                      color: Colors.black26,
                    ),
                  ),
                  TextSpan(text: "track"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToBaseorHome() async {
    // Minimum display time for splash screen (reduced from 3000ms)
    final minDisplayTime = Future.delayed(const Duration(milliseconds: 800));
    
    // Check onboarding status
    final box = Hive.box<OnboardingData>('onboardingCompletedData');
    OnboardingData? capturedData = box.get('currentUserOnboarding');
    
    // Wait for minimum display time
    await minDisplayTime;
    
    if (!mounted) return;
    
    // Navigate based on onboarding status
    if (capturedData != null) {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const Base(),
          settings: const RouteSettings(name: 'exerciseBackdrop'),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const InfoSliderMain(),
          settings: const RouteSettings(name: 'exerciseBackdrop'),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
        ),
        (route) => false,
      );
    }
  }
}
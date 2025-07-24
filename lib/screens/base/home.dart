import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/home-controller.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        initState: (state) {
          // Refresh data when the widget is initialized
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<HomeController>().resetHomeGridValues();
          });
        },
        builder: (homeController) {
          return GetBuilder<PremiumController>(
              init: PremiumController(),
              initState: (state) {},
              builder: (premiumController) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 65.h,
                        ),
                        Builder(builder: (context) {
                          String fullName =
                              homeController.currentDateOnboardingData.name;
                          String firstName = fullName.contains(" ")
                              ? fullName.substring(0, fullName.indexOf(" "))
                              : fullName;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 24.w,
                                  ),
                                  TextAutoSize(
                                    "Hello,\n${firstName}",
                                    style: TextStyle(
                                        height: 1.2,
                                        fontSize: 28.sp,
                                        fontFamily: circularBold,
                                        color: nicotrackBlack1),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PremiumPaywallScreen(),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      // Ensures everything centers by default
                                      children: [
                                        Positioned(
                                            child: SvgPicture.asset(
                                          premiumBtnBg,
                                          width: 102.w,
                                        )),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 2.h),
                                          width: 112.w,
                                          child: Center(
                                            child: TextAutoSize(
                                              "Get Pro",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontFamily: recoletaBold,
                                                  color: nicotrackBlack1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24.w,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        SizedBox(
                          height: 8.w,
                        ),
                        homeController.weeklyCalendarView(context),
                        SizedBox(
                          height: 14.w,
                        ),
                        homeController.homeGridView(),
                        premiumController.isPremium.value
                            ? SizedBox.shrink()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12.w,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    child: premiumBox(context),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 28.w,
                        ),
                        homeController.dailyTasksSection(
                            context: context,
                            isUserPremium: premiumController.isPremium.value),
                        SizedBox(
                          height: 12.w,
                        ),
                        homeController.peronalizedQuitRoutine(),
                        SizedBox(
                          height: 40.w,
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/home-controller.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../elements/textAutoSize.dart';

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
        initState: (v) {},
        builder: (homeController) {
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
                    String firstName =
                        fullName.substring(0, fullName.indexOf(" "));
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
                              onTap: () async {},
                              child: Stack(
                                alignment: Alignment.center,
                                // Ensures everything centers by default
                                children: [
                                  Positioned(
                                      child: SvgPicture.asset(
                                    premiumBtnBg,
                                    width: 112.w,
                                  )),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    width: 112.w,
                                    child: Center(
                                      child: TextAutoSize(
                                        "Premium",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: circularMedium,
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
                    height: 8.h,
                  ),
                  homeController.weeklyCalendarView(context),
                  SizedBox(
                    height: 14.h,
                  ),
                  homeController.homeGridView(),
                  SizedBox(
                    height: 28.h,
                  ),
                  homeController.dailyTasksSection(context),
                  SizedBox(
                    height: 12.h,
                  ),
                  homeController.peronalizedQuitRoutine(),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
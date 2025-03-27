import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/home-controller.dart';

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
      initState: (v){
      },
      builder: (homeController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body:  SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 65.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 24.w,),
                          TextAutoSize(
                            "Hello,\nJack",
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
                          Stack(
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
                          SizedBox(width: 24.w,),
                        ],
                      ),
            
                    ],
                  ),
                  SizedBox(height: 8.h,),
                  homeController.weeklyCalendarView(),
                  SizedBox(height: 14.h,),
                  homeController.homeGridView(),
                  SizedBox(height: 22.h,),
                ],
              ),
          ),
        );
      }
    );
  }
}
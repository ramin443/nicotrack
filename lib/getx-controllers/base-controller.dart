import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/base/home.dart';
import 'package:nicotrack/screens/base/plan-alt.dart';
import 'package:nicotrack/screens/base/plan.dart';
import 'package:nicotrack/screens/base/settings.dart';

import '../constants/font-constants.dart';
import '../constants/image-constants.dart';
import '../screens/base/progress.dart';
import '../screens/elements/textAutoSize.dart';

class BaseController extends GetxController {
  int selectedIndex = 0;
  List<Widget> mainPages = [Home(), PlanAlt(), ProgressMain(), Settings()];

  void setCurrentIndex(index) {
    selectedIndex = index;
    update();
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
        onTap: (index) {
          setCurrentIndex(index);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                SvgPicture.asset(
                    selectedIndex == 0 ? homeIconSelected : homeIconUnselected,
                    width: 20.sp),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Home',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 0 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Column(
              children: [
                Icon(
                  FeatherIcons.calendar,
                  size: 22.sp,
                  color: selectedIndex == 1 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Plan',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 1 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Column(
              children: [
                Icon(
                  FeatherIcons.pieChart,
                  size: 22.sp,
                  color: selectedIndex == 2 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Progress',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 2 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(
                  FeatherIcons.sliders,
                  size: 22.sp,
                  color: selectedIndex == 3 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 3 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
        ]);
  }

  Widget bottomBavBar2() {
    return NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setCurrentIndex(index);
        },
        height: 62.h,
        // Custom height if you want to shrink it even more
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                SvgPicture.asset(
                    selectedIndex == 0 ? homeIconSelected : homeIconUnselected,
                    width: 20.sp),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Home',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 0 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Icon(
                  FeatherIcons.calendar,
                  size: 22.sp,
                  color: selectedIndex == 1 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Plan',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 1 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Icon(
                  FeatherIcons.pieChart,
                  size: 22.sp,
                  color: selectedIndex == 2 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Progress',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 2 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Icon(
                  FeatherIcons.sliders,
                  size: 22.sp,
                  color: selectedIndex == 3 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color:
                          selectedIndex == 3 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
        ]);
  }
}
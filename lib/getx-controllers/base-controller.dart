import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/base/home.dart';
import 'package:nicotrack/screens/base/activity.dart';
import 'package:nicotrack/screens/base/plan-alt.dart';
import 'package:nicotrack/screens/base/settings.dart';

import '../constants/font-constants.dart';
import '../constants/image-constants.dart';
import '../constants/quick-function-constants.dart';
import '../screens/base/progress.dart';
import '../screens/elements/textAutoSize.dart';

class BaseController extends GetxController {
  int selectedIndex = 0;
  List<Widget> mainPages = [Home(), PlanAlt(), Activity(), ProgressMain(), Settings()];

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
                    width: 18.sp),
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
                  size: 20.sp,
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
                  FeatherIcons.activity,
                  size: 18.sp,
                  color: selectedIndex == 2 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.h,
                ),
                TextAutoSize('Activity',
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
            backgroundColor: Colors.white,
            icon: Column(
              children: [
                Icon(
                  FeatherIcons.pieChart,
                  size: 18.sp,
                  color: selectedIndex == 3 ? Colors.black87 : Colors.black54,
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
                          selectedIndex == 3 ? Colors.black87 : Colors.black54,
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
                  size: 18.sp,
                  color: selectedIndex == 4 ? Colors.black87 : Colors.black54,
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
                          selectedIndex == 4 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
        ]);
  }

  Widget bottomBavBar2(BuildContext context) {
    return NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setCurrentIndex(index);
        },
        height: getBottomNavHeight(context),
        // Custom height if you want to shrink it even more
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Column(
              children: [
                SizedBox(
                  height: 16.w,
                ),
                SvgPicture.asset(
                    selectedIndex == 0 ? homeIconSelected : homeIconUnselected,
                    width: 20.sp),
                SizedBox(
                  height: 7.w,
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
                  height: 16.w,
                ),
                Icon(
                  FeatherIcons.calendar,
                  size: 22.sp,
                  color: selectedIndex == 1 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.w,
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
                  height: 16.w,
                ),
                Icon(
                  FeatherIcons.activity,
                  size: 22.sp,
                  color: selectedIndex == 2 ? Colors.black87 : Colors.black54,
                ),
                SizedBox(
                  height: 7.w,
                ),
                TextAutoSize('Activity',
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
                  height: 16.w,
                ),
                Icon(
                  FeatherIcons.pieChart,
                  size: 22.sp,
                  color: selectedIndex == 3 ? Colors.black87 : Colors.black54,
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
                          selectedIndex == 3 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Column(
              children: [
                SizedBox(
                  height: 16.w,
                ),
                Icon(
                  FeatherIcons.sliders,
                  size: 22.sp,
                  color: selectedIndex == 4 ? Colors.black87 : Colors.black54,
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
                          selectedIndex == 4 ? Colors.black87 : Colors.black54,
                    )),
              ],
            ),
            label: '',
          ),
        ]);
  }
}
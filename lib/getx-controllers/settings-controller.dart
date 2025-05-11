import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../constants/color-constants.dart';
import '../constants/dummy-data-constants.dart';
import '../constants/font-constants.dart';
import '../screens/base/progress-subpages/elements/1x2-scroll-view.dart';

class SettingsController extends GetxController {
  bool enablePushNotification = false;
  bool isdailyReminderExpanded = false;
  bool isweeklyReminderExpanded = false;
  final PageController financialGoalsScrollController =
      PageController(viewportFraction: 0.75);

  Widget personalInfoSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          SizedBox(
            height: 28.w,
          ),
          Row(
            children: [
              SizedBox(
                width: 4.w,
              ),
              TextAutoSize(
                "PERSONAL INFO",
                style: TextStyle(
                    fontSize: 13.sp,
                    letterSpacing: 2.0,
                    // Adds 2 logical pixels between each letter
                    fontFamily: circularBook,
                    color: nicotrackBlack1),
              ),
            ],
          ),
          SizedBox(
            height: 14.w,
          ),
          personalInfoBox(
              fieldName: "Name",
              fieldValue: "Jack",
              fieldActionName: "Edit",
              action: () {}),
          SizedBox(
            height: 6.w,
          ),
          personalInfoBox(
              fieldName: "Quit Date",
              fieldValue: "March 25, 2025",
              fieldActionName: "Change",
              action: () {}),
          SizedBox(
            height: 18.w,
          ),
          userSelectedDisplayCards(),
          SizedBox(
            height: 10.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextAutoSize(
                'Tap to modify this information',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularBook,
                    color: Color(0xFFC8C8C8)),
              ),
            ],
          ),
          SizedBox(
            height: 32.w,
          ),
        ],
      ),
    );
  }

  Widget personalInfoBox(
      {required String fieldName,
      required String fieldValue,
      required String fieldActionName,
      required void Function() action}) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.only(top: 21.w, bottom: 21.w, left: 21.w, right: 14.w),
      decoration: BoxDecoration(
        color: btnBGLightGrey,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 16.sp,
                      // Adds 2 logical pixels between each letter
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                  children: [
                TextSpan(text: "$fieldName: "),
                TextSpan(
                  text: fieldValue,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1),
                ),
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextAutoSize(
                fieldActionName,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBold,
                    color: nicotrackOrange),
              ),
              SizedBox(
                width: 1.w,
              ),
              Icon(
                FeatherIcons.chevronRight,
                color: nicotrackOrange,
                size: 16.w,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget normalInfoBox({
    required String fieldValue,
    required void Function() action
  }) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.only(top: 21.w, bottom: 21.w, left: 21.w, right: 14.w),
        decoration: BoxDecoration(
          color: btnBGLightGrey,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 16.sp,
                        // Adds 2 logical pixels between each letter
                        fontFamily: circularMedium,
                        color: nicotrackBlack1),
                    children: [
                  TextSpan(text: fieldValue),

                ])),
          ],
        ),
      ),
    );
  }

  Widget pushNotificationSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  TextAutoSize(
                    "PUSH NOTIFICATIONS",
                    style: TextStyle(
                        fontSize: 13.sp,
                        letterSpacing: 2.0,
                        // Adds 2 logical pixels between each letter
                        fontFamily: circularBook,
                        color: nicotrackBlack1),
                  ),
                ],
              ),
              CupertinoSwitch(
                  value: enablePushNotification,
                  onChanged: (value) {
                    enablePushNotification = value;
                    update();
                  })
            ],
          ),
          SizedBox(
            height: 14.w,
          ),
          dailyReminderSection(),
          SizedBox(
            height: 7.w,
          ),
          weeklyReminderSection(),
          SizedBox(
            height: 36.w,
          ),
        ],
      ),
    );
  }

  Widget financialGoalsSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child:
              Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  TextAutoSize(
                    "FINANCIAL GOALS",
                    style: TextStyle(
                        fontSize: 13.sp,
                        letterSpacing: 2.0,
                        // Adds 2 logical pixels between each letter
                        fontFamily: circularBook,
                        color: nicotrackBlack1),
                  ),
                ],
              ),
        ),
        OnexTwoScrollView(
          scrollController: financialGoalsScrollController,
          items: financialDummyData,
          childAspectRatio: 1.38,
          withPercent: false,
          percent: 16,
        ),
        SizedBox(
          height: 34.w,
        ),
      ],
    );
  }

  Widget helpandSupportSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  TextAutoSize(
                    "HELP & SUPPORT",
                    style: TextStyle(
                        fontSize: 13.sp,
                        letterSpacing: 2.0,
                        // Adds 2 logical pixels between each letter
                        fontFamily: circularBook,
                        color: nicotrackBlack1),
                  ),
                ],
              ),
              SizedBox(
                height: 24.w,
              ),
              quitTipsSection(),
              SizedBox(
                height: 8.w,
              ),
              normalInfoBox(fieldValue: "💬 Contact Support", action: (){}),
              SizedBox(
                height: 8.w,
              ),
              normalInfoBox(fieldValue: "📝 Give us an honest feedback", action: (){}),

            ],
          ),
        ),
        SizedBox(
          height: 36.w,
        ),
      ],
    );
  }
  Widget privacySection(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 4.w,
              ),
              TextAutoSize(
                "PRIVACY",
                style: TextStyle(
                    fontSize: 13.sp,
                    letterSpacing: 2.0,
                    // Adds 2 logical pixels between each letter
                    fontFamily: circularBook,
                    color: nicotrackBlack1),
              ),
            ],
          ),
          SizedBox(
            height: 18.w,
          ),
          GestureDetector(
            onTap: (){

            },
            child: Container(
              width: double.infinity,
              padding:
              EdgeInsets.only(top: 18.w, bottom: 18.w, left: 21.w, right: 14.w),
              decoration: BoxDecoration(
                color: Color(0x333480F8),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              // Adds 2 logical pixels between each letter
                              fontFamily: circularMedium,
                              color: Color(0xFF3380F8)),
                          children: [
                            TextSpan(text: '📃 Privacy Policy'),

                          ])),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          GestureDetector(
            onTap: (){

            },
            child: Container(
              width: double.infinity,
              padding:
              EdgeInsets.only(top: 18.w, bottom: 18.w, left: 21.w, right: 14.w),
              decoration: BoxDecoration(
                color: Color(0x33FF611D),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              // Adds 2 logical pixels between each letter
                              fontFamily: circularMedium,
                              color: nicotrackOrange),
                          children: [
                            TextSpan(text: '❌ Clear my journey'),

                          ])),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 54.w,
          ),
        ],
      ),
    );
  }

  Widget userSelectedDisplayCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.w,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: 1.58,
        children: [
          statCard2(
            emoji: cigImg,
            value: 4,
            label: 'Cigarettes\nper day',
            backgroundColor: const Color(0xFFB0F0A1),
            isCost: false, // green-ish background
          ),
          statCard2(
            emoji: moneyEmoji,
            value: 12,
            label: 'Cost per\npack',
            isCost: true,
          ),
        ],
      ),
    );
  }

  Widget dailyReminderSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.r),
        color: btnBGLightGrey,
        // border: Border.all(
        //   width: 1,
        //   color: const Color(0xFFEFEFEF),
        // )
      ),
      child: ExpansionTile(
          trailing: AnimatedRotation(
            turns: isdailyReminderExpanded ? 0.5 : 0.0,
            // 180 degrees when expanded
            duration: Duration(milliseconds: 200),
            child: Icon(
              FeatherIcons.chevronDown,
              size: 20.sp,
              color: nicotrackOrange,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          backgroundColor: btnBGLightGrey,
          collapsedBackgroundColor: btnBGLightGrey,
          initiallyExpanded: false,
          tilePadding: EdgeInsets.only(right: 19.w, top: 6.h, bottom: 6.h),
          childrenPadding: EdgeInsets.only(bottom: 14.h),
          onExpansionChanged: (expanded) {
            isdailyReminderExpanded = expanded;
            update();
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 18.w,
                  ),
                  TextAutoSize('🔔 Daily Reminder',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 16.sp,
                        fontFamily: circularMedium,
                        color: nicotrackBlack1,
                      )),
                ],
              ),
              TextAutoSize('8 AM',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: nicotrackOrange,
                  )),
            ],
          ),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 8.w,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.sp, vertical: 10.sp),
                  decoration: BoxDecoration(
                      color: nicotrackOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9.r)),
                  child: TextAutoSize('08: 00 AM',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        color: nicotrackOrange,
                      )),
                ),
                SizedBox(
                  height: 8.w,
                ),
              ],
            ),
          ]),
    );
  }

  Widget weeklyReminderSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.r),
        color: btnBGLightGrey,
        // border: Border.all(
        //   width: 1,
        //   color: const Color(0xFFEFEFEF),
        // )
      ),
      child: ExpansionTile(
          trailing: AnimatedRotation(
            turns: isweeklyReminderExpanded ? 0.5 : 0.0,
            // 180 degrees when expanded
            duration: Duration(milliseconds: 200),
            child: Icon(
              FeatherIcons.chevronDown,
              size: 20.sp,
              color: nicotrackOrange,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          backgroundColor: btnBGLightGrey,
          collapsedBackgroundColor: btnBGLightGrey,
          initiallyExpanded: false,
          tilePadding: EdgeInsets.only(right: 19.w, top: 6.h, bottom: 6.h),
          childrenPadding: EdgeInsets.only(bottom: 14.h),
          onExpansionChanged: (expanded) {
            isweeklyReminderExpanded = expanded;
            update();
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 18.w,
                  ),
                  TextAutoSize('🗓️ Weekly summary',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 16.sp,
                        fontFamily: circularMedium,
                        color: nicotrackBlack1,
                      )),
                ],
              ),
              TextAutoSize('Fri: 10 PM',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: nicotrackOrange,
                  )),
            ],
          ),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 8.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.sp, vertical: 10.sp),
                      decoration: BoxDecoration(
                          color: nicotrackOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(9.r)),
                      child: TextAutoSize('Friday',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            height: 1.1,
                            fontSize: 16.sp,
                            fontFamily: circularBold,
                            color: nicotrackOrange,
                          )),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.sp, vertical: 10.sp),
                      decoration: BoxDecoration(
                          color: nicotrackOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(9.r)),
                      child: TextAutoSize('08: 00 AM',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            height: 1.1,
                            fontSize: 16.sp,
                            fontFamily: circularBold,
                            color: nicotrackOrange,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.w,
                ),
              ],
            ),
          ]),
    );
  }

  Widget quitTipsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.r),
        color: btnBGLightGrey,
        // border: Border.all(
        //   width: 1,
        //   color: const Color(0xFFEFEFEF),
        // )
      ),
      child: ExpansionTile(
          trailing: AnimatedRotation(
            turns: isdailyReminderExpanded ? 0.5 : 0.0,
            // 180 degrees when expanded
            duration: Duration(milliseconds: 200),
            child: Icon(
              FeatherIcons.chevronDown,
              size: 20.sp,
              color: nicotrackBlack1,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          backgroundColor: btnBGLightGrey,
          collapsedBackgroundColor: btnBGLightGrey,
          initiallyExpanded: false,
          tilePadding: EdgeInsets.only(right: 19.w, top: 4.h, bottom: 4.h),
          childrenPadding: EdgeInsets.only(bottom: 14.h),
          onExpansionChanged: (expanded) {
            isdailyReminderExpanded = expanded;
            update();
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FeatherIcons.chevronDown,
                size: 20.sp,
                color: Colors.transparent,
              ),
              Icon(
                FeatherIcons.chevronDown,
                size: 20.sp,
                color: Colors.transparent,
              ),
              TextAutoSize('💡 Quit Tips',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 16.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1,
                  )),
            ],
          ),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 8.w,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.sp, vertical: 10.sp),
                  decoration: BoxDecoration(
                      color: nicotrackOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9.r)),
                  child: TextAutoSize('08: 00 AM',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        color: nicotrackOrange,
                      )),
                ),
                SizedBox(
                  height: 8.w,
                ),
              ],
            ),
          ]),
    );
  }
}
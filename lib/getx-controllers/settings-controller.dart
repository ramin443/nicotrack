import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/change-name.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/change-quit-date.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/contact-support.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/feedback.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-time.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-weekday.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/smokes-per-day.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../constants/color-constants.dart';
import '../constants/dummy-data-constants.dart';
import '../constants/font-constants.dart';
import '../models/emoji-text-pair/emojitext-model.dart';
import '../screens/base/progress-subpages/elements/1x2-scroll-view.dart';
import '../screens/base/settings-subpages/bottom-sheets/cost-per-pack.dart';

class SettingsController extends GetxController {
  bool enablePushNotification = false;
  bool isdailyReminderExpanded = false;
  bool isweeklyReminderExpanded = false;
  final PageController financialGoalsScrollController =
      PageController(viewportFraction: 0.75);
  int currentPage = 0;
  EmojiTextModel addNewGoal = EmojiTextModel(emoji: '🎯', text: 'Add new goal');

  //Set cigs variables
  late FixedExtentScrollController smokesPerDayController;
  int selectedFreq = 8;
  List<int> smokesPerDay = List.generate(12, (index) => index + 1); // 0 to 100

  //Set time variables
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;
  int selectedHour = 8;
  int selectedMinute = 0;
  String selectedHalf = ' AM';
  List<int> hours = List.generate(12, (index) => index); // 0 to 100
  List<int> minutes = List.generate(60, (index) => index); // 0 to 99
  List<String> halves = [' AM', ' PM']; // 0 to 99

  //Set price of pack variables
  late FixedExtentScrollController dollarController;
  late FixedExtentScrollController centController;
  int selectedDollar = 8;
  int selectedCent = 0;
  List<int> dollars = List.generate(100, (index) => index); // 0 to 100
  List<int> cents = List.generate(100, (index) => index); // 0 to 99

  //Set weekday variables
  late FixedExtentScrollController weekdayController;
  String selectedweekday = 'Monday';
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ]; // 0 to 100

  Widget personalInfoSection(BuildContext context) {
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
          GestureDetector(
            onTap: () {
              showChangeNameBottomSheet(context);
            },
            child: personalInfoBox(
                fieldName: "Name",
                fieldValue: "Jack",
                fieldActionName: "Edit",
                action: () {}),
          ),
          SizedBox(
            height: 6.w,
          ),
          GestureDetector(
            onTap: () {
              showChangeQuitDateBottomSheet(context);
            },
            child: personalInfoBox(
                fieldName: "Quit Date",
                fieldValue: "March 25, 2025",
                fieldActionName: "Change",
                action: () {}),
          ),
          SizedBox(
            height: 18.w,
          ),
          userSelectedDisplayCards(context),
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

  Widget normalInfoBox(
      {required String fieldValue, required void Function() action}) {
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

  Widget pushNotificationSection(BuildContext context) {
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
          dailyReminderSection(context),
          SizedBox(
            height: 7.w,
          ),
          weeklyReminderSection(context),
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
          child: Row(
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

  Widget helpandSupportSection(BuildContext context) {
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
              quitTipsSection(context),
              SizedBox(
                height: 8.w,
              ),
              normalInfoBox(
                  fieldValue: "💬 Contact Support",
                  action: () {
                    showContactSupportBottomSheet(context);
                  }),
              SizedBox(
                height: 8.w,
              ),
              normalInfoBox(
                  fieldValue: "📝 Give us an honest feedback",
                  action: () {
                    showFeedbackBottomSheet(context);
                  }),
            ],
          ),
        ),
        SizedBox(
          height: 36.w,
        ),
      ],
    );
  }

  Widget privacySection() {
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
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 18.w, bottom: 18.w, left: 21.w, right: 14.w),
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
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 18.w, bottom: 18.w, left: 21.w, right: 14.w),
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

  Widget userSelectedDisplayCards(BuildContext context) {
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
          GestureDetector(
            onTap: () {
              showSmokesPerDayBottomSheet(context);
            },
            child: statCard2(
              emoji: cigImg,
              value: 4,
              label: 'Cigarettes\nper day',
              backgroundColor: const Color(0xFFB0F0A1),
              isCost: false, // green-ish background
            ),
          ),
          GestureDetector(
            onTap: () {
              showSetCostofPackBottomSheet(context);
            },
            child: statCard2(
              emoji: moneyEmoji,
              value: 12,
              label: 'Cost per\npack',
              isCost: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget dailyReminderSection(BuildContext context) {
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
                GestureDetector(
                  onTap: () {
                    showSetTimeBottomSheet(context);
                  },
                  child: Container(
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
                ),
                SizedBox(
                  height: 8.w,
                ),
              ],
            ),
          ]),
    );
  }

  Widget weeklyReminderSection(BuildContext context) {
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
                    GestureDetector(
                      onTap: () {
                        showWeekDayBottomSheet(context);
                      },
                      child: Container(
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
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    GestureDetector(
                      onTap: (){
                        showSetTimeBottomSheet(context);
                      },
                      child: Container(
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

  Widget quitTipsSection(BuildContext context) {
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
                GestureDetector(
                  onTap: (){
                    showSetTimeBottomSheet(context);
                  },
                  child: Container(
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
                ),
                SizedBox(
                  height: 8.w,
                ),
              ],
            ),
          ]),
    );
  }

  void showSmokesPerDayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SmokesPerDayBottomSheet();
        });
  }

  void showSetTimeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SetTimeBottomSheet();
        });
  }

  void showSetCostofPackBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return CostPerPackBottomSheet();
        });
  }

  void showChangeQuitDateBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return ChangeQuitDateBottomSheet();
        });
  }

  void showChangeNameBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return ChangeNameBottomSheet();
        });
  }

  void showContactSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return ContactSupportBottomSheet();
        });
  }

  void showFeedbackBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return FeedbackBottomSheet();
        });
  }

  void showWeekDayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SetWeekdayBottomSheet();
        });
  }

  Widget setTimePicker() {
    return // Dollar Picker UI
        SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Value Scroll
          SizedBox(
            width: 80.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: hourController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedHour = hours[index];
                String dollarValue = "$selectedHour.$selectedMinute";
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: hours.length,
                builder: (context, index) {
                  bool isSelected = selectedHour == hours[index];
                  return Center(
                    child: TextAutoSize(
                      hours[index].toString(),
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dot
          TextAutoSize(
            ":",
            style: TextStyle(
                fontSize: 64.sp,
                fontFamily: circularBold,
                color: Color(0xffF35E5C)),
          ),

          // Cents Scroll
          SizedBox(
            width: 100.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: minuteController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedMinute = minutes[index];
                String dollarValue = "$selectedHour.$selectedMinute";
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: minutes.length,
                builder: (context, index) {
                  bool isSelected = selectedMinute == minutes[index];
                  String display = minutes[index].toString().padLeft(2, '0');
                  return Center(
                    child: TextAutoSize(
                      display,
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 90.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: amPmController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedHalf = halves[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: halves.length,
                builder: (context, index) {
                  bool isSelected = selectedHalf == halves[index];
                  String display = halves[index];
                  return Center(
                    child: TextAutoSize(
                      display,
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setWeekDay() {
    return // Dollar Picker UI
        SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Value Scroll
          SizedBox(
            width: 300.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: weekdayController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedweekday = weekdays[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: weekdays.length,
                builder: (context, index) {
                  bool isSelected = selectedweekday == weekdays[index];
                  return Center(
                    child: TextAutoSize(
                      weekdays[index].toString(),
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setPriceofBox() {
    return // Dollar Picker UI
        SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Sign - Fixed
          TextAutoSize(
            "\$",
            style: TextStyle(
              fontSize: 64.sp,
              fontFamily: circularBold,
              color: Color(0xffF35E5C),
            ),
          ),

          // Dollar Value Scroll
          SizedBox(
            width: 80.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: dollarController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedDollar = dollars[index];
                String dollarValue = "$selectedDollar.$selectedCent";
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: dollars.length,
                builder: (context, index) {
                  bool isSelected = selectedDollar == dollars[index];
                  return Center(
                    child: TextAutoSize(
                      dollars[index].toString(),
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dot
          TextAutoSize(
            ".",
            style: TextStyle(
                fontSize: 64.sp,
                fontFamily: circularBold,
                color: Color(0xffF35E5C)),
          ),

          // Cents Scroll
          SizedBox(
            width: 90.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: centController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedCent = cents[index];
                String dollarValue = "$selectedDollar.$selectedCent";
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: cents.length,
                builder: (context, index) {
                  bool isSelected = selectedCent == cents[index];
                  String display = cents[index].toString().padLeft(2, '0');
                  return Center(
                    child: TextAutoSize(
                      display,
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setCigsPerDay() {
    return // Dollar Picker UI
        SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Value Scroll
          SizedBox(
            width: 80.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: smokesPerDayController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFreq = smokesPerDay[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: smokesPerDay.length,
                builder: (context, index) {
                  bool isSelected = selectedFreq == smokesPerDay[index];
                  return Center(
                    child: TextAutoSize(
                      smokesPerDay[index].toString(),
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget changeQuitDatePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300.w,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            maximumDate: DateTime.now(),
            minimumYear: 2022,
            maximumYear: DateTime.now().year,
            onDateTimeChanged: (DateTime newDate) {},
          ),
        ),
      ],
    );
  }

  Widget contactSupportTextFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 5.w,
            ),
            TextAutoSize(
              'Email Address',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: Color(0xff454545).withOpacity(0.6),
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        TextField(
          cursorColor: nicotrackBlack1,
          decoration: InputDecoration(
            hintText: 'jdoe@icloud.com',
            hintStyle: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBook,
              color: Color(0xff454545).withOpacity(0.6),
              height: 1.1,
            ),
            filled: true,
            fillColor: Color(0xFFF2F2F2),
            // light gray background
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none, // removes outline
            ),
          ),
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: circularBook,
            color: nicotrackBlack1,
            height: 1.1,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(
          height: 15.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 5.w,
            ),
            TextAutoSize(
              'Details',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: Color(0xff454545).withOpacity(0.6),
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Expanded(
          child: TextField(
            minLines: 9,
            maxLines: 25,
            cursorColor: nicotrackBlack1,
            decoration: InputDecoration(
              filled: true,
              hintText: '',
              hintStyle: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: Color(0xff454545).withOpacity(0.6),
                height: 1.1,
              ),
              fillColor: Color(0xFFF2F2F2),
              // Light gray background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // removes outline
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1,
              height: 1.1,
            ),
          ),
        )
      ],
    );
  }

  Widget changeNameTextFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          cursorColor: nicotrackBlack1,
          decoration: InputDecoration(
            hintText: 'John Doe',
            hintStyle: TextStyle(
              fontSize: 34.sp,
              fontFamily: circularBold,
              color: Color(0xff454545).withOpacity(0.2),
              height: 1.1,
            ),
            filled: true,
            fillColor: Colors.transparent,
            // light gray background
            border: OutlineInputBorder(
              borderSide: BorderSide.none, // removes outline
            ),
          ),
          style: TextStyle(
            fontSize: 34.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
            height: 1.1,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(
          height: 15.w,
        ),
        Spacer(),
      ],
    );
  }

  Widget honestFeedbackTextFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 5.w,
            ),
            TextAutoSize(
              'Feedback',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: Color(0xff454545).withOpacity(0.6),
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        Expanded(
          child: TextField(
            minLines: 12,
            maxLines: 25,
            cursorColor: nicotrackBlack1,
            decoration: InputDecoration(
              filled: true,
              hintText: '',
              hintStyle: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: Color(0xff454545).withOpacity(0.6),
                height: 1.1,
              ),
              fillColor: Color(0xFFF2F2F2),
              // Light gray background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // removes outline
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1,
              height: 1.1,
            ),
          ),
        )
      ],
    );
  }
}
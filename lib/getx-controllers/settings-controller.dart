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
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/financial-goal.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-time.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-weekly-time.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-weekday.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/smokes-per-day.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../constants/color-constants.dart';
import '../constants/dummy-data-constants.dart';
import '../constants/font-constants.dart';
import '../models/emoji-text-pair/emojitext-model.dart';
import '../screens/base/progress-subpages/elements/1x2-scroll-view.dart';
import '../screens/base/settings-subpages/bottom-sheets/cost-per-pack.dart';
import '../screens/base/settings-subpages/bottom-sheets/set-price.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:hive/hive.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/utility-functions/date-functions.dart';
import 'package:nicotrack/models/notifications-preferences-model/notificationsPreferences-model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nicotrack/services/notification-service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';
import '../screens/base/settings-subpages/bottom-sheets/view-edit-goal.dart';
import '../screens/base/settings-subpages/bottom-sheets/privacy-policy.dart';
import '../screens/base/settings-subpages/bottom-sheets/terms-of-use.dart';
import '../screens/base/settings-subpages/bottom-sheets/change-currency.dart';
import '../screens/base/settings-subpages/bottom-sheets/change-language.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/models/quick-actions-model/quickActions-model.dart';
import 'package:nicotrack/initial/welcome-info/info-slider-main.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';

class SettingsController extends GetxController with WidgetsBindingObserver {
  bool enablePushNotification = false;
  bool isdailyReminderExpanded = false;

  // Clear data confirmation variables
  TextEditingController confirmationTextController = TextEditingController();
  bool isConfirmationValid = false;
  bool isweeklyReminderExpanded = false;
  bool isquitTipsExpanded = false;
  final PageController financialGoalsScrollController =
      PageController(viewportFraction: 0.75);
  int currentPage = 0;
  EmojiTextModel addNewGoal = EmojiTextModel(emoji: '🎯', text: 'Add new goal');

  //Set cigs variables
  late FixedExtentScrollController smokesPerDayController;
  int selectedFreq = 8;
  List<int> smokesPerDay = List.generate(12, (index) => index + 1); // 0 to 100

  //Set daily reminder time variables
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;
  int selectedHour = 8;
  int selectedMinute = 0;
  String selectedHalf = ' AM';

  //Set weekly reminder time variables
  late FixedExtentScrollController weeklyHourController;
  late FixedExtentScrollController weeklyMinuteController;
  late FixedExtentScrollController weeklyAmPmController;
  int selectedWeeklyHour = 6;
  int selectedWeeklyMinute = 0;
  String selectedWeeklyHalf = ' PM';

  //Shared time lists
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

  //Set financial goals variables
  String selectedEmoji = '😐';
  TextEditingController goalTitleController = TextEditingController();
  int selectedFinGoalDollar = 150;
  int selectedFinGoalCent = 25;

  String selectedEmoji1 = '😐';
  TextEditingController goalTitleController1 = TextEditingController();
  int selectedFinGoalDollar1 = 150;
  int selectedFinGoalCent1 = 25;

  bool isFinGoalSet = false;
  late FixedExtentScrollController finGoaldollarController;
  late FixedExtentScrollController finGoalcentController;

  late FixedExtentScrollController finGoaldollarController1;
  late FixedExtentScrollController finGoalcentController1;
  List<int> finGoaldollars =
      List.generate(101, (index) => index * 10); // 0 to 100
  List<int> finGoalcents = List.generate(100, (index) => index); // 0 to 99

  //Data layer
  OnboardingData currentDateOnboardingData = OnboardingData();
  NotificationsPreferencesModel? currentNotificationsPreferences;
  List<FinancialGoalsModel> userFinancialGoals = [];

  //Name change controller
  TextEditingController nameController = TextEditingController();

  //Quit date change variables
  DateTime selectedQuitDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    // Add observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    // Wait until after UI builds to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    setCurrentFilledData();
    // Check notification permission status when settings loads
    syncNotificationPermissionOnLoad();
  }

  @override
  void onClose() {
    // Remove observer when controller is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Re-sync permission when user returns to app (e.g., from device settings)
      syncNotificationPermissionOnLoad();
    }
  }

  Widget personalInfoSection(
      {required BuildContext context, required bool isUserPremium}) {
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
                context.l10n.personal_info_section,
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
                fieldName: context.l10n.field_name,
                fieldValue: currentDateOnboardingData.name,
                fieldActionName: context.l10n.action_edit,
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
                fieldName: context.l10n.field_quit_date,
                fieldValue: convertDatetoUsableFormat(
                    currentDateOnboardingData.lastSmokedDate),
                fieldActionName: context.l10n.action_change,
                action: () {}),
          ),
          SizedBox(
            height: 18.w,
          ),
          userSelectedDisplayCards(
              context: context, isUserPremium: isUserPremium),
          SizedBox(
            height: 10.w,
          ),
          GetBuilder<AppPreferencesController>(builder: (appPrefsController) {
            return GestureDetector(
              onTap: () {
                showChangeCurrencyBottomSheet(context);
              },
              child: personalInfoBox(
                  fieldName: context.l10n.field_currency,
                  fieldValue:
                      "${appPrefsController.currencySymbol} ${appPrefsController.currencyCode}",
                  fieldActionName: context.l10n.action_change,
                  action: () {}),
            );
          }),
          SizedBox(
            height: 6.w,
          ),
          GetBuilder<AppPreferencesController>(builder: (appPrefsController) {
            return GestureDetector(
              onTap: () {
                showChangeLanguageBottomSheet(context);
              },
              child: personalInfoBox(
                  fieldName: context.l10n.field_language,
                  fieldValue: appPrefsController.languageName,
                  fieldActionName: context.l10n.action_change,
                  action: () {}),
            );
          }),
          SizedBox(
            height: 10.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300.w,
                child: TextAutoSize(
                  context.l10n.tap_to_modify_info,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.1,
                      fontFamily: circularBook,
                      color: Color(0xFFC8C8C8)),
                ),
              )

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
          SizedBox(
            width: 175.w,
            child: RichText(
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
          ),
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
            SizedBox(
              width: 240.w,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 16.sp,
                          // Adds 2 logical pixels between each letter
                          fontFamily: circularMedium,
                          color: nicotrackBlack1),
                      children: [
                        TextSpan(text: fieldValue),
                      ])),
            )
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
                    context.l10n.push_notifications_section,
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
                    handlePushNotificationToggle(value);
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

  Widget financialGoalsSection(
      {required BuildContext context, required bool isUserPremium}) {
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
                context.l10n.financial_goals_section,
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
        SizedBox(
          height: 16.h,
        ),
        OnexTwoScrollView(
          scrollController: financialGoalsScrollController,
          items: getUserFinancialGoalsAsEmojiTextList(),
          childAspectRatio: 1.25,
          withPercent: false,
          percent: 16,
          newfinancialGoalAction: () {
            showAddFinancialGoalsBottomSheet(context);
          },
          onItemTap: (index) {
            showViewEditGoalBottomSheet(context, index);
          },
          isUserPremium: isUserPremium,
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
                    context.l10n.help_support_section,
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
                  fieldValue: context.l10n.contact_support,
                  action: () {
                    showContactSupportBottomSheet(context);
                  }),
              SizedBox(
                height: 8.w,
              ),
              normalInfoBox(
                  fieldValue: context.l10n.give_feedback,
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

  Widget privacySection(BuildContext context) {
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
                context.l10n.privacy_section,
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
            onTap: () {
              showPrivacyPolicyBottomSheet(context);
            },
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
            onTap: () {
              showTermsOfUseBottomSheet(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 18.w, bottom: 18.w, left: 21.w, right: 14.w),
              decoration: BoxDecoration(
                color: nicotrackPurple.withOpacity(0.2),
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
                              color: nicotrackPurple),
                          children: [
                        TextSpan(text: '📜 Terms of Use'),
                      ])),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          GestureDetector(
            onTap: () {
              showClearDataConfirmation(context);
            },
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

  Widget userSelectedDisplayCards(
      {required BuildContext context, required bool isUserPremium}) {
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
                if (!isUserPremium) {
                  // Navigate to premium screen when locked
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const PremiumPaywallScreen();
                  }));
                } else {
                  showSmokesPerDayBottomSheet(context);
                }
              },
              child: Stack(
                children: [
                  statCard2(
                    emoji: cigImg,
                    value:
                        currentDateOnboardingData.cigarettesPerDay.toDouble(),
                    label: 'Cigarettes\nper day',
                    backgroundColor: const Color(0xFFB0F0A1),
                    isCost: false, // green-ish background
                  ),
                  isUserPremium
                      ? SizedBox.shrink()
                      : Positioned(top: 10.w, left: 10.w, child: smallLockBox())
                ],
              )),
          GestureDetector(
              onTap: () {
                if (!isUserPremium) {
                  // Navigate to premium screen when locked
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const PremiumPaywallScreen();
                  }));
                } else {
                  showSetCostofPackBottomSheet(context);
                }
              },
              child: Stack(
                children: [
                  statCard2(
                    emoji: moneyEmoji,
                    value: double.parse(currentDateOnboardingData.costOfAPack),
                    label: 'Cost per\npack',
                    isCost: true,
                  ),
                  isUserPremium
                      ? SizedBox.shrink()
                      : Positioned(top: 10.w, left: 10.w, child: smallLockBox())
                ],
              )),
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
                  SizedBox(
                    width: 220.w,
                    child: TextAutoSize(
                        context.l10n.daily_reminder,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          height: 1.1,
                          fontSize: 16.sp,
                          fontFamily: circularMedium,
                          color: nicotrackBlack1,
                        )),
                  )
                ],
              ),
              TextAutoSize(getFormattedDailyReminderTime(),
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
                    child: TextAutoSize(getFormattedDailyReminderDetailedTime(),
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
                  SizedBox(
                    width: 175.w,
                    child: TextAutoSize(
                        context.l10n.weekly_summary,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          height: 1.1,
                          fontSize: 16.sp,
                          fontFamily: circularMedium,
                          color: nicotrackBlack1,
                        )),
                  )
                ],
              ),
              TextAutoSize(getFormattedWeeklyReminderTime(),
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
                        child: TextAutoSize(
                            currentNotificationsPreferences
                                    ?.weeklyReminderDay ??
                                'Monday',
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
                      onTap: () {
                        showWeeklySetTimeBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.sp, vertical: 10.sp),
                        decoration: BoxDecoration(
                            color: nicotrackOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(9.r)),
                        child: TextAutoSize(
                            getFormattedWeeklyReminderDetailedTime(),
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
            turns: isquitTipsExpanded ? 0.5 : 0.0,
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
            isquitTipsExpanded = expanded;
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
              SizedBox(
                width: 250.w,
                child: TextAutoSize(context.l10n.quit_tips,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 16.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1,
                    )),
              )
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _buildQuitTip(1, "Stay hydrated",
                      "Drink plenty of water to help flush nicotine from your system and reduce cravings."),
                  SizedBox(height: 12.h),
                  _buildQuitTip(2, "Keep your hands busy",
                      "Use stress balls, fidget toys, or engage in activities like drawing or crafts."),
                  SizedBox(height: 12.h),
                  _buildQuitTip(3, "Avoid triggers",
                      "Stay away from smoking areas, alcohol, or situations that make you want to smoke."),
                  SizedBox(height: 12.h),
                  _buildQuitTip(4, "Practice deep breathing",
                      "When cravings hit, take slow, deep breaths for 3-5 minutes to relax."),
                  SizedBox(height: 12.h),
                  _buildQuitTip(5, "Exercise regularly",
                      "Physical activity reduces stress, improves mood, and helps prevent weight gain."),
                  SizedBox(height: 12.h),
                  _buildQuitTip(6, "Reward yourself",
                      "Celebrate milestones with non-smoking rewards like a movie, meal, or new item."),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _buildQuitTip(int number, String title, String description) {
    String getNumberEmoji(int num) {
      switch (num) {
        case 1:
          return '1️⃣';
        case 2:
          return '2️⃣';
        case 3:
          return '3️⃣';
        case 4:
          return '4️⃣';
        case 5:
          return '5️⃣';
        case 6:
          return '6️⃣';
        default:
          return '$num️⃣';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextAutoSize(
          getNumberEmoji(number),
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextAutoSize(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBold,
                  color: nicotrackBlack1,
                ),
              ),
              SizedBox(height: 4.h),
              TextAutoSize(
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: circularBook,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
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

  void showWeeklySetTimeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SetWeeklyTimeBottomSheet();
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

  void showSetPriceBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SetPriceBottomSheet();
        });
  }

  void showEditGoalPriceBottomSheet(BuildContext context) {
    // Initialize controllers for price picker
    int dollarIndex = finGoaldollars.indexOf(selectedFinGoalDollar);
    int centIndex = finGoalcents.indexOf(selectedFinGoalCent);

    finGoaldollarController = FixedExtentScrollController(
        initialItem: dollarIndex >= 0 ? dollarIndex : 15 // Default to $150
        );
    finGoalcentController = FixedExtentScrollController(
        initialItem: centIndex >= 0 ? centIndex : 25 // Default to 25 cents
        );

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        builder: (context) {
          return GetBuilder<SettingsController>(builder: (controller) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              child: Column(
                children: [
                  SizedBox(height: 18.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4.8.w,
                        width: 52.w,
                        decoration: BoxDecoration(
                            color: nicotrackBlack1,
                            borderRadius: BorderRadius.circular(18.r)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                              color: nicotrackOrange.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.close_rounded,
                              size: 20.w,
                              color: nicotrackOrange,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setFinGoalTrue();
                              Navigator.of(context).pop();
                            },
                            child: TextAutoSize(
                              'Done',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBook,
                                color: nicotracklightBlue,
                                height: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Expanded(child: setPriceAsNeeded()),
                  SizedBox(height: 24.w),
                ],
              ),
            );
          });
        });
  }

  void showEditGoalPriceBottomSheet1(BuildContext context) {
    // Initialize controllers for price picker
    int dollarIndex = finGoaldollars.indexOf(selectedFinGoalDollar1);
    int centIndex = finGoalcents.indexOf(selectedFinGoalCent1);

    finGoaldollarController1 = FixedExtentScrollController(
        initialItem: dollarIndex >= 0 ? dollarIndex : 15 // Default to $150
        );
    finGoalcentController1 = FixedExtentScrollController(
        initialItem: centIndex >= 0 ? centIndex : 25 // Default to 25 cents
        );

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        builder: (context) {
          return GetBuilder<SettingsController>(builder: (controller) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              child: Column(
                children: [
                  SizedBox(height: 18.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4.8.w,
                        width: 52.w,
                        decoration: BoxDecoration(
                            color: nicotrackBlack1,
                            borderRadius: BorderRadius.circular(18.r)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                              color: nicotrackOrange.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.close_rounded,
                              size: 20.w,
                              color: nicotrackOrange,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setFinGoalTrue();
                              Navigator.of(context).pop();
                            },
                            child: TextAutoSize(
                              'Done',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBook,
                                color: nicotracklightBlue,
                                height: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Expanded(child: setPriceAsNeeded1()),
                  SizedBox(height: 24.w),
                ],
              ),
            );
          });
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
        isScrollControlled: true,
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
        isScrollControlled: true,
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

  void showAddFinancialGoalsBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return FinancialGoalsBottomSheet();
        });
  }

  void showViewEditGoalBottomSheet(BuildContext context, int goalIndex) {
    if (goalIndex >= userFinancialGoals.length) return;

    // Pre-populate fields with existing goal data for editing
    selectedEmoji1 = userFinancialGoals[goalIndex].emoji;
    goalTitleController1.text = userFinancialGoals[goalIndex].goalTitle;

    // Parse cost back into dollar and cent
    String costString = userFinancialGoals[goalIndex].cost.toStringAsFixed(2);
    List<String> parts = costString.split('.');
    selectedFinGoalDollar1 = int.parse(parts[0]);
    selectedFinGoalCent1 = int.parse(parts[1]);
    isFinGoalSet = true;

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        isScrollControlled: true,
        builder: (context) {
          return ViewEditGoalBottomSheet(
            goal: userFinancialGoals[goalIndex],
            goalIndex: goalIndex,
          );
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

  Widget setWeeklyTimePicker() {
    return SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour Scroll
          SizedBox(
            width: 80.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: weeklyHourController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedWeeklyHour = hours[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: hours.length,
                builder: (context, index) {
                  bool isSelected = selectedWeeklyHour == hours[index];
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

          // Colon
          TextAutoSize(
            ":",
            style: TextStyle(
                fontSize: 64.sp,
                fontFamily: circularBold,
                color: Color(0xffF35E5C)),
          ),

          // Minute Scroll
          SizedBox(
            width: 100.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: weeklyMinuteController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedWeeklyMinute = minutes[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: minutes.length,
                builder: (context, index) {
                  bool isSelected = selectedWeeklyMinute == minutes[index];
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
          // AM/PM Scroll
          SizedBox(
            width: 90.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: weeklyAmPmController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedWeeklyHalf = halves[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: halves.length,
                builder: (context, index) {
                  bool isSelected = selectedWeeklyHalf == halves[index];
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
            Get.find<AppPreferencesController>().currencySymbol,
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

  Widget setPriceAsNeeded() {
    return // Dollar Picker UI
        SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Sign - Fixed
          TextAutoSize(
            Get.find<AppPreferencesController>().currencySymbol,
            style: TextStyle(
              fontSize: 64.sp,
              fontFamily: circularBold,
              color: Color(0xffF35E5C),
            ),
          ),

          // Dollar Value Scroll
          SizedBox(
            width: 120.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: finGoaldollarController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFinGoalDollar = finGoaldollars[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: finGoaldollars.length,
                builder: (context, index) {
                  bool isSelected =
                      selectedFinGoalDollar == finGoaldollars[index];
                  return Center(
                    child: TextAutoSize(
                      finGoaldollars[index].toString(),
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
              controller: finGoalcentController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFinGoalCent = finGoalcents[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: finGoalcents.length,
                builder: (context, index) {
                  bool isSelected = selectedFinGoalCent == finGoalcents[index];
                  String display =
                      finGoalcents[index].toString().padLeft(2, '0');
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

  Widget setPriceAsNeeded1() {
    return // Dollar Picker UI
        SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Sign - Fixed
          TextAutoSize(
            Get.find<AppPreferencesController>().currencySymbol,
            style: TextStyle(
              fontSize: 64.sp,
              fontFamily: circularBold,
              color: Color(0xffF35E5C),
            ),
          ),

          // Dollar Value Scroll
          SizedBox(
            width: 120.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: finGoaldollarController1,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFinGoalDollar1 = finGoaldollars[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: finGoaldollars.length,
                builder: (context, index) {
                  bool isSelected =
                      selectedFinGoalDollar1 == finGoaldollars[index];
                  return Center(
                    child: TextAutoSize(
                      finGoaldollars[index].toString(),
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
              controller: finGoalcentController1,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFinGoalCent1 = finGoalcents[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: finGoalcents.length,
                builder: (context, index) {
                  bool isSelected = selectedFinGoalCent1 == finGoalcents[index];
                  String display =
                      finGoalcents[index].toString().padLeft(2, '0');
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
            initialDateTime: selectedQuitDate,
            maximumDate: DateTime.now(),
            minimumYear: 2022,
            maximumYear: DateTime.now().year,
            onDateTimeChanged: (DateTime newDate) {
              selectedQuitDate = newDate;
            },
          ),
        ),
      ],
    );
  }

  Widget contactSupportTextFields() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
            textInputAction: TextInputAction.done,
            scrollPadding: EdgeInsets.only(bottom: 100.h),
            onSubmitted: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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
          Container(
            height: 260.w,
            child: TextField(
              maxLines: null,
              expands: true,
              cursorColor: nicotrackBlack1,
              textInputAction: TextInputAction.done,
              scrollPadding: EdgeInsets.only(bottom: 100.h),
              onSubmitted: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Describe your issue or question...',
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: Color(0xff454545).withOpacity(0.6),
                  height: 1.1,
                ),
                fillColor: Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
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
              textAlignVertical: TextAlignVertical.top,
            ),
          )
        ],
      ),
    );
  }

  Widget financialGoalTextFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    showEmojiPicker(context);
                  },
                  child: Container(
                    height: 76.w,
                    width: 76.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: Center(
                      child: TextAutoSize(
                        selectedEmoji,
                        style: TextStyle(
                          fontSize: 48.sp,
                          letterSpacing: 1.92,
                          fontFamily: circularBook,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showEmojiPicker(context);
                    },
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: nicotracklightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 14.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 18.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextAutoSize(
              'NEW FINANCIAL GOAL',
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.92,
                fontFamily: circularBook,
                color: nicotrackBlack1,
                height: 1.1,
              ),
            ),
          ],
        ),
        TextField(
          controller: goalTitleController,
          cursorColor: nicotrackBlack1,
          onChanged: (value) {
            update(); // Update UI when text changes for validation
          },
          decoration: InputDecoration(
            hintText: 'e.g., Airpods pro ',
            hintStyle: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: Color(0xff454545).withOpacity(0.25),
              height: 1.1,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none, // removes outline
            ),
          ),
          style: TextStyle(
            fontSize: 24.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
            height: 1.1,
          ),
          keyboardType: TextInputType.text,
        ),
        SizedBox(
          height: 30.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextAutoSize(
              'SET THE PRICE',
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.92,
                fontFamily: circularBook,
                color: nicotrackBlack1,
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.w,
        ),
        GestureDetector(
          onTap: () {
            showSetPriceBottomSheet(context);
          },
          child: TextAutoSize(
            '${Get.find<AppPreferencesController>().currencySymbol} $selectedFinGoalDollar.$selectedFinGoalCent',
            style: TextStyle(
              fontSize: 48.sp,
              fontFamily: circularBold,
              color: isFinGoalSet
                  ? nicotrackOrange
                  : Color(0xff454545).withOpacity(0.25),
              height: 1.1,
            ),
          ),
        ),
        Spacer()
      ],
    );
  }

  Widget changeNameTextFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: nameController,
          cursorColor: nicotrackBlack1,
          decoration: InputDecoration(
            hintText: 'Enter your name',
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
          keyboardType: TextInputType.text,
        ),
        SizedBox(
          height: 15.w,
        ),
        Spacer(),
      ],
    );
  }

  Widget honestFeedbackTextFields() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 300.h,
            child: TextField(
              maxLines: null,
              expands: true,
              cursorColor: nicotrackBlack1,
              textInputAction: TextInputAction.done,
              scrollPadding: EdgeInsets.only(bottom: 100.h),
              onSubmitted: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Your Feedback...',
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: Color(0xff454545).withOpacity(0.6),
                  height: 1.1,
                ),
                fillColor: Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
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
              textAlignVertical: TextAlignVertical.top,
            ),
          )
        ],
      ),
    );
  }

  void setFinGoalTrue() {
    isFinGoalSet = true;
    update(); // This will trigger validation check
  }

  // Convert user financial goals to EmojiTextModel for display
  List<EmojiTextModel> getUserFinancialGoalsAsEmojiTextList() {
    return userFinancialGoals
        .map((goal) => EmojiTextModel(emoji: goal.emoji, text: goal.goalTitle))
        .toList();
  }

  // Check if current financial goal form is valid
  bool isFinancialGoalFormValid() {
    return selectedEmoji.isNotEmpty &&
        goalTitleController.text.trim().isNotEmpty &&
        isFinGoalSet;
  }

  bool isFinancialGoalFormValid1() {
    return selectedEmoji1.isNotEmpty &&
        goalTitleController1.text.trim().isNotEmpty &&
        isFinGoalSet;
  }

  // Add new financial goal
  void addNewFinancialGoal() async {
    if (!isFinancialGoalFormValid()) return;

    try {
      // Create new financial goal
      FinancialGoalsModel newGoal = FinancialGoalsModel(
        emoji: selectedEmoji,
        goalTitle: goalTitleController.text.trim(),
        cost: double.parse('$selectedFinGoalDollar.$selectedFinGoalCent'),
      );

      // Add to beginning of list
      userFinancialGoals.insert(0, newGoal);

      // Save to Hive
      await saveFinancialGoalsToHive();

      // Refresh ProgressController to sync data
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().refreshFinancialGoals();
      }

      // Reset form
      resetFinancialGoalForm();

      update();
    } catch (e) {
      print('Error adding financial goal: $e');
    }
  }

  // Update existing financial goal
  void updateFinancialGoal(int index) async {
    if (!isFinancialGoalFormValid1() || index >= userFinancialGoals.length)
      return;

    try {
      // Create updated financial goal
      FinancialGoalsModel updatedGoal = FinancialGoalsModel(
        emoji: selectedEmoji1,
        goalTitle: goalTitleController1.text.trim(),
        cost: double.parse('$selectedFinGoalDollar1.$selectedFinGoalCent1'),
      );

      // Update in list
      userFinancialGoals[index] = updatedGoal;

      // Save to Hive
      await saveFinancialGoalsToHive();

      // Refresh ProgressController to sync data
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().refreshFinancialGoals();
      }

      update();
    } catch (e) {
      print('Error updating financial goal: $e');
    }
  }

  // Delete financial goal
  void deleteFinancialGoal(int index) async {
    if (index >= userFinancialGoals.length) return;

    try {
      // Remove from list
      userFinancialGoals.removeAt(index);

      // Save to Hive
      await saveFinancialGoalsToHive();

      // Refresh ProgressController to sync data
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().refreshFinancialGoals();
      }

      update();
    } catch (e) {
      print('Error deleting financial goal: $e');
    }
  }

  // Reset the form after adding a goal
  void resetFinancialGoalForm() {
    selectedEmoji = '😐';
    goalTitleController.clear();
    selectedFinGoalDollar = 150;
    selectedFinGoalCent = 25;
    isFinGoalSet = false;
  }

  // Save financial goals to Hive
  Future<void> saveFinancialGoalsToHive() async {
    try {
      final box = Hive.box<FinancialGoalsModel>('financialGoalsData');

      // Clear existing data and add all goals
      await box.clear();
      for (int i = 0; i < userFinancialGoals.length; i++) {
        await box.put('goal_$i', userFinancialGoals[i]);
      }
    } catch (e) {
      print('Error saving financial goals: $e');
    }
  }

  // Load financial goals from Hive
  void loadFinancialGoalsFromHive() {
    try {
      final box = Hive.box<FinancialGoalsModel>('financialGoalsData');

      userFinancialGoals.clear();
      for (var goal in box.values) {
        userFinancialGoals.add(goal);
      }

      update();
    } catch (e) {
      print('Error loading financial goals: $e');
    }
  }

  void showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: 400.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextAutoSize(
                    'Select Emoji',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: nicotrackBlack1,
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  selectedEmoji = emoji.emoji;
                  update(); // This will trigger validation check
                  Navigator.pop(context);
                },
                config: Config(
                  height: 256,
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax: 28.sp,
                    backgroundColor: const Color(0xFFF2F2F2),
                  ),
                  skinToneConfig: const SkinToneConfig(
                    enabled: true,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    initCategory: Category.SMILEYS,
                    indicatorColor: nicotrackOrange,
                    iconColor: Colors.grey,
                    iconColorSelected: nicotrackOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEmojiPicker1(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: 400.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextAutoSize(
                    'Select Emoji',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: nicotrackBlack1,
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  selectedEmoji1 = emoji.emoji;
                  update(); // This will trigger validation check
                  Navigator.pop(context);
                },
                config: Config(
                  height: 256,
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax: 28.sp,
                    backgroundColor: const Color(0xFFF2F2F2),
                  ),
                  skinToneConfig: const SkinToneConfig(
                    enabled: true,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    initCategory: Category.SMILEYS,
                    indicatorColor: nicotrackOrange,
                    iconColor: Colors.grey,
                    iconColorSelected: nicotrackOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setCurrentFilledData() {
    DateTime currentDateTime = DateTime.now();
    final onboardingBox = Hive.box<OnboardingData>(
        'onboardingCompletedData'); // Specify the type of values in the box
    OnboardingData userOnboardingData =
        onboardingBox.get('currentUserOnboarding') ?? OnboardingData();
    currentDateOnboardingData = userOnboardingData;
    nameController.text = currentDateOnboardingData.name;

    // Initialize quit date
    if (currentDateOnboardingData.lastSmokedDate.isNotEmpty) {
      selectedQuitDate =
          DateTime.parse(currentDateOnboardingData.lastSmokedDate);
    }

    // Initialize cigarettes per day
    if (currentDateOnboardingData.cigarettesPerDay != -1) {
      selectedFreq = currentDateOnboardingData.cigarettesPerDay;
    }

    // Initialize cost per pack
    if (currentDateOnboardingData.costOfAPack.isNotEmpty) {
      List<String> costParts = currentDateOnboardingData.costOfAPack.split('.');
      if (costParts.length == 2) {
        selectedDollar = int.tryParse(costParts[0]) ?? 8;
        selectedCent = int.tryParse(costParts[1]) ?? 0;
      }
    }

    // Initialize notification preferences
    final notificationsBox =
        Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
    NotificationsPreferencesModel notificationPrefs =
        notificationsBox.get('currentUserNotificationPrefs') ??
            NotificationsPreferencesModel();
    currentNotificationsPreferences = notificationPrefs;

    // Set UI variables from saved preferences
    enablePushNotification =
        currentNotificationsPreferences?.pushNotificationsActivated ?? false;
    selectedHour = currentNotificationsPreferences?.dailyReminderHour ?? 8;
    selectedMinute = currentNotificationsPreferences?.dailyReminderMinute ?? 0;
    selectedHalf =
        currentNotificationsPreferences?.dailyReminderPeriod ?? " AM";
    selectedweekday =
        currentNotificationsPreferences?.weeklyReminderDay ?? "Monday";
    selectedWeeklyHour =
        currentNotificationsPreferences?.weeklyReminderHour ?? 6;
    selectedWeeklyMinute =
        currentNotificationsPreferences?.weeklyReminderMinute ?? 0;
    selectedWeeklyHalf =
        currentNotificationsPreferences?.weeklyReminderPeriod ?? " PM";

    // Check if saved preference is enabled but permission is revoked
    checkAndSyncNotificationPermission();

    // Load financial goals
    loadFinancialGoalsFromHive();

    update();
  }

  void updateUserName() async {
    // Get the box
    final box = Hive.box<OnboardingData>('onboardingCompletedData');

    // Update with new value
    OnboardingData updatedData =
        currentDateOnboardingData.copyWith(name: nameController.text);

    // Save back to Hive
    await box.put('currentUserOnboarding', updatedData);

    // Update local state
    currentDateOnboardingData = updatedData;
    update();
  }

  void updateQuitDate() async {
    // Get the box
    final box = Hive.box<OnboardingData>('onboardingCompletedData');

    // Update with new value
    OnboardingData updatedData = currentDateOnboardingData.copyWith(
        lastSmokedDate: selectedQuitDate.toIso8601String());

    // Save back to Hive
    await box.put('currentUserOnboarding', updatedData);

    // Update local state
    currentDateOnboardingData = updatedData;
    update();
  }

  void updateCigarettesPerDay() async {
    // Get the box
    final box = Hive.box<OnboardingData>('onboardingCompletedData');

    // Update with new value
    OnboardingData updatedData =
        currentDateOnboardingData.copyWith(cigarettesPerDay: selectedFreq);

    // Save back to Hive
    await box.put('currentUserOnboarding', updatedData);

    // Update local state
    currentDateOnboardingData = updatedData;
    update();
  }

  void updateCostPerPack() async {
    // Get the box
    final box = Hive.box<OnboardingData>('onboardingCompletedData');

    // Format cost as string (e.g., "8.25")
    String costString = '$selectedDollar.$selectedCent';

    // Update with new value
    OnboardingData updatedData =
        currentDateOnboardingData.copyWith(costOfAPack: costString);

    // Save back to Hive
    await box.put('currentUserOnboarding', updatedData);

    // Update local state
    currentDateOnboardingData = updatedData;
    update();
  }

  Future<void> updateNotificationPreferences() async {
    try {
      // Get the box
      final box = Hive.box<NotificationsPreferencesModel>(
          'notificationsPreferencesData');

      // Create a fresh instance if needed
      NotificationsPreferencesModel basePrefs =
          currentNotificationsPreferences ?? NotificationsPreferencesModel();

      // Update with current UI state
      NotificationsPreferencesModel updatedPrefs = basePrefs.copyWith(
        pushNotificationsActivated: enablePushNotification,
        dailyReminderHour: selectedHour,
        dailyReminderMinute: selectedMinute,
        dailyReminderPeriod: selectedHalf,
        weeklyReminderDay: selectedweekday,
        weeklyReminderHour: selectedWeeklyHour,
        weeklyReminderMinute: selectedWeeklyMinute,
        weeklyReminderPeriod: selectedWeeklyHalf,
      );

      // Save back to Hive
      await box.put('currentUserNotificationPrefs', updatedPrefs);

      // Update local state
      currentNotificationsPreferences = updatedPrefs;
      update();
    } catch (e, stackTrace) {
      print('Error updating notification preferences: $e');
      // Create fresh instance and retry
      currentNotificationsPreferences = NotificationsPreferencesModel(
        pushNotificationsActivated: enablePushNotification,
        dailyReminderHour: selectedHour,
        dailyReminderMinute: selectedMinute,
        dailyReminderPeriod: selectedHalf,
        weeklyReminderDay: selectedweekday,
        weeklyReminderHour: selectedWeeklyHour,
        weeklyReminderMinute: selectedWeeklyMinute,
        weeklyReminderPeriod: selectedWeeklyHalf,
      );
      update();
    }
  }

  Future<void> updateDailyReminderPreferences() async {
    try {
      // Get the box
      final box = Hive.box<NotificationsPreferencesModel>(
          'notificationsPreferencesData');

      // Create a fresh instance if needed
      NotificationsPreferencesModel basePrefs =
          currentNotificationsPreferences ?? NotificationsPreferencesModel();

      // Update with current daily reminder UI state
      NotificationsPreferencesModel updatedPrefs = basePrefs.copyWith(
        dailyReminderHour: selectedHour,
        dailyReminderMinute: selectedMinute,
        dailyReminderPeriod: selectedHalf,
      );

      // Save back to Hive
      await box.put('currentUserNotificationPrefs', updatedPrefs);

      // Update local state
      currentNotificationsPreferences = updatedPrefs;
      update();
    } catch (e) {
      print('Error updating daily reminder preferences: $e');
    }
  }

  Future<void> updateWeeklyReminderPreferences() async {
    try {
      // Get the box
      final box = Hive.box<NotificationsPreferencesModel>(
          'notificationsPreferencesData');

      // Create a fresh instance if needed
      NotificationsPreferencesModel basePrefs =
          currentNotificationsPreferences ?? NotificationsPreferencesModel();

      // Update with current weekly reminder UI state
      NotificationsPreferencesModel updatedPrefs = basePrefs.copyWith(
        weeklyReminderDay: selectedweekday,
        weeklyReminderHour: selectedWeeklyHour,
        weeklyReminderMinute: selectedWeeklyMinute,
        weeklyReminderPeriod: selectedWeeklyHalf,
      );

      // Save back to Hive
      await box.put('currentUserNotificationPrefs', updatedPrefs);

      // Update local state
      currentNotificationsPreferences = updatedPrefs;
      update();
    } catch (e) {
      print('Error updating weekly reminder preferences: $e');
    }
  }

  // Helper methods to format time for display
  String getFormattedDailyReminderTime() {
    try {
      int hour = currentNotificationsPreferences?.dailyReminderHour ?? 8;
      String period =
          currentNotificationsPreferences?.dailyReminderPeriod ?? ' AM';
      int displayHour = hour == 0 ? 12 : hour;
      return '$displayHour${period.isNotEmpty ? period : ' AM'}';
    } catch (e) {
      return '8 AM'; // Safe fallback
    }
  }

  String getFormattedDailyReminderDetailedTime() {
    try {
      int hour = currentNotificationsPreferences?.dailyReminderHour ?? 8;
      int minute = currentNotificationsPreferences?.dailyReminderMinute ?? 0;
      String period =
          currentNotificationsPreferences?.dailyReminderPeriod ?? ' AM';
      int displayHour = hour == 0 ? 12 : hour;
      String formattedMinute = minute.toString().padLeft(2, '0');
      return '${displayHour.toString().padLeft(2, '0')}: $formattedMinute${period.isNotEmpty ? period : ' AM'}';
    } catch (e) {
      return '08: 00 AM'; // Safe fallback
    }
  }

  String getFormattedWeeklyReminderTime() {
    try {
      String weekday =
          currentNotificationsPreferences?.weeklyReminderDay ?? 'Monday';
      int hour = currentNotificationsPreferences?.weeklyReminderHour ?? 6;
      String period =
          currentNotificationsPreferences?.weeklyReminderPeriod ?? ' PM';

      // Safe substring with null checks
      String shortDay = (weekday.isNotEmpty && weekday.length >= 3)
          ? weekday.substring(0, 3)
          : 'Mon';
      int displayHour = hour == 0 ? 12 : hour;
      return '$shortDay: $displayHour${period.isNotEmpty ? period : ' PM'}';
    } catch (e) {
      return 'Mon: 6 PM'; // Safe fallback
    }
  }

  String getFormattedWeeklyReminderDetailedTime() {
    try {
      int hour = currentNotificationsPreferences?.weeklyReminderHour ?? 6;
      int minute = currentNotificationsPreferences?.weeklyReminderMinute ?? 0;
      String period =
          currentNotificationsPreferences?.weeklyReminderPeriod ?? ' PM';
      int displayHour = hour == 0 ? 12 : hour;
      String formattedMinute = minute.toString().padLeft(2, '0');
      return '${displayHour.toString().padLeft(2, '0')}: $formattedMinute${period.isNotEmpty ? period : ' PM'}';
    } catch (e) {
      return '06: 00 PM'; // Safe fallback
    }
  }

  // Notification permission methods
  Future<bool> checkNotificationPermission() async {
    try {
      return await NotificationService().areNotificationsEnabled();
    } catch (e) {
      print('Permission check error: $e');
      // If permission check fails, assume no permission
      return false;
    }
  }

  void checkAndSyncNotificationPermission() async {
    try {
      // Check current system permission
      bool hasPermission = await checkNotificationPermission();
      bool wasManuallyDisabled =
          currentNotificationsPreferences?.manuallyDisabled ?? false;

      if (hasPermission && !wasManuallyDisabled && !enablePushNotification) {
        // System permission is granted, user hasn't manually disabled, but switch is off - auto-enable
        enablePushNotification = true;
        currentNotificationsPreferences =
            currentNotificationsPreferences?.copyWith(
          pushNotificationsActivated: true,
          manuallyDisabled: false,
        );
        updateNotificationPreferences();
      } else if (!hasPermission &&
          enablePushNotification &&
          !wasManuallyDisabled) {
        // Permission was revoked and user hadn't manually disabled - turn off
        enablePushNotification = false;
        updateNotificationPreferences();
      }
    } catch (e) {
      print('Permission sync error: $e');
      // If there's an error, keep current state
    }
  }

  void syncNotificationPermissionOnLoad() async {
    try {
      // Check actual system permission status
      bool hasSystemPermission = await checkNotificationPermission();

      // Check if user manually disabled notifications
      bool wasManuallyDisabled =
          currentNotificationsPreferences?.manuallyDisabled ?? false;

      if (hasSystemPermission && !wasManuallyDisabled) {
        // System permission is granted and user hasn't manually disabled - auto-enable
        enablePushNotification = true;
        currentNotificationsPreferences =
            currentNotificationsPreferences?.copyWith(
          pushNotificationsActivated: true,
          manuallyDisabled: false,
        );
        await updateNotificationPreferences();
        update();
      } else if (!hasSystemPermission || wasManuallyDisabled) {
        // Either system permission denied OR user manually disabled - keep off
        enablePushNotification = false;
        // Don't change manuallyDisabled flag here - preserve user's manual choice
        await updateNotificationPreferences();
        update();
      }
    } catch (e) {
      print('Error syncing notification permission on load: $e');
    }
  }

  Future<bool> requestNotificationPermission() async {
    try {
      return await NotificationService().requestPermissions();
    } catch (e) {
      print('Permission request error: $e');
      // If permission request fails, return false
      return false;
    }
  }

  void handlePushNotificationToggle(bool value) async {
    try {
      // Ensure preferences are initialized
      if (currentNotificationsPreferences == null) {
        currentNotificationsPreferences = NotificationsPreferencesModel();
      }

      if (value) {
        // User wants to enable notifications
        bool hasPermission = await checkNotificationPermission();

        if (!hasPermission) {
          // Request permission
          bool permissionGranted = await requestNotificationPermission();

          if (permissionGranted) {
            // Permission granted, enable notifications and clear manual disable flag
            enablePushNotification = true;
            currentNotificationsPreferences =
                currentNotificationsPreferences?.copyWith(
              pushNotificationsActivated: true,
              manuallyDisabled: false,
            );
            await updateNotificationPreferences();
          } else {
            // Permission denied, keep switch off and automatically open settings
            enablePushNotification = false;
            update();
            // Automatically open app settings instead of showing dialog
            openAppSettings();
          }
        } else {
          // Permission already granted, enable notifications and clear manual disable flag
          enablePushNotification = true;
          currentNotificationsPreferences =
              currentNotificationsPreferences?.copyWith(
            pushNotificationsActivated: true,
            manuallyDisabled: false,
          );
          await updateNotificationPreferences();
        }
      } else {
        // User manually wants to disable notifications
        enablePushNotification = false;
        currentNotificationsPreferences =
            currentNotificationsPreferences?.copyWith(
          pushNotificationsActivated: false,
          manuallyDisabled: true, // Mark as manually disabled
        );
        await updateNotificationPreferences();
      }
    } catch (e, stackTrace) {
      print('Push notification toggle error: $e');
      print('Full stack trace: $stackTrace');
      // If there's an error, keep switch in current state
      enablePushNotification = !value; // Revert to previous state
      update();
    }
  }

  void validateConfirmationText(String text) {
    isConfirmationValid = text.toLowerCase() == "clear my data";
    update();
  }

  Future<void> clearAllUserData() async {
    try {
      // Cancel all scheduled notifications first
      final notificationService = NotificationService();
      await notificationService.cancelAllNotifications();

      // Clear all Hive database boxes

      // 1. Clear onboarding data
      final onboardingBox = Hive.box<OnboardingData>('onboardingCompletedData');
      await onboardingBox.clear();

      // 2. Clear mood tracking data
      final moodBox = Hive.box<MoodModel>('moodData');
      await moodBox.clear();

      // 3. Clear smoking tracking data
      final smokeBox = Hive.box<DidYouSmokeModel>('didYouSmokeData');
      await smokeBox.clear();

      // 4. Clear quick actions data
      final quickActionsBox = Hive.box<QuickactionsModel>('quickActionsData');
      await quickActionsBox.clear();

      // 5. Clear financial goals data
      final financialGoalsBox =
          Hive.box<FinancialGoalsModel>('financialGoalsData');
      await financialGoalsBox.clear();

      // 6. Clear notification preferences data
      final notificationsBox = Hive.box<NotificationsPreferencesModel>(
          'notificationsPreferencesData');
      await notificationsBox.clear();

      // Reset controller state
      enablePushNotification = false;
      isdailyReminderExpanded = false;
      isweeklyReminderExpanded = false;
      isquitTipsExpanded = false;
      currentPage = 0;

      // Reset confirmation state
      confirmationTextController.clear();
      isConfirmationValid = false;

      // Update the controller to reflect changes
      update();

      print("All user data has been successfully cleared");
    } catch (e) {
      print("Error clearing user data: $e");
      // In production, you might want to show an error dialog to the user
    }
  }

  void showClearDataConfirmation(BuildContext context) {
    // Reset confirmation state
    confirmationTextController.clear();
    isConfirmationValid = false;
    update();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: Duration(milliseconds: 100),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r),
              ),
            ),
            child: GetBuilder<SettingsController>(
              builder: (controller) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.minHeight,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24.w,
                            right: 24.w,
                            top: 20.h,
                            bottom: 24.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Drag handle
                              Container(
                                width: 52.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: nicotrackBlack1,
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),

                              // Close button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: 36.w,
                                      width: 36.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color(0xffFF611D).withOpacity(0.20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Color(0xffFF611D),
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),

                              // Warning emoji circle
                              Text(
                                '‼️',
                                style: TextStyle(fontSize: 48.sp),
                              ),

                              SizedBox(height: 16.h),

                              // Title
                              Text(
                                "Clear All Data",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: circularBold,
                                  color: nicotrackBlack1,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              // Warning badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Color(0xffFF611D).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  "Destructive Action",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: circularMedium,
                                    color: Color(0xffFF611D),
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Warning content box
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 0.w),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF8F8F8),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: circularBook,
                                          height: 1.4,
                                          color: nicotrackBlack1,
                                        ),
                                        children: [
                                          TextSpan(text: "This action "),
                                          TextSpan(
                                            text: "cannot be undone",
                                            style: TextStyle(
                                              fontFamily: circularBold,
                                              color: Color(0xffFF611D),
                                            ),
                                          ),
                                          TextSpan(
                                              text:
                                                  " and will permanently delete all your "),
                                          TextSpan(
                                            text: "progress data",
                                            style: TextStyle(
                                              fontFamily: circularMedium,
                                              color: nicotrackOrange,
                                            ),
                                          ),
                                          TextSpan(
                                              text:
                                                  ", mood records, smoking history, and personal settings."),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),

                                    // Data loss items
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 48.w,
                                              height: 48.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffFF611D)
                                                    .withOpacity(0.15),
                                              ),
                                              child: Center(
                                                child: Text("📊",
                                                    style: TextStyle(
                                                        fontSize: 24.sp)),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              "Progress Data",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackBlack1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: 48.w,
                                              height: 48.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffFF611D)
                                                    .withOpacity(0.15),
                                              ),
                                              child: Center(
                                                child: Text("💭",
                                                    style: TextStyle(
                                                        fontSize: 24.sp)),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              "Mood Records",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackBlack1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: 48.w,
                                              height: 48.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffFF611D)
                                                    .withOpacity(0.15),
                                              ),
                                              child: Center(
                                                child: Text("⚙️",
                                                    style: TextStyle(
                                                        fontSize: 24.sp)),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              "Settings",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackBlack1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Confirmation instruction
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.w,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: nicotrackOrange.withOpacity(0.2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "✋",
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Confirmation Required",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: circularBold,
                                              color: nicotrackBlack1,
                                              height: 1.1,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            "Type \"CLEAR MY DATA\" below to proceed with the deletion.",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: circularBook,
                                              height: 1.3,
                                              color: nicotrackBlack1
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Confirmation text field
                              Container(
                                decoration: BoxDecoration(
                                  color: controller.isConfirmationValid
                                      ? Color(0xffFF611D).withOpacity(0.1)
                                      : Color(0xFFF8F8F8),
                                  border: Border.all(
                                    color: controller.isConfirmationValid
                                        ? Color(0xffFF611D)
                                        : Color(0xFFE0E0E0),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: TextField(
                                  controller:
                                      controller.confirmationTextController,
                                  onChanged:
                                      controller.validateConfirmationText,
                                  textAlign: TextAlign.center,
                                  autofocus: false,
                                  onTap: () {
                                    // Ensure text field is visible when tapped
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      Scrollable.ensureVisible(
                                        context,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                  },
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularMedium,
                                    color: nicotrackBlack1,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type \"CLEAR MY DATA\"",
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: circularBook,
                                      color: Colors.grey.shade500,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 18.h,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // Action buttons
                              Row(
                                children: [
                                  // Cancel button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 54.h,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(27.r),
                                          border: Border.all(
                                            color: Color(0xFFE0E0E0),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: TextAutoSize(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: circularMedium,
                                              color: nicotrackBlack1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),

                                  // Clear data button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: controller.isConfirmationValid
                                          ? () async {
                                              // Close the confirmation dialog first
                                              Navigator.pop(context);

                                              // Perform data clearing
                                              await controller
                                                  .clearAllUserData();

                                              // Navigate to info screen and remove all previous routes
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InfoSliderMain()),
                                                (route) => false,
                                              );
                                            }
                                          : null,
                                      child: Container(
                                        height: 54.h,
                                        decoration: BoxDecoration(
                                          color: controller.isConfirmationValid
                                              ? Color(0xffFF611D)
                                              : Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(27.r),
                                          border: Border.all(
                                            color:
                                                controller.isConfirmationValid
                                                    ? Color(0xffFF611D)
                                                    : Color(0xFFE0E0E0),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: TextAutoSize(
                                            "Clear All Data",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: circularMedium,
                                              color:
                                                  controller.isConfirmationValid
                                                      ? Colors.white
                                                      : Colors.grey.shade500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showPrivacyPolicyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const PrivacyPolicyBottomSheet();
      },
    );
  }

  void showTermsOfUseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const TermsOfUseBottomSheet();
      },
    );
  }

  void showChangeCurrencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
      ),
      builder: (BuildContext context) {
        return const ChangeCurrencyBottomSheet();
      },
    );
  }

  void showChangeLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
      ),
      builder: (BuildContext context) {
        return const ChangeLanguageBottomSheet();
      },
    );
  }
}
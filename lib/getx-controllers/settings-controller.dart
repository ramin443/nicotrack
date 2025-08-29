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
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-morning-time.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-evening-time.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-weekly-time.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/set-weekday.dart';
import 'package:nicotrack/screens/base/settings-subpages/bottom-sheets/smokes-per-day.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import 'package:nicotrack/getx-controllers/home-controller.dart';

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
import 'package:url_launcher/url_launcher.dart';
import '../screens/base/settings-subpages/bottom-sheets/change-currency.dart';
import '../screens/base/settings-subpages/bottom-sheets/change-language.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/models/quick-actions-model/quickActions-model.dart';
import 'package:nicotrack/initial/welcome-info/info-slider-main.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';
import 'package:nicotrack/services/firebase-service.dart';

class SettingsController extends GetxController with WidgetsBindingObserver {
  bool enablePushNotification = false;
  bool isdailyReminderExpanded = false;

  // Clear data confirmation variables
  TextEditingController confirmationTextController = TextEditingController();
  bool isConfirmationValid = false;
  
  // Contact Support and Feedback form controllers
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactDetailsController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  int feedbackRating = 5; // Default rating (1-5 stars)
  String feedbackType = 'general'; // general, bug_report, feature_request, other
  bool isSubmittingSupport = false;
  bool isSubmittingFeedback = false;
  
  // Error message states for inline display
  String? contactSupportErrorMessage;
  String? feedbackErrorMessage;
  bool isweeklyReminderExpanded = false;
  bool isquitTipsExpanded = false;
  final PageController financialGoalsScrollController =
      PageController(viewportFraction: 0.75);
  int currentPage = 0;
  // Dynamic getter for localized add new goal text
  EmojiTextModel getAddNewGoal(BuildContext context) => EmojiTextModel(emoji: '🎯', text: context.l10n.add_new_goal);

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
  List<int> hours = List.generate(12, (index) => index + 1); // 1 to 12
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
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Wait a bit to ensure Hive boxes are fully opened
    await Future.delayed(Duration(milliseconds: 100));
    
    await setCurrentFilledData();
    
    // Simple load - just get what the user last saved, no complex syncing
    await _loadNotificationStateFromHive();
    
    print('🔔 SETTINGS INIT COMPLETE: enablePushNotification = $enablePushNotification');
  }
  
  // Simple method to load notification state from Hive
  Future<void> _loadNotificationStateFromHive() async {
    try {
      print('🔔 SETTINGS: Loading notification state from Hive...');
      
      // Wait a bit to ensure Hive operations from onboarding are complete
      await Future.delayed(Duration(milliseconds: 100));
      
      // Get fresh data from Hive
      final box = Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
      final prefs = box.get('currentUserNotificationPrefs');
      
      if (prefs != null) {
        enablePushNotification = prefs.pushNotificationsActivated;
        currentNotificationsPreferences = prefs;
        print('🔔 SETTINGS LOADED: pushNotificationsActivated = ${prefs.pushNotificationsActivated}');
        print('🔔 SETTINGS LOADED: manuallyDisabled = ${prefs.manuallyDisabled}');
      } else {
        // No preferences found - default to false
        enablePushNotification = false;
        print('🔔 SETTINGS: No notification preferences found, defaulting to false');
      }
      
      update();
      
    } catch (e) {
      print('🔔 SETTINGS ERROR: Failed to load notification state: $e');
      enablePushNotification = false;
      update();
    }
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
    // Removed complex sync logic - keep it simple
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
              HapticFeedback.mediumImpact();
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
              HapticFeedback.mediumImpact();
              showChangeQuitDateBottomSheet(context);
            },
            child: personalInfoBox(
                fieldName: context.l10n.field_quit_date,
                fieldValue: convertDatetoUsableFormat(selectedQuitDate.toIso8601String()),
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
                HapticFeedback.mediumImpact();
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
                HapticFeedback.mediumImpact();
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
            width: 185.w,
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
                    HapticFeedback.lightImpact();
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
          // weeklyReminderSection(context),
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
            HapticFeedback.mediumImpact();
            showAddFinancialGoalsBottomSheet(context);
          },
          onItemTap: (index) {
            HapticFeedback.mediumImpact();
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
              // Commented out quit tips section
              // quitTipsSection(context),
              // SizedBox(
              //   height: 8.w,
              // ),
              normalInfoBox(
                  fieldValue: context.l10n.contact_support,
                  action: () {
                    HapticFeedback.lightImpact();
                    showContactSupportBottomSheet(context);
                  }),
              SizedBox(
                height: 8.w,
              ),
              normalInfoBox(
                  fieldValue: context.l10n.give_feedback,
                  action: () {
                    HapticFeedback.lightImpact();
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
              HapticFeedback.lightImpact();
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
                        TextSpan(text: context.l10n.privacy_policy),
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
              HapticFeedback.lightImpact();
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
                        TextSpan(text: context.l10n.terms_of_use),
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
              HapticFeedback.mediumImpact();
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
                        TextSpan(text: context.l10n.clear_my_journey),
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
                    value: selectedFreq.toDouble(),
                    label: context.l10n.field_cigarettes_per_day,
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
                    value: double.parse('$selectedDollar.$selectedCent'),
                    label: context.l10n.field_cost_per_pack,
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
            HapticFeedback.lightImpact();
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
              Container(), // Empty container since we'll show times in expanded section
            ],
          ),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 8.w,
                ),
                // Morning notification time selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showSetMorningTimeBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.sp, vertical: 10.sp),
                        decoration: BoxDecoration(
                            color: nicotrackOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(9.r)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextAutoSize('Morning: ',
                                style: TextStyle(
                                  height: 1.1,
                                  fontSize: 16.sp,
                                  fontFamily: circularMedium,
                                  color: nicotrackOrange,
                                )),
                            TextAutoSize(getFormattedMorningTime(),
                                style: TextStyle(
                                  height: 1.1,
                                  fontSize: 16.sp,
                                  fontFamily: circularBold,
                                  color: nicotrackOrange,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.w,
                ),
                // Evening notification time selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showSetEveningTimeBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.sp, vertical: 10.sp),
                        decoration: BoxDecoration(
                            color: nicotrackOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(9.r)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextAutoSize('Evening: ',
                                style: TextStyle(
                                  height: 1.1,
                                  fontSize: 16.sp,
                                  fontFamily: circularMedium,
                                  color: nicotrackOrange,
                                )),
                            TextAutoSize(getFormattedEveningTime(),
                                style: TextStyle(
                                  height: 1.1,
                                  fontSize: 16.sp,
                                  fontFamily: circularBold,
                                  color: nicotrackOrange,
                                )),
                          ],
                        ),
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

  // Widget weeklyReminderSection(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(21.r),
  //       color: btnBGLightGrey,
  //       // border: Border.all(
  //       //   width: 1,
  //       //   color: const Color(0xFFEFEFEF),
  //       // )
  //     ),
  //     child: ExpansionTile(
  //         trailing: AnimatedRotation(
  //           turns: isweeklyReminderExpanded ? 0.5 : 0.0,
  //           // 180 degrees when expanded
  //           duration: Duration(milliseconds: 200),
  //           child: Icon(
  //             FeatherIcons.chevronDown,
  //             size: 20.sp,
  //             color: nicotrackOrange,
  //           ),
  //         ),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
  //         collapsedShape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
  //         backgroundColor: btnBGLightGrey,
  //         collapsedBackgroundColor: btnBGLightGrey,
  //         initiallyExpanded: false,
  //         tilePadding: EdgeInsets.only(right: 19.w, top: 6.h, bottom: 6.h),
  //         childrenPadding: EdgeInsets.only(bottom: 14.h),
  //         onExpansionChanged: (expanded) {
  //           isweeklyReminderExpanded = expanded;
  //           update();
  //         },
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 SizedBox(
  //                   width: 18.w,
  //                 ),
  //                 SizedBox(
  //                   width: 175.w,
  //                   child: TextAutoSize(
  //                       context.l10n.weekly_summary,
  //                       textAlign: TextAlign.left,
  //                       style: TextStyle(
  //                         height: 1.1,
  //                         fontSize: 16.sp,
  //                         fontFamily: circularMedium,
  //                         color: nicotrackBlack1,
  //                       )),
  //                 )
  //               ],
  //             ),
  //             TextAutoSize(getFormattedWeeklyReminderTime(),
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   height: 1.1,
  //                   fontSize: 16.sp,
  //                   fontFamily: circularBold,
  //                   color: nicotrackOrange,
  //                 )),
  //           ],
  //         ),
  //         children: [
  //           Column(
  //             children: [
  //               SizedBox(
  //                 height: 8.w,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       showWeekDayBottomSheet(context);
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: 13.sp, vertical: 10.sp),
  //                       decoration: BoxDecoration(
  //                           color: nicotrackOrange.withOpacity(0.2),
  //                           borderRadius: BorderRadius.circular(9.r)),
  //                       child: TextAutoSize(
  //                           currentNotificationsPreferences
  //                                   ?.weeklyReminderDay ??
  //                               'Monday',
  //                           textAlign: TextAlign.left,
  //                           style: TextStyle(
  //                             height: 1.1,
  //                             fontSize: 16.sp,
  //                             fontFamily: circularBold,
  //                             color: nicotrackOrange,
  //                           )),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 12.w,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       showWeeklySetTimeBottomSheet(context);
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: 13.sp, vertical: 10.sp),
  //                       decoration: BoxDecoration(
  //                           color: nicotrackOrange.withOpacity(0.2),
  //                           borderRadius: BorderRadius.circular(9.r)),
  //                       child: TextAutoSize(
  //                           getFormattedWeeklyReminderDetailedTime(),
  //                           textAlign: TextAlign.left,
  //                           style: TextStyle(
  //                             height: 1.1,
  //                             fontSize: 16.sp,
  //                             fontFamily: circularBold,
  //                             color: nicotrackOrange,
  //                           )),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 8.w,
  //               ),
  //             ],
  //           ),
  //         ]),
  //   );
  // }

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
            HapticFeedback.lightImpact();
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

  void showSetMorningTimeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SetMorningTimeBottomSheet();
        });
  }

  void showSetEveningTimeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        // isScrollControlled: true,
        builder: (context) {
          return SetEveningTimeBottomSheet();
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
                          HapticFeedback.lightImpact();
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
                              HapticFeedback.lightImpact();
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
                          HapticFeedback.lightImpact();
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
                              HapticFeedback.lightImpact();
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
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: ChangeNameBottomSheet(),
          );
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

  Widget contactSupportTextFields(BuildContext context) {
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
                context.l10n.email_address,
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
            controller: contactEmailController,
            cursorColor: nicotrackBlack1,
            textInputAction: TextInputAction.done,
            scrollPadding: EdgeInsets.only(bottom: 100.h),
            onSubmitted: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: context.l10n.email_placeholder,
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
                context.l10n.details,
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
              controller: contactDetailsController,
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
                hintText: context.l10n.describe_issue_placeholder,
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
          ),
          // Error message display
          if (contactSupportErrorMessage != null) ...[
            SizedBox(height: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 16.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextAutoSize(
                      contactSupportErrorMessage!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: circularBook,
                        color: Colors.red,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              context.l10n.new_financial_goal,
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
            hintText: context.l10n.goal_title_placeholder,
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
              context.l10n.set_the_price,
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

  Widget honestFeedbackTextFields(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 300.h,
            child: TextField(
              controller: feedbackController,
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
                hintText: context.l10n.your_feedback_placeholder,
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
          ),
          // Error message display
          if (feedbackErrorMessage != null) ...[
            SizedBox(height: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 16.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextAutoSize(
                      feedbackErrorMessage!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: circularBook,
                        color: Colors.red,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        cost: double.tryParse('$selectedFinGoalDollar.$selectedFinGoalCent') ?? 0.0,
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
        cost: double.tryParse('$selectedFinGoalDollar1.$selectedFinGoalCent1') ?? 0.0,
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
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
                  HapticFeedback.lightImpact();
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
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
                  HapticFeedback.lightImpact();
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

  Future<void> setCurrentFilledData() async {
    DateTime currentDateTime = DateTime.now();
    
    // Check if box is open before accessing (same as home controller)
    if (Hive.isBoxOpen('onboardingCompletedData')) {
      final onboardingBox = Hive.box<OnboardingData>(
          'onboardingCompletedData'); // Specify the type of values in the box
      OnboardingData userOnboardingData =
          onboardingBox.get('currentUserOnboarding') ?? OnboardingData();
      
      currentDateOnboardingData = userOnboardingData;
    } else {
      // If box is not open yet, set default model (same as home controller)
      currentDateOnboardingData = OnboardingData();
    }
    // Always set the name from the loaded data
    nameController.text = currentDateOnboardingData.name;
    
    // Initialize quit date - use the stored date or keep current default
    if (currentDateOnboardingData.lastSmokedDate.isNotEmpty) {
      selectedQuitDate =
          DateTime.parse(currentDateOnboardingData.lastSmokedDate);
    } else {
      // Keep today's date as default if no date is stored
      selectedQuitDate = DateTime.now();
    }

    // Initialize cigarettes per day - always use the stored value
    if (currentDateOnboardingData.cigarettesPerDay != -1 && 
        currentDateOnboardingData.cigarettesPerDay > 0) {
      selectedFreq = currentDateOnboardingData.cigarettesPerDay;
    } else {
      // Only use default if no data was stored (-1 means not set)
      selectedFreq = 8;
    }

    // Initialize cost per pack - always parse the stored value
    if (currentDateOnboardingData.costOfAPack.isNotEmpty) {
      List<String> costParts = currentDateOnboardingData.costOfAPack.split('.');
      if (costParts.length == 2) {
        selectedDollar = int.tryParse(costParts[0]) ?? 8;
        selectedCent = int.tryParse(costParts[1]) ?? 0;
      } else if (costParts.length == 1) {
        // Handle case where there's no decimal point (e.g., "8")
        selectedDollar = int.tryParse(costParts[0]) ?? 8;
        selectedCent = 0;
      } else {
        // Fallback to defaults if parsing fails
        selectedDollar = 8;
        selectedCent = 0;
      }
    } else {
      // Only use defaults if no cost was stored
      selectedDollar = 8;
      selectedCent = 0;
    }

    // Initialize notification preferences - just load, don't set enablePushNotification here
    final notificationsBox =
        Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
    
    NotificationsPreferencesModel notificationPrefs =
        notificationsBox.get('currentUserNotificationPrefs') ?? NotificationsPreferencesModel();
    currentNotificationsPreferences = notificationPrefs;
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

    // Initialize morning/evening times if they don't exist in storage
    // Removed problematic initialization - using defaults from model instead

    // Don't auto-sync permissions here - only sync on explicit load
    // checkAndSyncNotificationPermission() - removed to prevent unexpected toggle changes

    // Load financial goals
    loadFinancialGoalsFromHive();

    update();
  }

  // Initialize morning/evening times if they don't exist in storage
  Future<void> _initializeMorningEveningTimes() async {
    try {
      final box = Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
      
      // Check if morning/evening times are already set (not using defaults)
      bool morningTimeExists = currentNotificationsPreferences?.morningReminderHour != 8 || 
                              currentNotificationsPreferences?.morningReminderMinute != 0 ||
                              currentNotificationsPreferences?.morningReminderPeriod != ' AM';
      
      bool eveningTimeExists = currentNotificationsPreferences?.eveningReminderHour != 8 || 
                              currentNotificationsPreferences?.eveningReminderMinute != 0 ||
                              currentNotificationsPreferences?.eveningReminderPeriod != ' PM';
      
      // If morning/evening times don't exist, initialize them with defaults and save
      if (!morningTimeExists || !eveningTimeExists) {
        print('🔔 Initializing missing morning/evening times with defaults');
        
        NotificationsPreferencesModel updatedPrefs = (currentNotificationsPreferences ?? NotificationsPreferencesModel()).copyWith(
          morningReminderHour: 8,
          morningReminderMinute: 0,
          morningReminderPeriod: ' AM',
          eveningReminderHour: 8,
          eveningReminderMinute: 0,
          eveningReminderPeriod: ' PM',
        );
        
        await box.put('currentUserNotificationPrefs', updatedPrefs);
        currentNotificationsPreferences = updatedPrefs;
        print('🔔 Saved default morning (8:00 AM) and evening (8:00 PM) times to storage');
      } else {
        print('🔔 Morning and evening times already exist in storage - Morning: ${currentNotificationsPreferences?.morningReminderHour}:${currentNotificationsPreferences?.morningReminderMinute}${currentNotificationsPreferences?.morningReminderPeriod}, Evening: ${currentNotificationsPreferences?.eveningReminderHour}:${currentNotificationsPreferences?.eveningReminderMinute}${currentNotificationsPreferences?.eveningReminderPeriod}');
      }
      
      update();
    } catch (e) {
      print('🔔 Error initializing morning/evening times: $e');
    }
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
    
    // Log settings change
    FirebaseService().logSettingsChanged(
      settingType: 'user_name',
      newValue: nameController.text.isNotEmpty ? 'name_provided' : 'name_removed',
    );
    
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
    
    // Refresh home controller to recalculate values
    try {
      final homeController = Get.find<HomeController>();
      homeController.setCurrentFilledData();
      homeController.resetHomeGridValues();
      print('✅ Home controller refreshed after quit date change');
    } catch (e) {
      print('⚠️ Home controller not found, will refresh when accessed: $e');
    }
    
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
    
    // Refresh home controller to recalculate values
    try {
      final homeController = Get.find<HomeController>();
      homeController.setCurrentFilledData();
      homeController.resetHomeGridValues();
      print('✅ Home controller refreshed after cigarettes per day change');
    } catch (e) {
      print('⚠️ Home controller not found, will refresh when accessed: $e');
    }
    
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
    
    // Refresh home controller to recalculate values
    try {
      final homeController = Get.find<HomeController>();
      homeController.setCurrentFilledData();
      homeController.resetHomeGridValues();
      print('✅ Home controller refreshed after cost per pack change');
    } catch (e) {
      print('⚠️ Home controller not found, will refresh when accessed: $e');
    }
    
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

      // Update with current UI state (use currentNotificationsPreferences if it was updated)
      NotificationsPreferencesModel prefsToSave = currentNotificationsPreferences ?? basePrefs;
      NotificationsPreferencesModel updatedPrefs = prefsToSave.copyWith(
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
      
      // Debug: Print what we're saving
      print('🔔 SAVING to Hive: pushNotificationsActivated=${updatedPrefs.pushNotificationsActivated}, manuallyDisabled=${updatedPrefs.manuallyDisabled}');

      // Update local state
      currentNotificationsPreferences = updatedPrefs;
      update();
    } catch (e, stackTrace) {
      print('Error updating notification preferences: $e');
      // Create fresh instance and retry (preserve manuallyDisabled state if it existed)
      bool preserveManuallyDisabled = currentNotificationsPreferences?.manuallyDisabled ?? false;
      currentNotificationsPreferences = NotificationsPreferencesModel(
        pushNotificationsActivated: enablePushNotification,
        manuallyDisabled: preserveManuallyDisabled,
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
      
      // Update notification service with new time
      final notificationService = NotificationService();
      int hour24Format = _convertTo24HourFormat(selectedHour, selectedHalf);
      
      print('🔔 DEBUG Settings Controller - Daily Reminder:');
      print('  Selected: ${selectedHour}:${selectedMinute.toString().padLeft(2, '0')} ${selectedHalf}');
      print('  Converted to 24h: ${hour24Format}:${selectedMinute.toString().padLeft(2, '0')}');
      
      await notificationService.updateMorningNotificationTime(hour24Format, selectedMinute);
      
      // Schedule a test notification to verify the change worked
      await notificationService.scheduleSettingsTestNotification(hour24Format, selectedMinute);
      
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
      
      // Update notification service with new time  
      final notificationService = NotificationService();
      int hour24Format = _convertTo24HourFormat(selectedWeeklyHour, selectedWeeklyHalf);
      
      print('🔔 DEBUG Settings Controller - Weekly Reminder:');
      print('  Selected: ${selectedWeeklyHour}:${selectedWeeklyMinute.toString().padLeft(2, '0')} ${selectedWeeklyHalf}');
      print('  Converted to 24h: ${hour24Format}:${selectedWeeklyMinute.toString().padLeft(2, '0')}');
      
      await notificationService.updateEveningNotificationTime(hour24Format, selectedWeeklyMinute);
      
      // Schedule a test notification to verify the change worked
      await notificationService.scheduleSettingsTestNotification(hour24Format, selectedWeeklyMinute);
      
      update();
    } catch (e) {
      print('Error updating weekly reminder preferences: $e');
    }
  }

  // Update morning notification time (8 AM default)
  Future<void> updateMorningNotificationTime() async {
    try {
      final notificationService = NotificationService();
      int hour24Format = _convertTo24HourFormat(selectedHour, selectedHalf);
      
      // Update notification schedule
      await notificationService.updateMorningNotificationTime(hour24Format, selectedMinute);
      
      // Save to preferences
      final box = Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
      NotificationsPreferencesModel basePrefs = currentNotificationsPreferences ?? NotificationsPreferencesModel();
      
      NotificationsPreferencesModel updatedPrefs = basePrefs.copyWith(
        morningReminderHour: selectedHour,
        morningReminderMinute: selectedMinute,
        morningReminderPeriod: selectedHalf,
      );
      
      await box.put('currentUserNotificationPrefs', updatedPrefs);
      await box.flush();
      
      currentNotificationsPreferences = updatedPrefs;
      
      update();
    } catch (e) {
      print('Error updating morning notification time: $e');
    }
  }


  // Update evening notification time (8 PM default)
  Future<void> updateEveningNotificationTime() async {
    try {
      final notificationService = NotificationService();
      int hour24Format = _convertTo24HourFormat(selectedHour, selectedHalf);
      
      // Update notification schedule
      await notificationService.updateEveningNotificationTime(hour24Format, selectedMinute);
      
      // Save to preferences
      final box = Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
      NotificationsPreferencesModel basePrefs = currentNotificationsPreferences ?? NotificationsPreferencesModel();
      
      NotificationsPreferencesModel updatedPrefs = basePrefs.copyWith(
        eveningReminderHour: selectedHour,
        eveningReminderMinute: selectedMinute,
        eveningReminderPeriod: selectedHalf,
      );
      
      await box.put('currentUserNotificationPrefs', updatedPrefs);
      await box.flush();
      
      currentNotificationsPreferences = updatedPrefs;
      
      update();
    } catch (e) {
      print('Error updating evening notification time: $e');
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

  // Morning notification time (8:00 AM default)
  String getFormattedMorningTime() {
    try {
      // Get stored morning time from preferences
      int hour = currentNotificationsPreferences?.morningReminderHour ?? 8;
      int minute = currentNotificationsPreferences?.morningReminderMinute ?? 0;
      String period = currentNotificationsPreferences?.morningReminderPeriod ?? ' AM';
      
      // Format for display
      int displayHour = hour == 0 ? 12 : hour;
      String formattedMinute = minute.toString().padLeft(2, '0');
      String result = '${displayHour.toString().padLeft(2, '0')}:$formattedMinute$period';
      
      return result;
    } catch (e) {
      print('Error in getFormattedMorningTime: $e');
      return '08:00 AM'; // Safe fallback
    }
  }

  // Evening notification time (8:00 PM default)
  String getFormattedEveningTime() {
    try {
      // Get stored evening time from preferences
      int hour = currentNotificationsPreferences?.eveningReminderHour ?? 8;
      int minute = currentNotificationsPreferences?.eveningReminderMinute ?? 0;
      String period = currentNotificationsPreferences?.eveningReminderPeriod ?? ' PM';
      
      
      // Format for display
      int displayHour = hour == 0 ? 12 : hour;
      String formattedMinute = minute.toString().padLeft(2, '0');
      return '${displayHour.toString().padLeft(2, '0')}:$formattedMinute$period';
    } catch (e) {
      print('🔔 ERROR in getFormattedEveningTime: $e');
      return '08:00 PM'; // Safe fallback
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

  // Public method to refresh notification state (can be called from anywhere)
  Future<void> refreshNotificationState() async {
    print('🔔 REFRESH: Refreshing notification state...');
    await _loadNotificationStateFromHive();
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
    print('🔔 SIMPLE TOGGLE: User toggled to $value');
    
    // Step 1: Update UI immediately
    enablePushNotification = value;
    update();
    
    // Step 2: If turning ON, check for system permission first
    if (value) {
      bool hasPermission = await checkNotificationPermission();
      if (!hasPermission) {
        print('🔔 No system permission - requesting...');
        bool granted = await requestNotificationPermission();
        if (!granted) {
          print('🔔 Permission denied - reverting toggle');
          enablePushNotification = false;
          update();
          return;
        }
      }
    }
    
    // Step 3: Save to Hive immediately and simply
    try {
      final box = Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
      
      // Create or update preferences
      NotificationsPreferencesModel updatedPrefs = (currentNotificationsPreferences ?? NotificationsPreferencesModel()).copyWith(
        pushNotificationsActivated: value,
        manuallyDisabled: !value, // True when turned OFF, False when turned ON
      );
      
      // Save to Hive
      await box.put('currentUserNotificationPrefs', updatedPrefs);
      await box.flush(); // Force write
      
      // Update local state
      currentNotificationsPreferences = updatedPrefs;
      
      print('🔔 SIMPLE SAVE SUCCESS: pushNotificationsActivated=$value');
      
      // Step 4: Handle notifications
      if (value) {
        await NotificationService().forceScheduleNotifications();
        print('🔔 Notifications scheduled');
      } else {
        await NotificationService().cancelAllNotifications();
        print('🔔 Notifications cancelled');
      }
      
    } catch (e) {
      print('🔔 SIMPLE TOGGLE ERROR: $e');
      // Revert UI on error
      enablePushNotification = !value;
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
              maxHeight: MediaQuery.of(context).size.height * 0.92,
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
                                      HapticFeedback.lightImpact();
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
                                context.l10n.clear_data_title,
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
                                  context.l10n.clear_data_destructive_action,
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
                                          TextSpan(text: context.l10n.clear_data_this_action + " "),
                                          TextSpan(
                                            text: context.l10n.clear_data_cannot_be_undone,
                                            style: TextStyle(
                                              fontFamily: circularBold,
                                              color: Color(0xffFF611D),
                                            ),
                                          ),
                                          TextSpan(
                                              text: " " + context.l10n.clear_data_will_delete + " "),
                                          TextSpan(
                                            text: context.l10n.clear_data_progress_data,
                                            style: TextStyle(
                                              fontFamily: circularMedium,
                                              color: nicotrackOrange,
                                            ),
                                          ),
                                          TextSpan(
                                              text: context.l10n.clear_data_delete_description),
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
                                            SizedBox(height: 8.w),
                                            SizedBox(width:90.w,
                                            child: Text(
                                              context.l10n.clear_data_progress_label,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackBlack1,
                                              ),
                                            ),),

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
                                            SizedBox(width:90.w,
                                              child: Text(
                                              context.l10n.clear_data_mood_records,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackBlack1,
                                              ),
                                            ),)
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
                                            SizedBox(width:90.w,
                                              child: Text(
                                              context.l10n.clear_data_settings,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: circularMedium,
                                                color: nicotrackBlack1,
                                              ),
                                            ),)
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
                                            context.l10n.clear_data_confirmation_required,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: circularBold,
                                              color: nicotrackBlack1,
                                              height: 1.1,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            context.l10n.clear_data_type_instruction,
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
                                    hintText: context.l10n.clear_data_type_hint,
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
                                        HapticFeedback.lightImpact();
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
                                              HapticFeedback.lightImpact();
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
                                            context.l10n.clear_data_button,
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

  void showPrivacyPolicyBottomSheet(BuildContext context) async {
    final Uri url = Uri.parse('https://aged-jewel-b95.notion.site/Nicotrack-Privacy-Policy-24818258f0c080199a49c27c50efd55a?source=copy_link');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Privacy Policy',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
    }
  }

  void showTermsOfUseBottomSheet(BuildContext context) async {
    final Uri url = Uri.parse('https://aged-jewel-b95.notion.site/Nicotrack-Terms-of-Use-24818258f0c080fdac85ccca299d576a?source=copy_link');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Terms of Use',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
    }
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

  // Contact Support and Feedback submission methods
  Future<void> submitContactSupport(BuildContext context) async {
    if (isSubmittingSupport) return;
    
    // Clear previous error messages
    contactSupportErrorMessage = null;
    
    // Validate form
    if (contactEmailController.text.trim().isEmpty) {
      contactSupportErrorMessage = context.l10n.email_address_required;
      update();
      return;
    }
    
    if (contactDetailsController.text.trim().isEmpty) {
      contactSupportErrorMessage = context.l10n.issue_description_required;
      update();
      return;
    }
    
    if (!_isValidEmail(contactEmailController.text.trim())) {
      contactSupportErrorMessage = context.l10n.valid_email_required;
      update();
      return;
    }
    
    isSubmittingSupport = true;
    update();
    
    try {
      // Get device and app info
      final deviceInfo = await FirebaseService().getDeviceAndAppInfo();
      
      // Generate user ID (you can replace this with actual user ID from your auth system)
      final userId = _generateUserId();
      
      // Submit to Firebase Firestore
      await FirebaseService().saveContactSupport(
        userId: userId,
        email: contactEmailController.text.trim(),
        details: contactDetailsController.text.trim(),
        deviceInfo: '${deviceInfo['device_model']} - ${deviceInfo['os_version']}',
        appVersion: '${deviceInfo['app_version']} (${deviceInfo['app_build']})',
      );
      
      // Log analytics event
      FirebaseService().logEvent(
        name: 'contact_support_submitted',
        parameters: {
          'email_provided': 'true',
          'details_length': contactDetailsController.text.trim().length.toString(),
          'platform': deviceInfo['platform'] ?? 'unknown',
        },
      );
      
      // Clear form
      contactEmailController.clear();
      contactDetailsController.clear();
      
      // Show success message
      _showSuccessSnackBar(context, context.l10n.support_request_submitted_success);
      
      // Close bottom sheet
      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
      
    } catch (e) {
      print('Error submitting contact support: $e');
      contactSupportErrorMessage = context.l10n.support_request_failed;
    } finally {
      isSubmittingSupport = false;
      update();
    }
  }

  Future<void> submitFeedback(BuildContext context) async {
    if (isSubmittingFeedback) return;
    
    // Clear previous error messages
    feedbackErrorMessage = null;
    
    // Validate form
    if (feedbackController.text.trim().isEmpty) {
      feedbackErrorMessage = context.l10n.feedback_required;
      update();
      return;
    }
    
    isSubmittingFeedback = true;
    update();
    
    try {
      // Get device and app info
      final deviceInfo = await FirebaseService().getDeviceAndAppInfo();
      
      // Generate user ID (you can replace this with actual user ID from your auth system)
      final userId = _generateUserId();
      
      // Get user context for better analysis
      final userContext = await _getUserContext();
      
      // Submit to Firebase Firestore
      await FirebaseService().saveFeedback(
        userId: userId,
        feedback: feedbackController.text.trim(),
        rating: feedbackRating,
        feedbackType: feedbackType,
        deviceInfo: '${deviceInfo['device_model']} - ${deviceInfo['os_version']}',
        appVersion: '${deviceInfo['app_version']} (${deviceInfo['app_build']})',
        userContext: userContext,
      );
      
      // Log analytics event
      FirebaseService().logEvent(
        name: 'feedback_submitted',
        parameters: {
          'rating': feedbackRating.toString(),
          'feedback_type': feedbackType,
          'feedback_length': feedbackController.text.trim().length.toString(),
          'platform': deviceInfo['platform'] ?? 'unknown',
        },
      );
      
      // Clear form
      feedbackController.clear();
      feedbackRating = 5; // Reset to default
      feedbackType = 'general';
      
      // Show success message
      _showSuccessSnackBar(context, context.l10n.feedback_submitted_success);
      
      // Close bottom sheet
      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
      
    } catch (e) {
      print('Error submitting feedback: $e');
      feedbackErrorMessage = context.l10n.feedback_submission_failed;
    } finally {
      isSubmittingFeedback = false;
      update();
    }
  }

  // Helper methods
  String _generateUserId() {
    // Generate a simple user ID based on device and timestamp
    // In a real app, you'd use Firebase Auth or another user management system
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'user_${now.toString().substring(now.toString().length - 8)}';
  }

  Future<Map<String, dynamic>> _getUserContext() async {
    try {
      // Get user's current progress and app usage data
      final onboardingBox = Hive.box<OnboardingData>('onboardingCompletedData');
      final userData = onboardingBox.get('currentUserOnboarding');
      
      return {
        'days_since_quit': userData?.lastSmokedDate != null 
            ? DateTime.now().difference(DateTime.parse(userData!.lastSmokedDate)).inDays
            : null,
        'cigarettes_per_day': userData?.cigarettesPerDay,
        'user_name_provided': userData?.name?.isNotEmpty == true,
        'app_language': Get.locale?.languageCode ?? 'en',
        'submission_timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': 'Could not retrieve user context',
        'submission_timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextAutoSize(
          message,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              height: 1.2,
              color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextAutoSize(
          message,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              height: 1.2,
              color: Colors.white),
        ),
        backgroundColor: nicotrackBlack1,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Rating and feedback type setters
  void setFeedbackRating(int rating) {
    feedbackRating = rating;
    update();
  }

  void setFeedbackType(String type) {
    feedbackType = type;
    update();
  }

  // Form validation helpers
  bool get isContactSupportFormValid {
    return contactEmailController.text.trim().isNotEmpty &&
           contactDetailsController.text.trim().isNotEmpty &&
           _isValidEmail(contactEmailController.text.trim());
  }

  bool get isFeedbackFormValid {
    return feedbackController.text.trim().isNotEmpty;
  }

  // Debug method to test notifications
  Future<void> debugNotifications() async {
    final notificationService = NotificationService();
    
    print('🔔 DEBUG: Testing notification permissions and scheduling...');
    
    // Check permissions
    final bool enabled = await notificationService.areNotificationsEnabled();
    print('🔔 Notifications enabled: $enabled');
    
    if (enabled) {
      // Send immediate test notification
      await notificationService.scheduleTestNotification();
      
      // Send 5-second delayed notification (better for testing)
      await notificationService.scheduleTestNotificationDelayed();
      
      // Check pending notifications
      await notificationService.debugPendingNotifications();
    } else {
      print('🔔 Notifications not enabled - please enable in device settings');
    }
  }

  // Helper method to convert 12-hour format to 24-hour format
  int _convertTo24HourFormat(int hour12, String period) {
    print('🔔 Time conversion: $hour12:xx $period → ?');
    
    // Validate inputs
    if (hour12 < 1 || hour12 > 12) {
      print('🔔 ERROR: Invalid 12-hour format hour: $hour12');
      return 8; // Default to 8 AM if invalid
    }
    
    if (period != ' AM' && period != ' PM') {
      print('🔔 ERROR: Invalid period: "$period"');
      return 8; // Default to 8 AM if invalid
    }
    
    int hour24;
    
    if (period == ' AM') {
      if (hour12 == 12) {
        hour24 = 0; // 12 AM = 00:00 (midnight)
        print('🔔 Time conversion: 12 AM → 0 (midnight)');
      } else {
        hour24 = hour12; // 1-11 AM = 01:00-11:00
        print('🔔 Time conversion: $hour12 AM → $hour24');
      }
    } else { // PM
      if (hour12 == 12) {
        hour24 = 12; // 12 PM = 12:00 (noon)
        print('🔔 Time conversion: 12 PM → 12 (noon)');
      } else {
        hour24 = hour12 + 12; // 1-11 PM = 13:00-23:00
        print('🔔 Time conversion: $hour12 PM → $hour24');
      }
    }
    
    print('🔔 Time conversion: ${hour12}:xx ${period} → ${hour24}:xx (24h)');
    return hour24;
  }
}
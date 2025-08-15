import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/home-controller.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';
import 'package:nicotrack/screens/emergency/emergency_craving_motivation_screen.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

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
                                    context.l10n.home_hello(firstName),
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
                                          width: 112.w,
                                        )),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 2.h),
                                          width: 112.w,
                                          child: Center(
                                            child: TextAutoSize(
                                              context.l10n.home_get_pro,
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
                        homeController.homeGridView(
                          context: context,
                          daysSinceLabel: context.l10n.home_days_since_last_smoked,
                          moneySavedLabel: context.l10n.home_money_saved,
                          hoursRegainedLabel: context.l10n.home_hours_regained,
                          cigarettesNotSmokedLabel: context.l10n.home_cigarettes_not_smoked,
                        ),
                        premiumController.effectivePremiumStatus
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
                          isUserPremium: premiumController.effectivePremiumStatus,
                          dailyTasksLabel: context.l10n.home_daily_tasks,
                          smokingStatusDone: context.l10n.home_smoking_status_done,
                          didYouSmokeToday: context.l10n.home_did_you_smoke_today,
                          thanksForUpdate: context.l10n.home_thanks_for_update,
                          letUsKnow: context.l10n.home_let_us_know,
                          moodRecorded: context.l10n.home_mood_recorded,
                          howDoYouFeel: context.l10n.home_how_do_you_feel,
                          moodSet: context.l10n.home_mood_set,
                          tapToTellMood: context.l10n.home_tap_to_tell_mood,
                          quickActionsLabel: context.l10n.home_quick_actions,
                        ),
                        SizedBox(
                          height: 12.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EmergencyCravingMotivationScreen(),
                              ),
                            );
                          },
                          child: homeController.emergencyCravingButton(
                            context: context,
                            label: 'Emergency Craving Button',
                          ),
                        ),
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
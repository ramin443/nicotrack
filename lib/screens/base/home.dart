import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../utility-functions/home-grid-calculations.dart';
import '../../models/award-model/award-model.dart';
import '../elements/gradient-text.dart';
import '../../constants/quick-function-constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _showMilestoneBottomSheet(
      BuildContext context, HomeController homeController) {
    int currentDays = getDaysSinceLastSmoked(DateTime.now());
    List<AwardModel> earnedBadges =
        allAwards.where((badge) => badge.day <= currentDays).toList();
    List<AwardModel> nextMilestones =
        allAwards.where((badge) => badge.day > currentDays).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 18.w),
              // Handle bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    margin: EdgeInsets.only(left: 16.w),
                    // margin: EdgeInsets.only(right: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),

                  ),
                  Container(
                    height: 5.w,
                    width: 52.w,
                    decoration: BoxDecoration(
                      color: nicotrackBlack1,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      margin: EdgeInsets.only(right: 16.w),
                      decoration: BoxDecoration(
                        color: nicotrackOrange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20.w,
                        color: nicotrackOrange,
                      ),
                    ),
                  ),
                ],
              ),

              // Header

              // Milestone content matching plan screen
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Earned badges section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 14.h),
                            decoration: BoxDecoration(
                                color: nicotrackBlack1,
                                borderRadius: BorderRadius.circular(24.r)),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: circularBold,
                                        height: 1.1,
                                        color: Colors.white),
                                    children: [
                                  TextSpan(
                                    text:
                                        "🪙  ${context.l10n.earned_badges_title} (${earnedBadges.length})",
                                  ),
                                ])),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (earnedBadges.isNotEmpty)
                        _buildMilestoneGrid(earnedBadges, context)
                      else
                        Container(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            context.l10n.first_badge_message(
                                allAwards.first.day.toString()),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularMedium,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 12.h),
                      // Next milestones section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 14.h),
                            decoration: BoxDecoration(
                                color: nicotrackBlack1,
                                borderRadius: BorderRadius.circular(24.r)),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: circularBold,
                                        height: 1.1,
                                        color: Colors.white),
                                    children: [
                                  TextSpan(
                                    text:
                                        "📆  ${context.l10n.next_milestones_title}",
                                  ),
                                ])),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (nextMilestones.isNotEmpty)
                        ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.saturation,
                            ),
                            child: _buildMilestoneGrid(nextMilestones, context))
                      else
                        Container(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            context.l10n.all_badges_earned_message,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularMedium,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMilestoneGrid(
      List<AwardModel> awardsList, BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.7,
      ),
      itemCount: awardsList.length,
      itemBuilder: (context, index) {
        final item = awardsList[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(hexaPolygon, width: 105.w),
                Image.asset(item.emojiImg, width: 58.w),
              ],
            ),
            SizedBox(height: 8),
            GradientText(
              text: context.l10n.day_number(item.day.toString()),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff3217C3).withOpacity(0.7), Color(0xffFF4B4B)],
              ),
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: circularBold,
                height: 1.1,
                color: const Color(0xFFA1A1A1),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        initState: (state) {
          // Refresh data when the widget is initialized
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final controller = Get.find<HomeController>();
            controller.resetHomeGridValues();
            // Wait a bit for Hive boxes to be opened, then refresh data
            await Future.delayed(Duration(milliseconds: 500));
            controller.setCurrentFilledData();
            controller.setQuickActionsData();
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
                                  // GestureDetector(
                                  //   onTap: () async {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const PremiumPaywallScreen(),
                                  //       ),
                                  //     );
                                  //   },
                                  //   child: Stack(
                                  //     alignment: Alignment.center,
                                  //     // Ensures everything centers by default
                                  //     children: [
                                  //       Positioned(
                                  //           child: SvgPicture.asset(
                                  //         premiumBtnBg,
                                  //         width: 112.w,
                                  //       )),
                                  //       Container(
                                  //         padding: EdgeInsets.only(bottom: 2.h),
                                  //         width: 112.w,
                                  //         child: Center(
                                  //           child: TextAutoSize(
                                  //             context.l10n.home_get_pro,
                                  //             style: TextStyle(
                                  //                 fontSize: 16.sp,
                                  //                 fontFamily: recoletaBold,
                                  //                 color: nicotrackBlack1),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  // Milestone button
                                  GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        _showMilestoneBottomSheet(
                                            context, homeController);
                                      },
                                      child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 56.w,
                                              height: 56.w,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF6F4F1),
                                                shape: BoxShape.circle
                                              ),
                                            ),
                                            // Image.asset(
                                            //   badgeBG,
                                            //   width: 60.w,
                                            // ),
                                            Container(
                                              width: 54.w,
                                              height: 54.w,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: homeController
                                                    .getLatestMilestoneImage(),
                                              ),
                                            ),
                                          ])),

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
                          daysSinceLabel:
                              context.l10n.home_days_since_last_smoked,
                          moneySavedLabel: context.l10n.home_money_saved,
                          hoursRegainedLabel: context.l10n.home_hours_regained,
                          cigarettesNotSmokedLabel:
                              context.l10n.home_cigarettes_not_smoked,
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
                          isUserPremium:
                              premiumController.effectivePremiumStatus,
                          dailyTasksLabel: context.l10n.home_daily_tasks,
                          smokingStatusDone:
                              context.l10n.home_smoking_status_done,
                          didYouSmokeToday:
                              context.l10n.home_did_you_smoke_today,
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
                            HapticFeedback.heavyImpact();
                            // Check if user is premium
                            if (!premiumController.effectivePremiumStatus) {
                              // If not premium, navigate to premium paywall
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PremiumPaywallScreen(),
                                ),
                              );
                            } else {
                              // If premium, proceed to emergency craving screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EmergencyCravingMotivationScreen(),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              homeController.emergencyCravingButton(
                                context: context,
                                label: context.l10n.emergency_craving_button,
                              ),
                              // Show lock for non-premium users
                              if (!premiumController.effectivePremiumStatus)
                                Positioned(
                                  top: 8.w,
                                  right: 18.w,
                                  child: smallLockBox(),
                                ),
                            ],
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
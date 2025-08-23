import 'dart:ui';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';
import 'package:nicotrack/constants/image-constants.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';

class ChangeQuitDateBottomSheet extends StatefulWidget {
  const ChangeQuitDateBottomSheet({super.key});

  @override
  State<ChangeQuitDateBottomSheet> createState() => _CostPerPackBottomSheetState();
}

class _CostPerPackBottomSheetState extends State<ChangeQuitDateBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PremiumController>(
        init: PremiumController(),
        builder: (premiumController) {
          return GetBuilder<SettingsController>(
              init: SettingsController(),
              initState: (v) {},
              builder: (settingsController) {
                final isPremium = premiumController.effectivePremiumStatus;
                
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18.w,
                      ),
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
                                  if (isPremium) {
                                    settingsController.updateQuitDate();
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).pop();
                                  } else {
                                    // Navigate to premium screen if not premium
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PremiumPaywallScreen(),
                                      ),
                                    );
                                  }
                                },
                                child: TextAutoSize(
                                  context.l10n.done,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularBook,
                                    color: isPremium ? nicotracklightBlue : nicotracklightBlue.withOpacity(0.5),
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      TextAutoSize(
                        context.l10n.change_quit_date,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            // Date picker
                            settingsController.changeQuitDatePicker(),
                            
                            // Premium lock overlay
                            if (!isPremium)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PremiumPaywallScreen(),
                                      ),
                                    );
                                  },
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        color: Colors.white.withOpacity(0.1),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // Lock icon
                                              Container(
                                                padding: EdgeInsets.all(20.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  lockImg,
                                                  width: 32.w,
                                                  height: 32.w,
                                                ),
                                              ),
                                              SizedBox(height: 16.h),
                                              // Get Pro to unlock text
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 12.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(30.r),
                                                ),
                                                child: Text(
                                                  context.l10n.premium_get_pro_to_unlock,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    height: 1.2,
                                                    fontFamily: circularMedium,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.w,
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
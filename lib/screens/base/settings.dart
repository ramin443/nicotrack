import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/getx-controllers/settings-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-in-overview.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-section.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../constants/color-constants.dart';
import '../elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
    } else if (_scrollController.offset <= 200 && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (settingsController) {
          return GetBuilder<PremiumController>(
              init: PremiumController(),
              builder: (premiumController) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 20.w,),
                        AppBar(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          surfaceTintColor: Colors.white,
                          centerTitle: false,
                          title: TextAutoSize(
                            context.l10n.settings_title,
                            style: TextStyle(
                                fontSize: 32.sp,
                                fontFamily: circularBold,
                                color: nicotrackBlack1),
                          ),
                        ),
                        premiumController.effectivePremiumStatus
                            ? SizedBox.shrink()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 14.w,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    child: premiumBox(context),
                                  ),
                                ],
                              ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     await Get.find<SettingsController>().debugNotifications();
                        //   },
                        //   child: Text('🧪 Test Notifications'),
                        // ),

                        settingsController.personalInfoSection(context:context, isUserPremium: premiumController.effectivePremiumStatus),
                        settingsController.pushNotificationSection(context),
                        settingsController.financialGoalsSection(context: context, isUserPremium: premiumController.effectivePremiumStatus),
                        settingsController.helpandSupportSection(context),
                        settingsController.privacySection(context),
                      ],
                    ),
                  ),
                  floatingActionButton: _showFloatingButton
                      ? FloatingActionButton(
                          onPressed: _scrollToTop,
                          backgroundColor: nicotrackBlack1,
                          elevation: 8,
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        )
                      : null,
                );
              });
        });
  }
}
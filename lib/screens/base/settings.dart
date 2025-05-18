import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/getx-controllers/settings-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-in-overview.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-section.dart';

import '../../constants/color-constants.dart';
import '../elements/textAutoSize.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (settingsController) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    surfaceTintColor: Colors.white,
                    centerTitle: false,
                    title: TextAutoSize(
                      "📋 Settings",
                      style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1),
                    ),
                  ),

                  settingsController.personalInfoSection(context),
                  settingsController.pushNotificationSection(context),
                  settingsController.financialGoalsSection(context),
                  settingsController.helpandSupportSection(context),
                  settingsController.privacySection(),

                ],
              ),
            ),
          );
        });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class HowYouFeel extends StatefulWidget {
  const HowYouFeel({super.key});

  @override
  State<HowYouFeel> createState() => _HowYouFeelState();
}

class _HowYouFeelState extends State<HowYouFeel> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        builder: (didYouSmokeController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 18.h,
              ),
              SizedBox(
                width: 247.w,
                child: TextAutoSize(
                  context.l10n.how_did_it_make_feel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 26.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              didYouSmokeController.howYouFeelGrid(context),

              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}
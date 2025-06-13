import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';

import '../../../constants/color-constants.dart';

class DidYouSmokeMainSlider extends StatefulWidget {
  final DateTime currentDateTime;

  const DidYouSmokeMainSlider({super.key, required this.currentDateTime});

  @override
  State<DidYouSmokeMainSlider> createState() => _DidYouSmokeMainSliderState();
}

class _DidYouSmokeMainSliderState extends State<DidYouSmokeMainSlider> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        builder: (didYouSmokeController) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  didYouSmokeController.continueButton(
                      widget.currentDateTime, context),
                  SizedBox(
                    height: 0.h,
                  )
                ],
              ),
            ),
            body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: false,
                      title: Row(
                        children: [
                          SizedBox(
                            width: 14.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (didYouSmokeController.currentPage == 0) {
                                HapticFeedback.mediumImpact();
                                Navigator.of(context).pop();
                              } else {
                                if (didYouSmokeController.currentPage != 0) {
                                  HapticFeedback.mediumImpact();
                                }
                                didYouSmokeController.previousPage();
                                didYouSmokeController.getCurrentPageStatus();
                              }
                            },
                            child: Container(
                              height: 36.w,
                              width: 36.w,
                              padding: EdgeInsets.only(right: 2.w, bottom: 2.w),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: nicotrackBlack1),
                              child: Center(
                                child: Icon(
                                  FeatherIcons.chevronLeft,
                                  color: Colors.white,
                                  size: 24.w,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    didYouSmokeController.topSlider(),
                    didYouSmokeController.mainDisplay()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';

class UpdateQuitDate extends StatefulWidget {
  const UpdateQuitDate({super.key});

  @override
  State<UpdateQuitDate> createState() => _UpdateQuitDateState();
}

class _UpdateQuitDateState extends State<UpdateQuitDate> {
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
                width: 227.w,
                child: TextAutoSize(
                  "🗓️ Update Your Quit Date?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 26.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              SizedBox(
                width: 220.w,
                child: RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          "Update your quit date to today? Or treat this as a rare fluke and keep your original quit date ",
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 13.sp,
                          fontFamily: circularBook,
                          color: Color(0xff979797))),
                  TextSpan(
                      text: "April 7, 2025",
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 13.sp,
                          fontFamily: circularBold,
                          color: Colors.black87)),
                  TextSpan(
                      text: "?",
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 13.sp,
                          fontFamily: circularBook,
                          color: Color(0xff979797))),
                ])),
              ),
              SizedBox(
                height: 46.h,
              ),
              didYouSmokeController.updateQuitDateSelection(),
              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}
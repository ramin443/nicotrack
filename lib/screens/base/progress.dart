import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../elements/sliver-header-delegate.dart';
import '../elements/textAutoSize.dart';

class ProgressMain extends StatefulWidget {
  const ProgressMain({super.key});

  @override
  State<ProgressMain> createState() => _ProgressState();
}

class _ProgressState extends State<ProgressMain>
    with SingleTickerProviderStateMixin {
  final progressMainController = Get.find<ProgressController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        initState: (v) {
          progressMainController.tabController = TabController(
              length: progressMainController.tabs.length, vsync: this);
        },
        builder: (progressController) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: CustomScrollView(
              controller: progressController.scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12.h,
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: false,
                  delegate: SliverHeaderDelegate(
                    minHeight: 55.h,
                    maxHeight: 55.h,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    progressBGBtnImg,
                                    width: 170.w,
                                  ),
                                  Positioned.fill(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          progressImg,
                                          width: 32.w,
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        TextAutoSize(
                                          "Progress",
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontFamily: circularBold,
                                              height: 1.1,
                                              color: nicotrackBlack1),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        height: 9.h,
                        width: 1.w,
                        decoration: BoxDecoration(color: nicotrackBlack1),
                      ),
                      Container(
                        width: 190.w,
                        padding: EdgeInsets.only(
                            left: 18.h, right: 22.h, top: 8.h, bottom: 16.h),
                        decoration: BoxDecoration(
                          color: nicotrackBlack1,
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 7.w,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      instantQuitEmoji,
                                      width: 22.w,
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    TextAutoSize(
                                      "Current\nStreak",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: circularMedium,
                                          height: 1.1,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 24.w,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: circularMedium,
                                        height: 1,
                                        color: Colors.white),
                                    children: [
                                  TextSpan(
                                    text: "14\n",
                                    style: TextStyle(
                                        fontSize: 36.sp,
                                        fontFamily: circularMedium,
                                        height: 1.1,
                                        color: Colors.white),
                                  ),
                                  TextSpan(text: "days"),
                                ]))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: circularMedium,
                                  height: 1.1,
                                  color: nicotrackBlack1),
                              children: [
                            TextSpan(text: "🗓️ Quit Date: "),
                            TextSpan(
                              text: "Mar 13, 2025",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: circularBold,
                                  height: 1.1,
                                  color: nicotrackBlack1),
                            ),
                          ])),
                      SizedBox(
                        height: 24.h,
                      ),
                      progressController.mainDisplayCards(),
                      SizedBox(
                        height: 16.h,
                      ),
                      progressController.progressTabs(),
                      SizedBox(
                        height: 26.h,
                      ),
                    ],
                  ),
                )
              ],
            )),
          );
        });
  }
}
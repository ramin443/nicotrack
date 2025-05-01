import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/single-row-scroll-view.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';

class UpcomingHealthTrend extends StatelessWidget {
  final ScrollController scrollController;
  const UpcomingHealthTrend({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 18.w,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: nicotrackBlack1),
                    children: [
                      TextSpan(
                        text: "🔮 Upcoming ",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: Color(0xffFF4800)
                        ),
                      ),
                      TextSpan(
                        text: "body changes",
                      ),
                    ])),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        SingleRowScrollView(items: healthDummyData, scrollController: scrollController,)
      ],
    );
  }
}
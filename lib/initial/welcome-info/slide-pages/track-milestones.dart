import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';

class TrackMilestones extends StatelessWidget {
  const TrackMilestones({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAutoSize(
          context.l10n.track_milestones_title,
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.2,
              fontSize: 28.sp,
              fontFamily: circularMedium,
              color: nicotrackBlack1),
        ),
        SizedBox(
          height: 18.h,
        ),
        SvgPicture.asset(
          illustration1,
          width: 312.w,
        ),
        SizedBox(
          height: 18.h,
        ),
        SizedBox(
          width: 305.w,
          child: TextAutoSize(
            context.l10n.track_milestones_description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: circularBook,
                color: nicotrackBlack1),
          ),
        ),
      ],
    );
  }
}

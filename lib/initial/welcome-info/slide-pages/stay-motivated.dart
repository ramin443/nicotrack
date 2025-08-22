import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';

class StayMotivated extends StatelessWidget {
  const StayMotivated({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 293.w,
          child: TextAutoSize(
            context.l10n.stay_motivated_title,
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.2,
                fontSize: 28.sp,
                fontFamily: circularMedium,
                color: nicotrackBlack1),
          ),
        ),
        SizedBox(
          height: 18.w,
        ),
        SvgPicture.asset(
          illustration4,
          width: 312.w,
        ),
        SizedBox(
          height: 18.w,
        ),
        SizedBox(
          width: 305.w,
          child: TextAutoSize(
            context.l10n.stay_motivated_description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp,
                height: 1.2,
                fontFamily: circularBook,
                color: nicotrackBlack1),
          ),
        ),
      ],
    );
  }
}
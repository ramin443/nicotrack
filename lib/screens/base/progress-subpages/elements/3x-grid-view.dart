import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/award-model/award-model.dart';

import '../../../../constants/image-constants.dart';
import '../../../elements/gradient-text.dart';
import '../../../../extensions/app_localizations_extension.dart';
class ThreexGridView extends StatefulWidget {
  final List<AwardModel> awardsList;
  const ThreexGridView({super.key, required this.awardsList});

  @override
  State<ThreexGridView> createState() => _ThreexGridViewState();
}

class _ThreexGridViewState extends State<ThreexGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.7,
      ),
      itemCount: widget.awardsList.length,
      itemBuilder: (context, index) {
        final item = widget.awardsList[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(hexaPolygon,
                width: 105.w,),
                Image.asset(
                    item.emojiImg,
                   width: 58.w,
                  ),

              ],
            ),
            SizedBox(height: 8),
            GradientText(
              text: context.l10n.day_number(item.day.toString()),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff3217C3).withOpacity(0.7),
                  Color(0xffFF4B4B)
                ],
              ),
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: circularBold,
                height: 1.1,
                color: const Color(0xFFA1A1A1),
              ),
            )

          ],
        );
      },
    );  }
}
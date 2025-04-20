import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';

class EmojiGridCards extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const EmojiGridCards({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    int halfLength = (items.length / 2).ceil();

    return Column(
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: List.generate(items.length, (index) {
            final emoji = items[index]['emoji'];
            final text = items[index]['text'];

            return Container(
              width: (MediaQuery.of(context).size.width / 2) - 24.w,
              padding: EdgeInsets.only(left: 12.w,right: 2.w, top: 10.h,bottom: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xfff0f0f0)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      text,
                      style:  TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularMedium,
                        height: 1.1,
                        color: nicotrackBlack1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../elements/textAutoSize.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../extensions/app_localizations_extension.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final List<Map<String, dynamic>> techniques = [
    {
      'phase': 'Phase 1',
      'title': 'The 4-7-8 Technique',
      'duration': '4 min',
      'icon': '💨',
    },
    {
      'phase': 'Phase 1',
      'title': 'Cold water shock',
      'duration': '4 min',
      'icon': '🌊',
    },
    {
      'phase': 'Phase 2',
      'title': 'The 3-Minute Rule',
      'duration': '4 min',
      'icon': '⏳',
    },
    {
      'phase': 'Phase 1',
      'title': '5-4-3-2-1 Technique',
      'duration': '4 min',
      'icon': '🔍',
    },
    {
      'phase': 'Phase 2',
      'title': 'Deep Breathing',
      'duration': '5 min',
      'icon': '🫁',
    },
    {
      'phase': 'Phase 3',
      'title': 'Mindful Walking',
      'duration': '10 min',
      'icon': '🚶',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      activityBGBtn,
                      width: 140.w,
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextAutoSize(
                            "🎮",
                            style: TextStyle(
                                fontSize: 50.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: nicotrackBlack1),
                          ),
                          SizedBox(
                            height: 8.w,
                          ),
                          TextAutoSize(
                            "Activities",
                            style: TextStyle(
                                fontSize: 18.sp,
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
            Container(
              height: 10.h,
              width: 1.w,
              decoration: BoxDecoration(color: nicotrackBlack1),
            ),
            Container(
              width: 256.w,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                  color: nicotrackBlack1,
                  borderRadius: BorderRadius.circular(26.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    instantQuitEmoji,
                    width: 24.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 190.w,
                    child: TextAutoSize(
                      'Tricks to handle cravings',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: circularMedium,
                          height: 1.1,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.info,
                    weight: 14.sp,
                    color: const Color(0xFFA1A1A1),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  TextAutoSize(
                    context.l10n.info_button,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: circularBook,
                      height: 1.1,
                      color: const Color(0xFFA1A1A1),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.w,
                  childAspectRatio: 0.75,
                ),
                itemCount: techniques.length,
                itemBuilder: (context, index) {
                  return _buildTechniqueCard(techniques[index]);
                },
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueCard(Map<String, dynamic> technique) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffff1f1f1),width: 1.sp)
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      technique['icon'],
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 56.sp),
                    ),

                SizedBox(height: 12.h),
                TextAutoSize(
                  technique['phase'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularMedium,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 4.h),
                TextAutoSize(
                  technique['title'],
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(
                      FeatherIcons.clock,
                      size: 14.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    TextAutoSize(
                      technique['duration'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: circularMedium,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FeatherIcons.play,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
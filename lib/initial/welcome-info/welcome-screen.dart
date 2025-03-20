import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.transparent,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 36.sp,
                            fontFamily: circularBold,
                            color: nicotrackBlack1),
                        children: [
                          TextSpan(
                            text: "Welcome to\n",
                          ),
                          TextSpan(
                            text: "Nico",
                            style: TextStyle(
                                fontSize: 36.sp,
                                fontFamily: circularBold,
                                color: nicotrackLightBlack),
                          ),
                          TextSpan(text: "track")
                        ])),
                SizedBox(
                  height: 34.h,
                ),
                SvgPicture.asset(
                  groupedLogo,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 346.w,
                    height: 54.h,
                    margin: EdgeInsets.symmetric(vertical: 24.w),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(fullButtonBg), // Load from assets
                        fit: BoxFit
                            .cover, // Adjusts how the image fits the container
                      ),
                    ),
                    child: Center(
                      child: TextAutoSize(
                        "Start your journey",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: circularBold,
                            color: nicotrackBlack1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34.h,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

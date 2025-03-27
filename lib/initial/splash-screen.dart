import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              splashLogo,
              width: 164.w,
            ),
            SizedBox(
              height: 18.h,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 34.sp,
                        fontFamily: circularMedium,
                        color: nicotrackBlack1),
                    children: [
                  TextSpan(
                    text: "Nico",
                    style: TextStyle(
                        fontSize: 34.sp,
                        fontFamily: circularMedium,
                        color: Colors.black26),
                  ),
                  TextSpan(text: "track")
                ])),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:confetti/confetti.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';

import '../../../../../constants/font-constants.dart';
import '../../../../elements/gradient-text.dart';
import '../../../../elements/textAutoSize.dart';

class NoSmokeCongratsPage extends StatefulWidget {
  const NoSmokeCongratsPage({super.key});

  @override
  State<NoSmokeCongratsPage> createState() => _NoSmokeCongratsPageState();
}

class _NoSmokeCongratsPageState extends State<NoSmokeCongratsPage> {
  //congrats page variables
  ConfettiController controllerTopCenter =
      ConfettiController(duration: const Duration(milliseconds: 2000));
  List<Color> confettiColor = [
    const Color(0xff2fb5ff),
    const Color(0xffad46ff),
    const Color(0xffff723d),
    const Color(0xffdd00c0),
    const Color(0xffff3400),
    const Color(0xffCBF1E5),
    const Color(0xffffdd0e),
  ];

  @override
  void initState() {
    super.initState();
    startConfetti();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        builder: (didYouSmokeController) {
          return Scaffold(
            backgroundColor: Colors.white,
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            // floatingActionButton:
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.0),
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            surfaceTintColor: Colors.transparent,
                            automaticallyImplyLeading: false,
                            actions: [
                              Container(
                                height: 36.w,
                                width: 36.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFF611D).withOpacity(0.20)),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Color(0xffFF611D),
                                    size: 18.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    awardBg2,
                                    width: 220.w,
                                  ),
                                  Image.asset(
                                    celebrateImg,
                                    width: 120.w,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        GradientText(
                          text: "Amazing!",
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xff3217C3), Color(0xffFF4B4B)],
                          ),
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: const Color(0xFFA1A1A1),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        SizedBox(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontFamily: circularMedium,
                                    height: 1.1,
                                    color: nicotrackBlack1,
                                  ),
                                  children: [
                                    TextSpan(text: 'You’re on your '),
                                    TextSpan(
                                      text: '5th\n',
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontFamily: circularBold,
                                        height: 1.1,
                                        color: Color(0xffFF4B4B),
                                      ),
                                    ),
                                    TextSpan(text: 'smoke-free day 🥳.'),
                                  ])),
                        ),
                        SizedBox(
                          height: 36.h,
                        ),
                        didYouSmokeController.financialGoalProgressBar(),
                        didYouSmokeController.notSmokedTodayDataCubes(),
                        SizedBox(
                          height: 140.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      didYouSmokeController.gotoHomeBtn(),
                      SizedBox(
                        height: 12.h,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    minimumSize: const Size(6, 1),
                    maximumSize: const Size(12, 2),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.45,
                    // set a lower max blast force
                    minBlastForce: 0.4,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 240,
                    // a lot of particles at once
                    gravity: 0.14,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(12, 12),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.45,
                    // set a lower max blast force
                    minBlastForce: 0.1,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 240,
                    // a lot of particles at once
                    gravity: 0.14,
                    createParticlePath: drawCircle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConfettiWidget(
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(12, 12),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.45,
                    // set a lower max blast force
                    minBlastForce: 0.1,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 240,
                    // a lot of particles at once
                    gravity: 0.14,
                    createParticlePath: drawCircle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ConfettiWidget(
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(12, 12),
                    colors: confettiColor,
                    confettiController: controllerTopCenter,
                    blastDirection: pi / 2,
                    maxBlastForce: 0.9,
                    // set a lower max blast force
                    minBlastForce: 0.4,
                    // set a lower min blast force
                    emissionFrequency: 0.4,
                    numberOfParticles: 240,
                    // a lot of particles at once
                    gravity: 0.14,
                    createParticlePath: drawCircle,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void startConfetti() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      controllerTopCenter.play();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.heavyImpact();
      });
    });
  }

  Path drawCircle(Size size) {
    final path = Path();

    path.addOval(Rect.fromCircle(
      center: const Offset(0, 0),
      radius: size.width / 2,
    ));

    return path;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../../../../../constants/font-constants.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:nicotrack/screens/base/base.dart';
import 'package:nicotrack/screens/elements/gradient-text.dart';
import 'package:nicotrack/models/award-model/award-model.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import 'package:nicotrack/constants/quick-function-constants.dart';

class BadgeEarned extends StatefulWidget {
  final AwardModel earnedBadge;
  final int daysSinceQuit;
  final DateTime selectedDate;

  const BadgeEarned({
    super.key,
    required this.earnedBadge,
    required this.daysSinceQuit,
    required this.selectedDate,
  });

  @override
  State<BadgeEarned> createState() => _BadgeEarnedState();
}

class _BadgeEarnedState extends State<BadgeEarned> {
  ConfettiController controllerTopCenter =
      ConfettiController(duration: const Duration(milliseconds: 2000));

  int _getStreakNumber() {
    // Find the position of this badge in the allAwards list to determine streak number
    for (int i = 0; i < allAwards.length; i++) {
      if (allAwards[i].day == widget.earnedBadge.day) {
        return i + 1; // Streak numbers start from 1
      }
    }
    return 1; // Default fallback
  }

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

  void startConfetti() {
    // Start lighter confetti after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      controllerTopCenter.play();
      HapticFeedback.lightImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 24.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        // Save smoke-free data and navigate to home
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Base()),
                            (route) => false);
                      },
                      child: Container(
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
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: 220.w,
                child: TextAutoSize(
                  context.l10n.badge_earned_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 30.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 40.w,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    badgeBG,
                    width: 190.w,
                  ),
                  Image.asset(
                    widget.earnedBadge.emojiImg,
                    width: 100.w,
                  ),
                ],
              ),
              SizedBox(
                height: 20.w,
              ),
              GradientText(
                text: context.l10n.streak_number(_getStreakNumber().toString()),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff3217C3).withOpacity(0.7),
                    Color(0xffFF4B4B)
                  ],
                ),
                style: TextStyle(
                    height: 1.1, fontSize: 28.sp, fontFamily: circularBold),
              ),
              SizedBox(
                height: 5.w,
              ),
              TextAutoSize(
                widget.daysSinceQuit == 1 
                  ? context.l10n.badge_days_no_smoking_single(widget.daysSinceQuit.toString())
                  : context.l10n.badge_days_no_smoking_plural(widget.daysSinceQuit.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.1,
                    fontSize: 20.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1),
              ),
              Spacer(),
              Spacer(),
              Spacer(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCollectButton(),
                SizedBox(
                  height: 12.h,
                )
              ],
            ),
          ),
          // Lighter confetti effects
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              minimumSize: const Size(4, 1),
              maximumSize: const Size(8, 2),
              colors: confettiColor,
              confettiController: controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 0.25,
              minBlastForce: 0.2,
              emissionFrequency: 0.2,
              numberOfParticles: 60,
              gravity: 0.1,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              minimumSize: const Size(3, 3),
              maximumSize: const Size(8, 8),
              colors: confettiColor,
              confettiController: controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 0.25,
              minBlastForce: 0.05,
              emissionFrequency: 0.2,
              numberOfParticles: 60,
              gravity: 0.1,
              createParticlePath: drawCircle,
            ),
          ),
        ]));
  }

  Widget _buildCollectButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Save smoke-free data and navigate to home
            HapticFeedback.lightImpact();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Base()),
                    (route) => false);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                fullButtonBg,
                width: 346.w,
              ),
              Text(
                context.l10n.badge_collect_button,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.w,
        )
      ],
    );
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
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/single-row-scroll-view.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../constants/image-constants.dart';
import '../../../../getx-controllers/premium-controller.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';
import '../../../../utility-functions/home-grid-calculations.dart';
import '../../../premium/premium-paywall-screen.dart';

class HealthImprovementTrend extends StatefulWidget {
  final ScrollController scrollController;
  const HealthImprovementTrend({super.key, required this.scrollController});

  @override
  State<HealthImprovementTrend> createState() => _HealthImprovementTrendState();
}

class _HealthImprovementTrendState extends State<HealthImprovementTrend> {
  
  List<EmojiTextModel> _getBodyImprovements() {
    int daysSinceQuit = getDaysSinceLastSmoked(DateTime.now());
    List<EmojiTextModel> improvements = [];
    
    // Define comprehensive body improvements with timeline and emoji assets
    Map<String, Map<String, dynamic>> allImprovements = {
      // 20 minutes - 1 hour
      "Heart rate normalizes": {"hours": 0.33, "emoji": "❤️"},
      "Blood pressure drops": {"hours": 0.33, "emoji": "💓"},
      
      // 8-12 hours
      "Carbon monoxide halves": {"hours": 8, "emoji": "🫁"},
      "Oxygen levels normal": {"hours": 12, "emoji": "🧠"},
      
      // 24-48 hours
      "CO eliminated": {"hours": 24, "emoji": "💨"},
      "Nerve endings regenerate": {"hours": 48, "emoji": "🧠"},
      "Taste/smell improve": {"hours": 48, "emoji": "👃"},
      
      // 72 hours - 1 week
      "Nicotine leaves body": {"hours": 72, "emoji": "🚭"},
      "Breathing easier": {"hours": 72, "emoji": "🫁"},
      "Energy increases": {"hours": 96, "emoji": "⚡"},
      "Circulation improves": {"hours": 168, "emoji": "🩸"},
      
      // 2-3 weeks
      "Lung function +10%": {"hours": 336, "emoji": "🫁"},
      "Physical activity easier": {"hours": 336, "emoji": "🏃"},
      "Cilia regrow in lungs": {"hours": 504, "emoji": "🫁"},
      
      // 1 month
      "Lung capacity +30%": {"hours": 720, "emoji": "💪"},
      "Coughing decreases": {"hours": 720, "emoji": "😮‍💨"},
      "Sinus congestion gone": {"hours": 720, "emoji": "👃"},
      "Fatigue reduces": {"hours": 720, "emoji": "😊"},
      
      // 2-3 months
      "Circulation optimal": {"hours": 1440, "emoji": "❤️"},
      "Walking easier": {"hours": 1440, "emoji": "🚶"},
      "Lung function +50%": {"hours": 2160, "emoji": "🫁"},
      
      // 6 months
      "Airways clear": {"hours": 4320, "emoji": "🌬️"},
      "Infection risk down": {"hours": 4320, "emoji": "🛡️"},
      "Energy levels peak": {"hours": 4320, "emoji": "⚡"},
      
      // 1 year
      "Heart disease risk halves": {"hours": 8760, "emoji": "❤️"},
      "Stroke risk reduces": {"hours": 8760, "emoji": "🧠"},
      
      // 5 years
      "Cancer risk halves": {"hours": 43800, "emoji": "🛡️"},
      "Stroke risk = non-smoker": {"hours": 43800, "emoji": "🧠"},
      
      // 10 years
      "Lung cancer risk halves": {"hours": 87600, "emoji": "🫁"},
      "Pre-cancer cells replaced": {"hours": 87600, "emoji": "✨"},
      
      // 15 years
      "Heart risk = non-smoker": {"hours": 131400, "emoji": "❤️"},
      "Full recovery achieved": {"hours": 131400, "emoji": "🎉"},
    };
    
    // Convert days to hours for comparison
    int hoursSinceQuit = daysSinceQuit * 24;
    
    // Add improvements that should have occurred based on quit duration
    for (String improvementName in allImprovements.keys) {
      num requiredHours = allImprovements[improvementName]!["hours"];
      String emoji = allImprovements[improvementName]!["emoji"];
      
      if (hoursSinceQuit >= requiredHours) {
        improvements.add(EmojiTextModel(
          emoji: emoji,
          text: improvementName,
        ));
      }
    }
    
    // If very early in quit (< 20 minutes), show encouraging immediate changes
    if (improvements.isEmpty) {
      return [
        EmojiTextModel(emoji: "❤️", text: "Heart rate\nstabilizing"),
        EmojiTextModel(emoji: "💓", text: "Blood pressure\ndropping"),
        EmojiTextModel(emoji: "🧠", text: "Oxygen levels\nrising"),
        EmojiTextModel(emoji: "💨", text: "CO levels\ndecreasing"),
      ];
    }
    
    // Return most recent improvements first, limited to reasonable display count
    return improvements.reversed.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PremiumController>(
        init: PremiumController(),
        builder: (premiumController) {
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
                        text: "🍎 What’s improved ",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: Color(0xffFF4800)
                        ),
                      ),
                      TextSpan(
                        text: "in your body",
                      ),
                    ])),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Stack(
          children: [
            SingleRowScrollView(items: _getBodyImprovements(), scrollController: widget.scrollController,),
            if (!premiumController.effectivePremiumStatus)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const PremiumPaywallScreen();
                    }));
                  },
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.1),
                        child: Center(child: contentLockBox(),),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        )
      ],
    );
        });
  }
}
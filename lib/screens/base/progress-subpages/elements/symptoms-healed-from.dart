import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/4x4-alt-scroll-view.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/dummy-data-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../constants/image-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';
import '../../../../utility-functions/home-grid-calculations.dart';
import '../../../elements/textAutoSize.dart';

class SymptomsHealedFrom extends StatefulWidget {
  const SymptomsHealedFrom({super.key});

  @override
  State<SymptomsHealedFrom> createState() => _SymptomsHealedFromState();
}

class _SymptomsHealedFromState extends State<SymptomsHealedFrom> {
  
  List<EmojiTextModel> _getSymptomsEasedOrHealed() {
    int daysSinceQuit = getDaysSinceLastSmoked(DateTime.now());
    List<EmojiTextModel> symptoms = [];
    
    // Define all symptoms with their healing timeframes and emoji assets
    Map<String, Map<String, dynamic>> allSymptoms = {
      // Immediate relief (0-24 hours)
      "Nicotine cravings reduce": {"days": 0, "emoji": cigImg},
      "Anxiety and restlessness": {"days": 0, "emoji": anxiousImg},
      "Heart rate normalizes": {"days": 0, "emoji": heartEmoji},
      
      // 1-3 days
      "Carbon monoxide cleared": {"days": 1, "emoji": heartEmoji},
      "Oxygen levels improve": {"days": 1, "emoji": heartEmoji},
      "Sense of taste improves": {"days": 1, "emoji": platesEmoji},
      "Sense of smell improves": {"days": 1, "emoji": coffeeEmoji},
      
      // 3-7 days
      "Nicotine withdrawal peaks": {"days": 3, "emoji": cigImg},
      "Irritability reduces": {"days": 3, "emoji": angryImg},
      "Mood swings subside": {"days": 5, "emoji": frustratedImg},
      "Fatigue decreases": {"days": 5, "emoji": tiredImg},
      
      // 1-2 weeks
      "Circulation improves": {"days": 7, "emoji": heartEmoji},
      "Breathing easier": {"days": 10, "emoji": healthImg},
      "Shortness of breath": {"days": 10, "emoji": healthImg},
      "Lung function improves": {"days": 14, "emoji": bicepsEmoji},
      "Sleep quality better": {"days": 14, "emoji": neutralImg},
      
      // 2-4 weeks
      "Persistent coughing": {"days": 21, "emoji": healthImg},
      "Mucus production normal": {"days": 21, "emoji": healthImg},
      "Walking stamina better": {"days": 21, "emoji": walkImg},
      "Brain fog clears": {"days": 28, "emoji": brainsoutEmoji},
      
      // 1-3 months
      "Heart palpitations": {"days": 30, "emoji": heartEmoji},
      "Blood pressure stable": {"days": 30, "emoji": heartEmoji},
      "Lung capacity +30%": {"days": 30, "emoji": bicepsEmoji},
      "Chest tightness": {"days": 45, "emoji": healthImg},
      "Exercise tolerance": {"days": 60, "emoji": targetImg},
      
      // 3-6 months
      "Stress handling better": {"days": 90, "emoji": meditateImg},
      "Mood stability": {"days": 90, "emoji": happyImg},
      "Overall wellbeing": {"days": 120, "emoji": partyImg},
      "Energy levels boost": {"days": 120, "emoji": motivImg},
      
      // 6-12 months
      "Cold/flu resistance": {"days": 180, "emoji": bicepsEmoji},
      "Physical fitness": {"days": 180, "emoji": targetImg},
      "Mental clarity peak": {"days": 180, "emoji": brainsoutEmoji},
      "Long-term health gains": {"days": 365, "emoji": celebrateImg},
    };
    
    // Add symptoms that should be healed based on days since quit
    for (String symptomName in allSymptoms.keys) {
      int requiredDays = allSymptoms[symptomName]!["days"];
      String emoji = allSymptoms[symptomName]!["emoji"];
      
      if (daysSinceQuit >= requiredDays) {
        symptoms.add(EmojiTextModel(
          emoji: emoji,
          text: symptomName,
        ));
      }
    }
    
    // If no symptoms qualified yet (very early in quit), show encouraging first symptoms
    if (symptoms.isEmpty) {
      return [
        EmojiTextModel(emoji: heartEmoji, text: "Heart rate stabilizing"),
        EmojiTextModel(emoji: cigImg, text: "Initial nicotine clearing"),
        EmojiTextModel(emoji: coffeeEmoji, text: "Taste buds recovering"),
        EmojiTextModel(emoji: healthImg, text: "Oxygen improving"),
      ];
    }
    
    // Sort by healing timeline (most recent healings first) and limit to 16 items
    return symptoms.take(16).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18.w,
                  ),
                  SizedBox(
                    width: 150.w,
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: const Color(0xFFFF611D)),
                            children: [
                              TextSpan(
                                text: "📈 Symptoms ",
                              ),
                              TextSpan(
                                text: "eased & healed from",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularBold,
                                    height: 1.1,
                                    color: nicotrackBlack1),
                              ),
                            ])),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              FourxFourAltScrollView(
                scrollController:
                progressController.symptomsHealedScrollController,
                items: _getSymptomsEasedOrHealed(),
                childAspectRatio: 2.2,
              ),

            ],
          );
        });
  }
}
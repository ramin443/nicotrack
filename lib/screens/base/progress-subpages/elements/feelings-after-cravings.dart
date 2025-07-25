import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/4x4-scroll-view.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../constants/image-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../../getx-controllers/premium-controller.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';
import '../../../../models/mood-model/mood-model.dart';
import '../../../premium/premium-paywall-screen.dart';

class FeelingsAfterCravings extends StatefulWidget {
  const FeelingsAfterCravings({super.key});

  @override
  State<FeelingsAfterCravings> createState() => _FeelingsAfterCravingsState();
}

class _FeelingsAfterCravingsState extends State<FeelingsAfterCravings> {
  
  List<EmojiTextModel> _getFeelingsAfterCravings() {
    final moodBox = Hive.box<MoodModel>('moodData');
    Map<String, int> feelingCounts = {};
    Map<String, String> feelingEmojis = {};
    
    // Define all possible feelings with their emoji assets
    Map<String, String> allFeelings = {
      "Happy": happyImg,
      "Neutral": neutralImg,
      "Sad": sadImg,
      "Angry": angryImg,
      "Anxious": anxiousImg,
      "Confident": motivImg,
      "Tired": tiredImg,
      "Frustrated": frustratedImg,
      "Excited": partyImg,
      "Confused": confusedImg,
      "Motivated": targetImg,
      "Proud": happyImg, // Using happy emoji for proud
    };
    
    // Analyze all mood entries
    for (String key in moodBox.keys.cast<String>()) {
      final moodData = moodBox.get(key);
      if (moodData != null) {
        // Check if user had cravings (anyCravingToday > 0 means they had cravings)
        if (moodData.anyCravingToday > 0 && moodData.selfFeeling.isNotEmpty) {
          try {
            // Extract feeling from the mood data
            String feeling = moodData.selfFeeling['text'] ?? 'Unknown';
            String emoji = moodData.selfFeeling['emoji'] ?? othersEmoji;
            
            // Count this feeling
            feelingCounts[feeling] = (feelingCounts[feeling] ?? 0) + 1;
            feelingEmojis[feeling] = emoji;
          } catch (e) {
            // Handle any data extraction errors
          }
        }
      }
    }
    
    // If no craving data found, return empty list or placeholder message
    if (feelingCounts.isEmpty) {
      return [
        EmojiTextModel(emoji: othersEmoji, text: "No craving data yet|0|0"),
      ];
    }
    
    // Sort feelings by frequency (most common first)
    List<MapEntry<String, int>> sortedFeelings = feelingCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Calculate total for percentage
    int totalCount = feelingCounts.values.reduce((a, b) => a + b);
    
    // Create result list with counts and percentages
    List<EmojiTextModel> results = [];
    for (var entry in sortedFeelings) {
      String feeling = entry.key;
      int count = entry.value;
      int percentage = ((count / totalCount) * 100).round();
      String emoji = feelingEmojis[feeling] ?? othersEmoji;
      
      // Format text for display
      results.add(EmojiTextModel(
        emoji: emoji,
        text: "$feeling|$count|$percentage", // Using | as separator for parsing in UI
      ));
    }
    
    // Return only feelings that have been logged (no 0-count items)
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
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
                  SizedBox(
                    width: 150.w,
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: nicotrackBlack1),
                            children: [
                          TextSpan(
                            text: "⚡ How you ",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: const Color(0xFF6D9C32)),
                          ),
                          TextSpan(
                            text: "felt after cravings",
                          ),
                        ])),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Stack(
                children: [
                  FourxFourScrollView(
                      scrollController:
                          progressController.cravingFeelingsScrollController,
                      items: _getFeelingsAfterCravings(), childAspectRatio: 1.9,),
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
              ),
              SizedBox(
                height: 12.h,
              ),
              SizedBox(
                width: 180.w,
                child: TextAutoSize(
                  "Based on your mood logs during cravings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: circularBook,
                      height: 1.1,
                      color: const Color(0xFFC8C8C8)),
                ),
              )
            ],
          );
              });
        });
  }
}
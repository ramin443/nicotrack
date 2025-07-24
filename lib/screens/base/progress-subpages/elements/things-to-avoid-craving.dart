import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../constants/image-constants.dart';
import '../../../../getx-controllers/premium-controller.dart';
import '../../../../models/did-you-smoke/didyouSmoke-model.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';
import '../../../elements/textAutoSize.dart';
import '../../../premium/premium-paywall-screen.dart';
import '4x4-scroll-view.dart';
class ThingsToAvoidCraving extends StatefulWidget {
  const ThingsToAvoidCraving({super.key});

  @override
  State<ThingsToAvoidCraving> createState() => _ThingsToAvoidCravingState();
}

class _ThingsToAvoidCravingState extends State<ThingsToAvoidCraving> {
  
  List<EmojiTextModel> _getAvoidanceStrategies() {
    final didYouSmokeBox = Hive.box<DidYouSmokeModel>('didYouSmokeData');
    Map<String, int> strategyCounts = {};
    Map<String, String> strategyEmojis = {};
    
    // Define all possible avoidance strategies with their emoji assets
    Map<String, String> allStrategies = {
      "Use breathing exercises": meditateImg,
      "Distract with a game": gameImg,
      "Go for a walk": walkImg,
      "Call someone": phoneImg,
      "Log craving and mood": notesImg,
      "Other": xmarkEmoji,
    };
    
    // Analyze all smoking log entries
    for (String key in didYouSmokeBox.keys.cast<String>()) {
      final smokingData = didYouSmokeBox.get(key);
      if (smokingData != null && smokingData.avoidNext.isNotEmpty) {
        try {
          // Count each avoidance strategy
          for (var strategy in smokingData.avoidNext) {
            String strategyText = strategy['text']?.toString().trim() ?? 'Unknown';
            String emoji = strategy['emoji'] ?? xmarkEmoji;
            
            // Clean up strategy text to match our mapping
            strategyText = strategyText.replaceFirst(RegExp(r'^\s*'), ''); // Remove leading spaces
            
            strategyCounts[strategyText] = (strategyCounts[strategyText] ?? 0) + 1;
            strategyEmojis[strategyText] = emoji;
          }
        } catch (e) {
          // Handle any data extraction errors
        }
      }
    }
    
    // If no avoidance data found, return placeholder message
    if (strategyCounts.isEmpty) {
      return [
        EmojiTextModel(emoji: xmarkEmoji, text: "No avoidance data yet|0|0"),
      ];
    }
    
    // Sort strategies by frequency (most common first)
    List<MapEntry<String, int>> sortedStrategies = strategyCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Calculate total for percentage
    int totalCount = strategyCounts.values.reduce((a, b) => a + b);
    
    // Create result list with counts and percentages
    List<EmojiTextModel> results = [];
    for (var entry in sortedStrategies) {
      String strategy = entry.key;
      int count = entry.value;
      int percentage = ((count / totalCount) * 100).round();
      String emoji = strategyEmojis[strategy] ?? xmarkEmoji;
      
      // Format text for display
      results.add(EmojiTextModel(
        emoji: emoji,
        text: "$strategy|$count|$percentage", // Using | as separator for parsing in UI
      ));
    }
    
    // Return only strategies that have been used (no 0-count items)
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
                  width: 170.w,
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              height: 1.1,
                              color: nicotrackBlack1),
                          children: [
                            TextSpan(
                              text: "🛡️ What you would do to ",

                            ),
                            TextSpan(
                              text: "avoid cravings?",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: circularBold,
                                  height: 1.1,
                                  color: const Color(0xFFC79C42)),
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
                    progressController.avoidCravingsScrollController,
                    items: _getAvoidanceStrategies(), childAspectRatio: 1.65,),
                if (!premiumController.isPremium.value)
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
                "Based on your avoidance strategies from smoking logs",
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
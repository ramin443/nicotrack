import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/4x4-alt-scroll-view.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/dummy-data-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../constants/image-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../../getx-controllers/premium-controller.dart';
import '../../../../models/did-you-smoke/didyouSmoke-model.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';
import '../../../../models/mood-model/mood-model.dart';
import '../../../../models/onboarding-data/onboardingData-model.dart';
import '../../../elements/textAutoSize.dart';
import '../../../premium/premium-paywall-screen.dart';
import '../../../../extensions/app_localizations_extension.dart';

class TopTriggersSection extends StatefulWidget {
  const TopTriggersSection({super.key});

  @override
  State<TopTriggersSection> createState() => _TopTriggersSectionState();
}

class _TopTriggersSectionState extends State<TopTriggersSection> {
  
  List<EmojiTextModel> _getTopTriggers() {
    Map<String, int> triggerCounts = {};
    Map<String, String> triggerEmojis = {};
    
    // 1. Get onboarding crave situations
    try {
      final onboardingBox = Hive.box<OnboardingData>('onboardingCompletedData');
      final onboardingData = onboardingBox.get('currentUserOnboarding');
      
      if (onboardingData != null && onboardingData.craveSituations.isNotEmpty) {
        for (String situation in onboardingData.craveSituations) {
          triggerCounts[situation] = (triggerCounts[situation] ?? 0) + 2; // Weight onboarding data higher
          
          // Map situation to emoji
          switch (situation.toLowerCase()) {
            case 'morning with coffee':
              triggerEmojis[situation] = coffeeEmoji;
              break;
            case 'after meals':
              triggerEmojis[situation] = platesEmoji;
              break;
            case 'when drinking alcohol':
              triggerEmojis[situation] = beerEmoji;
              break;
            case 'when feeling stressed':
              triggerEmojis[situation] = stressedEmoji;
              break;
            case 'boredom or habit':
              triggerEmojis[situation] = homeEmoji;
              break;
            default:
              triggerEmojis[situation] = othersEmoji;
          }
        }
      }
    } catch (e) {
      print('Error reading onboarding data: $e');
    }
    
    // 2. Get daily smoking triggers
    try {
      final smokingBox = Hive.box<DidYouSmokeModel>('didYouSmokeData');
      
      for (String key in smokingBox.keys.cast<String>()) {
        final smokingData = smokingBox.get(key);
        if (smokingData != null && smokingData.whatTriggerred.isNotEmpty) {
          for (Map<String, dynamic> trigger in smokingData.whatTriggerred) {
            String triggerText = trigger['text'] ?? 'Unknown';
            String triggerEmoji = trigger['emoji'] ?? othersEmoji;
            
            triggerCounts[triggerText] = (triggerCounts[triggerText] ?? 0) + 1;
            triggerEmojis[triggerText] = triggerEmoji;
          }
        }
      }
    } catch (e) {
      print('Error reading smoking data: $e');
    }
    
    // 3. Get mood/craving timing triggers
    try {
      final moodBox = Hive.box<MoodModel>('moodData');
      
      for (String key in moodBox.keys.cast<String>()) {
        final moodData = moodBox.get(key);
        if (moodData != null && moodData.craveTiming.isNotEmpty) {
          for (Map<String, dynamic> craving in moodData.craveTiming) {
            String triggerText = craving['text'] ?? 'Unknown';
            String triggerEmoji = craving['emoji'] ?? othersEmoji;
            
            triggerCounts[triggerText] = (triggerCounts[triggerText] ?? 0) + 1;
            triggerEmojis[triggerText] = triggerEmoji;
          }
        }
      }
    } catch (e) {
      print('Error reading mood data: $e');
    }
    
    // 4. Sort triggers by frequency and create EmojiTextModel list
    if (triggerCounts.isEmpty) {
      // Return fallback data if no user data found
      return [
        EmojiTextModel(emoji: coffeeEmoji, text: "Morning with coffee"),
        EmojiTextModel(emoji: stressedEmoji, text: "When feeling stressed"),
        EmojiTextModel(emoji: platesEmoji, text: "After meals"),
        EmojiTextModel(emoji: beerEmoji, text: "When drinking alcohol"),
      ];
    }
    
    List<MapEntry<String, int>> sortedTriggers = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    List<EmojiTextModel> topTriggers = [];
    for (int i = 0; i < sortedTriggers.length && i < 12; i++) {
      String triggerText = sortedTriggers[i].key;
      String emoji = triggerEmojis[triggerText] ?? othersEmoji;
      
      topTriggers.add(EmojiTextModel(
        emoji: emoji,
        text: triggerText,
      ));
    }
    
    return topTriggers;
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
                            text: context.l10n.top_prefix,
                          ),
                          TextSpan(
                            text: context.l10n.triggers_word,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: const Color(0xFFFF611D)),
                          ),
                        ])),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  FourxFourAltScrollView(
                    scrollController:
                    progressController.topTriggersScrollController,
                    items: _getTopTriggers(),
                    childAspectRatio: 2.6,
                  ),
                  if (!premiumController.effectivePremiumStatus)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return const PremiumPaywallScreen();
                          }));
                        },
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container( // This container will still fill due to BackdropFilter behavior
                              color: Colors.white.withOpacity(0.1), // Semi-transparent to see blur
                              child: Align(
                                alignment: Alignment.center, // Or any other alignment
                                child: contentLockBox(context), // contentLockBox will now use its intrinsic size
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                ],
              ),

              SizedBox(
                height: 6.w,
              ),
              SizedBox(
                width: double.infinity,
                child: TextAutoSize(
                  context.l10n.triggers_subtitle,
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
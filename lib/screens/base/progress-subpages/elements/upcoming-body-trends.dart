import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/single-row-scroll-view.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/premium-controller.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';
import '../../../../utility-functions/home-grid-calculations.dart';
import '../../../premium/premium-paywall-screen.dart';
import '../../../../extensions/app_localizations_extension.dart';

class UpcomingHealthTrend extends StatefulWidget {
  final ScrollController scrollController;
  const UpcomingHealthTrend({super.key, required this.scrollController});

  @override
  State<UpcomingHealthTrend> createState() => _UpcomingHealthTrendState();
}

class _UpcomingHealthTrendState extends State<UpcomingHealthTrend> {
  
  List<EmojiTextModel> _getUpcomingBodyChanges() {
    int daysSinceQuit = getDaysSinceLastSmoked(DateTime.now());
    int hoursSinceQuit = daysSinceQuit * 24;
    List<EmojiTextModel> upcomingChanges = [];
    
    // Define all body improvements with timeline
    Map<String, Map<String, dynamic>> allChanges = {
      // Hours-based milestones
      "Blood pressure normalizes": {"hours": 0.33, "emoji": "💓"},
      "Heart rate stabilizes": {"hours": 0.33, "emoji": "❤️"},
      "CO levels drop 50%": {"hours": 8, "emoji": "💨"},
      "Oxygen levels normalize": {"hours": 12, "emoji": "🧠"},
      "CO fully eliminated": {"hours": 24, "emoji": "✨"},
      "Nicotine levels drop 90%": {"hours": 48, "emoji": "📉"},
      "Nerve endings regenerate": {"hours": 48, "emoji": "🧠"},
      "Taste & smell sharpen": {"hours": 48, "emoji": "👃"},
      
      // Days-based milestones (converted to hours)
      "Nicotine leaves system": {"hours": 72, "emoji": "🚭"},
      "Breathing becomes easier": {"hours": 72, "emoji": "🫁"},
      "Energy levels surge": {"hours": 96, "emoji": "⚡"},
      "Bronchial tubes relax": {"hours": 120, "emoji": "🫁"},
      "Circulation improves": {"hours": 168, "emoji": "🩸"},
      
      // Week-based milestones
      "Lung function +5%": {"hours": 168, "emoji": "📈"},
      "Cilia start regrowing": {"hours": 336, "emoji": "🫁"},
      "Physical activity easier": {"hours": 336, "emoji": "🏃"},
      "Lung function +10%": {"hours": 336, "emoji": "💪"},
      "Withdrawal symptoms fade": {"hours": 504, "emoji": "😌"},
      
      // Month-based milestones
      "Coughing decreases": {"hours": 720, "emoji": "😮‍💨"},
      "Lung capacity +30%": {"hours": 720, "emoji": "🫁"},
      "Athletic performance improves": {"hours": 720, "emoji": "🏃"},
      "Sinus congestion clears": {"hours": 720, "emoji": "👃"},
      "Fatigue disappears": {"hours": 720, "emoji": "💪"},
      "Overall energy doubles": {"hours": 1080, "emoji": "⚡"},
      
      // 2-3 months
      "Blood flow optimal": {"hours": 1440, "emoji": "❤️"},
      "Walking long distances easy": {"hours": 1440, "emoji": "🚶"},
      "Lung function +50%": {"hours": 2160, "emoji": "🫁"},
      "Immune system stronger": {"hours": 2160, "emoji": "🛡️"},
      
      // 6-9 months
      "Cilia fully regrown": {"hours": 4320, "emoji": "✨"},
      "Infection risk minimal": {"hours": 4320, "emoji": "🛡️"},
      "Energy at peak levels": {"hours": 4320, "emoji": "⚡"},
      "Breathing like non-smoker": {"hours": 6480, "emoji": "🫁"},
      
      // 1 year+
      "Heart disease risk -50%": {"hours": 8760, "emoji": "❤️"},
      "Stroke risk decreasing": {"hours": 8760, "emoji": "🧠"},
      "Lung function normalized": {"hours": 8760, "emoji": "🫁"},
      
      // 2-5 years
      "Stroke risk -50%": {"hours": 17520, "emoji": "🧠"},
      "Cervical cancer risk -50%": {"hours": 17520, "emoji": "🛡️"},
      "Cancer risk dropping": {"hours": 35040, "emoji": "🛡️"},
      "Stroke risk = non-smoker": {"hours": 43800, "emoji": "✨"},
      
      // 10+ years
      "Lung cancer risk -50%": {"hours": 87600, "emoji": "🫁"},
      "Mouth/throat cancer -50%": {"hours": 87600, "emoji": "🛡️"},
      "Pre-cancerous cells gone": {"hours": 87600, "emoji": "✨"},
      
      // 15+ years
      "Coronary heart disease risk = non-smoker": {"hours": 131400, "emoji": "❤️"},
      "Pancreas cancer risk = non-smoker": {"hours": 131400, "emoji": "🛡️"},
      "Full body recovery": {"hours": 131400, "emoji": "🎉"},
    };
    
    // Find upcoming changes (not yet achieved)
    for (String changeName in allChanges.keys) {
      num requiredHours = allChanges[changeName]!["hours"];
      String emoji = allChanges[changeName]!["emoji"];
      
      if (hoursSinceQuit < requiredHours) {
        // Calculate time until this change
        int hoursUntil = (requiredHours - hoursSinceQuit).toInt();
        String timeframe = _formatTimeUntil(hoursUntil);
        
        upcomingChanges.add(EmojiTextModel(
          emoji: emoji,
          text: "$changeName\n$timeframe",
        ));
      }
    }
    
    // If all changes achieved (15+ years), show long-term maintenance
    if (upcomingChanges.isEmpty) {
      return [
        EmojiTextModel(emoji: "🏆", text: "All milestones\nachieved!"),
        EmojiTextModel(emoji: "💪", text: "Maintaining\noptimal health"),
        EmojiTextModel(emoji: "🛡️", text: "Maximum\nprotection active"),
        EmojiTextModel(emoji: "🎉", text: "Lifetime\nnon-smoker status"),
      ];
    }
    
    // Return next 8-10 upcoming changes
    return upcomingChanges.take(10).toList();
  }
  
  String _formatTimeUntil(int hoursUntil) {
    if (hoursUntil < 1) {
      int minutes = (hoursUntil * 60).toInt();
      return "in $minutes min";
    } else if (hoursUntil < 24) {
      return "in $hoursUntil hrs";
    } else if (hoursUntil < 168) { // Less than a week
      int days = (hoursUntil / 24).round();
      return "in $days days";
    } else if (hoursUntil < 720) { // Less than a month
      int weeks = (hoursUntil / 168).round();
      return "in $weeks weeks";
    } else if (hoursUntil < 8760) { // Less than a year
      int months = (hoursUntil / 720).round();
      return "in $months months";
    } else {
      int years = (hoursUntil / 8760).round();
      return "in $years years";
    }
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
                        text: context.l10n.upcoming_prefix,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: Color(0xffFF4800)
                        ),
                      ),
                      TextSpan(
                        text: context.l10n.upcoming_suffix,
                      ),
                    ])),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Stack(
          children: [
            SingleRowScrollView(items: _getUpcomingBodyChanges(), scrollController: widget.scrollController,),
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
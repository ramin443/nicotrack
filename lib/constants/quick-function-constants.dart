import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/models/award-model/award-model.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';

import '../models/withdrawal-stage-model/withdrawal-stage-model.dart';
import '../screens/elements/info-bottom-sheet.dart';

double getDynamicHeightWeeklyCalendar(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight <= 667) {
    // iPhone SE (screen height is small)
    return 112.h;
  } else if (screenHeight >= 812) {
    // iPhone 11 Pro / Plus / Large devices
    return 94.h;
  } else {
    // Default case for mid-range devices
    return 94.h;
  }
}

double getDynamicStageBox(BuildContext context) {


  double screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight <= 667) {
    // iPhone SE (screen height is small)
    return 168.h;
  } else if (screenHeight >= 812) {
    // iPhone 11 Pro / Plus / Large devices
    return 138.h;
  } else {
    // Default case for mid-range devices
    return 138.h;
  }
}
double getDynamicPlanHeader(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight <= 667) {
    // iPhone SE (screen height is small)
    return 126.h;
  } else if (screenHeight >= 812) {
    // iPhone 11 Pro / Plus / Large devices
    return 106.h;
  } else {
    // Default case for mid-range devices
    return 106.h;
  }
}

double getBottomNavHeight(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight <= 667) {
    // iPhone SE (screen height is small)
    return 82.h;
  } else if (screenHeight >= 812) {
    // iPhone 11 Pro / Plus / Large devices
    return 62.h;
  } else {
    // Default case for mid-range devices
    return 62.h;
  }
}
Color colorWithOpacityHex(Color baseColor, double opacity) {
  final alpha = (opacity * 255).round().clamp(0, 255);
  return baseColor.withAlpha(alpha);
}

void showCustomBottomSheet({required BuildContext context, required int index}) {
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () {
        overlayEntry.remove();
      },
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: InfoBottomSheet(
                      withdrawalStage: withdrawalStages[index],
                    ), // your actual content
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
}





 List<WithdrawalStageModel> withdrawalStages = [
  // Day 0 - First 24 Hours
  WithdrawalStageModel(
    intensityLevel: 0,
    timeAfterQuitting: "First 24 Hours",
    whatHappens: [
      EmojiTextModel(emoji: "💨", text: "CO exits bloodstream").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Oxygen normalizes").toJson(),
      EmojiTextModel(emoji: "💓", text: "Heart rate drops").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😰", text: "Mild cravings").toJson(),
      EmojiTextModel(emoji: "😵", text: "Restlessness").toJson(),
      EmojiTextModel(emoji: "😟", text: "Mild anxiety").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "💧", text: "Drink plenty of water").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Practice deep breathing").toJson(),
      EmojiTextModel(emoji: "🚶", text: "Take short walks").toJson()
    ],
  ),

  // Day 1 - Day 2
  WithdrawalStageModel(
    intensityLevel: 0,
    timeAfterQuitting: "Day 2",
    whatHappens: [
      EmojiTextModel(emoji: "🧪", text: "Nicotine drops 90%").toJson(),
      EmojiTextModel(emoji: "👃", text: "Taste improves").toJson(),
      EmojiTextModel(emoji: "😰", text: "Withdrawal begins").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🔥", text: "Strong cravings").toJson(),
      EmojiTextModel(emoji: "😠", text: "Irritability").toJson(),
      EmojiTextModel(emoji: "🤯", text: "Headaches").toJson(),
      EmojiTextModel(emoji: "😴", text: "Sleep issues").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "☕", text: "Limit caffeine intake").toJson(),
      EmojiTextModel(emoji: "💧", text: "Stay well hydrated").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Use meditation apps").toJson()
    ],
  ),

  // Day 3 - Day 3-4
  WithdrawalStageModel(
    intensityLevel: 1,
    timeAfterQuitting: "Day 3-4",
    whatHappens: [
      EmojiTextModel(emoji: "🚫", text: "Nicotine eliminated").toJson(),
      EmojiTextModel(emoji: "📈", text: "Peak cravings").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Brain adjusts").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😢", text: "Low mood").toJson(),
      EmojiTextModel(emoji: "😩", text: "Fatigue").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Brain fog").toJson(),
      EmojiTextModel(emoji: "🚬", text: "Strong urges").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃", text: "Engage in light exercise").toJson(),
      EmojiTextModel(emoji: "🍎", text: "Eat nutritious snacks").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Practice progressive muscle relaxation").toJson()
    ],
  ),

  // Day 5 - Day 5-7
  WithdrawalStageModel(
    intensityLevel: 2,
    timeAfterQuitting: "Day 5-7",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Cilia moving").toJson(),
      EmojiTextModel(emoji: "🤧", text: "Toxin removal").toJson(),
      EmojiTextModel(emoji: "💪", text: "Peak withdrawal").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🤧", text: "Coughing").toJson(),
      EmojiTextModel(emoji: "🤮", text: "Mucus buildup").toJson(),
      EmojiTextModel(emoji: "😵", text: "Dizziness").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🍵", text: "Drink warm herbal teas").toJson(),
      EmojiTextModel(emoji: "🚶", text: "Maintain light physical activity").toJson(),
      EmojiTextModel(emoji: "🌬️", text: "Practice breathing exercises").toJson()
    ],
  ),

  // Day 8 - Week 1-2
  WithdrawalStageModel(
    intensityLevel: 2,
    timeAfterQuitting: "Week 1-2",
    whatHappens: [
      EmojiTextModel(emoji: "🩸", text: "Circulation +15%").toJson(),
      EmojiTextModel(emoji: "😮‍💨", text: "Easier breathing").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Fog clears").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌊", text: "Weaker cravings").toJson(),
      EmojiTextModel(emoji: "😌", text: "Better mood").toJson(),
      EmojiTextModel(emoji: "💭", text: "Clearer thinking").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📝", text: "Stick to your established quit plan").toJson(),
      EmojiTextModel(emoji: "🎁", text: "Reward yourself for progress").toJson(),
      EmojiTextModel(emoji: "🚫", text: "Continue avoiding smoking triggers").toJson()
    ],
  ),

  // Day 14 - 2 Weeks
  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: "2 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Lung function +5%").toJson(),
      EmojiTextModel(emoji: "🏃", text: "Exercise easier").toJson(),
      EmojiTextModel(emoji: "😊", text: "Mood stabilizes").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😮‍💨", text: "Better breathing").toJson(),
      EmojiTextModel(emoji: "💪", text: "More energy").toJson(),
      EmojiTextModel(emoji: "😌", text: "Stable emotions").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: "Start incorporating light exercise").toJson(),
      EmojiTextModel(emoji: "🚶‍♂️", text: "Take longer daily walks").toJson(),
      EmojiTextModel(emoji: "🥗", text: "Focus on nutritious eating habits").toJson()
    ],
  ),

  // Day 18 - 2.5 Weeks
  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: "2.5 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Rapid cilia regrowth").toJson(),
      EmojiTextModel(emoji: "🌬️", text: "Self-cleaning starts").toJson(),
      EmojiTextModel(emoji: "💪", text: "Stamina up").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏃", text: "Exercise easier").toJson(),
      EmojiTextModel(emoji: "😊", text: "Positive mood").toJson(),
      EmojiTextModel(emoji: "💤", text: "Better sleep").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📅", text: "Establish new healthy routines").toJson(),
      EmojiTextModel(emoji: "🧘‍♂️", text: "Practice daily mindfulness").toJson(),
      EmojiTextModel(emoji: "🎯", text: "Set progressive fitness goals").toJson()
    ],
  ),

  // Day 21 - 3 Weeks
  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: "3 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🧠", text: "Receptors -50%").toJson(),
      EmojiTextModel(emoji: "😌", text: "Less anxiety").toJson(),
      EmojiTextModel(emoji: "🔋", text: "Energy boost").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😌", text: "Emotional stability").toJson(),
      EmojiTextModel(emoji: "💭", text: "Mental clarity").toJson(),
      EmojiTextModel(emoji: "⚡", text: "All-day energy").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📚", text: "Learn new skills or hobbies").toJson(),
      EmojiTextModel(emoji: "👥", text: "Strengthen social connections").toJson(),
      EmojiTextModel(emoji: "🎉", text: "Celebrate your 3-week milestone").toJson()
    ],
  ),

  // Day 28 - 4 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: "4 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Capacity +15%").toJson(),
      EmojiTextModel(emoji: "💓", text: "BP stabilizes").toJson(),
      EmojiTextModel(emoji: "🎯", text: "Cravings fade").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🧊", text: "Rare cravings").toJson(),
      EmojiTextModel(emoji: "😊", text: "Stable mood").toJson(),
      EmojiTextModel(emoji: "💪", text: "More strength").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🥗", text: "Continue healthy eating habits").toJson(),
      EmojiTextModel(emoji: "🎉", text: "Celebrate this major milestone!").toJson(),
      EmojiTextModel(emoji: "💰", text: "Calculate and track money saved").toJson()
    ],
  ),

  // Day 35 - 5 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: "5 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🌬️", text: "Infection risk drops").toJson(),
      EmojiTextModel(emoji: "🏃‍♂️", text: "Cardio +20%").toJson(),
      EmojiTextModel(emoji: "😴", text: "Better sleep").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌟", text: "More vibrant").toJson(),
      EmojiTextModel(emoji: "💤", text: "Deep sleep").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Sharp focus").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: "Increase physical activity intensity").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Practice gratitude meditation").toJson(),
      EmojiTextModel(emoji: "📚", text: "Pursue learning new skills").toJson()
    ],
  ),

  // Day 42 - 6 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: "6 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "👃", text: "Sinuses clear").toJson(),
      EmojiTextModel(emoji: "💪", text: "Strength up").toJson(),
      EmojiTextModel(emoji: "⚡", text: "Energy doubles").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌟", text: "Peak vitality and energy").toJson(),
      EmojiTextModel(emoji: "😴", text: "Excellent sleep quality").toJson(),
      EmojiTextModel(emoji: "🏃", text: "Exercise feels effortless").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎯", text: "Set ambitious fitness goals").toJson(),
      EmojiTextModel(emoji: "👥", text: "Join active communities").toJson(),
      EmojiTextModel(emoji: "📈", text: "Track your fitness improvements").toJson()
    ],
  ),

  // Day 50 - 7 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: "7 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Function +25%").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Sharp focus").toJson(),
      EmojiTextModel(emoji: "🔥", text: "Optimal metabolism").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💭", text: "Crystal clear thinking").toJson(),
      EmojiTextModel(emoji: "⚡", text: "Sustained high energy").toJson(),
      EmojiTextModel(emoji: "💪", text: "Peak physical condition").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: "Challenge yourself with new goals").toJson(),
      EmojiTextModel(emoji: "📝", text: "Document your transformation").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Inspire others to quit").toJson()
    ],
  ),

  // Day 56 - 8 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: "8 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🩸", text: "Peak oxygen delivery").toJson(),
      EmojiTextModel(emoji: "💓", text: "Heart +30%").toJson(),
      EmojiTextModel(emoji: "😊", text: "Mood optimal").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏃", text: "Athletic performance surpasses baseline").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Enhanced cognitive function").toJson(),
      EmojiTextModel(emoji: "😌", text: "Emotional equilibrium achieved").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃", text: "Try new physical challenges").toJson(),
      EmojiTextModel(emoji: "🎯", text: "Set long-term health goals").toJson(),
      EmojiTextModel(emoji: "👥", text: "Share your success story").toJson()
    ],
  ),

  // Day 65 - 9-10 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: "9-10 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🏃", text: "Athletic baseline").toJson(),
      EmojiTextModel(emoji: "🛡️", text: "Strong immunity").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Better skin").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💪", text: "Exceptional physical stamina").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Peak mental clarity").toJson(),
      EmojiTextModel(emoji: "✨", text: "Visible health transformation").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📊", text: "Monitor your health metrics").toJson(),
      EmojiTextModel(emoji: "🎉", text: "Celebrate your transformation").toJson(),
      EmojiTextModel(emoji: "💪", text: "Maintain momentum").toJson()
    ],
  ),

  // Day 75 - 10-11 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: "10-11 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Cilia 70% restored").toJson(),
      EmojiTextModel(emoji: "😮‍💨", text: "No breathlessness").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Peak clarity").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌬️", text: "Perfect breathing capacity").toJson(),
      EmojiTextModel(emoji: "⚡", text: "Unlimited energy reserves").toJson(),
      EmojiTextModel(emoji: "🎯", text: "Laser-sharp focus").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: "Enjoy your enhanced abilities").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Become a quit-smoking advocate").toJson(),
      EmojiTextModel(emoji: "📝", text: "Journal your journey").toJson()
    ],
  ),

  // Day 84 - 12 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: "12 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "💪", text: "Peak muscle oxygen").toJson(),
      EmojiTextModel(emoji: "🌬️", text: "Full lung cleaning").toJson(),
      EmojiTextModel(emoji: "🎯", text: "Optimal cognition").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏆", text: "Peak physical performance").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Optimal brain function").toJson(),
      EmojiTextModel(emoji: "💎", text: "Perfect health status").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎉", text: "Celebrate 3-month milestone").toJson(),
      EmojiTextModel(emoji: "🎯", text: "Plan long-term health goals").toJson(),
      EmojiTextModel(emoji: "💪", text: "Maintain peak condition").toJson()
    ],
  ),

  // Day 95 - 13-14 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: "13-14 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Function +40%").toJson(),
      EmojiTextModel(emoji: "❤️", text: "Low heart risk").toJson(),
      EmojiTextModel(emoji: "⚡", text: "Sustained energy").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏃", text: "Elite athletic performance").toJson(),
      EmojiTextModel(emoji: "💓", text: "Optimal heart health").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Radiant vitality").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: "Push your physical limits").toJson(),
      EmojiTextModel(emoji: "📈", text: "Track health improvements").toJson(),
      EmojiTextModel(emoji: "👥", text: "Mentor other quitters").toJson()
    ],
  ),

  // Day 105 - 15 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "15 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🛡️", text: "Optimal white cells").toJson(),
      EmojiTextModel(emoji: "🏃‍♀️", text: "Fast recovery").toJson(),
      EmojiTextModel(emoji: "😴", text: "Deep sleep").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💪", text: "Fast recovery").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Better cognition").toJson(),
      EmojiTextModel(emoji: "✨", text: "Full vitality").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: "Enjoy your superhuman abilities").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Inspire others with your success").toJson(),
      EmojiTextModel(emoji: "📝", text: "Document your complete transformation").toJson()
    ],
  ),

  // Continue with remaining stages...
  // Day 112 - 16 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "16 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🌬️", text: "Athletic breathing").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Full neurotransmitters").toJson(),
      EmojiTextModel(emoji: "💎", text: "Peak repair").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏆", text: "Athletic performance").toJson(),
      EmojiTextModel(emoji: "⚡", text: "Unlimited energy").toJson(),
      EmojiTextModel(emoji: "🧬", text: "Optimal cells").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎯", text: "Set ambitious life goals").toJson(),
      EmojiTextModel(emoji: "💪", text: "Challenge your limits").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Live your best life").toJson()
    ],
  ),

  // Day 126 - 18 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "18 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Capacity +45%").toJson(),
      EmojiTextModel(emoji: "🔋", text: "Optimal mitochondria").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Visible transformation").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "✨", text: "Radiant health").toJson(),
      EmojiTextModel(emoji: "💪", text: "Peak condition").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Optimal brain").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📸", text: "Document your transformation").toJson(),
      EmojiTextModel(emoji: "🎉", text: "Celebrate your new self").toJson(),
      EmojiTextModel(emoji: "💪", text: "Maintain excellence").toJson()
    ],
  ),

  // Day 140 - 20 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "20 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "💓", text: "Peak heart efficiency").toJson(),
      EmojiTextModel(emoji: "🏃", text: "Max VO2").toJson(),
      EmojiTextModel(emoji: "🧬", text: "DNA repair boost").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "❤️", text: "Perfect heart health").toJson(),
      EmojiTextModel(emoji: "⚡", text: "Limitless energy").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Cell regeneration").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: "Achieve your dreams").toJson(),
      EmojiTextModel(emoji: "💪", text: "Push new boundaries").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Inspire others").toJson()
    ],
  ),

  // Day 154 - 22 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "22 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Cilia 90% normal").toJson(),
      EmojiTextModel(emoji: "🛡️", text: "Max infection resistance").toJson(),
      EmojiTextModel(emoji: "⚡", text: "No crashes").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💪", text: "Ultimate resilience").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Peak mental").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Optimal health").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎯", text: "Set lifetime goals").toJson(),
      EmojiTextModel(emoji: "💪", text: "Maintain peak performance").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Be a role model").toJson()
    ],
  ),

  // Day 168 - 24 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "24 Weeks",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Function +50%").toJson(),
      EmojiTextModel(emoji: "🌬️", text: "Non-smoker breathing").toJson(),
      EmojiTextModel(emoji: "🏆", text: "Full transformation").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "✨", text: "Full restoration").toJson(),
      EmojiTextModel(emoji: "💪", text: "Peak performance").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Optimal cognition").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎉", text: "Celebrate complete transformation").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Embrace your new life").toJson(),
      EmojiTextModel(emoji: "💪", text: "Maintain excellence forever").toJson()
    ],
  ),

  // Day 180 - 6 Months
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: "6 Months",
    whatHappens: [
      EmojiTextModel(emoji: "✨", text: "Complete restoration").toJson(),
      EmojiTextModel(emoji: "💪", text: "Peak performance").toJson(),
      EmojiTextModel(emoji: "🎉", text: "Major milestone!").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏆", text: "Ultimate milestone").toJson(),
      EmojiTextModel(emoji: "💎", text: "Optimal health").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Best life").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: "Celebrate this incredible achievement").toJson(),
      EmojiTextModel(emoji: "🌟", text: "Plan your smoke-free future").toJson(),
      EmojiTextModel(emoji: "💪", text: "Continue your healthy lifestyle forever").toJson()
    ],
  ),
];


List<AwardModel> allAwards =[
  AwardModel(emojiImg: badge1Emoji, day: 1),
  AwardModel(emojiImg: baseballImg, day: 3),
  AwardModel(emojiImg: pinataImg, day: 5),
  AwardModel(emojiImg: medalImg, day: 7),
  AwardModel(emojiImg: kiteImg, day: 10),
  AwardModel(emojiImg: golfImg, day: 12),
  AwardModel(emojiImg: dartarrowImg, day: 15),
  AwardModel(emojiImg: teddyImg, day: 18),
  AwardModel(emojiImg: hat2Img, day: 20),
  AwardModel(emojiImg: ballrollImg, day: 25),
  AwardModel(emojiImg: hatImg, day: 30),
  AwardModel(emojiImg: ballImg, day: 40),
  AwardModel(emojiImg: chocolateImg, day: 50),
  AwardModel(emojiImg: magicbowlImg, day: 60),
  AwardModel(emojiImg: crownImg, day: 75),
  AwardModel(emojiImg: vacayImg, day: 90),
  AwardModel(emojiImg: no1Img, day: 120),
  AwardModel(emojiImg: trophyImg, day: 150),
  AwardModel(emojiImg: celebrateImg, day: 180),
];


String getTwemojiImageUrlFromName(String name) {
  final parser = EmojiParser();
  final emoji = parser.get(name); // Retrieves the Emoji object
  final emojiChar = emoji.code; // The actual emoji character

  final codePoints = emojiChar.runes.map((r) => r.toRadixString(16)).join('-');
  return 'https://twemoji.maxcdn.com/v/latest/72x72/$codePoints.png';
}

String getMountainImagefromIntensity(int intensityLevel){
  switch(intensityLevel){
    case 0:
      return volcMountain;
    case 1:
      return icyVolcMountain;
    case 2:
      return barrenMountain;
    case 3:
      return icyMountain;
    case 4:
      return icyMountain;
    case 5:
      return icyMountain;
    case 6:
      return icyMountain;
      default:
      return volcMountain;
  }
}
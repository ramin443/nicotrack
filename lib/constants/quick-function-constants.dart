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
  WithdrawalStageModel(
    intensityLevel: 0,
    timeAfterQuitting: "0-24 Hours",
    whatHappens: [
      EmojiTextModel(emoji: "🧠", text: "Carbon monoxide exits").toJson(),
      EmojiTextModel(emoji: "🫁", text: "Oxygen levels improves").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😰", text: "Mild cravings").toJson(),
      EmojiTextModel(emoji: "😵", text: "Restlessness").toJson(),
      EmojiTextModel(emoji: "😟", text: "Anxiety").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "💧", text: "Drink water").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Meditate").toJson()
    ],
  ),

  WithdrawalStageModel(
    intensityLevel: 0,
    timeAfterQuitting: "Day 2-3",
    whatHappens: [
      EmojiTextModel(emoji: "🧪", text: "Nicotine exits body").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🔥", text: "Strong cravings").toJson(),
      EmojiTextModel(emoji: "😠", text: "Irritability").toJson(),
      EmojiTextModel(emoji: "🤯", text: "Headaches").toJson(),
      EmojiTextModel(emoji: "😴", text: "Insomnia").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "☕", text: "Avoid caffeine").toJson(),
      EmojiTextModel(emoji: "💧", text: "Stay hydrated").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Meditate").toJson()
    ],
  ),

  WithdrawalStageModel(
    intensityLevel: 1,
    timeAfterQuitting: "Day 3-5",
    whatHappens: [
      EmojiTextModel(emoji: "📈", text: "Cravings peak").toJson(),
      EmojiTextModel(emoji: "⬇️", text: "Dopamine levels drop").toJson(),
      EmojiTextModel(emoji: "😖", text: "Mood swings common").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😢", text: "Depression").toJson(),
      EmojiTextModel(emoji: "😩", text: "Fatigue").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Brain fog").toJson(),
      EmojiTextModel(emoji: "🚬", text: "Strong urges to smoke").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃", text: "Exercise").toJson(),
      EmojiTextModel(emoji: "🍎", text: "Eat healthy snacks").toJson(),
      EmojiTextModel(emoji: "🧘", text: "Do deep breathing").toJson()
    ],
  ),

  WithdrawalStageModel(
    intensityLevel: 2,
    timeAfterQuitting: "Day 5-10",
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: "Lung function improves").toJson(),
      EmojiTextModel(emoji: "🧹", text: "Mucus and toxins cleared").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🤧", text: "Coughing").toJson(),
      EmojiTextModel(emoji: "🤮", text: "Mucus buildup").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🍵", text: "Drink warm fluids").toJson(),
      EmojiTextModel(emoji: "🚶", text: "Stay active").toJson(),
      EmojiTextModel(emoji: "🌬️", text: "Take deep breaths").toJson()
    ],
  ),

  WithdrawalStageModel(
    intensityLevel: 2,
    timeAfterQuitting: "Day 10-14",
    whatHappens: [
      EmojiTextModel(emoji: "💪", text: "Circulation improves").toJson(),
      EmojiTextModel(emoji: "🧠", text: "Withdrawal symptoms fade").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌊", text: "Weaker cravings").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📝", text: "Stick to your quit plan").toJson(),
      EmojiTextModel(emoji: "🎁", text: "Reward yourself").toJson(),
      EmojiTextModel(emoji: "🚫", text: "Avoid triggers").toJson()
    ],
  ),

  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: "Week 3-4",
    whatHappens: [
      EmojiTextModel(emoji: "🧠", text: "Nicotine receptors in the brain begin shutting down").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🔁", text: "Habits still linger").toJson(),
      EmojiTextModel(emoji: "📉", text: "Cravings reduce").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📅", text: "Focus on new routines").toJson(),
      EmojiTextModel(emoji: "🧘‍♂️", text: "Practice mindfulness").toJson()
    ],
  ),

  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: "1 Month Smoke-Free",
    whatHappens: [
      EmojiTextModel(emoji: "🏃‍♂️", text: "Lung function improves by 30%").toJson(),
      EmojiTextModel(emoji: "💓", text: "Blood pressure stabilizes").toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🧊", text: "Occasional cravings").toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🥗", text: "Continue healthy habits").toJson(),
      EmojiTextModel(emoji: "🎉", text: "Celebrate progress!").toJson()
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
  AwardModel(emojiImg: ballrollImg, day: 23),
  AwardModel(emojiImg: hatImg, day: 25),
  AwardModel(emojiImg: ballImg, day: 28),
  AwardModel(emojiImg: chocolateImg, day: 30),
  AwardModel(emojiImg: magicbowlImg, day: 32),
  AwardModel(emojiImg: crownImg, day: 35),
  AwardModel(emojiImg: vacayImg, day: 38),
  AwardModel(emojiImg: no1Img, day: 40),
  AwardModel(emojiImg: trophyImg, day: 42),
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
      default:
      return volcMountain;
  }
}
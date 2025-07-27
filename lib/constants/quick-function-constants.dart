import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/models/award-model/award-model.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';

import '../extensions/app_localizations_extension.dart';
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
                      withdrawalStage: getTranslatedWithdrawalStages(context)[index],
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





// Method to get translated withdrawal stages
List<WithdrawalStageModel> getTranslatedWithdrawalStages(BuildContext context) => [
  // Day 0 - First 24 Hours
  WithdrawalStageModel(
    intensityLevel: 0,
    timeAfterQuitting: context.l10n.timeline_duration_first_24_hours,
    whatHappens: [
      EmojiTextModel(emoji: "💨", text: context.l10n.withdrawal_happens_co_exits).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_oxygen_normalizes).toJson(),
      EmojiTextModel(emoji: "💓", text: context.l10n.withdrawal_happens_heart_rate_drops).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😰", text: context.l10n.withdrawal_symptom_mild_cravings).toJson(),
      EmojiTextModel(emoji: "😵", text: context.l10n.withdrawal_symptom_restlessness).toJson(),
      EmojiTextModel(emoji: "😟", text: context.l10n.withdrawal_symptom_mild_anxiety).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "💧", text: context.l10n.withdrawal_cope_drink_water).toJson(),
      EmojiTextModel(emoji: "🧘", text: context.l10n.withdrawal_cope_deep_breathing).toJson(),
      EmojiTextModel(emoji: "🚶", text: context.l10n.withdrawal_cope_short_walks).toJson()
    ],
  ),

  // Day 1 - Day 2
  WithdrawalStageModel(
    intensityLevel: 0,
    timeAfterQuitting: context.l10n.timeline_duration_day_2,
    whatHappens: [
      EmojiTextModel(emoji: "🧪", text: context.l10n.withdrawal_happens_nicotine_drops_90).toJson(),
      EmojiTextModel(emoji: "👃", text: context.l10n.withdrawal_happens_taste_improves).toJson(),
      EmojiTextModel(emoji: "😰", text: context.l10n.withdrawal_happens_withdrawal_begins).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🔥", text: context.l10n.withdrawal_symptom_strong_cravings).toJson(),
      EmojiTextModel(emoji: "😠", text: context.l10n.withdrawal_symptom_irritability).toJson(),
      EmojiTextModel(emoji: "🤯", text: context.l10n.withdrawal_symptom_headaches).toJson(),
      EmojiTextModel(emoji: "😴", text: context.l10n.withdrawal_symptom_sleep_issues).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "☕", text: context.l10n.withdrawal_cope_limit_caffeine).toJson(),
      EmojiTextModel(emoji: "💧", text: context.l10n.withdrawal_cope_stay_hydrated).toJson(),
      EmojiTextModel(emoji: "🧘", text: context.l10n.withdrawal_cope_meditation_apps).toJson()
    ],
  ),

  // Day 3 - Day 3-4
  WithdrawalStageModel(
    intensityLevel: 1,
    timeAfterQuitting: context.l10n.timeline_duration_day_3_4,
    whatHappens: [
      EmojiTextModel(emoji: "🚫", text: context.l10n.withdrawal_happens_nicotine_eliminated).toJson(),
      EmojiTextModel(emoji: "📈", text: context.l10n.withdrawal_happens_peak_cravings).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_brain_adjusts).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😢", text: context.l10n.withdrawal_symptom_low_mood).toJson(),
      EmojiTextModel(emoji: "😩", text: context.l10n.withdrawal_symptom_fatigue).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_brain_fog).toJson(),
      EmojiTextModel(emoji: "🚬", text: context.l10n.withdrawal_symptom_strong_urges).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_cope_light_exercise).toJson(),
      EmojiTextModel(emoji: "🍎", text: context.l10n.withdrawal_cope_nutritious_snacks).toJson(),
      EmojiTextModel(emoji: "🧘", text: context.l10n.withdrawal_cope_muscle_relaxation).toJson()
    ],
  ),

  // Day 5 - Day 5-7
  WithdrawalStageModel(
    intensityLevel: 2,
    timeAfterQuitting: context.l10n.timeline_duration_day_5_7,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_cilia_moving).toJson(),
      EmojiTextModel(emoji: "🤧", text: context.l10n.withdrawal_happens_toxin_removal).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_happens_peak_withdrawal).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🤧", text: context.l10n.withdrawal_symptom_coughing).toJson(),
      EmojiTextModel(emoji: "🤮", text: context.l10n.withdrawal_symptom_mucus_buildup).toJson(),
      EmojiTextModel(emoji: "😵", text: context.l10n.withdrawal_symptom_dizziness).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🍵", text: context.l10n.withdrawal_cope_herbal_teas).toJson(),
      EmojiTextModel(emoji: "🚶", text: context.l10n.withdrawal_cope_maintain_activity).toJson(),
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_cope_breathing_exercises).toJson()
    ],
  ),

  // Day 8 - Week 1-2
  WithdrawalStageModel(
    intensityLevel: 2,
    timeAfterQuitting: context.l10n.timeline_duration_week_1_2,
    whatHappens: [
      EmojiTextModel(emoji: "🩸", text: context.l10n.withdrawal_happens_circulation_15).toJson(),
      EmojiTextModel(emoji: "😮‍💨", text: context.l10n.withdrawal_happens_easier_breathing).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_fog_clears).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌊", text: context.l10n.withdrawal_symptom_weaker_cravings).toJson(),
      EmojiTextModel(emoji: "😌", text: context.l10n.withdrawal_symptom_better_mood).toJson(),
      EmojiTextModel(emoji: "💭", text: context.l10n.withdrawal_symptom_clearer_thinking).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📝", text: context.l10n.withdrawal_cope_stick_quit_plan).toJson(),
      EmojiTextModel(emoji: "🎁", text: context.l10n.withdrawal_cope_reward_progress).toJson(),
      EmojiTextModel(emoji: "🚫", text: context.l10n.withdrawal_cope_avoid_triggers).toJson()
    ],
  ),

  // Day 14 - 2 Weeks
  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: context.l10n.timeline_duration_2_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_lung_function_5).toJson(),
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_happens_exercise_easier).toJson(),
      EmojiTextModel(emoji: "😊", text: context.l10n.withdrawal_happens_mood_stabilizes).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😮‍💨", text: context.l10n.withdrawal_symptom_better_breathing).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_more_energy).toJson(),
      EmojiTextModel(emoji: "😌", text: context.l10n.withdrawal_symptom_stable_emotions).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: context.l10n.withdrawal_cope_incorporate_exercise).toJson(),
      EmojiTextModel(emoji: "🚶‍♂️", text: context.l10n.withdrawal_cope_longer_walks).toJson(),
      EmojiTextModel(emoji: "🥗", text: context.l10n.withdrawal_cope_nutritious_eating).toJson()
    ],
  ),

  // Day 18 - 2.5 Weeks
  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: context.l10n.timeline_duration_2_5_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_rapid_cilia_regrowth).toJson(),
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_happens_self_cleaning_starts).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_happens_stamina_up).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_symptom_exercise_easier).toJson(),
      EmojiTextModel(emoji: "😊", text: context.l10n.withdrawal_symptom_positive_mood).toJson(),
      EmojiTextModel(emoji: "💤", text: context.l10n.withdrawal_symptom_better_sleep).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📅", text: context.l10n.withdrawal_cope_healthy_routines).toJson(),
      EmojiTextModel(emoji: "🧘‍♂️", text: context.l10n.withdrawal_cope_daily_mindfulness).toJson(),
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_cope_fitness_goals).toJson()
    ],
  ),

  // Day 21 - 3 Weeks
  WithdrawalStageModel(
    intensityLevel: 3,
    timeAfterQuitting: context.l10n.timeline_duration_3_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_receptors_50).toJson(),
      EmojiTextModel(emoji: "😌", text: context.l10n.withdrawal_happens_less_anxiety).toJson(),
      EmojiTextModel(emoji: "🔋", text: context.l10n.withdrawal_happens_energy_boost).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "😌", text: context.l10n.withdrawal_symptom_emotional_stability).toJson(),
      EmojiTextModel(emoji: "💭", text: context.l10n.withdrawal_symptom_mental_clarity).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_symptom_all_day_energy).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📚", text: context.l10n.withdrawal_cope_learn_skills).toJson(),
      EmojiTextModel(emoji: "👥", text: context.l10n.withdrawal_cope_social_connections).toJson(),
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_cope_celebrate_3weeks).toJson()
    ],
  ),

  // Day 28 - 4 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: context.l10n.timeline_duration_4_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_capacity_15).toJson(),
      EmojiTextModel(emoji: "💓", text: context.l10n.withdrawal_happens_bp_stabilizes).toJson(),
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_happens_cravings_fade).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🧊", text: context.l10n.withdrawal_symptom_rare_cravings).toJson(),
      EmojiTextModel(emoji: "😊", text: context.l10n.withdrawal_symptom_stable_mood).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_more_strength).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🥗", text: context.l10n.withdrawal_cope_healthy_eating).toJson(),
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_cope_celebrate_milestone).toJson(),
      EmojiTextModel(emoji: "💰", text: context.l10n.withdrawal_cope_track_money).toJson()
    ],
  ),

  // Day 35 - 5 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: context.l10n.timeline_duration_5_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_happens_infection_risk_drops).toJson(),
      EmojiTextModel(emoji: "🏃‍♂️", text: context.l10n.withdrawal_happens_cardio_20).toJson(),
      EmojiTextModel(emoji: "😴", text: context.l10n.withdrawal_happens_better_sleep).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_symptom_more_vibrant).toJson(),
      EmojiTextModel(emoji: "💤", text: context.l10n.withdrawal_symptom_deep_sleep).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_sharp_focus).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: context.l10n.withdrawal_cope_increase_activity).toJson(),
      EmojiTextModel(emoji: "🧘", text: context.l10n.withdrawal_cope_gratitude_meditation).toJson(),
      EmojiTextModel(emoji: "📚", text: context.l10n.withdrawal_cope_pursue_learning).toJson()
    ],
  ),

  // Day 42 - 6 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: context.l10n.timeline_duration_6_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "👃", text: context.l10n.withdrawal_happens_sinuses_clear).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_happens_strength_up).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_happens_energy_doubles).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_symptom_peak_vitality_energy).toJson(),
      EmojiTextModel(emoji: "😴", text: context.l10n.withdrawal_symptom_excellent_sleep_quality).toJson(),
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_symptom_exercise_feels_effortless).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_cope_ambitious_fitness).toJson(),
      EmojiTextModel(emoji: "👥", text: context.l10n.withdrawal_cope_active_communities).toJson(),
      EmojiTextModel(emoji: "📈", text: context.l10n.withdrawal_cope_track_improvements).toJson()
    ],
  ),

  // Day 50 - 7 Weeks
  WithdrawalStageModel(
    intensityLevel: 4,
    timeAfterQuitting: context.l10n.timeline_duration_7_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_function_25).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_sharp_focus).toJson(),
      EmojiTextModel(emoji: "🔥", text: context.l10n.withdrawal_happens_optimal_metabolism).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💭", text: context.l10n.withdrawal_symptom_crystal_clear_thinking).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_symptom_sustained_high_energy).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_peak_physical_condition).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_cope_challenge_goals).toJson(),
      EmojiTextModel(emoji: "📝", text: context.l10n.withdrawal_cope_document_transformation).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_inspire_others).toJson()
    ],
  ),

  // Day 56 - 8 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: context.l10n.timeline_duration_8_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🩸", text: context.l10n.withdrawal_happens_peak_oxygen_delivery).toJson(),
      EmojiTextModel(emoji: "💓", text: context.l10n.withdrawal_happens_heart_30).toJson(),
      EmojiTextModel(emoji: "😊", text: context.l10n.withdrawal_happens_mood_optimal).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_symptom_athletic_performance_surpasses).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_enhanced_cognitive_function).toJson(),
      EmojiTextModel(emoji: "😌", text: context.l10n.withdrawal_symptom_emotional_equilibrium).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_cope_physical_challenges).toJson(),
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_cope_long_term_health).toJson(),
      EmojiTextModel(emoji: "👥", text: context.l10n.withdrawal_cope_share_success).toJson()
    ],
  ),

  // Day 65 - 9-10 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: context.l10n.timeline_duration_9_10_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_happens_athletic_baseline).toJson(),
      EmojiTextModel(emoji: "🛡️", text: context.l10n.withdrawal_happens_strong_immunity).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_happens_better_skin).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_exceptional_physical_stamina).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_peak_mental_clarity).toJson(),
      EmojiTextModel(emoji: "✨", text: context.l10n.withdrawal_symptom_visible_health_transformation).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📊", text: context.l10n.withdrawal_cope_monitor_health).toJson(),
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_cope_celebrate_transformation).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_maintain_momentum).toJson()
    ],
  ),

  // Day 75 - 10-11 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: context.l10n.timeline_duration_10_11_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_cilia_70_restored).toJson(),
      EmojiTextModel(emoji: "😮‍💨", text: context.l10n.withdrawal_happens_no_breathlessness).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_peak_clarity).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_symptom_perfect_breathing_capacity).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_symptom_unlimited_energy_reserves).toJson(),
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_symptom_laser_sharp_focus).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: context.l10n.withdrawal_cope_enjoy_abilities).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_quit_advocate).toJson(),
      EmojiTextModel(emoji: "📝", text: context.l10n.withdrawal_cope_journal_journey).toJson()
    ],
  ),

  // Day 84 - 12 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: context.l10n.timeline_duration_12_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_happens_peak_muscle_oxygen).toJson(),
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_happens_full_lung_cleaning).toJson(),
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_happens_optimal_cognition).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_symptom_peak_physical_performance).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_optimal_brain_function).toJson(),
      EmojiTextModel(emoji: "💎", text: context.l10n.withdrawal_symptom_perfect_health_status).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_cope_celebrate_3months).toJson(),
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_cope_plan_long_term).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_maintain_peak).toJson()
    ],
  ),

  // Day 95 - 13-14 Weeks
  WithdrawalStageModel(
    intensityLevel: 5,
    timeAfterQuitting: context.l10n.timeline_duration_13_14_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_function_40).toJson(),
      EmojiTextModel(emoji: "❤️", text: context.l10n.withdrawal_happens_low_heart_risk).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_happens_sustained_energy).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_symptom_elite_athletic_performance).toJson(),
      EmojiTextModel(emoji: "💓", text: context.l10n.withdrawal_symptom_optimal_heart_health).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_symptom_radiant_vitality).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_cope_push_limits).toJson(),
      EmojiTextModel(emoji: "📈", text: context.l10n.withdrawal_cope_track_health).toJson(),
      EmojiTextModel(emoji: "👥", text: context.l10n.withdrawal_cope_mentor_quitters).toJson()
    ],
  ),

  // Day 105 - 15 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_15_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🛡️", text: context.l10n.withdrawal_happens_optimal_white_cells).toJson(),
      EmojiTextModel(emoji: "🏃‍♀️", text: context.l10n.withdrawal_happens_fast_recovery).toJson(),
      EmojiTextModel(emoji: "😴", text: context.l10n.withdrawal_happens_deep_sleep).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_fast_recovery).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_better_cognition).toJson(),
      EmojiTextModel(emoji: "✨", text: context.l10n.withdrawal_symptom_full_vitality).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏃‍♀️", text: context.l10n.withdrawal_cope_superhuman_abilities).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_inspire_success).toJson(),
      EmojiTextModel(emoji: "📝", text: context.l10n.withdrawal_cope_document_complete).toJson()
    ],
  ),

  // Day 112 - 16 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_16_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_happens_athletic_breathing).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_happens_full_neurotransmitters).toJson(),
      EmojiTextModel(emoji: "💎", text: context.l10n.withdrawal_happens_peak_repair).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_symptom_athletic_performance).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_symptom_unlimited_energy).toJson(),
      EmojiTextModel(emoji: "🧬", text: context.l10n.withdrawal_symptom_optimal_cells).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_cope_ambitious_life).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_challenge_limits).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_live_best_life).toJson()
    ],
  ),

  // Day 126 - 18 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_18_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_capacity_45).toJson(),
      EmojiTextModel(emoji: "🔋", text: context.l10n.withdrawal_happens_optimal_mitochondria).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_happens_visible_transformation).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "✨", text: context.l10n.withdrawal_symptom_radiant_health).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_peak_condition).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_optimal_brain).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "📸", text: context.l10n.withdrawal_cope_document_visual).toJson(),
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_cope_celebrate_new_self).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_maintain_excellence).toJson()
    ],
  ),

  // Day 140 - 20 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_20_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "💓", text: context.l10n.withdrawal_happens_peak_heart_efficiency).toJson(),
      EmojiTextModel(emoji: "🏃", text: context.l10n.withdrawal_happens_max_vo2).toJson(),
      EmojiTextModel(emoji: "🧬", text: context.l10n.withdrawal_happens_dna_repair_boost).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "❤️", text: context.l10n.withdrawal_symptom_perfect_heart_health).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_symptom_limitless_energy).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_symptom_cell_regeneration).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_cope_achieve_dreams).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_push_boundaries).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_inspire_others_general).toJson()
    ],
  ),

  // Day 154 - 22 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_22_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_cilia_90_normal).toJson(),
      EmojiTextModel(emoji: "🛡️", text: context.l10n.withdrawal_happens_max_infection_resistance).toJson(),
      EmojiTextModel(emoji: "⚡", text: context.l10n.withdrawal_happens_no_crashes).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_ultimate_resilience).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_peak_mental).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_symptom_optimal_health).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎯", text: context.l10n.withdrawal_cope_lifetime_goals).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_maintain_performance).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_role_model).toJson()
    ],
  ),

  // Day 168 - 24 Weeks
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_24_weeks,
    whatHappens: [
      EmojiTextModel(emoji: "🫁", text: context.l10n.withdrawal_happens_function_50).toJson(),
      EmojiTextModel(emoji: "🌬️", text: context.l10n.withdrawal_happens_non_smoker_breathing).toJson(),
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_happens_full_transformation).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "✨", text: context.l10n.withdrawal_symptom_full_restoration).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_symptom_peak_performance).toJson(),
      EmojiTextModel(emoji: "🧠", text: context.l10n.withdrawal_symptom_optimal_cognition).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_cope_celebrate_complete).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_embrace_new_life).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_maintain_forever).toJson()
    ],
  ),

  // Day 180 - 6 Months
  WithdrawalStageModel(
    intensityLevel: 6,
    timeAfterQuitting: context.l10n.timeline_duration_6_months,
    whatHappens: [
      EmojiTextModel(emoji: "✨", text: context.l10n.withdrawal_happens_complete_restoration).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_happens_peak_performance).toJson(),
      EmojiTextModel(emoji: "🎉", text: context.l10n.withdrawal_happens_major_milestone).toJson()
    ],
    symptoms: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_symptom_ultimate_milestone).toJson(),
      EmojiTextModel(emoji: "💎", text: context.l10n.withdrawal_symptom_optimal_health).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_symptom_best_life).toJson()
    ],
    howToCope: [
      EmojiTextModel(emoji: "🏆", text: context.l10n.withdrawal_cope_incredible_achievement).toJson(),
      EmojiTextModel(emoji: "🌟", text: context.l10n.withdrawal_cope_smoke_free_future).toJson(),
      EmojiTextModel(emoji: "💪", text: context.l10n.withdrawal_cope_healthy_lifestyle).toJson()
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
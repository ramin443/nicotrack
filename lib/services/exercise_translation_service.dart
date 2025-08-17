import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../extensions/app_localizations_extension.dart';

/// Service to provide translated exercise content for UI components
/// Since ExerciseModel cannot directly access context.l10n, this service
/// bridges the gap between model data and localized content
class ExerciseTranslationService {
  
  /// Get translated exercise title
  static String getTitle(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return context.l10n.exercise_1_title;
      case '2': return context.l10n.exercise_2_title;
      case '3': return context.l10n.exercise_3_title;
      case '4': return context.l10n.exercise_4_title;
      case '5': return context.l10n.exercise_5_title;
      case '6': return context.l10n.exercise_6_title;
      case '7': return context.l10n.exercise_7_title;
      case '8': return context.l10n.exercise_8_title;
      case '9': return context.l10n.exercise_9_title;
      case '10': return context.l10n.exercise_10_title;
      case '11': return context.l10n.exercise_11_title;
      case '12': return context.l10n.exercise_12_title;
      case '13': return context.l10n.exercise_13_title;
      case '14': return context.l10n.exercise_14_title;
      case '15': return context.l10n.exercise_15_title;
      case '16': return context.l10n.exercise_16_title;
      case '17': return context.l10n.exercise_17_title;
      case '18': return context.l10n.exercise_18_title;
      case '19': return context.l10n.exercise_19_title;
      case '20': return context.l10n.exercise_20_title;
      default: return 'Exercise';
    }
  }

  /// Get translated exercise duration
  static String getDuration(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return context.l10n.exercise_1_duration;
      case '2': return context.l10n.exercise_2_duration;
      case '3': return context.l10n.exercise_3_duration;
      case '4': return context.l10n.exercise_4_duration;
      case '5': return context.l10n.exercise_5_duration;
      case '6': return context.l10n.exercise_6_duration;
      case '7': return context.l10n.exercise_7_duration;
      case '8': return context.l10n.exercise_8_duration;
      case '9': return context.l10n.exercise_9_duration;
      case '10': return context.l10n.exercise_10_duration;
      case '11': return context.l10n.exercise_11_duration;
      case '12': return context.l10n.exercise_12_duration;
      case '13': return context.l10n.exercise_13_duration;
      case '14': return context.l10n.exercise_14_duration;
      case '15': return context.l10n.exercise_15_duration;
      case '16': return context.l10n.exercise_16_duration;
      case '17': return context.l10n.exercise_17_duration;
      case '18': return context.l10n.exercise_18_duration;
      case '19': return context.l10n.exercise_19_duration;
      case '20': return context.l10n.exercise_20_duration;
      default: return '';
    }
  }

  /// Get translated exercise phase
  static String getPhase(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return context.l10n.exercise_1_phase;
      case '2': return context.l10n.exercise_2_phase;
      case '3': return context.l10n.exercise_3_phase;
      case '4': return context.l10n.exercise_4_phase;
      case '5': return context.l10n.exercise_5_phase;
      case '6': return context.l10n.exercise_6_phase;
      case '7': return context.l10n.exercise_7_phase;
      case '8': return context.l10n.exercise_8_phase;
      case '9': return context.l10n.exercise_9_phase;
      case '10': return context.l10n.exercise_10_phase;
      case '11': return context.l10n.exercise_11_phase;
      case '12': return context.l10n.exercise_12_phase;
      case '13': return context.l10n.exercise_13_phase;
      case '14': return context.l10n.exercise_14_phase;
      case '15': return context.l10n.exercise_15_phase;
      case '16': return context.l10n.exercise_16_phase;
      case '17': return context.l10n.exercise_17_phase;
      case '18': return context.l10n.exercise_18_phase;
      case '19': return context.l10n.exercise_19_phase;
      case '20': return context.l10n.exercise_20_phase;
      default: return '';
    }
  }

  /// Get translated exercise description
  static String getDescription(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return context.l10n.exercise_1_description;
      case '2': return context.l10n.exercise_2_description;
      case '3': return context.l10n.exercise_3_description;
      case '4': return context.l10n.exercise_4_description;
      case '5': return context.l10n.exercise_5_description;
      case '6': return context.l10n.exercise_6_description;
      case '7': return context.l10n.exercise_7_description;
      case '8': return context.l10n.exercise_8_description;
      case '9': return context.l10n.exercise_9_description;
      case '10': return context.l10n.exercise_10_description;
      case '11': return context.l10n.exercise_11_description;
      case '12': return context.l10n.exercise_12_description;
      case '13': return context.l10n.exercise_13_description;
      case '14': return context.l10n.exercise_14_description;
      case '15': return context.l10n.exercise_15_description;
      case '16': return context.l10n.exercise_16_description;
      case '17': return context.l10n.exercise_17_description;
      case '18': return context.l10n.exercise_18_description;
      case '19': return context.l10n.exercise_19_description;
      case '20': return context.l10n.exercise_20_description;
      default: return '';
    }
  }

  /// Get translated science explanation
  static String getScience(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return context.l10n.exercise_1_science;
      case '2': return context.l10n.exercise_2_science;
      case '3': return context.l10n.exercise_3_science;
      case '4': return context.l10n.exercise_4_science;
      case '5': return context.l10n.exercise_5_science;
      case '6': return context.l10n.exercise_6_science;
      case '7': return context.l10n.exercise_7_science;
      case '8': return context.l10n.exercise_8_science;
      case '9': return context.l10n.exercise_9_science;
      case '10': return context.l10n.exercise_10_science;
      case '11': return context.l10n.exercise_11_science;
      case '12': return context.l10n.exercise_12_science;
      case '13': return context.l10n.exercise_13_science;
      case '14': return context.l10n.exercise_14_science;
      case '15': return context.l10n.exercise_15_science;
      case '16': return context.l10n.exercise_16_science;
      case '17': return context.l10n.exercise_17_science;
      case '18': return context.l10n.exercise_18_science;
      case '19': return context.l10n.exercise_19_science;
      case '20': return context.l10n.exercise_20_science;
      default: return '';
    }
  }

  /// Get translated detailed duration
  static String getDetailedDuration(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return context.l10n.exercise_1_detailed_duration;
      case '2': return context.l10n.exercise_2_detailed_duration;
      case '3': return context.l10n.exercise_3_detailed_duration;
      case '4': return context.l10n.exercise_4_detailed_duration;
      case '5': return context.l10n.exercise_5_detailed_duration;
      case '6': return context.l10n.exercise_6_detailed_duration;
      case '7': return context.l10n.exercise_7_detailed_duration;
      case '8': return context.l10n.exercise_8_detailed_duration;
      case '9': return context.l10n.exercise_9_detailed_duration;
      case '10': return context.l10n.exercise_10_detailed_duration;
      case '11': return context.l10n.exercise_11_detailed_duration;
      case '12': return context.l10n.exercise_12_detailed_duration;
      case '13': return context.l10n.exercise_13_detailed_duration;
      case '14': return context.l10n.exercise_14_detailed_duration;
      case '15': return context.l10n.exercise_15_detailed_duration;
      case '16': return context.l10n.exercise_16_detailed_duration;
      case '17': return context.l10n.exercise_17_detailed_duration;
      case '18': return context.l10n.exercise_18_detailed_duration;
      case '19': return context.l10n.exercise_19_detailed_duration;
      case '20': return context.l10n.exercise_20_detailed_duration;
      default: return '';
    }
  }

  /// Get translated preparation steps
  static List<String> getPreparationSteps(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return [
        context.l10n.exercise_1_preparation_1,
        context.l10n.exercise_1_preparation_2,
        context.l10n.exercise_1_preparation_3,
      ];
      case '2': return [
        context.l10n.exercise_2_preparation_1,
        context.l10n.exercise_2_preparation_2,
        context.l10n.exercise_2_preparation_3,
      ];
      case '3': return [
        context.l10n.exercise_3_preparation_1,
        context.l10n.exercise_3_preparation_2,
        context.l10n.exercise_3_preparation_3,
      ];
      case '4': return [
        context.l10n.exercise_4_preparation_1,
        context.l10n.exercise_4_preparation_2,
        context.l10n.exercise_4_preparation_3,
      ];
      case '5': return [
        context.l10n.exercise_5_preparation_1,
        context.l10n.exercise_5_preparation_2,
        context.l10n.exercise_5_preparation_3,
      ];
      case '6': return [
        context.l10n.exercise_6_preparation_1,
        context.l10n.exercise_6_preparation_2,
        context.l10n.exercise_6_preparation_3,
      ];
      case '7': return [
        context.l10n.exercise_7_preparation_1,
        context.l10n.exercise_7_preparation_2,
        context.l10n.exercise_7_preparation_3,
      ];
      case '8': return [
        context.l10n.exercise_8_preparation_1,
        context.l10n.exercise_8_preparation_2,
        context.l10n.exercise_8_preparation_3,
      ];
      case '9': return [
        context.l10n.exercise_9_preparation_1,
        context.l10n.exercise_9_preparation_2,
        context.l10n.exercise_9_preparation_3,
      ];
      case '10': return [
        context.l10n.exercise_10_preparation_1,
        context.l10n.exercise_10_preparation_2,
        context.l10n.exercise_10_preparation_3,
      ];
      case '11': return [
        context.l10n.exercise_11_preparation_1,
        context.l10n.exercise_11_preparation_2,
        context.l10n.exercise_11_preparation_3,
      ];
      case '12': return [
        context.l10n.exercise_12_preparation_1,
        context.l10n.exercise_12_preparation_2,
        context.l10n.exercise_12_preparation_3,
      ];
      case '13': return [
        context.l10n.exercise_13_preparation_1,
        context.l10n.exercise_13_preparation_2,
        context.l10n.exercise_13_preparation_3,
      ];
      case '14': return [
        context.l10n.exercise_14_preparation_1,
        context.l10n.exercise_14_preparation_2,
        context.l10n.exercise_14_preparation_3,
      ];
      case '15': return [
        context.l10n.exercise_15_preparation_1,
        context.l10n.exercise_15_preparation_2,
        context.l10n.exercise_15_preparation_3,
      ];
      case '16': return [
        context.l10n.exercise_16_preparation_1,
        context.l10n.exercise_16_preparation_2,
        context.l10n.exercise_16_preparation_3,
      ];
      case '17': return [
        context.l10n.exercise_17_preparation_1,
        context.l10n.exercise_17_preparation_2,
        context.l10n.exercise_17_preparation_3,
      ];
      case '18': return [
        context.l10n.exercise_18_preparation_1,
        context.l10n.exercise_18_preparation_2,
        context.l10n.exercise_18_preparation_3,
      ];
      case '19': return [
        context.l10n.exercise_19_preparation_1,
        context.l10n.exercise_19_preparation_2,
        context.l10n.exercise_19_preparation_3,
      ];
      case '20': return [
        context.l10n.exercise_20_preparation_1,
        context.l10n.exercise_20_preparation_2,
        context.l10n.exercise_20_preparation_3,
      ];
      default: return [];
    }
  }

  /// Get translated exercise step instructions
  static List<String> getExerciseSteps(BuildContext context, String exerciseId) {
    switch (exerciseId) {
      case '1': return [
        context.l10n.exercise_1_step_1,
        context.l10n.exercise_1_step_2,
        context.l10n.exercise_1_step_3,
      ];
      case '2': return [
        context.l10n.exercise_2_step_1,
        context.l10n.exercise_2_step_2,
        context.l10n.exercise_2_step_3,
        context.l10n.exercise_2_step_4,
      ];
      case '3': return [
        context.l10n.exercise_3_step_1,
        context.l10n.exercise_3_step_2,
        context.l10n.exercise_3_step_3,
        context.l10n.exercise_3_step_4,
      ];
      case '4': return [
        context.l10n.exercise_4_step_1,
        context.l10n.exercise_4_step_2,
        context.l10n.exercise_4_step_3,
        context.l10n.exercise_4_step_4,
        context.l10n.exercise_4_step_5,
      ];
      case '5': return [
        context.l10n.exercise_5_step_1,
        context.l10n.exercise_5_step_2,
        context.l10n.exercise_5_step_3,
        context.l10n.exercise_5_step_4,
        context.l10n.exercise_5_step_5,
        context.l10n.exercise_5_step_6,
        context.l10n.exercise_5_step_7,
        context.l10n.exercise_5_step_8,
        context.l10n.exercise_5_step_9,
        context.l10n.exercise_5_step_10,
        context.l10n.exercise_5_step_11,
        context.l10n.exercise_5_step_12,
        context.l10n.exercise_5_step_13,
        context.l10n.exercise_5_step_14,
      ];
      case '6': return [
        context.l10n.exercise_6_step_1,
        context.l10n.exercise_6_step_2,
        context.l10n.exercise_6_step_3,
      ];
      case '7': return [
        context.l10n.exercise_7_step_1,
        context.l10n.exercise_7_step_2,
        context.l10n.exercise_7_step_3,
      ];
      case '8': return [
        context.l10n.exercise_8_step_1,
        context.l10n.exercise_8_step_2,
        context.l10n.exercise_8_step_3,
        context.l10n.exercise_8_step_4,
      ];
      case '9': return [
        context.l10n.exercise_9_step_1,
        context.l10n.exercise_9_step_2,
        context.l10n.exercise_9_step_3,
        context.l10n.exercise_9_step_4,
      ];
      case '10': return [
        context.l10n.exercise_10_step_1,
        context.l10n.exercise_10_step_2,
        context.l10n.exercise_10_step_3,
        context.l10n.exercise_10_step_4,
      ];
      case '11': return [
        context.l10n.exercise_11_step_1,
        context.l10n.exercise_11_step_2,
        context.l10n.exercise_11_step_3,
        context.l10n.exercise_11_step_4,
        context.l10n.exercise_11_step_5,
        context.l10n.exercise_11_step_6,
      ];
      case '12': return [
        context.l10n.exercise_12_step_1,
        context.l10n.exercise_12_step_2,
      ];
      case '13': return [
        context.l10n.exercise_13_step_1,
        context.l10n.exercise_13_step_2,
        context.l10n.exercise_13_step_3,
        context.l10n.exercise_13_step_4,
      ];
      case '14': return [
        context.l10n.exercise_14_step_1,
        context.l10n.exercise_14_step_2,
        context.l10n.exercise_14_step_3,
        context.l10n.exercise_14_step_4,
        context.l10n.exercise_14_step_5,
      ];
      case '15': return [
        context.l10n.exercise_15_step_1,
        context.l10n.exercise_15_step_2,
        context.l10n.exercise_15_step_3,
        context.l10n.exercise_15_step_4,
        context.l10n.exercise_15_step_5,
        context.l10n.exercise_15_step_6,
      ];
      case '16': return [
        context.l10n.exercise_16_step_1,
        context.l10n.exercise_16_step_2,
        context.l10n.exercise_16_step_3,
        context.l10n.exercise_16_step_4,
      ];
      case '17': return [
        context.l10n.exercise_17_step_1,
        context.l10n.exercise_17_step_2,
      ];
      case '18': return [
        context.l10n.exercise_18_step_1,
        context.l10n.exercise_18_step_2,
        context.l10n.exercise_18_step_3,
        context.l10n.exercise_18_step_4,
      ];
      case '19': return [
        context.l10n.exercise_19_step_1,
        context.l10n.exercise_19_step_2,
        context.l10n.exercise_19_step_3,
        context.l10n.exercise_19_step_4,
      ];
      case '20': return [
        context.l10n.exercise_20_step_1,
        context.l10n.exercise_20_step_2,
        context.l10n.exercise_20_step_3,
        context.l10n.exercise_20_step_4,
        context.l10n.exercise_20_step_5,
      ];
      default: return [];
    }
  }

  /// Convenience method to get all translated content for an exercise
  static ExerciseTranslatedContent getTranslatedContent(BuildContext context, ExerciseModel exercise) {
    return ExerciseTranslatedContent(
      title: getTitle(context, exercise.id),
      duration: getDuration(context, exercise.id),
      phase: getPhase(context, exercise.id),
      description: getDescription(context, exercise.id),
      science: getScience(context, exercise.id),
      detailedDuration: getDetailedDuration(context, exercise.id),
      preparationSteps: getPreparationSteps(context, exercise.id),
      exerciseSteps: getExerciseSteps(context, exercise.id),
      // Keep original non-translatable fields
      icon: exercise.icon,
      timerType: exercise.timerType,
      exerciseStepsWithDuration: exercise.exerciseSteps, // For duration data
    );
  }
}

/// Translated content for an exercise
class ExerciseTranslatedContent {
  final String title;
  final String duration;
  final String phase;
  final String description;
  final String science;
  final String detailedDuration;
  final List<String> preparationSteps;
  final List<String> exerciseSteps;
  
  // Non-translatable fields from original model
  final String icon;
  final ExerciseTimerType timerType;
  final List<ExerciseStep> exerciseStepsWithDuration;

  ExerciseTranslatedContent({
    required this.title,
    required this.duration,
    required this.phase,
    required this.description,
    required this.science,
    required this.detailedDuration,
    required this.preparationSteps,
    required this.exerciseSteps,
    required this.icon,
    required this.timerType,
    required this.exerciseStepsWithDuration,
  });
}
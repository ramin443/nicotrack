class ExerciseModel {
  final String id;
  final String title;
  final String icon;
  final String duration;
  final String phase;
  final String description;
  final String science;
  final String detailedDuration;
  final List<String> preparationSteps;
  final List<ExerciseStep> exerciseSteps;
  final ExerciseTimerType timerType;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.duration,
    required this.phase,
    required this.description,
    required this.science,
    required this.detailedDuration,
    required this.preparationSteps,
    required this.exerciseSteps,
    required this.timerType,
  });
}

class ExerciseStep {
  final String instruction;
  final int durationSeconds;
  final String? visualCue;

  ExerciseStep({
    required this.instruction,
    required this.durationSeconds,
    this.visualCue,
  });
}

enum ExerciseTimerType {
  cycle,
  countdown,
  selfPaced,
  segmented,
  twoPhase,
}

final List<ExerciseModel> allExercises = [
  ExerciseModel(
    id: '1',
    title: 'The 4-7-8 Technique',
    icon: '💨',
    duration: '2-3 min',
    phase: 'Phase 1',
    description: 'A powerful breathing technique that calms your nervous system by controlling your breath in a specific pattern.',
    science: 'Activates the parasympathetic nervous system, reducing stress hormones and promoting relaxation.',
    detailedDuration: '4-6 cycles (approximately 2-3 minutes)',
    preparationSteps: [
      'Find a comfortable seated position',
      'Place the tip of your tongue behind your upper front teeth',
      'Exhale completely through your mouth',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Breathe in through your nose', durationSeconds: 4),
      ExerciseStep(instruction: 'Hold your breath', durationSeconds: 7),
      ExerciseStep(instruction: 'Exhale through your mouth', durationSeconds: 8),
    ],
    timerType: ExerciseTimerType.cycle,
  ),
  ExerciseModel(
    id: '2',
    title: 'Cold Water Shock',
    icon: '🌊',
    duration: '60 sec',
    phase: 'Phase 1',
    description: 'Use cold water to trigger your vagus nerve and interrupt craving pathways instantly.',
    science: 'Triggers the vagus nerve response, interrupting the neural pathway of cravings and providing immediate relief.',
    detailedDuration: '60 seconds total',
    preparationSteps: [
      'Get a glass of ice-cold water ready',
      'Have a towel nearby if splashing face',
      'Take a moment to focus on the present',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Take a sip of ice-cold water and hold it in your mouth', durationSeconds: 10),
      ExerciseStep(instruction: 'Swallow slowly and feel the cold sensation', durationSeconds: 5),
      ExerciseStep(instruction: 'Splash cold water on your face or wrists', durationSeconds: 15),
      ExerciseStep(instruction: 'Take deep breaths and notice the refreshing feeling', durationSeconds: 30),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '3',
    title: 'The 3-Minute Rule',
    icon: '⌛',
    duration: '3 min',
    phase: 'Phase 1',
    description: 'Wait out the craving peak with focused awareness. Most cravings naturally decrease after 3 minutes.',
    science: 'Cravings follow a predictable pattern, peaking and then naturally decreasing after the initial dopamine spike.',
    detailedDuration: '3 minutes countdown',
    preparationSteps: [
      'Acknowledge the craving without judgment',
      'Set your intention to wait it out',
      'Find something to focus on during the wait',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Notice and accept the craving', durationSeconds: 30),
      ExerciseStep(instruction: 'Focus on your breathing', durationSeconds: 60),
      ExerciseStep(instruction: 'Observe the craving intensity changing', durationSeconds: 60),
      ExerciseStep(instruction: 'Notice the craving weakening', durationSeconds: 30),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '4',
    title: '5-4-3-2-1 Grounding',
    icon: '🔍',
    duration: '2-3 min',
    phase: 'Phase 1',
    description: 'Ground yourself in the present moment using all five senses to disrupt craving thoughts.',
    science: 'Engages the prefrontal cortex and disrupts the limbic system\'s craving response through sensory awareness.',
    detailedDuration: 'Self-paced (approximately 2-3 minutes)',
    preparationSteps: [
      'Look around your environment',
      'Take a comfortable position',
      'Prepare to engage all your senses',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Name 5 things you can see', durationSeconds: 30),
      ExerciseStep(instruction: 'Name 4 things you can touch', durationSeconds: 30),
      ExerciseStep(instruction: 'Name 3 things you can hear', durationSeconds: 30),
      ExerciseStep(instruction: 'Name 2 things you can smell', durationSeconds: 30),
      ExerciseStep(instruction: 'Name 1 thing you can taste', durationSeconds: 30),
    ],
    timerType: ExerciseTimerType.selfPaced,
  ),
  ExerciseModel(
    id: '5',
    title: 'Muscle Relaxation (PMR)',
    icon: '💆',
    duration: '8-10 min',
    phase: 'Phase 2',
    description: 'Systematically tense and release muscle groups from toes to face for deep relaxation.',
    science: 'Reduces cortisol levels and activates GABA neurotransmitters, promoting physical and mental relaxation.',
    detailedDuration: '8-10 minutes for full body scan',
    preparationSteps: [
      'Lie down or sit comfortably',
      'Close your eyes or soften your gaze',
      'Take three deep breaths to begin',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Tense your toes and feet', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax your feet', durationSeconds: 10),
      ExerciseStep(instruction: 'Tense your calves', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax your calves', durationSeconds: 10),
      ExerciseStep(instruction: 'Tense your thighs', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax your thighs', durationSeconds: 10),
      ExerciseStep(instruction: 'Tense your abdomen', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax your abdomen', durationSeconds: 10),
      ExerciseStep(instruction: 'Tense your arms', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax your arms', durationSeconds: 10),
      ExerciseStep(instruction: 'Tense your shoulders', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax your shoulders', durationSeconds: 10),
      ExerciseStep(instruction: 'Tense your face', durationSeconds: 10),
      ExerciseStep(instruction: 'Release and relax completely', durationSeconds: 30),
    ],
    timerType: ExerciseTimerType.segmented,
  ),
  ExerciseModel(
    id: '6',
    title: 'Bilateral Stimulation',
    icon: '🔍',
    duration: '2-3 min',
    phase: 'Phase 2',
    description: 'Cross your arms and tap alternating shoulders, or march in place to activate both brain hemispheres.',
    science: 'Activates both brain hemispheres simultaneously, similar to EMDR therapy effects, reducing emotional intensity.',
    detailedDuration: '2-3 minutes of alternating movement',
    preparationSteps: [
      'Stand or sit comfortably',
      'Cross your arms over your chest',
      'Prepare for rhythmic movement',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Tap your right shoulder with left hand', durationSeconds: 2),
      ExerciseStep(instruction: 'Tap your left shoulder with right hand', durationSeconds: 2),
      ExerciseStep(instruction: 'Continue alternating taps rhythmically', durationSeconds: 120),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '7',
    title: 'Finger Pressure Points',
    icon: '👈',
    duration: '60 sec',
    phase: 'Phase 2',
    description: 'Apply firm pressure between your thumb and index finger to stimulate acupressure points.',
    science: 'Stimulates the LI4 acupoint, releasing endorphins and reducing stress-related cravings.',
    detailedDuration: '60 seconds of sustained pressure',
    preparationSteps: [
      'Locate the webbing between thumb and index finger',
      'Prepare to apply firm but comfortable pressure',
      'Breathe normally throughout',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Apply firm pressure to the point', durationSeconds: 20),
      ExerciseStep(instruction: 'Maintain steady pressure', durationSeconds: 20),
      ExerciseStep(instruction: 'Gently massage in circles', durationSeconds: 20),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '8',
    title: 'Rapid distraction',
    icon: '⚡',
    duration: '60 sec',
    phase: 'Phase 2',
    description: 'A quick physical reset: STOP what you\'re doing, DROP your shoulders, and ROLL them back.',
    science: 'Physical movement interrupts automatic behavior circuits and releases tension instantly.',
    detailedDuration: '30 seconds quick routine',
    preparationSteps: [
      'Stand or sit up straight',
      'Notice any tension in your shoulders',
      'Prepare for quick movements',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'STOP - Freeze your current position', durationSeconds: 5),
      ExerciseStep(instruction: 'DROP - Let your shoulders fall', durationSeconds: 5),
      ExerciseStep(instruction: 'ROLL - Roll shoulders backward 3 times', durationSeconds: 10),
      ExerciseStep(instruction: 'Take a deep breath and reset', durationSeconds: 10),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '9',
    title: 'Stop-Drop-Roll',
    icon: '🔄',
    duration: '30 sec',
    phase: 'Phase 2',
    description: 'A quick physical reset: STOP what you\'re doing, DROP your shoulders, and ROLL them back.',
    science: 'Physical movement interrupts automatic behavior circuits and releases tension instantly.',
    detailedDuration: '30 seconds quick routine',
    preparationSteps: [
      'Stand or sit up straight',
      'Notice any tension in your shoulders',
      'Prepare for quick movements',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'STOP - Freeze your current position', durationSeconds: 5),
      ExerciseStep(instruction: 'DROP - Let your shoulders fall', durationSeconds: 5),
      ExerciseStep(instruction: 'ROLL - Roll shoulders backward 3 times', durationSeconds: 10),
      ExerciseStep(instruction: 'Take a deep breath and reset', durationSeconds: 10),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '10',
    title: 'Rapid Eye Movement',
    icon: '👀',
    duration: '1-2 min',
    phase: 'Phase 3',
    description: 'Move your eyes rapidly in different directions to disrupt focused craving thoughts.',
    science: 'Disrupts focused craving thoughts and reduces intrusive thinking through eye movement desensitization.',
    detailedDuration: '40 movements total (10 in each direction)',
    preparationSteps: [
      'Sit comfortably with head still',
      'Keep your head facing forward',
      'Move only your eyes',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Look far left 10 times', durationSeconds: 20),
      ExerciseStep(instruction: 'Look far right 10 times', durationSeconds: 20),
      ExerciseStep(instruction: 'Look up 10 times', durationSeconds: 20),
      ExerciseStep(instruction: 'Look down 10 times', durationSeconds: 20),
    ],
    timerType: ExerciseTimerType.segmented,
  ),
  ExerciseModel(
    id: '11',
    title: 'Lemon Visualization',
    icon: '🍋',
    duration: '2-3 min',
    phase: 'Phase 3',
    description: 'Vividly imagine biting into a sour lemon to activate taste centers and override cravings.',
    science: 'Activates taste centers in the brain, crowding out nicotine craving signals through sensory imagination.',
    detailedDuration: '2-3 minutes guided visualization',
    preparationSteps: [
      'Close your eyes or soften your gaze',
      'Take a comfortable seated position',
      'Prepare to engage your imagination',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Imagine holding a bright yellow lemon', durationSeconds: 30),
      ExerciseStep(instruction: 'Picture cutting it in half', durationSeconds: 20),
      ExerciseStep(instruction: 'Imagine bringing it to your mouth', durationSeconds: 20),
      ExerciseStep(instruction: 'Feel the sour juice on your tongue', durationSeconds: 30),
      ExerciseStep(instruction: 'Notice your mouth watering', durationSeconds: 20),
      ExerciseStep(instruction: 'Let the sensation fade gradually', durationSeconds: 30),
    ],
    timerType: ExerciseTimerType.countdown,
  ),
  ExerciseModel(
    id: '12',
    title: 'Hand Warming',
    icon: '🤲',
    duration: '1 min',
    phase: 'Phase 3',
    description: 'Rub your hands together vigorously, then place them on your cheeks for warmth and comfort.',
    science: 'Increases blood flow and reduces stress-induced vasoconstriction, promoting relaxation.',
    detailedDuration: '1 minute (30 seconds each phase)',
    preparationSteps: [
      'Sit or stand comfortably',
      'Remove any rings if wearing',
      'Prepare for vigorous movement',
    ],
    exerciseSteps: [
      ExerciseStep(instruction: 'Rub hands together vigorously', durationSeconds: 30),
      ExerciseStep(instruction: 'Place warm hands on your cheeks', durationSeconds: 30),
    ],
    timerType: ExerciseTimerType.twoPhase,
  ),
];
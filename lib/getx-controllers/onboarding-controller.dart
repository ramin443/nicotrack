import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/choose-language.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/cost-of-pack.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/last-smoke.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/smoke-frequency.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/one-pack-contents.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/biggest-motivation.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/crave-situations.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/help-need.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import 'package:flutter/services.dart';
import 'package:nicotrack/models/emoji-Text-Pair.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/enter-name.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/manage-notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/notification-service.dart';
import '../models/notifications-preferences-model/notificationsPreferences-model.dart';
import '../models/onboarding-data/onboardingData-model.dart';
import '../services/firebase-service.dart';
import '../screens/base/base.dart';
import 'package:hive/hive.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';

class OnboardingController extends GetxController {
  List<Widget> pages = [
    ChooseLanguage(),
    LastSmoked(),
    SmokeFrequency(),
    CostofPack(),
    OnePackContents(),
    BiggestMotivation(),
    CraveSituations(),
    HelpNeed(),
    // QuitMethod(),
    EnterName(),
    ManageNotifications(),
  ];
  final PageController pageController = PageController();
  int currentPage = 0;
  bool currentPageDoneStatus = false;

  OnboardingData onboardingFilledData = OnboardingData();

  //Page 2 variables - Cigarette frequency
  int selectedNumber1 = 2; // Default selected number
  FixedExtentScrollController listWheelController1 =
      FixedExtentScrollController(initialItem: 1);
  final List<int> numbers = List.generate(15, (index) => index + 1); // 1 to 15

  //Page 3 variables - Cigarette frequency
  late FixedExtentScrollController dollarController;
  late FixedExtentScrollController centController;
  int selectedDollar = 3;
  int selectedCent = 0;
  List<int> dollars = List.generate(100, (index) => index); // 0 to 100
  List<int> cents = List.generate(100, (index) => index); // 0 to 99

  //Page 4 variables - Cigarette frequency
  int selectedNumber2 = 5; // Default selected number
  late FixedExtentScrollController listWheelController2;
  final List<int> packNumbers =
      List.generate(20, (index) => index + 1); // 1 to 15

  //Page 5 variables - Cigarette frequency
  List<int> selectedMotivationIndex = [];
  List<String> selectedMotivations = [];
  
  // Dynamic method to build motivation pairs with localization
  List<EmojiTextPair> getMotivationPairs(BuildContext context) {
    return [
      EmojiTextPair(emoji: heartEmoji, text: context.l10n.motivation_health),
      EmojiTextPair(emoji: cashEmoji, text: context.l10n.motivation_money),
      EmojiTextPair(emoji: crownEmoji, text: context.l10n.motivation_challenge),
      EmojiTextPair(emoji: peopleEmoji, text: context.l10n.motivation_family),
      EmojiTextPair(emoji: xmarkEmoji, text: context.l10n.motivation_addiction),
      EmojiTextPair(emoji: rocketEmoji, text: context.l10n.motivation_other),
    ];
  }

  //Page 6 variables - Cigarette frequency
  List<int> selectedcravingsIndex = [];
  
  // Dynamic method to build crave situation pairs with localization
  List<EmojiTextPair> getCraveSituationPairs(BuildContext context) {
    return [
      EmojiTextPair(emoji: coffeeEmoji, text: context.l10n.craving_coffee),
      EmojiTextPair(emoji: platesEmoji, text: context.l10n.craving_meals),
      EmojiTextPair(emoji: beerEmoji, text: context.l10n.craving_alcohol),
      EmojiTextPair(emoji: stressedEmoji, text: context.l10n.craving_stress),
      EmojiTextPair(emoji: homeEmoji, text: context.l10n.craving_boredom),
      EmojiTextPair(emoji: othersEmoji, text: context.l10n.craving_other),
    ];
  }

  //Page 0 variables - Language selection
  int selectedLanguageIndex = 0;
  int rememberedLanguageIndex = 0; // Store user's selection during onboarding
  late FixedExtentScrollController languageController;
  
  final List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇧🇷'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'},
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
    {'code': 'nl', 'name': 'Dutch', 'flag': '🇳🇱'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'},
    {'code': 'cs', 'name': 'Czech', 'flag': '🇨🇿'},
    {'code': 'el', 'name': 'Greek', 'flag': '🇬🇷'},
    {'code': 'he', 'name': 'Hebrew', 'flag': '🇮🇱'},
    {'code': 'hu', 'name': 'Hungarian', 'flag': '🇭🇺'},
    {'code': 'id', 'name': 'Indonesian', 'flag': '🇮🇩'},
    {'code': 'pl', 'name': 'Polish', 'flag': '🇵🇱'},
    {'code': 'ro', 'name': 'Romanian', 'flag': '🇷🇴'},
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'},
    {'code': 'tr', 'name': 'Turkish', 'flag': '🇹🇷'},
  ];

  //Page 8 variables - Help needed
  List<int> selectedHelpIndex = [];
  
  // Dynamic method to build help pairs with localization
  List<EmojiTextPair> getHelpPairs(BuildContext context) {
    return [
      EmojiTextPair(emoji: brainsoutEmoji, text: context.l10n.help_cravings),
      EmojiTextPair(emoji: mountainEmoji, text: context.l10n.help_plan),
      EmojiTextPair(emoji: celebrateEmoji, text: context.l10n.help_support),
      EmojiTextPair(emoji: badge1Emoji, text: context.l10n.help_tracking),
    ];
  }

  //Page 8 variables - Cigarette frequency
  int instantQuitSelected = 0;

  //Page 1 variables - Last smoke date selection
  int selectedLastSmokeOption = -1; // 0: Today, 1: Yesterday, 2: Custom
  DateTime selectedCustomDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    // Initialize language controller with default position
    languageController = FixedExtentScrollController(initialItem: selectedLanguageIndex);
  }



  void goToNextPage(int page) {
    currentPage = page;
    update();
  }

  void nextPage() {
    // Handle language selection on page 0
    if (currentPage == 0) {
      // Remember the user's selection for when they come back
      rememberedLanguageIndex = selectedLanguageIndex;
      
      // Save the selected language to app preferences
      final selectedLanguage = supportedLanguages[selectedLanguageIndex];
      final appPrefsController = Get.find<AppPreferencesController>();
      appPrefsController.updateLanguage(
        selectedLanguage['code']!,
        selectedLanguage['name']!,
      );
    }
    
    // Unfocus keyboard when leaving the name input page (page 8)
    if (currentPage == 8) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    
    // Move to the next page
    if (currentPage < pages.length - 1) {
      // Log onboarding step completed
      final stepNames = ["language_selection", "last_smoke_date", "cigarettes_per_day", "cost_per_pack", "pack_contents", "motivation", "crave_situations", "help_needed", "user_name"];
      if (currentPage < stepNames.length) {
        FirebaseService().logOnboardingStepCompleted(
          stepNumber: currentPage + 1,
          stepName: stepNames[currentPage],
        );
      }
      
      currentPage++;
      getCurrentPageStatus();
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    // Move to the previouslanguage page
    if (currentPage > 0) {
      currentPage--;
      
      // If going back to language selection page, restore the remembered selection
      if (currentPage == 0) {
        selectedLanguageIndex = rememberedLanguageIndex;
        // Update the picker to show the remembered language selection after the page transition
        Future.delayed(Duration(milliseconds: 200), () {
          languageController.animateToItem(
            selectedLanguageIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
      
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget topSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        width: 315.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: ((currentPage) / pages.length) * 315.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: nicotrackBlack1,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainDisplay() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: pages.length,
        onPageChanged: (int page) {
          goToNextPage(page);
        },
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(key: ValueKey<int>(index), child: pages[index]));
        },
      ),
    );
  }

  Widget getLastSmokedDate() {
    return Builder(builder: (context) {
      List<Map<String, dynamic>> options = [
        {'text': context.l10n.today, 'emoji': '📅'},
        {'text': context.l10n.yesterday, 'emoji': '⏮️'},
        {'text': context.l10n.custom_date, 'emoji': '🗓️'},
      ];

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            for (int i = 0; i < options.length; i++)
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      selectedLastSmokeOption = i;
                      
                      String formattedDate;
                      if (i == 0) { // Today
                        formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      } else if (i == 1) { // Yesterday
                        formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
                      } else { // Custom date
                        DateTime? pickedDate = await _showCustomDatePicker(context);
                        if (pickedDate != null) {
                          selectedCustomDate = pickedDate;
                          formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        } else {
                          selectedLastSmokeOption = -1;
                          update();
                          return;
                        }
                      }
                      
                      onboardingFilledData = onboardingFilledData.copyWith(lastSmokedDate: formattedDate);
                      getCurrentPageStatus();
                      update();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: double.infinity,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: selectedLastSmokeOption == i 
                            ? Colors.deepPurple.shade100 
                            : Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(20.r),
                        border: selectedLastSmokeOption == i
                            ? Border.all(color: Colors.deepPurple, width: 2.5)
                            : Border.all(color: Colors.grey.shade200, width: 1),
                        boxShadow: selectedLastSmokeOption == i
                            ? [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                        child: Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: selectedLastSmokeOption == i 
                                    ? Colors.deepPurple.withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: selectedLastSmokeOption == i 
                                      ? Colors.deepPurple.withOpacity(0.3)
                                      : Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  options[i]['emoji'],
                                  style: TextStyle(fontSize: 24.sp),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: TextAutoSize(
                                (i == 2 && selectedLastSmokeOption == 2) 
                                    ? DateFormat('MMM dd, yyyy').format(selectedCustomDate)
                                    : options[i]['text'],
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontFamily: circularMedium,
                                  color: selectedLastSmokeOption == i 
                                      ? Colors.deepPurple.shade700
                                      : nicotrackBlack1,
                                  fontWeight: selectedLastSmokeOption == i 
                                      ? FontWeight.w600 
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (selectedLastSmokeOption == i)
                              Container(
                                width: 24.w,
                                height: 24.w,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (i < options.length - 1) SizedBox(height: 12.h),
                ],
              ),
          ],
        ),
      );
    });
  }

  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    DateTime? pickedDate;
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 350.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              TextAutoSize(
                "Select Date",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedCustomDate,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    HapticFeedback.lightImpact();
                    pickedDate = newDateTime;
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: TextAutoSize(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pickedDate == null) {
                          pickedDate = selectedCustomDate;
                        }
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: nicotrackBlack1,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: TextAutoSize(
                            "Confirm",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularMedium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    
    return pickedDate;
  }

  Widget cigarreteFrequencyScroll() {
    return // Number Picker
        SizedBox(
      height: 300.h,
      child: ListWheelScrollView.useDelegate(
        controller: listWheelController1,
        itemExtent: 120,

        // Spacing between items
        perspective: 0.005,
        diameterRatio: 5.0,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          HapticFeedback.mediumImpact();
          selectedNumber1 = numbers[index];
          onboardingFilledData =
              onboardingFilledData.copyWith(cigarettesPerDay: numbers[index]);
          getCurrentPageStatus();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = selectedNumber1 == numbers[index];

            return AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                  fontSize: 86.sp,
                  fontFamily: circularBold,
                  color: isSelected
                      ? nicotrackPurple
                      : nicotrackPurple.withOpacity(0.3)),
              child: Center(child: Text(numbers[index].toString())),
            );
          },
          childCount: numbers.length,
        ),
      ),
    );
  }

  Widget cigarreteFrequencyPack() {
    return // Number Picker
        SizedBox(
      height: 300.h,
      child: ListWheelScrollView.useDelegate(
        controller: listWheelController2,
        itemExtent: 120,
        // Spacing between items
        perspective: 0.005,
        diameterRatio: 5.0,
        physics: BouncingScrollPhysics(),
        onSelectedItemChanged: (index) {
          HapticFeedback.mediumImpact();
          selectedNumber2 = packNumbers[index];
          onboardingFilledData = onboardingFilledData.copyWith(
              numberOfCigarettesIn1Pack: packNumbers[index]);
          getCurrentPageStatus();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = selectedNumber2 == packNumbers[index];

            return AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                  fontSize: 86.sp,
                  fontFamily: circularBold,
                  color: isSelected
                      ? nicotrackPurple
                      : nicotrackPurple.withOpacity(0.3)),
              child: Center(child: Text(packNumbers[index].toString())),
            );
          },
          childCount: packNumbers.length,
        ),
      ),
    );
  }

  Widget biggestMotivationGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        child: Builder(
          builder: (context) {
            final motivationPairs = getMotivationPairs(context);
            return GridView.builder(
              itemCount: motivationPairs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 9.w,
                mainAxisSpacing: 9.w,
                childAspectRatio: 1, // Adjusts box shape
              ),
              itemBuilder: (context, index) {
                bool isSelected = selectedMotivationIndex.contains(index);

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (selectedMotivationIndex.contains(index)) {
                      selectedMotivationIndex.remove(index);
                      onboardingFilledData = onboardingFilledData.copyWith(
                          biggestMotivation: onboardingFilledData.biggestMotivation
                              .where((e) => e != motivationPairs[index].text)
                              .toList());
                    } else {
                      selectedMotivationIndex.add(index);
                      onboardingFilledData = onboardingFilledData.copyWith(
                          biggestMotivation: [
                            ...onboardingFilledData.biggestMotivation,
                            motivationPairs[index].text
                          ]);
                    }
                    getCurrentPageStatus();
                  },
                  child: AnimatedContainer(
                    height: 176.h,
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: Colors.deepPurple, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          motivationPairs[index].emoji,
                          width: 54.w,
                        ),
                        SizedBox(height: 18.h),
                        SizedBox(
                          width: 138.w,
                          child: TextAutoSize(
                            motivationPairs[index].text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: circularMedium,
                                color: nicotrackBlack1),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget cravingsGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Builder(
          builder: (context) {
            final craveSituationPairs = getCraveSituationPairs(context);
            return GridView.builder(
              itemCount: craveSituationPairs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 9.w,
                mainAxisSpacing: 9.w,
                childAspectRatio: 1, // Adjusts box shape
              ),
              itemBuilder: (context, index) {
            bool isSelected = selectedcravingsIndex.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedcravingsIndex.contains(index)) {
                  selectedcravingsIndex.remove(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      craveSituations: onboardingFilledData.craveSituations
                          .where((e) => e != craveSituationPairs[index].text)
                          .toList());
                } else {
                  selectedcravingsIndex.add(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      craveSituations: [
                        ...onboardingFilledData.craveSituations,
                        craveSituationPairs[index].text
                      ]);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: Colors.deepPurple, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      craveSituationPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                        width: 120.w,
                        child: TextAutoSize(
                          craveSituationPairs[index].text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1),
                        )),
                  ],
                ),
              ),
            );
          },
        );
          },
        ),
      ),
    );
  }

  Widget helpGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Builder(
          builder: (context) {
            final helpPairs = getHelpPairs(context);
            return GridView.builder(
              itemCount: helpPairs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 9.w,
                mainAxisSpacing: 9.w,
                childAspectRatio: 1, // Adjusts box shape
              ),
              itemBuilder: (context, index) {
            bool isSelected = selectedHelpIndex.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedHelpIndex.contains(index)) {
                  selectedHelpIndex.remove(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      helpNeeded: onboardingFilledData.helpNeeded
                          .where((e) => e != helpPairs[index].text)
                          .toList());
                } else {
                  selectedHelpIndex.add(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      helpNeeded: [
                        ...onboardingFilledData.helpNeeded,
                        helpPairs[index].text
                      ]);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: Colors.deepPurple, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      helpPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                        width: 120.w,
                        child: TextAutoSize(
                          helpPairs[index].text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1),
                        )),
                  ],
                ),
              ),
            );
          },
        );
          },
        ),
      ),
    );
  }

  Widget pricePackPicker() {
    return // Dollar Picker UI
        SizedBox(
      height: 328.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Sign - Fixed
          TextAutoSize(
            Get.find<AppPreferencesController>().currencySymbol,
            style: TextStyle(
              fontSize: 86.sp,
              fontFamily: circularBold,
              color: Color(0xffF35E5C),
            ),
          ),

          SizedBox(width: 10),

          // Dollar Value Scroll
          SizedBox(
            width: 110.w,
            height: 328.h,
            child: ListWheelScrollView.useDelegate(
              controller: dollarController,
              itemExtent: 120.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedDollar = dollars[index];
                String dollarValue = "$selectedDollar.$selectedCent";
                onboardingFilledData =
                    onboardingFilledData.copyWith(costOfAPack: dollarValue);
                getCurrentPageStatus();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: dollars.length,
                builder: (context, index) {
                  bool isSelected = selectedDollar == dollars[index];
                  return Center(
                    child: TextAutoSize(
                      dollars[index].toString(),
                      style: TextStyle(
                        fontSize: 86.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dot
          TextAutoSize(
            ".",
            style: TextStyle(
                fontSize: 86.sp,
                fontFamily: circularBold,
                color: Color(0xffF35E5C)),
          ),

          // Cents Scroll
          SizedBox(
            width: 110.w,
            height: 328.h,
            child: ListWheelScrollView.useDelegate(
              controller: centController,
              itemExtent: 120.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedCent = cents[index];
                String dollarValue = "$selectedDollar.$selectedCent";
                onboardingFilledData =
                    onboardingFilledData.copyWith(costOfAPack: dollarValue);
                getCurrentPageStatus();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: cents.length,
                builder: (context, index) {
                  bool isSelected = selectedCent == cents[index];
                  String display = cents[index].toString().padLeft(2, '0');
                  return Center(
                    child: TextAutoSize(
                      display,
                      style: TextStyle(
                        fontSize: isSelected ? 86.sp : 86.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quitMethodSelection() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Builder(
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      instantQuitSelected = 1;
                      onboardingFilledData =
                          onboardingFilledData.copyWith(quitMethod: 1);
                      update();
                    },
                    child: Container(
                      width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(16.r),
                        image: instantQuitSelected == 1
                            ? DecorationImage(
                                image: AssetImage(
                                    quitMethodBG), // Replace with your image path
                                fit: BoxFit
                                    .cover, // You can also use BoxFit.fill, BoxFit.contain, etc.
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            instantQuitEmoji,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          TextAutoSize(
                            context.l10n.instant_quit,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          SizedBox(
                            width: 130.w,
                            child: TextAutoSize(
                              context.l10n.instant_quit_description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                height: 1.2,
                                fontFamily: circularMedium,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      ),
                    ))),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      instantQuitSelected = 2;
                      update();
                    },
                    child: Container(
                      // width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          image: instantQuitSelected == 2
                              ? DecorationImage(
                                  image: AssetImage(
                                      quitMethodBG), // Replace with your image path
                                  fit: BoxFit
                                      .cover, // You can also use BoxFit.fill, BoxFit.contain, etc.
                                )
                              : null,
                          borderRadius: BorderRadius.circular(16.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            stepdownEmoji,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          TextAutoSize(
                            context.l10n.stepdown_method,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          SizedBox(
                            width: 130.w,
                            child: TextAutoSize(
                              context.l10n.stepdown_description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                height: 1.2,
                                fontFamily: circularMedium,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      ),
                    ))),
              ],
            );
          }
        ));
  }

  Widget nameTextField() {
    return TextField(
      maxLines: 2,
      onChanged: (v) {
        onboardingFilledData = onboardingFilledData.copyWith(name: v);
        getCurrentPageStatus();
      },
      decoration: InputDecoration(
        hintText: "Jane Wilson",
        hintStyle: TextStyle(
          fontFamily: circularBold,
          color: nicotrackPurple.withOpacity(0.21),
          fontSize: 48.sp,
        ),
        border: InputBorder.none,
        isDense: true,
        // Reduces vertical padding
        contentPadding: EdgeInsets.zero, // Optional: aligns with container edge
      ),
      cursorColor: nicotrackBlack1,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: circularBold,
        fontSize: 48.sp,
        color: nicotrackPurple,
      ),
    );
  }

  // Method to complete onboarding
  Future<void> completeOnboarding(BuildContext context) async {
    // Log onboarding completion analytics
    FirebaseService().logOnboardingCompleted(
      lastSmokedDate: onboardingFilledData.lastSmokedDate,
      cigarettesPerDay: onboardingFilledData.cigarettesPerDay,
      costPerPack: onboardingFilledData.costOfAPack,
      motivations: onboardingFilledData.biggestMotivation,
      craveSituations: onboardingFilledData.craveSituations,
      helpNeeded: onboardingFilledData.helpNeeded,
      userName: onboardingFilledData.name,
    );
    
    final box = Hive.box<OnboardingData>('onboardingCompletedData');
    await box.put('currentUserOnboarding', onboardingFilledData);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Base(),
        ),
        (route) => false);
  }

  // Method to complete onboarding without notifications (skip case)
  Future<void> completeOnboardingSkipNotifications(BuildContext context) async {
    // Save preferences indicating user skipped notifications
    await saveNotificationPreferences(false);
    
    // Complete normal onboarding flow
    await completeOnboarding(context);
  }

  // Method to handle notification permission request
  Future<void> requestNotificationPermission(BuildContext context) async {
    try {
      print('🔔 Requesting notification permission via onboarding...');
      
      // Use NotificationService to request permissions - this will now show the dialog
      final notificationService = NotificationService();
      bool granted = await notificationService.requestPermissions();
      print('🔔 Permission request result: $granted');
      
      if (granted) {
        print('🔔 Permission granted! Initializing notifications...');
        // Initialize notifications if permission granted
        await notificationService.initialize();
        
        // Save notification preferences to indicate permission was granted
        await saveNotificationPreferences(true);
        print('🔔 Notification preferences saved successfully');
      } else {
        print('🔔 Permission denied');
        
        // Save preferences indicating permission was denied
        await saveNotificationPreferences(false);
      }
      
      // Complete onboarding regardless of permission result
      await completeOnboarding(context);
    } catch (e) {
      print('🔔 Error requesting notification permission: $e');
      // Save preferences indicating there was an error (assume denied)
      await saveNotificationPreferences(false);
      // Still complete onboarding even if there's an error
      await completeOnboarding(context);
    }
  }

  // Method to save notification preferences
  Future<void> saveNotificationPreferences(bool permissionGranted) async {
    try {
      final notificationsBox = Hive.box<NotificationsPreferencesModel>('notificationsPreferencesData');
      
      // Create default notification preferences
      NotificationsPreferencesModel notificationPrefs = NotificationsPreferencesModel(
        pushNotificationsActivated: permissionGranted,
        manuallyDisabled: false, // User hasn't manually disabled
        dailyReminderHour: 8,
        dailyReminderMinute: 0,
        dailyReminderPeriod: " AM",
        morningReminderHour: 8,
        morningReminderMinute: 0,
        morningReminderPeriod: " AM",
        eveningReminderHour: 8,
        eveningReminderMinute: 0,
        eveningReminderPeriod: " PM",
        weeklyReminderDay: "Monday",
        weeklyReminderHour: 6,
        weeklyReminderMinute: 0,
        weeklyReminderPeriod: " PM",
      );
      
      await notificationsBox.put('currentUserNotificationPrefs', notificationPrefs);
      print('📱 Saved notification preferences: permissionGranted=$permissionGranted');
    } catch (e) {
      print('Error saving notification preferences: $e');
    }
  }

  Widget continueButton(BuildContext context) {
    // Special handling for notifications page (last page)
    if (currentPage == pages.length - 1) {
      return Column(
        children: [
          // Allow notifications button
          GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await requestNotificationPermission(context);
            },
            child: Container(
              width: 346.w,
              height: 54.h,
              decoration: BoxDecoration(
                color: nicotrackBlack1,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: TextAutoSize(
                  context.l10n.manage_notifications_allow_button,
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularMedium,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Skip for now button
          GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await completeOnboardingSkipNotifications(context);
            },
            child: TextAutoSize(
              context.l10n.manage_notifications_skip_button,
              style: TextStyle(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1.withOpacity(0.7)),
            ),
          ),
        ],
      );
    }
    
    // Standard continue button for other pages
    return GestureDetector(
      onTap: () async{

        if (currentPageDoneStatus) {
          HapticFeedback.mediumImpact();
          nextPage();
        }
      },
      child: Container(
        width: 346.w,
        height: 54.h,
        decoration: BoxDecoration(
          color: currentPageDoneStatus
              ? nicotrackBlack1
              : nicotrackButtonLightBlack,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: TextAutoSize(
            context.l10n.continueButton,
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: circularMedium,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool currentPageCompleted() {
    switch (currentPage) {
      case 0:
        if (selectedLastSmokeOption != -1 && onboardingFilledData.lastSmokedDate != "") {
          return true;
        } else {
          return false;
        }
      case 1:
        if (onboardingFilledData.cigarettesPerDay != -1) {
          return true;
        } else {
          return false;
        }
      case 2:
        if (onboardingFilledData.costOfAPack != "") {
          return true;
        } else {
          return false;
        }
      case 3:
        if (onboardingFilledData.numberOfCigarettesIn1Pack != -1) {
          return true;
        } else {
          return false;
        }
      case 4:
        if (onboardingFilledData.biggestMotivation != []) {
          return true;
        } else {
          return false;
        }
      case 5:
        if (onboardingFilledData.craveSituations != []) {
          return true;
        } else {
          return false;
        }
      case 6:
        if (onboardingFilledData.helpNeeded != []) {
          return true;
        } else {
          return false;
        }
      case 7:
        if (onboardingFilledData.name != "") {
          return true;
        } else {
          return false;
        }
      default:
        return false;
    }
  }

  void getCurrentPageStatus() {
    switch (currentPage) {
      case 0:
        // Language selection - always enabled since it has a default selection
        currentPageDoneStatus = true;
      case 1:
        if (selectedLastSmokeOption != -1 && onboardingFilledData.lastSmokedDate != "") {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 2:
        if (onboardingFilledData.cigarettesPerDay != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 3:
        if (onboardingFilledData.costOfAPack != "") {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 4:
        if (onboardingFilledData.numberOfCigarettesIn1Pack != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 5:
        if (onboardingFilledData.biggestMotivation.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 6:
        if (onboardingFilledData.craveSituations.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 7:
        if (onboardingFilledData.helpNeeded.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 8:
        if (onboardingFilledData.name != "") {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 9:
        // Notifications page - always skip the standard validation
        currentPageDoneStatus = true;
      default:
        currentPageDoneStatus = false;
    }
    update();
  }
}
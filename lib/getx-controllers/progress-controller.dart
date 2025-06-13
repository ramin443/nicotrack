import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-cravings.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-health.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-milestones.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-overview.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-savings.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';
import 'package:nicotrack/screens/base/progress-subpages/bottom-sheets/progress-financial-goal.dart';
import 'package:nicotrack/screens/base/progress-subpages/bottom-sheets/progress-view-edit-goal.dart';
import 'package:hive/hive.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/services.dart';

import '../constants/color-constants.dart';
import '../constants/dummy-data-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';

class ProgressController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  final ScrollController tabScrollController = ScrollController();
  final PageController healthScrollViewController =
      PageController(viewportFraction: 0.75);
  final PageController upcominghealthscrollController =
      PageController(viewportFraction: 0.75);
  final PageController cravingFeelingsScrollController =
      PageController(viewportFraction: 0.75);
  final PageController avoidCravingsScrollController =
      PageController(viewportFraction: 0.75);
  final PageController topTriggersScrollController =
      PageController(viewportFraction: 0.75);
  final PageController symptomsHealedScrollController =
      PageController(viewportFraction: 0.75);
  final PageController financialGoalsScrollController =
      PageController(viewportFraction: 0.75);
  final ScrollController dailyStreakScrollController = ScrollController();

  // Financial Goals Variables (copied from SettingsController)
  List<FinancialGoalsModel> userFinancialGoals = [];
  String selectedEmoji = '😐';
  TextEditingController goalTitleController = TextEditingController();
  int selectedFinGoalDollar = 150;
  int selectedFinGoalCent = 25;
  bool isFinGoalSet = false;
  late FixedExtentScrollController finGoaldollarController;
  late FixedExtentScrollController finGoalcentController;
  List<int> finGoaldollars = List.generate(101, (index) => index * 10); // 0 to 1000
  List<int> finGoalcents = List.generate(100, (index) => index); // 0 to 99


  final List<Map<String, String>> tabs = [
    {"label": "Overview", "emoji": "📋"},
    {"label": "Health", "emoji": "🧠"},
    {"label": "Savings", "emoji": "🪙"},
    {"label": "Cravings", "emoji": "🤤"},
    {"label": "Milestones", "emoji": "🏆"},
  ];

  final List<Map<String, String>> moodHistory = [
    {"date": "April 27, 2025", "emoji": "📋"},
    {"date": "April 26, 2025", "emoji": "🧠"},
    {"date": "April 24, 2025", "emoji": "🪙"},
    {"date": "April 23, 2025", "emoji": "🤤"},
    {"date": "April 22, 2025", "emoji": "🏆"},
  ];
  List<Widget> allprogressTabs = [
    ProgressOverview(),
    ProgressHealth(),
    ProgressSavings(),
    ProgressCravings(),
    ProgressMilestones()
  ];

  @override
  void onInit() {
    super.onInit();
    loadFinancialGoalsFromHive();
    
    // Initialize FixedExtentScrollControllers
    finGoaldollarController = FixedExtentScrollController(initialItem: 15); // Default to $150
    finGoalcentController = FixedExtentScrollController(initialItem: 25); // Default to 25 cents
  }

  Widget mainDisplayCards() {
    DateTime now = DateTime.now();
    int daysSinceLastSmoked = getDaysSinceLastSmoked(now);
    double moneySaved = getMoneySaved(now);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.w,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: 1.58,
        children: [
          mainCard(
            emoji: bicepsEmoji,
            value: daysSinceLastSmoked,
            label: 'Days since\nlast smoked',
            backgroundColor: const Color(0xFFB0F0A1),
            isCost: false, // green-ish background
          ),
          statCard(
            emoji: moneyEmoji,
            value: moneySaved.round(),
            label: 'Money saved',
            isCost: true,
          ),
        ],
      ),
    );
  }

  Widget savingsDisplayCards() {
    DateTime now = DateTime.now();
    int daysSinceLastSmoked = getDaysSinceLastSmoked(now);
    double moneySaved = getMoneySaved(now);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.w,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: 1.58,
        children: [
          mainCard(
            emoji: moneyEmoji,
            value: moneySaved.round(),
            label: 'Money saved',
            backgroundColor: const Color(0xFFB0F0A1),
            isCost: true, // green-ish background
          ),
          statCard(
            emoji: bicepsEmoji,
            value: daysSinceLastSmoked,
            label: 'Days since\nlast smoked',
            isCost: false,
          ),
        ],
      ),
    );
  }

  Widget progressTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: tabScrollController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          final isSelected = tabController.index == index;
          return GestureDetector(
            onTap: () {
              tabController.animateTo(index);

              // Scroll to the tapped tab's position
              final tabWidth =
                  140.w; // Approximate tab width (adjust if needed)
              double targetOffset = (tabWidth + 8.w) * index - 34.w;

              if (targetOffset < 0) targetOffset = 0;
              if (targetOffset > tabScrollController.position.maxScrollExtent) {
                targetOffset = tabScrollController.position.maxScrollExtent;
              }

              tabScrollController.animateTo(
                targetOffset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );

              update(); // Rebuild to update active tab
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: index == 0 ? 16.w : 0,
                  right: index == tabs.length - 1 ? 16.w : 0),
              padding: EdgeInsets.only(
                  right: 16.w, left: 8.w, top: 16.h, bottom: 16.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Row(
                children: [
                  TextAutoSize(
                    '  ${tabs[index]["emoji"]!}',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: isSelected ? Colors.white : nicotrackBlack1),
                  ),
                  SizedBox(width: 6.w),
                  TextAutoSize(
                    tabs[index]["label"]!,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: isSelected ? Colors.white : nicotrackBlack1),
                  ),
                  SizedBox(width: 2.w),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget progressTabContent2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        allprogressTabs[tabController.index], // Only show current tab content
      ],
    );
  }

  Widget progressTabContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: MediaQuery.of(context)
              .size
              .height, // or a custom calculated height
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: List.generate(tabs.length, (index) {
              return Center(
                child: Column(
                  children: [allprogressTabs[index]],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget moodTrend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: Color(0xffFF9900)),
                    children: [
                  TextSpan(text: '🌤️️ Mood '),
                  TextSpan(
                      text: 'trend',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: nicotrackBlack1,
                      )),
                ])),
          ],
        ),
      ],
    );
  }

  // Financial Goals Methods (copied from SettingsController)

  // Convert user financial goals to EmojiTextModel for display
  List<EmojiTextModel> getUserFinancialGoalsAsEmojiTextList() {
    return userFinancialGoals.map((goal) => 
      EmojiTextModel(
        emoji: goal.emoji, 
        text: goal.goalTitle
      )
    ).toList();
  }

  // Calculate individual completion percentage for each financial goal
  List<int> getIndividualFinancialGoalsCompletionPercentages() {
    if (userFinancialGoals.isEmpty) return [];
    
    DateTime now = DateTime.now();
    double moneySaved = getMoneySaved(now);
    
    return userFinancialGoals.map((goal) {
      double percentage = (moneySaved / goal.cost) * 100;
      return percentage.clamp(0, 100).toInt();
    }).toList();
  }

  // Calculate average completion percentage for all financial goals
  int getAverageFinancialGoalsCompletionPercentage() {
    if (userFinancialGoals.isEmpty) return 0;
    
    DateTime now = DateTime.now();
    double moneySaved = getMoneySaved(now);
    
    double totalPercentage = 0;
    for (var goal in userFinancialGoals) {
      double percentage = (moneySaved / goal.cost) * 100;
      totalPercentage += percentage.clamp(0, 100);
    }
    
    return (totalPercentage / userFinancialGoals.length).round();
  }

  // Check if current financial goal form is valid
  bool isFinancialGoalFormValid() {
    return selectedEmoji.isNotEmpty && 
           goalTitleController.text.trim().isNotEmpty && 
           isFinGoalSet;
  }

  // Add new financial goal
  void addNewFinancialGoal() async {
    if (!isFinancialGoalFormValid()) return;
    
    try {
      // Create new financial goal
      FinancialGoalsModel newGoal = FinancialGoalsModel(
        emoji: selectedEmoji,
        goalTitle: goalTitleController.text.trim(),
        cost: double.parse('$selectedFinGoalDollar.$selectedFinGoalCent'),
      );
      
      // Add to beginning of list
      userFinancialGoals.insert(0, newGoal);
      
      // Save to Hive
      await saveFinancialGoalsToHive();
      
      // Reset form
      resetFinancialGoalForm();
      
      update();
    } catch (e) {
      print('Error adding financial goal: $e');
    }
  }

  // Update existing financial goal
  void updateFinancialGoal(int index) async {
    if (!isFinancialGoalFormValid() || index >= userFinancialGoals.length) return;
    
    try {
      // Create updated financial goal
      FinancialGoalsModel updatedGoal = FinancialGoalsModel(
        emoji: selectedEmoji,
        goalTitle: goalTitleController.text.trim(),
        cost: double.parse('$selectedFinGoalDollar.$selectedFinGoalCent'),
      );
      
      // Update in list
      userFinancialGoals[index] = updatedGoal;
      
      // Save to Hive
      await saveFinancialGoalsToHive();
      
      update();
    } catch (e) {
      print('Error updating financial goal: $e');
    }
  }

  // Delete financial goal
  void deleteFinancialGoal(int index) async {
    if (index >= userFinancialGoals.length) return;
    
    try {
      // Remove from list
      userFinancialGoals.removeAt(index);
      
      // Save to Hive
      await saveFinancialGoalsToHive();
      
      update();
    } catch (e) {
      print('Error deleting financial goal: $e');
    }
  }

  // Reset the form after adding a goal
  void resetFinancialGoalForm() {
    selectedEmoji = '😐';
    goalTitleController.clear();
    selectedFinGoalDollar = 150;
    selectedFinGoalCent = 25;
    isFinGoalSet = false;
  }

  // Save financial goals to Hive
  Future<void> saveFinancialGoalsToHive() async {
    try {
      // Check if box is open before accessing it
      if (Hive.isBoxOpen('financialGoalsData')) {
        final box = Hive.box<FinancialGoalsModel>('financialGoalsData');
        
        // Clear existing data and add all goals
        await box.clear();
        for (int i = 0; i < userFinancialGoals.length; i++) {
          await box.put('goal_$i', userFinancialGoals[i]);
        }
      } else {
        print('Financial goals box not open, cannot save');
      }
    } catch (e) {
      print('Error saving financial goals: $e');
    }
  }

  // Load financial goals from Hive
  void loadFinancialGoalsFromHive() {
    try {
      // Check if box is open before accessing it
      if (Hive.isBoxOpen('financialGoalsData')) {
        final box = Hive.box<FinancialGoalsModel>('financialGoalsData');
        
        userFinancialGoals.clear();
        for (var goal in box.values) {
          userFinancialGoals.add(goal);
        }
        
        update();
      } else {
        // Try again after a short delay
        Future.delayed(Duration(milliseconds: 100), () {
          loadFinancialGoalsFromHive();
        });
      }
    } catch (e) {
      print('Error loading financial goals: $e');
    }
  }

  void setFinGoalTrue() {
    isFinGoalSet = true;
    update();
  }

  // Show add financial goals bottom sheet
  void showAddFinancialGoalsBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        isScrollControlled: false,
        builder: (context) {
          return ProgressFinancialGoalsBottomSheet();
        });
  }

  // Show view/edit goal bottom sheet
  void showViewEditGoalBottomSheet(BuildContext context, int goalIndex) {
    if (goalIndex >= userFinancialGoals.length) return;
    
    // Pre-populate fields with existing goal data for editing
    selectedEmoji = userFinancialGoals[goalIndex].emoji;
    goalTitleController.text = userFinancialGoals[goalIndex].goalTitle;
    
    // Parse cost back into dollar and cent
    String costString = userFinancialGoals[goalIndex].cost.toStringAsFixed(2);
    List<String> parts = costString.split('.');
    selectedFinGoalDollar = int.parse(parts[0]);
    selectedFinGoalCent = int.parse(parts[1]);
    isFinGoalSet = true;
    
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        isScrollControlled: false,
        builder: (context) {
          return ProgressViewEditGoalBottomSheet(
            goal: userFinancialGoals[goalIndex],
            goalIndex: goalIndex,
          );
        });
  }

  // Show emoji picker
  void showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: false,
      builder: (context) => SizedBox(
        height: 400.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextAutoSize(
                    'Select Emoji',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: nicotrackBlack1,
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  selectedEmoji = emoji.emoji;
                  update();
                  Navigator.pop(context);
                },
                config: Config(
                  height: 256,
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax: 28.sp,
                    backgroundColor: const Color(0xFFF2F2F2),
                  ),
                  skinToneConfig: const SkinToneConfig(
                    enabled: true,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    initCategory: Category.SMILEYS,
                    indicatorColor: nicotrackOrange,
                    iconColor: Colors.grey,
                    iconColorSelected: nicotrackOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show price picker bottom sheet
  void showEditGoalPriceBottomSheet(BuildContext context) {
    // Initialize controllers for price picker
    int dollarIndex = finGoaldollars.indexOf(selectedFinGoalDollar);
    int centIndex = finGoalcents.indexOf(selectedFinGoalCent);
    
    finGoaldollarController = FixedExtentScrollController(
      initialItem: dollarIndex >= 0 ? dollarIndex : 15 // Default to $150
    );
    finGoalcentController = FixedExtentScrollController(
      initialItem: centIndex >= 0 ? centIndex : 25 // Default to 25 cents
    );
    
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        builder: (context) {
          return GetBuilder<ProgressController>(
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.sp),
                child: Column(
                  children: [
                    SizedBox(height: 18.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4.8.w,
                          width: 52.w,
                          decoration: BoxDecoration(
                              color: nicotrackBlack1,
                              borderRadius: BorderRadius.circular(18.r)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                                color: nicotrackOrange.withOpacity(0.2),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.w,
                                color: nicotrackOrange,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setFinGoalTrue();
                                Navigator.of(context).pop();
                              },
                              child: TextAutoSize(
                                'Done',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: circularBook,
                                  color: nicotracklightBlue,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.w),
                    Expanded(child: setPriceAsNeeded()),
                    SizedBox(height: 24.w),
                  ],
                ),
              );
            }
          );
        });
  }

  // Price picker widget
  Widget setPriceAsNeeded() {
    return SizedBox(
      height: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Sign - Fixed
          TextAutoSize(
            "\$",
            style: TextStyle(
              fontSize: 64.sp,
              fontFamily: circularBold,
              color: Color(0xffF35E5C),
            ),
          ),

          // Dollar Value Scroll
          SizedBox(
            width: 120.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: finGoaldollarController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFinGoalDollar = finGoaldollars[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: finGoaldollars.length,
                builder: (context, index) {
                  bool isSelected =
                      selectedFinGoalDollar == finGoaldollars[index];
                  return Center(
                    child: TextAutoSize(
                      finGoaldollars[index].toString(),
                      style: TextStyle(
                        fontSize: 64.sp,
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
                fontSize: 64.sp,
                fontFamily: circularBold,
                color: Color(0xffF35E5C)),
          ),

          // Cents Scroll
          SizedBox(
            width: 90.w,
            height: 240.w,
            child: ListWheelScrollView.useDelegate(
              controller: finGoalcentController,
              itemExtent: 100.w,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedFinGoalCent = finGoalcents[index];
                update();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: finGoalcents.length,
                builder: (context, index) {
                  bool isSelected = selectedFinGoalCent == finGoalcents[index];
                  String display =
                      finGoalcents[index].toString().padLeft(2, '0');
                  return Center(
                    child: TextAutoSize(
                      display,
                      style: TextStyle(
                        fontSize: 64.sp,
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

  Widget financialGoalTextFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    showEmojiPicker(context);
                  },
                  child: Container(
                    height: 76.w,
                    width: 76.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: Center(
                      child: TextAutoSize(
                        selectedEmoji,
                        style: TextStyle(
                          fontSize: 48.sp,
                          letterSpacing: 1.92,
                          fontFamily: circularBook,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showEmojiPicker(context);
                    },
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: nicotracklightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 14.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 18.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextAutoSize(
              'NEW FINANCIAL GOAL',
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.92,
                fontFamily: circularBook,
                color: nicotrackBlack1,
                height: 1.1,
              ),
            ),
          ],
        ),
        TextField(
          controller: goalTitleController,
          cursorColor: nicotrackBlack1,
          onChanged: (value) {
            update(); // Update UI when text changes for validation
          },
          decoration: InputDecoration(
            hintText: 'e.g., Airpods pro ',
            hintStyle: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: Color(0xff454545).withOpacity(0.25),
              height: 1.1,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none, // removes outline
            ),
          ),
          style: TextStyle(
            fontSize: 24.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
            height: 1.1,
          ),
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 30.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextAutoSize(
              'SET THE PRICE',
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.92,
                fontFamily: circularBook,
                color: nicotrackBlack1,
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        GestureDetector(
          onTap: () {
            showEditGoalPriceBottomSheet(context);
          },
          child: TextAutoSize(
            '\$ $selectedFinGoalDollar.$selectedFinGoalCent',
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: isFinGoalSet? nicotrackOrange:Color(0xff454545).withOpacity(0.25),
              height: 1.1,
            ),
          ),
        ),
        Spacer()
      ],
    );
  }
}
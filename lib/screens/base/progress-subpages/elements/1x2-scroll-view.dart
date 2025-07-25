import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';

import '../../../elements/textAutoSize.dart';

class OnexTwoScrollView extends StatefulWidget {
  final ScrollController scrollController;
  final double childAspectRatio;
  final List<EmojiTextModel> items;
  final bool withPercent;
  final int percent;
  final List<int>? percentList;
  final void Function() newfinancialGoalAction;
  final void Function(int)? onItemTap;
  final bool isUserPremium;

  const OnexTwoScrollView({
    super.key,
    required this.scrollController,
    required this.childAspectRatio,
    required this.items,
    required this.withPercent,
    required this.percent,
    required this.newfinancialGoalAction,
    this.onItemTap,
    this.percentList,
    required this.isUserPremium,
  });

  @override
  State<OnexTwoScrollView> createState() => _OnexTwoScrollViewState();
}

class _OnexTwoScrollViewState extends State<OnexTwoScrollView> {
  int currentPage = 0;
  EmojiTextModel addNewGoal = EmojiTextModel(emoji: '🎯', text: 'Add new goal');

  @override
  Widget build(BuildContext context) {
    List<EmojiTextModel> extendedList = [...widget.items, addNewGoal];

    final pages = _chunkItems(extendedList, 4); // 4 items per scroll "page"
    final showIndicator = pages.length > 1;

    return GetBuilder<ProgressController>(
        init: ProgressController(),
        initState: (v) {
          widget.scrollController.addListener(_onScroll);
        },
        builder: (progressController) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SingleChildScrollView(
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pages.map((pageItems) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 rows
                        childAspectRatio: widget.childAspectRatio,
                        crossAxisSpacing: 6.w,
                        mainAxisSpacing: 6.w,
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        final item = pageItems[index];
                        return GestureDetector(
                          onTap: () {
                            if (item.emoji == '🎯' && item.text == 'Add new goal') {
                              // Check if user is premium for "Add new goal"
                              if (!widget.isUserPremium) {
                                // Navigate to premium screen
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const PremiumPaywallScreen();
                                }));
                              } else {
                                widget.newfinancialGoalAction();
                              }
                            } else {
                              // Calculate the actual index in the original items list
                              int actualIndex = widget.items.indexWhere(
                                (originalItem) => originalItem.emoji == item.emoji && originalItem.text == item.text
                              );
                              if (actualIndex != -1 && widget.onItemTap != null) {
                                widget.onItemTap!(actualIndex);
                              }
                            }
                          },
                          child:
                              Stack(
                                children: [
                                  Positioned.fill(child: Container(
                                    padding: EdgeInsets.only(
                                        left: 12.w,
                                        right: 12.w,
                                        top: 16.h,
                                        bottom: 14.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Color(0xfff0f0f0), width: 1.sp),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextAutoSize(
                                          item.emoji,
                                          style: TextStyle(
                                            fontSize: 52.sp,
                                            fontFamily: circularMedium,
                                            height: 1.05,
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        widget.withPercent && !(item.emoji == '🎯' && item.text == 'Add new goal')
                                            ?

                                        Container(
                                            child:RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    style: TextStyle(
                                                      fontSize: 14.5.sp,
                                                      fontFamily: circularMedium,
                                                      height: 1.2,
                                                      color: Colors.black,
                                                    ),
                                                    children: [
                                                      TextSpan(text: "${item.text}: "),
                                                      TextSpan(
                                                        text: "${_getPercentageForItem(item, index)}%",
                                                        style: TextStyle(
                                                          fontSize: 14.5.sp,
                                                          fontFamily: circularBold,
                                                          height: 1.2,
                                                          color: nicotrackGreen,
                                                        ),
                                                      ),
                                                    ])))
                                            : Container(child:TextAutoSize(
                                          item.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.5.sp,
                                            fontFamily: circularMedium,
                                            height: 1.2,
                                            color: Colors.black,
                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),),
                                  // Show lock for "Add new goal" if user is not premium
                                  (item.emoji == '🎯' && item.text == 'Add new goal' && !widget.isUserPremium)
                                      ? Positioned(
                                          top: 10.w,
                                          right: 10.w,
                                          child: smallLockBox(),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              )

                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            if (showIndicator)
              SizedBox(
                height: 12.h,
              ),
            if (showIndicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  final isActive = index == currentPage;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.black : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
          ]);
        });
  }

  List<List<EmojiTextModel>> _chunkItems(
      List<EmojiTextModel> items, int chunkSize) {
    List<List<EmojiTextModel>> chunks = [];
    for (var i = 0; i < items.length; i += chunkSize) {
      chunks.add(items.sublist(i, (i + chunkSize).clamp(0, items.length)));
    }
    return chunks;
  }

  void _onScroll() {
    if (!mounted) return;
    final page =
        (widget.scrollController.offset / MediaQuery.sizeOf(context).width)
            .round();
    if (page != currentPage) {
      setState(() {
        currentPage = page;
      });
    }
  }

  int _getPercentageForItem(EmojiTextModel item, int pageIndex) {
    // If it's the "Add new goal" item, return 0
    if (item.emoji == '🎯' && item.text == 'Add new goal') {
      return 0;
    }
    
    // Find the actual index in the original items list
    int actualIndex = widget.items.indexWhere(
      (originalItem) => originalItem.emoji == item.emoji && originalItem.text == item.text
    );
    
    // Use individual percentages if available, otherwise use the single percent
    if (widget.percentList != null && actualIndex >= 0 && actualIndex < widget.percentList!.length) {
      return widget.percentList![actualIndex];
    }
    
    return widget.percent;
  }
}
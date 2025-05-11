import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';

import '../../../elements/textAutoSize.dart';

class OnexTwoScrollView extends StatefulWidget {
  final ScrollController scrollController;
  final double childAspectRatio;
  final List<EmojiTextModel> items;
  final bool withPercent;
  final int percent;

  const OnexTwoScrollView({
    super.key,
    required this.scrollController,
    required this.childAspectRatio,
    required this.items,
    required this.withPercent,
    required this.percent,
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
          return Column(children: [
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
                        return Container(
                          padding: EdgeInsets.only(
                              left: 12.w, right: 12.w, top: 16.h, bottom: 14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color(0xfff0f0f0), width: 1.sp),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              TextAutoSize(
                                item.emoji,
                                style: TextStyle(
                                  fontSize: 52.sp,
                                  fontFamily: circularMedium,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              widget.withPercent
                                  ? RichText(
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
                                            text: "${widget.percent}%",
                                            style: TextStyle(
                                              fontSize: 14.5.sp,
                                              fontFamily: circularBold,
                                              height: 1.2,
                                              color: nicotrackGreen,
                                            ),
                                          ),
                                        ]))
                                  : TextAutoSize(
                                      item.text,
                                      style: TextStyle(
                                        fontSize: 14.5.sp,
                                        fontFamily: circularMedium,
                                        height: 1.2,
                                        color: Colors.black,
                                      ),
                                    ),
                            ],
                          ),
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
}
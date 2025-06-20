import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';

import '../../../elements/textAutoSize.dart';

class FourxFourAltScrollView extends StatefulWidget {
  final ScrollController scrollController;
  final double childAspectRatio;
  final List<EmojiTextModel> items;

  const FourxFourAltScrollView(
      {super.key,
      required this.scrollController,
      required this.childAspectRatio,
      required this.items});

  @override
  State<FourxFourAltScrollView> createState() => _FourxFourAltScrollViewState();
}

class _FourxFourAltScrollViewState extends State<FourxFourAltScrollView> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final pages = _chunkItems(widget.items, 4); // 4 items per scroll "page"
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
                            color: Color(0xffF4F4F4),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                item.emoji,
                                width: 34.sp,
                                height: 34.sp,
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                // color: Colors.grey,
                                width: 100.w,
                                child: Text(
                                  item.text,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: circularMedium,
                                    height: 1.1,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
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
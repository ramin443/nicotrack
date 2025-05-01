import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/font-constants.dart';
import '../../../../models/emoji-text-pair/emojitext-model.dart';

class SingleRowScrollView extends StatefulWidget {
  final List<EmojiTextModel> items;
  final ScrollController scrollController;
  const SingleRowScrollView({
    super.key,
    required this.items,
    required this.scrollController,
  });

  @override
  State<SingleRowScrollView> createState() => _SingleRowScrollViewState();
}

class _SingleRowScrollViewState extends State<SingleRowScrollView> {
  int _currentPage = 0;
  int _totalPages = 0 ;
  final progressMainController = Get.find<ProgressController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        initState: (v){
          widget.scrollController.addListener(_onScroll);

          // Compute total "pages"
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final screenWidth = MediaQuery.of(context).size.width;
            final visibleItems = (screenWidth / 160.w).floor();
            setState(() {
              _totalPages = (widget.items.length - visibleItems + 1).clamp(1, widget.items.length);
            });
          });
        },
        builder: (progressController) {
          return Column(
            children: [
              SingleChildScrollView(
                controller:  widget.scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.items.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final item = entry.value;

                    final bool isFirst = index == 0;
                    final bool isLast = index == widget.items.length - 1;

                    return Container(
                      margin: EdgeInsets.only(
                        left: isFirst ? 16.w : 0.w,
                        right: isLast ? 16.w : 8.w,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xfff0f0f0), width: 1.sp),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          TextAutoSize(
                            item.emoji,
                            style: TextStyle(
                              fontSize: 38.sp,
                              fontFamily: circularMedium,
                              height: 1.1,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          TextAutoSize(
                            item.text,
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontFamily: circularMedium,
                              height: 1.1,
                              color: Color.fromRGBO(0, 0, 0, 0.76),
                            ),
                          ),
                          SizedBox(width: 3.w),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 12.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalPages, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.black : Colors.black12,
                    ),
                  );
                }),
              ),
            ],
          );
        });
  }
  void _onScroll(){
    if (!mounted) return;
    final offset =  widget.scrollController.offset;
    final pageWidth = 160.w; // approximate card width + margin
    final page = (offset / pageWidth).round();

    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }
}
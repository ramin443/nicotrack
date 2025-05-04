import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/quick-function-constants.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';
import 'package:nicotrack/models/withdrawal-stage-model/withdrawal-stage-model.dart';
import 'package:nicotrack/screens/elements/emoji-grid-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../getx-controllers/plan-controller.dart';

class InfoBottomSheet extends StatefulWidget {
  final WithdrawalStageModel withdrawalStage;

  const InfoBottomSheet({super.key, required this.withdrawalStage});

  @override
  State<InfoBottomSheet> createState() => _InfoBottomSheetState();
}

class _InfoBottomSheetState extends State<InfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanController>(
        init: PlanController(),
        builder: (planController) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: (){
                  planController.setBottomSheetOff();
                  Navigator.of(context).pop();
                },
                child: Container(
                  // color: Colors.black.withOpacity(0.4), // Barrier color
                  color: Colors.transparent, // Barrier color
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r))),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.w,
                        ),
                        Container(
                          width: 52.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(24.r)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                planController.setBottomSheetOff();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 36.w,
                                width: 36.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFF611D).withOpacity(0.20)),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Color(0xffFF611D),
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 24.w,
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              getMountainImagefromIntensity(
                                  widget.withdrawalStage.intensityLevel),
                              width: 86.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.w,
                        ),
                        TextAutoSize(
                          "📅 ${widget.withdrawalStage.timeAfterQuitting}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: nicotrackBlack1,
                          ),
                        ),
                        SizedBox(
                          height: 8.w,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.w),
                          decoration: BoxDecoration(
                            color: Color(0x33FF611D),
                          ),
                          child: TextAutoSize(
                            "Current Stage",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: circularBook,
                              height: 1.1,
                              color: Color(0xffFF611D),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 26.w,
                        ),
                        symptomsSection(),
                        SizedBox(
                          height: 26.w,
                        ),
                        effectsonBodySection(),
                        SizedBox(
                          height: 26.w,
                        ),
                        howtoCopeSection(),
                        SizedBox(
                          height: 34.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget symptomsSection() {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: circularBold,
                  height: 1.1,
                  color: nicotrackBlack1,
                ),
                children: [
              TextSpan(
                text: "Symptoms ",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: circularBoldItalic,
                  height: 1.1,
                  color: Color(0xffFF611D),
                ),
              ),
              TextSpan(text: "you might feel 😵 "),
            ])),
        SizedBox(
          height: 14.w,
        ),
        EmojiGridCards(items: widget.withdrawalStage.symptoms),
      ],
    );
  }

  Widget effectsonBodySection() {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: circularBold,
                  height: 1.1,
                  color: nicotrackBlack1,
                ),
                children: [
              TextSpan(
                text: "What happens ",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: circularBoldItalic,
                  height: 1.1,
                  color: Color(0xffFF9900),
                ),
              ),
              TextSpan(text: "to your body 💪"),
            ])),
        SizedBox(
          height: 14.w,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 78.w, // Adjust this height based on your content needs
          ),
          child: ListView.builder(
            itemCount: widget.withdrawalStage.whatHappens.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            // Let parent scroll handle it
            itemBuilder: (context, index) {
              final data = EmojiTextModel.fromJson(
                  widget.withdrawalStage.whatHappens[index]);
              final currentEmoji = data.emoji;
              final currentDescription = data.text;

              return Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? 20.w : 8.w,
                    right:
                        index == widget.withdrawalStage.whatHappens.length - 1
                            ? 20.w
                            : 0), // Optional: spacing between items
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Color(0xfff0f0f0)),
                ),
                padding: EdgeInsets.only(
                  left: 10.w,
                  // vertical: 16.h
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 👈 IMPORTANT: Shrink-wrap the Row
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      currentEmoji,
                      style: TextStyle(
                        fontFamily: circularMedium,
                        height: 1.1,
                        fontSize: 48.w,
                        color: nicotrackBlack1,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      width: 120.w,
                      child: Text(
                        currentDescription,
                        maxLines: currentDescription.length > 10 ? 3 : 1,
                        softWrap: true, // Allows text to wrap to the next line
                        style: TextStyle(
                          fontFamily: circularMedium,
                          height: 1.1,
                          fontSize: 14.sp,
                          color: nicotrackBlack1,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget howtoCopeSection() {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: circularBold,
                  height: 1.1,
                  color: nicotrackBlack1,
                ),
                children: [
              TextSpan(
                text: "How to ",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: circularBoldItalic,
                  height: 1.1,
                  color: nicotrackGreen,
                ),
              ),
              TextSpan(text: "cope with it 🧘‍♂️"),
            ])),
        SizedBox(
          height: 14.h,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.withdrawalStage.howToCope.length; i++)
                Builder(builder: (context) {
                  final data = EmojiTextModel.fromJson(
                      widget.withdrawalStage.howToCope[i]);
                  final currentEmoji = data.emoji;
                  final currentDescription = data.text;
                  return Container(
                    height: getDynamicStageBox(context),
                    margin: EdgeInsets.only(
                        left: i == 0 ? 20.w : 8.w,
                        right: i == widget.withdrawalStage.howToCope.length - 1
                            ? 20.w
                            : 0),
                    // Optional: spacing between items
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Color(0xfff0f0f0)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentEmoji,
                          style: TextStyle(
                            fontFamily: circularMedium,
                            height: 1.1,
                            fontSize: 48.w,
                            color: nicotrackBlack1,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 120.w,
                          child: Text(
                            currentDescription,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: circularMedium,
                              height: 1.1,
                              fontSize: 13.sp,
                              color: nicotrackBlack1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            ],
          ),
        ),
        // ConstrainedBox(
        //   constraints: BoxConstraints(
        //     maxHeight: 148.h,
        //     // Adjust this height based on your content needs
        //   ),
        //   child: ListView.builder(
        //     itemCount: widget.withdrawalStage.howToCope.length,
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     physics: BouncingScrollPhysics(),
        //     // Let parent scroll handle it
        //     itemBuilder: (context, index) {
        //       final data = EmojiTextModel.fromJson(
        //           widget.withdrawalStage.howToCope[index]);
        //       final currentEmoji = data.emoji;
        //       final currentDescription = data.text;
        //
        //       return Container(
        //         width: 120.w
        //         ,
        //         margin: EdgeInsets.only(
        //             left: index == 0 ? 20.w : 8.w,
        //             right:
        //             index == widget.withdrawalStage.howToCope.length - 1
        //                 ? 20.w
        //                 : 0), // Optional: spacing between items
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(16.r),
        //           border: Border.all(color: Color(0xfff0f0f0)),
        //         ),
        //         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             SizedBox(height: 16.h,),
        //             Text(
        //               currentEmoji,
        //               style: TextStyle(
        //                 fontFamily: circularMedium,
        //                 height: 1.1,
        //                 fontSize: 48.w,
        //                 color: nicotrackBlack1,
        //               ),
        //             ),
        //             SizedBox(width: 8.h),
        //             SizedBox(
        //               width: 80.w,
        //               child: Text(
        //                 currentDescription,
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   fontFamily: circularMedium,
        //                   height: 1.1,
        //                   fontSize: 13.sp,
        //                   color: nicotrackBlack1,
        //                 ),
        //               ),
        //             ),
        //
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
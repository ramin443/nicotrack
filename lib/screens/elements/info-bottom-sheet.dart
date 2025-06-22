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
                        disclaimerSection(),
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

  Widget disclaimerSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Color(0xFFE8E8E8),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      nicotrackGreen.withOpacity(0.8),
                      nicotrackGreen.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    "💡",
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Important Note",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Individual experiences may vary",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: circularBook,
                        color: nicotrackBlack1.withOpacity(0.6),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Main disclaimer text
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: nicotracklightBlue.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          "ℹ️",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "These symptoms and effects on your body are approximations based on common experiences. They may vary from person to person. Everyone's quit journey is unique!",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: circularBook,
                          height: 1.4,
                          color: nicotrackBlack1.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Feature highlights
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureItem("🎯", "Personalized", nicotrackOrange),
                    _buildFeatureItem("📊", "Evidence-based", nicotracklightBlue),
                    _buildFeatureItem("💪", "Supportive", Color(0xFF6BB02A)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Motivational message
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  nicotrackGreen.withOpacity(0.1),
                  nicotrackGreen.withOpacity(0.05),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: nicotrackGreen.withOpacity(0.2),
                width: 1.w,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("✨", style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 6.w),
                    Text("✨", style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "Your journey is unique and valuable",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularMedium,
                    color: Color(0xFF6BB02A),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text, Color color) {
    return Column(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
          ),
          child: Center(
            child: Text(emoji, style: TextStyle(fontSize: 18.sp)),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: circularMedium,
            color: color,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
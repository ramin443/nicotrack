import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({super.key});

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        initState: (v) {},
        builder: (settingsController) {
          return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 18.sp,
                  right: 18.sp,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18.w,
                      ),
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
                              settingsController.selectedDollar = 4;
                              settingsController.selectedCent = 20;
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
                                onTap: () async {
                                  // If feedback field is empty, just close without submitting
                                  if (settingsController.feedbackController.text.trim().isEmpty) {
                                    Navigator.of(context).pop();
                                    return;
                                  }
                                  // Otherwise, attempt to submit
                                  await settingsController.submitFeedback(context);
                                },
                                child: TextAutoSize(
                                  context.l10n.done,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularBook,
                                    color: nicotracklightBlue,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300.w,
                            child:
                          TextAutoSize(
                            context.l10n.your_honest_feedback,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1,
                              height: 1.1,
                            ),
                          ),)
                        ],
                      ),
                      SizedBox(
                        height: 25.w,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: settingsController.honestFeedbackTextFields(context),
                      ),
                      SizedBox(
                        height: 24.w,
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
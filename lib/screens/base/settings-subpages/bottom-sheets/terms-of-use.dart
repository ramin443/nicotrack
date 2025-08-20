import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/base/settings-subpages/elements/terms-of-use-components.dart';

class TermsOfUseBottomSheet extends StatelessWidget {
  const TermsOfUseBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 52.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: nicotrackBlack1,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
              
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 36.w,
                      width: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: nicotrackPurple.withOpacity(0.20),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: nicotrackPurple,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              
              // Header section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 86.w,
                      height: 86.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: nicotrackPurple.withOpacity(0.15),
                      ),
                      child: Center(
                        child: Text(
                          "📜",
                          style: TextStyle(fontSize: 48.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Terms of Use",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: nicotrackPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "Legal Agreement",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: circularMedium,
                          color: nicotrackPurple,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // Last updated
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Updated: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: circularMedium,
                        color: nicotrackBlack1.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Please read these terms carefully before using Nicotrack. By using our app, you agree to these terms.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularBook,
                        color: nicotrackBlack1,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Agreement highlight box
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: nicotrackPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: nicotrackPurple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: nicotrackPurple.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text("📋", style: TextStyle(fontSize: 20.sp)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "User Agreement",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              color: nicotrackPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "By downloading and using Nicotrack, you agree to be bound by these terms of use. These terms establish your rights and responsibilities when using our smoking cessation app.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularBook,
                        color: nicotrackBlack1,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),

              // Content sections
              TermsOfUseComponents.buildTermsSection(
                "1. Acceptance of Terms",
                [
                  "By accessing and using Nicotrack, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.",
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "2. App Purpose & Use",
                [
                  TermsOfUseComponents.buildTermsPoint("Health Support Tool", "Nicotrack is designed to support your quit smoking journey through tracking and motivation"),
                  TermsOfUseComponents.buildTermsPoint("Personal Use Only", "The app is intended for individual, non-commercial personal use"),
                  TermsOfUseComponents.buildTermsPoint("Age Requirement", "You must be at least 18 years old to use this application"),
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "3. Medical Disclaimer",
                [
                  TermsOfUseComponents.buildMedicalCard(
                    "⚕️ Not Medical Advice",
                    "Nicotrack is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions regarding smoking cessation.",
                    Color(0xffFF611D),
                  ),
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "4. User Responsibilities",
                [
                  TermsOfUseComponents.buildTermsPoint("Accurate Information", "Provide accurate and truthful information when using the app"),
                  TermsOfUseComponents.buildTermsPoint("Personal Data Security", "Keep your device secure to protect your personal health data"),
                  TermsOfUseComponents.buildTermsPoint("Appropriate Use", "Use the app only for its intended purpose of smoking cessation support"),
                  TermsOfUseComponents.buildTermsPoint("No Misuse", "Do not attempt to reverse engineer, hack, or misuse the application"),
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "5. Intellectual Property",
                [
                  TermsOfUseComponents.buildTermsPoint("App Ownership", "Nicotrack and all its content are owned by the app developers"),
                  TermsOfUseComponents.buildTermsPoint("Limited License", "You receive a limited, non-exclusive license to use the app"),
                  TermsOfUseComponents.buildTermsPoint("No Distribution", "You may not copy, distribute, or create derivative works from the app"),
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "6. Limitation of Liability",
                [
                  TermsOfUseComponents.buildMedicalCard(
                    "⚖️ Use at Your Own Risk",
                    "We provide Nicotrack 'as is' without any warranties. We are not liable for any damages or health outcomes related to your use of the app. Your smoking cessation journey is your personal responsibility.",
                    nicotrackOrange,
                  ),
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "7. Privacy & Data",
                [
                  TermsOfUseComponents.buildTermsPoint("Local Storage", "All your data is stored locally on your device only"),
                  TermsOfUseComponents.buildTermsPoint("No Data Collection", "We do not collect, transmit, or store your personal data on external servers"),
                  TermsOfUseComponents.buildTermsPoint("Privacy Policy", "Refer to our Privacy Policy for detailed information about data handling"),
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "8. App Updates & Changes",
                [
                  "We reserve the right to modify or update the app and these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.",
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "9. Termination",
                [
                  "You may stop using Nicotrack at any time by deleting the app from your device. We reserve the right to terminate or restrict access to the app for violations of these terms.",
                ],
              ),

              TermsOfUseComponents.buildTermsSection(
                "10. Support & Contact",
                [
                  "For questions about these terms or app support, please contact us through the feedback feature in the app's Settings section.",
                ],
              ),

              SizedBox(height: 32.h),

              // Footer
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    Text(
                      "🤝 Fair & Transparent Terms",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "These terms are designed to protect both you and us while ensuring you have the best possible experience with Nicotrack on your quit smoking journey.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularBook,
                        color: nicotrackBlack1.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
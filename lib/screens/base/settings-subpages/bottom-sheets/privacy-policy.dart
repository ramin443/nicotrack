import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/base/settings-subpages/elements/privacy-policy-components.dart';

class PrivacyPolicyBottomSheet extends StatelessWidget {
  const PrivacyPolicyBottomSheet({super.key});

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
                        color: Color(0xFF3380F8).withOpacity(0.20),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF3380F8),
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
                        color: Color(0xFF3380F8).withOpacity(0.15),
                      ),
                      child: Center(
                        child: Text(
                          "📃",
                          style: TextStyle(fontSize: 48.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Privacy Policy",
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
                        color: Color(0xFF3380F8).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "Your Privacy Matters",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: circularMedium,
                          color: Color(0xFF3380F8),
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
                      "We believe in complete transparency about how we handle your personal information.",
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

              // Privacy highlight box
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: nicotrackGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: nicotrackGreen.withOpacity(0.3),
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
                            color: nicotrackGreen.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text("🔒", style: TextStyle(fontSize: 20.sp)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Privacy-First Design",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              color: nicotrackGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Nicotrack is designed with your privacy as the top priority. All your personal data stays on your device and is never transmitted to external servers.",
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
              SizedBox(height: 28.w),

              // Content sections
              PrivacyPolicyComponents.buildPolicySection(
                "1. Information We Collect",
                [
                  PrivacyPolicyComponents.buildDataPoint("Personal Information", "Your name and quit smoking journey details"),
                  PrivacyPolicyComponents.buildDataPoint("Health Data", "Mood tracking, craving patterns, and smoking history"),
                  PrivacyPolicyComponents.buildDataPoint("Usage Data", "Daily task completion and progress tracking"),
                  PrivacyPolicyComponents.buildDataPoint("Preferences", "Notification settings and personalization choices"),
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "2. How We Store Your Data",
                [
                  PrivacyPolicyComponents.buildInfoCard(
                    "🏠 Local Storage Only",
                    "All your data is stored locally on your device using secure Hive database technology. We never upload your information to external servers.",
                    nicotrackOrange,
                  ),
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "3. Data Sharing & External Services",
                [
                  PrivacyPolicyComponents.buildInfoCard(
                    "🚫 Zero Data Sharing",
                    "We do not share, sell, or transmit your personal data to any third parties, advertisers, or external services. Your information stays with you.",
                    Color(0xffFF611D),
                  ),
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "4. Data Security",
                [
                  PrivacyPolicyComponents.buildDataPoint("Device Security", "Data is protected by your device's built-in security"),
                  PrivacyPolicyComponents.buildDataPoint("No Cloud Storage", "No risk of data breaches from external servers"),
                  PrivacyPolicyComponents.buildDataPoint("Encrypted Storage", "Local data is stored using Flutter's secure storage"),
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "5. Permissions We Request",
                [
                  PrivacyPolicyComponents.buildPermissionItem("📱 Notifications", "To send you helpful reminders about your quit journey"),
                  PrivacyPolicyComponents.buildPermissionItem("⏰ Alarms", "To schedule precise notification timing"),
                  PrivacyPolicyComponents.buildPermissionItem("📳 Vibration", "To ensure you notice important reminders"),
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "6. Your Rights & Control",
                [
                  PrivacyPolicyComponents.buildDataPoint("Full Control", "You can delete all your data anytime from Settings"),
                  PrivacyPolicyComponents.buildDataPoint("Data Portability", "Your data remains accessible to you on your device"),
                  PrivacyPolicyComponents.buildDataPoint("No Tracking", "We don't track your behavior or usage patterns"),
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "7. Children's Privacy",
                [
                  "This app is intended for adults (18+) who are trying to quit smoking. We do not knowingly collect personal information from children under 18.",
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "8. Changes to Privacy Policy",
                [
                  "Any updates to this privacy policy will be reflected in app updates. Continued use of the app constitutes acceptance of any changes.",
                ],
              ),
              SizedBox(height: 16.w),

              PrivacyPolicyComponents.buildPolicySection(
                "9. Contact Information",
                [
                  "If you have questions about this privacy policy or your data, please contact us through the app's feedback feature in Settings.",
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
                      "🌟 Your Privacy is Our Promise",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Nicotrack is committed to helping you quit smoking while keeping your personal journey completely private and secure.",
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
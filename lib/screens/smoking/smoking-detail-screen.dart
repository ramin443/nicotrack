import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

class SmokingDetailScreen extends StatefulWidget {
  final DateTime selectedDate;
  
  const SmokingDetailScreen({super.key, required this.selectedDate});

  @override
  State<SmokingDetailScreen> createState() => _SmokingDetailScreenState();
}

class _SmokingDetailScreenState extends State<SmokingDetailScreen> {
  DidYouSmokeModel? smokingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSmokingData();
  }

  Future<void> _loadSmokingData() async {
    try {
      final box = await Hive.openBox<DidYouSmokeModel>('didYouSmokeData');
      final dateKey = DateFormat.yMMMd().format(widget.selectedDate);
      
      setState(() {
        smokingData = box.get(dateKey);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(widget.selectedDate);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              _buildHeader(formattedDate),
              
              if (isLoading)
                Container(
                  height: 200.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: nicotrackGreen,
                    ),
                  ),
                )
              else if (smokingData == null)
                _buildNoDataSection()
              else
                _buildSmokingDataSection(),
                
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String formattedDate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: nicotrackBlack1,
                    size: 20.sp,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      TextAutoSize(
                        "🚭 Smoking Status",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: nicotrackOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: TextAutoSize(
                          "Daily Report",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: circularMedium,
                            color: nicotrackOrange,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 44.w), // Balance the back button
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  nicotrackOrange.withOpacity(0.08),
                  nicotrackOrange.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: nicotrackOrange.withOpacity(0.15),
                width: 1.w,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 76.w,
                  height: 76.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        nicotrackOrange.withOpacity(0.3),
                        nicotrackOrange.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: nicotrackOrange.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "🚭",
                      style: TextStyle(fontSize: 36.sp),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextAutoSize(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                TextAutoSize(
                  "Your smoking activity for this day",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularBook,
                    color: nicotrackBlack1.withOpacity(0.6),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFF1F3F4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: nicotrackLightGrey.withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  nicotrackLightGrey.withOpacity(0.2),
                  nicotrackLightGrey.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "📊",
                style: TextStyle(fontSize: 44.sp),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          TextAutoSize(
            "No Smoking Data",
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
              height: 1.1,
            ),
          ),
          SizedBox(height: 8.h),
          TextAutoSize(
            "No smoking status was recorded for this date. Track your daily progress to build healthy habits.",
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: nicotrackOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: nicotrackOrange.withOpacity(0.2),
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("💪", style: TextStyle(fontSize: 16.sp)),
                SizedBox(width: 8.w),
                TextAutoSize(
                  "Track daily for better insights",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularMedium,
                    color: nicotrackOrange,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmokingDataSection() {
    bool didSmoke = smokingData!.hasSmokedToday == 0;
    
    return Column(
      children: [
        // Smoking Status Card
        _buildSmokingStatusCard(didSmoke),
        
        // Additional data only shown if user smoked
        if (didSmoke) ...[
          // Number of cigarettes
          if (smokingData!.howManyCigs != -1)
            _buildCigaretteCountCard(),
            
          // Triggers
          if (smokingData!.whatTriggerred.isNotEmpty)
            _buildListCard(
              title: "What Triggered Smoking",
              emoji: "⚡",
              items: smokingData!.whatTriggerred,
              color: nicotrackRed,
            ),
            
          // Feelings
          if (smokingData!.howYouFeel.isNotEmpty)
            _buildListCard(
              title: "How I Felt",
              emoji: "💭",
              items: smokingData!.howYouFeel,
              color: nicotrackPurple,
            ),
            
          // Avoidance strategies
          if (smokingData!.avoidNext.isNotEmpty)
            _buildListCard(
              title: "How to Avoid Next Time",
              emoji: "🛡️",
              items: smokingData!.avoidNext,
              color: nicotrackGreen,
            ),
            
          // Quit date update
          if (smokingData!.updateQuitDate != -1)
            _buildQuitDateCard(),
        ]
      ],
    );
  }

  Widget _buildSmokingStatusCard(bool didSmoke) {
    Color cardColor = didSmoke ? nicotrackRed : nicotrackGreen;
    String statusLabel = didSmoke ? "SMOKED" : "SMOKE-FREE";
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: cardColor.withOpacity(0.15),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cardColor.withOpacity(0.06),
                  cardColor.withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        cardColor.withOpacity(0.25),
                        cardColor.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cardColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      didSmoke ? "🚬" : "🚭",
                      style: TextStyle(fontSize: 26.sp),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextAutoSize(
                        "Smoking Status",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextAutoSize(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: circularBold,
                            color: cardColor,
                            height: 1.1,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Container(
            padding: EdgeInsets.all(20.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFFE8EAED),
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: cardColor.withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        didSmoke ? "🔴" : "🟢",
                        style: TextStyle(fontSize: 40.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextAutoSize(
                    didSmoke ? "Smoked Today" : "Smoke-Free Day",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBold,
                      color: cardColor,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextAutoSize(
                    didSmoke 
                      ? "You recorded smoking activity today"
                      : "Congratulations on staying smoke-free!",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: circularBook,
                      color: nicotrackBlack1.withOpacity(0.6),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCigaretteCountCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: nicotrackOrange.withOpacity(0.15),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: nicotrackOrange.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  nicotrackOrange.withOpacity(0.06),
                  nicotrackOrange.withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        nicotrackOrange.withOpacity(0.25),
                        nicotrackOrange.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: nicotrackOrange.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "📊",
                      style: TextStyle(fontSize: 26.sp),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextAutoSize(
                        "Cigarette Count",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: nicotrackOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextAutoSize(
                          "QUANTITY",
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: circularBold,
                            color: nicotrackOrange,
                            height: 1.1,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Container(
            padding: EdgeInsets.all(20.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFFE8EAED),
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        smokingData!.howManyCigs.toString(),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontFamily: circularBold,
                          color: nicotrackOrange,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        smokingData!.howManyCigs == 1 ? "cigarette" : "cigarettes",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: circularMedium,
                          color: nicotrackBlack1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: nicotrackOrange,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      TextAutoSize(
                        "Recorded consumption for this day",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: circularBook,
                          color: nicotrackBlack1.withOpacity(0.5),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required String emoji,
    required List<Map<String, dynamic>> items,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextAutoSize(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...items.map((item) => Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                if (item['emoji'] != null) ...[
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: item['emoji'].toString().startsWith('assets/')
                          ? Image.asset(
                              item['emoji'],
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.cover,
                            )
                          : Text(
                              item['emoji'],
                              style: TextStyle(fontSize: 18.sp),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: TextAutoSize(
                    item['text'] ?? 'No description',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildQuitDateCard() {
    bool willUpdateQuitDate = smokingData!.updateQuitDate == 0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: willUpdateQuitDate ? nicotrackPurple.withOpacity(0.2) : nicotrackGreen.withOpacity(0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: willUpdateQuitDate ? nicotrackPurple.withOpacity(0.15) : nicotrackGreen.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    "📅",
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextAutoSize(
                  "Quit Date Decision",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: willUpdateQuitDate ? nicotrackPurple.withOpacity(0.08) : nicotrackGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  willUpdateQuitDate ? "🔄" : "📌",
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(height: 8.h),
                TextAutoSize(
                  willUpdateQuitDate ? "Reset Quit Date" : "Keep Current Quit Date",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBold,
                    color: willUpdateQuitDate ? nicotrackPurple : nicotrackGreen,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                TextAutoSize(
                  willUpdateQuitDate 
                    ? "Decided to start fresh with new quit date"
                    : "Kept the original quit date for streak calculation",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularBook,
                    color: nicotrackBlack1.withOpacity(0.7),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
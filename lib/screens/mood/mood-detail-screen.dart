import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

class MoodDetailScreen extends StatefulWidget {
  final DateTime selectedDate;
  
  const MoodDetailScreen({super.key, required this.selectedDate});

  @override
  State<MoodDetailScreen> createState() => _MoodDetailScreenState();
}

class _MoodDetailScreenState extends State<MoodDetailScreen> {
  MoodModel? moodData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    try {
      final box = await Hive.openBox<MoodModel>('moodData');
      final dateKey = DateFormat.yMMMd().format(widget.selectedDate);
      
      setState(() {
        moodData = box.get(dateKey);
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
              else if (moodData == null)
                _buildNoDataSection()
              else
                _buildMoodDataSection(),
                
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
                onTap: () {
                  Navigator.of(context).pop();
                },
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
                        "🌤️ Mood Journey",
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
                          color: nicotrackGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: TextAutoSize(
                          "Daily Reflection",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: circularMedium,
                            color: nicotrackGreen,
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
                  nicotrackGreen.withOpacity(0.08),
                  nicotrackGreen.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: nicotrackGreen.withOpacity(0.15),
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
                        nicotrackGreen.withOpacity(0.3),
                        nicotrackGreen.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: nicotrackGreen.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "📅",
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
                  "Your emotional state for this day",
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
                "📝",
                style: TextStyle(fontSize: 44.sp),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          TextAutoSize(
            "No Mood Recorded",
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
              height: 1.1,
            ),
          ),
          SizedBox(height: 8.h),
          TextAutoSize(
            "No mood data was captured for this date. Start tracking your daily emotions to see your patterns over time.",
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
              color: nicotrackGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: nicotrackGreen.withOpacity(0.2),
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("💡", style: TextStyle(fontSize: 16.sp)),
                SizedBox(width: 8.w),
                TextAutoSize(
                  "Track mood daily for insights",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularMedium,
                    color: nicotrackGreen,
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

  Widget _buildMoodDataSection() {
    return Column(
      children: [
        // Self Feeling Section
        if (moodData!.selfFeeling.isNotEmpty)
          _buildDataCard(
            title: "How I Felt",
            emoji: "😊",
            data: moodData!.selfFeeling,
            color: nicotrackGreen,
          ),
          
        // Mood Affecting Section
        if (moodData!.moodAffecting.isNotEmpty)
          _buildDataCard(
            title: "What Affected My Mood",
            emoji: "🎯",
            data: moodData!.moodAffecting,
            color: nicotrackOrange,
          ),
          
        // Craving Section
        if (moodData!.anyCravingToday != -1)
          _buildCravingCard(),
          
        // Craving Timing Section
        if (moodData!.craveTiming.isNotEmpty)
          _buildDataCard(
            title: "When I Had Cravings",
            emoji: "⏰",
            data: moodData!.craveTiming,
            color: nicotracklightBlue,
          ),
          
        // Reflection Section
        if (moodData!.reflectionNote.isNotEmpty)
          _buildReflectionCard(),
      ],
    );
  }

  Widget _buildDataCard({
    required String title,
    required String emoji,
    required Map<String, dynamic> data,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
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
                  color.withOpacity(0.06),
                  color.withOpacity(0.03),
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
                        color.withOpacity(0.25),
                        color.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      emoji,
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
                        title,
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
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextAutoSize(
                          "Recorded",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: circularMedium,
                            color: color,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Data Content
          Container(
            padding: EdgeInsets.all(20.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFFE8EAED),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  if (data['emoji'] != null)
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28.r),
                          child: data['emoji'].toString().startsWith('assets/')
                              ? Image.asset(
                                  data['emoji'],
                                  width: 36.w,
                                  height: 36.w,
                                  fit: BoxFit.cover,
                                )
                              : Text(
                                  data['emoji'],
                                  style: TextStyle(fontSize: 32.sp),
                                ),
                        ),
                      ),
                    ),
                  if (data['emoji'] != null) SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAutoSize(
                          data['text'] ?? 'No description available',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: circularMedium,
                            color: nicotrackBlack1,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            TextAutoSize(
                              "Personal selection",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCravingCard() {
    String cravingText = "";
    String cravingEmoji = "";
    String intensityLabel = "";
    Color cardColor = nicotrackRed;
    
    switch (moodData!.anyCravingToday) {
      case 0:
        cravingText = "Strong Cravings";
        cravingEmoji = "🔴";
        intensityLabel = "HIGH";
        cardColor = nicotrackRed;
        break;
      case 1:
        cravingText = "Mild Cravings";
        cravingEmoji = "🟡";
        intensityLabel = "MEDIUM";
        cardColor = nicotrackOrange;
        break;
      case 2:
        cravingText = "No Cravings";
        cravingEmoji = "🟢";
        intensityLabel = "NONE";
        cardColor = nicotrackGreen;
        break;
    }
    
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      "⚡",
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
                        "Craving Level",
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
                          intensityLabel,
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
                    width: 72.w,
                    height: 72.w,
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
                        cravingEmoji,
                        style: TextStyle(fontSize: 36.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextAutoSize(
                    cravingText,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBold,
                      color: cardColor,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextAutoSize(
                    moodData!.anyCravingToday == 2 
                      ? "Great job staying strong today!"
                      : "It's normal to experience cravings",
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

  Widget _buildReflectionCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: nicotrackPurple.withOpacity(0.15),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: nicotrackPurple.withOpacity(0.08),
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
                  nicotrackPurple.withOpacity(0.06),
                  nicotrackPurple.withOpacity(0.03),
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
                        nicotrackPurple.withOpacity(0.25),
                        nicotrackPurple.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: nicotrackPurple.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "💭",
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
                        "My Reflection",
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
                          color: nicotrackPurple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextAutoSize(
                          "Personal Note",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: circularMedium,
                            color: nicotrackPurple,
                            height: 1.1,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: nicotrackPurple,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextAutoSize(
                          moodData!.reflectionNote,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: circularBook,
                            color: nicotrackBlack1,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
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
                          color: nicotrackPurple,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      TextAutoSize(
                        "Personal thoughts and feelings",
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
}
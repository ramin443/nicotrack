import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/base/home.dart';

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
    // Format date with smart labels like mood detail screen
    String dateDisplay;
    if (widget.selectedDate.isToday) {
      dateDisplay = "Today";
    } else if (widget.selectedDate.isYesterday) {
      dateDisplay = "Yesterday";
    } else {
      dateDisplay = DateFormat('d. MMM yyyy').format(widget.selectedDate);
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              if (isLoading)
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: nicotrackGreen,
                    ),
                  ),
                )
              else if (smokingData == null)
                _buildNoDataSection(dateDisplay)
              else
                _buildSmokingContent(dateDisplay),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmokingContent(String dateDisplay) {
    bool didSmoke = smokingData!.hasSmokedToday == 0;
    String smokingEmoji = didSmoke ? "🚬" : "🚭";
    String smokingStatus = didSmoke ? "Smoked Today" : "Smoke-Free Day";
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
      child: Column(
        children: [
          // Header with date and close button (similar to mood detail)
          _buildHeader(dateDisplay),
          
          SizedBox(height: 18.w),
          
          // Main smoking status with large emoji
          Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x192196F3),
            ),
            child: Center(
              child: Text(
                smokingEmoji,
                style: TextStyle(fontSize: 86.w),
              ),
            ),
          ),
          SizedBox(height: 12.w),
          
          // Smoking status text
          TextAutoSize(
            smokingStatus,
            style: TextStyle(
              fontSize: 28.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
          SizedBox(height: 25.w),
          
          // Sections based on smoking status
          if (didSmoke) ...[
            // Number of cigarettes section
            if (smokingData!.howManyCigs != -1) ...[
              TextAutoSize(
                "Number of cigarettes smoked",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 14.h),
              _buildCigaretteCountSection(),
              SizedBox(height: 32.w),
            ],
            
            // Triggers section
            if (smokingData!.whatTriggerred.isNotEmpty) ...[
              TextAutoSize(
                "What triggered smoking",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 14.w),
              _buildMultipleItemsGrid(smokingData!.whatTriggerred),
              SizedBox(height: 32.w),
            ],
            
            // Feelings section
            if (smokingData!.howYouFeel.isNotEmpty) ...[
              TextAutoSize(
                "How you felt after smoking",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 14.w),
              _buildMultipleItemsGrid(smokingData!.howYouFeel),
              SizedBox(height: 32.w),
            ],
            
            // Avoidance strategies section
            if (smokingData!.avoidNext.isNotEmpty) ...[
              TextAutoSize(
                "Strategies to avoid next time",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 14.w),
              _buildMultipleItemsGrid(smokingData!.avoidNext),
              SizedBox(height: 32.w),
            ],
            
            // Quit date decision section
            if (smokingData!.updateQuitDate != -1) ...[
              TextAutoSize(
                "Quit date decision",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 14.w),
              _buildQuitDateSection(),
              SizedBox(height: 32.w),
            ],
          ] else ...[
            // Smoke-free message
            TextAutoSize(
              "Congratulations on staying smoke-free today! Keep up the great work on your journey to better health.",
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: nicotrackBlack1.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.w),
          ],
          
          SizedBox(height: 60.w),
        ],
      ),
    );
  }

  Widget _buildHeader(String dateDisplay) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: TextAutoSize(
        dateDisplay,
        style: TextStyle(
          fontSize: 18.sp,
          fontFamily: circularMedium,
          color: nicotrackRed,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: nicotrackRed.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                Icons.close,
                color: nicotrackRed,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataSection(String dateDisplay) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
      child: Column(
        children: [
          // Header
          _buildHeader(dateDisplay),
          
          SizedBox(height: 100.h),
          
          // No data content similar to mood detail screen
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x192196F3),
            ),
            child: Center(
              child: Text(
                "📝",
                style: TextStyle(fontSize: 56.sp),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          TextAutoSize(
            "No Smoking Data",
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
          SizedBox(height: 8.h),
          TextAutoSize(
            "No smoking status was recorded for this date",
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCigaretteCountSection() {
    return Container(
      width: 150.w,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  fontSize: 42.sp,
                  fontFamily: circularBold,
                  color: nicotrackRed,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                smokingData!.howManyCigs == 1 ? "cigarette" : "cigarettes",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuitDateSection() {
    bool willUpdateQuitDate = smokingData!.updateQuitDate == 0;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFE8EAED),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Text(
            willUpdateQuitDate ? "🔄" : "📌",
            style: TextStyle(fontSize: 32.sp),
          ),
          SizedBox(height: 8.h),
          TextAutoSize(
            willUpdateQuitDate ? "Reset Quit Date" : "Keep Current Quit Date",
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
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
              color: nicotrackBlack1.withOpacity(0.6),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleItemsGrid(List<Map<String, dynamic>> items) {
    final pages = _chunkItems(items, 2); // 2 items per scroll "page"
    final showIndicator = pages.length > 1;
    
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: pages.map((pageItems) {
              return Container(
                width: MediaQuery.sizeOf(context).width - 40.w, // Account for padding
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns per page
                    childAspectRatio: 1.5, // Fixed aspect ratio for consistent sizing
                    crossAxisSpacing: 0.w,
                    mainAxisSpacing: 0.h, // No vertical spacing since it's one row
                  ),
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final item = pageItems[index];
                    return _buildInfoCard(
                      icon: item['emoji'],
                      text: item['text'] ?? '',
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
        if (showIndicator) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.black : Colors.black12,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard({
    required dynamic icon,
    required String text,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFE8EAED),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon.toString().startsWith('assets/')
              ? Image.asset(
                  icon,
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                )
              : Text(
                  icon,
                  style: TextStyle(fontSize: 28.sp),
                ),
          SizedBox(height: 10.w),
          TextAutoSize(
            text,
            style: TextStyle(
              height: 1.2,
              fontSize: 14.sp,
              fontFamily: circularMedium,
              color: nicotrackBlack1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<List<Map<String, dynamic>>> _chunkItems(
      List<Map<String, dynamic>> items, int chunkSize) {
    List<List<Map<String, dynamic>>> chunks = [];
    for (var i = 0; i < items.length; i += chunkSize) {
      chunks.add(items.sublist(i, (i + chunkSize).clamp(0, items.length)));
    }
    return chunks;
  }
}

// Extension to check if date is today or yesterday
extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}


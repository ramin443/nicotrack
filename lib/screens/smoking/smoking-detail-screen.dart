import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/no-selected/congratulatory-page.dart';
import 'package:nicotrack/screens/base/base.dart';

enum SmokingDetailRouteSource {
  fromHome,
  afterSmokingCompletion,
}

class SmokingDetailScreen extends StatefulWidget {
  final DateTime selectedDate;
  final SmokingDetailRouteSource routeSource;
  
  const SmokingDetailScreen({
    super.key, 
    required this.selectedDate,
    this.routeSource = SmokingDetailRouteSource.fromHome,
  });

  @override
  State<SmokingDetailScreen> createState() => _SmokingDetailScreenState();
}

class _SmokingDetailScreenState extends State<SmokingDetailScreen> {
  DidYouSmokeModel? smokingData;
  bool isLoading = true;
  int currentTriggersPage = 0;
  int currentFeelingsPage = 0;
  int currentAvoidancePage = 0;

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

  void _handleCloseNavigation() {
    switch (widget.routeSource) {
      case SmokingDetailRouteSource.fromHome:
        // Coming from home daily page - use pop
        Navigator.of(context).pop();
        break;
      case SmokingDetailRouteSource.afterSmokingCompletion:
        // Coming after completing smoking questionnaire - navigate back to home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Base(),
          ),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: nicotrackGreen,
          ),
        ),
      );
    }
    
    if (smokingData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _buildNoDataSection(),
        ),
      );
    }
    
    // Check if it's a smoke-free day and show congratulations page
    if (smokingData!.hasSmokedToday == 1) {
      // Navigate to congratulations page for smoke-free days
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NoSmokeCongratsPage(),
            ),
          );
        }
      });
      return Container(); // Return empty container while navigating
    }
    
    // Show smoking details for days when user smoked
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: _buildSmokingContent(),
        ),
      ),
    );
  }

  Widget _buildSmokingContent() {
    // Format date
    String dateDisplay;
    if (widget.selectedDate.isToday) {
      dateDisplay = "Today";
    } else if (widget.selectedDate.isYesterday) {
      dateDisplay = "Yesterday";
    } else {
      dateDisplay = DateFormat('d. MMM yyyy').format(widget.selectedDate);
    }
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
      child: Column(
        children: [
          // Header with date and close button
          _buildHeader(dateDisplay),
          
          SizedBox(height: 18.w),
          
          // Did you smoke section with Yes/No buttons
          _buildSmokingStatusSection(),
          
          SizedBox(height: 32.h),
          
          // Cigarette count circle with large number
          if (smokingData!.howManyCigs > 0) ...[
            Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFFE4D9),
              ),
              child: Center(
                child: TextAutoSize(
                  smokingData!.howManyCigs.toString(),
                  style: TextStyle(
                    fontSize: 85.sp,
                    fontFamily: circularMedium,
                    color: Color(0xffFF611D),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22.w,
                  fontFamily: circularBold,
                  color: nicotrackBlack1,
                  height: 1.1
                ),
                children: [
                  TextSpan(text: "This is how many "),
                  TextSpan(
                    text: "🚬\ncigarettes",
                    style: TextStyle(
                      color: Color(0xffFF611D),
                      fontSize: 22.w,
                      fontFamily: circularBold,
                    ),
                  ),
                  TextSpan(text: " you smoked today"),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
          
          // Triggers section
          if (smokingData!.whatTriggerred.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                "This is what triggered your craving",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
            ]),
            SizedBox(height: 14.h),
            _buildMultipleItemsGrid(
              smokingData!.whatTriggerred,
              currentTriggersPage,
              (page) => setState(() => currentTriggersPage = page),
            ),
            SizedBox(height: 32.h),
          ],
          
          // Feelings section
          if (smokingData!.howYouFeel.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                "This is what it made you feel",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
            ]),
            SizedBox(height: 14.h),
            _buildMultipleItemsGrid(
              smokingData!.howYouFeel,
              currentFeelingsPage,
              (page) => setState(() => currentFeelingsPage = page),
            ),
            SizedBox(height: 32.h),
          ],
          
          // Avoidance strategies section
          if (smokingData!.avoidNext.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                "This is what you marked\nyou would do next to avoid craving",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                  height: 1.3,
                ),
              ),
            ]),
            SizedBox(height: 14.h),
            _buildMultipleItemsGrid(
              smokingData!.avoidNext,
              currentAvoidancePage,
              (page) => setState(() => currentAvoidancePage = page),
            ),
            SizedBox(height: 32.h),
          ],
          
          SizedBox(height: 60.h),
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
          color: Color(0xffFF611D),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            _handleCloseNavigation();
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFF611D).withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                Icons.close,
                color: Color(0xffFF611D),
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSmokingStatusSection() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextAutoSize(
            "Did you smoke today?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
            ),
          ),
        ]),
        SizedBox(height: 14.h),
        SizedBox(
          width: 260.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildStatusButton(
                  icon: '👎',
                  text: 'Yes',
                  isSelected: true, // Always true for smoking days
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _buildStatusButton(
                  icon: '👍',
                  text: 'No',
                  isSelected: false, // Always false for smoking days
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusButton({
    required String icon,
    required String text,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? nicotrackBlack1 : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? nicotrackBlack1 : Color(0xFFE8EAED),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(width: 8.w),
          TextAutoSize(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularMedium,
              color: isSelected ? Colors.white : nicotrackBlack1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataSection() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

  Widget _buildMultipleItemsGrid(List<Map<String, dynamic>> items,
      int currentPage, Function(int) onPageChanged) {
    final pages = _chunkItems(items, 2); // 2 items per scroll "page"
    final showIndicator = pages.length > 1;

    return StatefulBuilder(
      builder: (context, setState) {
        final scrollController = ScrollController();

        void _onScroll() {
          if (!scrollController.hasClients) return;
          final page = (scrollController.offset /
                  (MediaQuery.sizeOf(context).width - 40.w))
              .round();
          if (page != currentPage && page >= 0 && page < pages.length) {
            onPageChanged(page);
          }
        }

        scrollController.addListener(_onScroll);

        return Column(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pages.asMap().entries.map((entry) {
                  final pageItems = entry.value;
                  return Container(
                    width: MediaQuery.sizeOf(context).width -
                        40.w, // Account for padding
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 0.w,
                        mainAxisSpacing: 0.h,
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
                      color:
                          index == currentPage ? Colors.black : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ],
        );
      },
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
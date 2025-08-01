import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/base/base.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

enum MoodDetailRouteSource {
  fromHome,
  afterMoodCompletion,
}

class MoodDetailScreen extends StatefulWidget {
  final DateTime selectedDate;
  final MoodDetailRouteSource routeSource;

  const MoodDetailScreen({
    super.key,
    required this.selectedDate,
    this.routeSource = MoodDetailRouteSource.fromHome,
  });

  @override
  State<MoodDetailScreen> createState() => _MoodDetailScreenState();
}

class _MoodDetailScreenState extends State<MoodDetailScreen> {
  MoodModel? moodData;
  bool isLoading = true;
  int currentMoodAffectingPage = 0;
  int currentCraveTimingPage = 0;

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

  void _handleCloseNavigation() {
    switch (widget.routeSource) {
      case MoodDetailRouteSource.fromHome:
        // Coming from home daily page - use pop
        Navigator.of(context).pop();
        break;
      case MoodDetailRouteSource.afterMoodCompletion:
        // Coming after completing mood - navigate back to base
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Base(),
          ),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              else if (moodData == null)
                _buildNoDataSection()
              else
                _buildMoodContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodContent() {
    // Get mood data
    final selfFeeling = moodData!.selfFeeling;
    final moodAffecting = moodData!.moodAffecting;
    final cravingLevel = moodData!.anyCravingToday;
    final craveTiming = moodData!.craveTiming;
    final reflection = moodData!.reflectionNote;

    // Format date
    String dateDisplay;
    if (widget.selectedDate.isToday) {
      dateDisplay = context.l10n.today;
    } else if (widget.selectedDate.isYesterday) {
      dateDisplay = context.l10n.yesterday;
    } else {
      dateDisplay =
          DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
              .format(widget.selectedDate);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
      child: Column(
        children: [
          // Header with date and close button
          _buildHeader(dateDisplay),

          SizedBox(height: 18.w),

          // Large emoji with blue background
          if (selfFeeling.isNotEmpty) ...[
            Container(
              width: 170.w,
              height: 170.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x192196F3),
              ),
              child: Center(
                child: selfFeeling['emoji'].toString().startsWith('assets/')
                    ? Image.asset(
                        selfFeeling['emoji'],
                        width: 86.w,
                        height: 86.w,
                        fit: BoxFit.cover,
                      )
                    : Text(
                        selfFeeling['emoji'] ?? '😊',
                        style: TextStyle(fontSize: 86.w),
                      ),
              ),
            ),
            SizedBox(height: 12.w),

            // Mood name
            TextAutoSize(
              selfFeeling['text'] ?? 'Happy',
              style: TextStyle(
                fontSize: 28.sp,
                fontFamily: circularBold,
                color: nicotrackBlack1,
              ),
            ),
            SizedBox(height: 25.w),
          ],
          // Cravings section
          if (cravingLevel != -1) ...[
            _buildCravingSection(cravingLevel),
            SizedBox(height: 32.w),
          ],
          // Subtitle

          TextAutoSize(
            context.l10n.mood_detail_affecting_mood,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.1,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 14.h),
          // Multiple mood affecting items
          if (moodAffecting.isNotEmpty) ...[
            _buildMultipleItemsGrid(
              moodAffecting,
              currentMoodAffectingPage,
              (page) => setState(() => currentMoodAffectingPage = page),
            ),
            SizedBox(height: 32.w),
          ],

          // Only show craving timing section if user had cravings and timing data exists
          if (craveTiming.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextAutoSize(
                context.l10n.mood_detail_craving_timing,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1.withOpacity(0.6),
                ),
              ),
            ]),
            SizedBox(height: 14.w),
            _buildMultipleItemsGrid(
              craveTiming,
              currentCraveTimingPage,
              (page) => setState(() => currentCraveTimingPage = page),
            ),
            SizedBox(height: 32.w),
          ],

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextAutoSize(
              context.l10n.mood_detail_reflection_note,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                color: nicotrackBlack1.withOpacity(0.6),
              ),
            ),
          ]),
          // Reflection note
          _buildReflectionSection(reflection),

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
            _handleCloseNavigation();
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

  Widget _buildCravingSection(int cravingLevel) {
    String questionText = context.l10n.mood_detail_cravings_question;
    bool hadCravings = cravingLevel != 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextAutoSize(
            questionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.6),
            ),
          ),
        ]),
        SizedBox(height: 14.w),
        SizedBox(
          width: 260.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildCravingButton(
                  icon: '👍',
                  text: context.l10n.mood_detail_yes,
                  isSelected: hadCravings,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _buildCravingButton(
                  icon: '👎',
                  text: context.l10n.mood_detail_no,
                  isSelected: !hadCravings,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCravingButton({
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

  Widget _buildReflectionSection(String reflection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14.w),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextAutoSize(
                reflection.isNotEmpty
                    ? reflection
                    : context.l10n.mood_detail_nothing_here,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: circularBook,
                  color: reflection.isNotEmpty
                      ? nicotrackBlack1
                      : Color(0xffB9B9B9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
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
            context.l10n.mood_detail_no_mood_recorded,
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
          SizedBox(height: 8.h),
          TextAutoSize(
            context.l10n.mood_detail_no_mood_data_captured,
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
                        // 2 columns per page
                        childAspectRatio: 1.5,
                        // Fixed aspect ratio for consistent sizing
                        crossAxisSpacing: 0.w,
                        mainAxisSpacing:
                            0.h, // No vertical spacing since it's one row
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
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}
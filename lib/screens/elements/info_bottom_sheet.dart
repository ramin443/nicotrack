import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feather_icons/feather_icons.dart';

/// Reusable bottom sheet widget for displaying info content
class InfoBottomSheet extends StatelessWidget {
  final Widget content;
  final double heightRatio;

  const InfoBottomSheet({
    super.key,
    required this.content,
    this.heightRatio = 0.85,
  });

  /// Shows the info bottom sheet with the provided content
  static void show(
    BuildContext context, {
    required Widget content,
    double heightRatio = 0.85,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return InfoBottomSheet(
          content: content,
          heightRatio: heightRatio,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * heightRatio,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 20.w,
                top: 10.h,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FeatherIcons.x,
                    size: 18.sp,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 20.h,
              ),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
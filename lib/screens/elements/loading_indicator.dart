import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standardized loading indicator used across the entire app
/// Uses white circle background with black rotating indicator
class StandardLoadingIndicator extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  
  const StandardLoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: strokeWidth ?? 2.w,
        backgroundColor: Colors.black,
      ),
    );
  }
}

/// Standardized loading dialog used across the entire app
class StandardLoadingDialog extends StatelessWidget {
  final String? message;
  
  const StandardLoadingDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StandardLoadingIndicator(),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper function to show standardized loading dialog
void showStandardLoadingDialog(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StandardLoadingDialog(message: message),
  );
}
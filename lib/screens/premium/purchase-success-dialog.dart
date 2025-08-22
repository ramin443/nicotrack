import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../base/base.dart';

class PurchaseSuccessDialog extends StatefulWidget {
  final String planType;
  
  const PurchaseSuccessDialog({
    Key? key, 
    this.planType = 'Premium',
  }) : super(key: key);

  @override
  State<PurchaseSuccessDialog> createState() => _PurchaseSuccessDialogState();
}

class _PurchaseSuccessDialogState extends State<PurchaseSuccessDialog> {

  @override
  void initState() {
    super.initState();
    // Haptic feedback for success
    HapticFeedback.heavyImpact();
  }

  void _handleClose() {
    HapticFeedback.lightImpact();
    
    // Navigate to home and clear all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Base(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleClose();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Decorative elements
                Positioned(
                  top: 80.h,
                  left: 40.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800).withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 120.h,
                  right: 60.w,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200.h,
                  left: 30.w,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800).withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 160.h,
                  right: 40.w,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                
                // Main content
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Crown icon
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFFFB800),
                                const Color(0xFFFF8F00),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFB800).withOpacity(0.3),
                                blurRadius: 30,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '👑',
                              style: TextStyle(
                                fontSize: 60.sp,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 50.h),
                        
                        // Success title
                        Text(
                          'Welcome to Premium!',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontFamily: circularBold,
                            color: Colors.white,
                            letterSpacing: -0.8,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Subtitle
                        Text(
                          'Thank you for investing in your\nsmoke-free journey',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: circularBook,
                            color: Colors.white.withOpacity(0.75),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Plan type badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 28.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFFB800).withOpacity(0.15),
                                const Color(0xFFFF8F00).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: const Color(0xFFFFB800).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            widget.planType,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularMedium,
                              color: const Color(0xFFFFB800),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 60.h),
                        
                        // Continue button
                        GestureDetector(
                          onTap: _handleClose,
                          child: Container(
                            width: 220.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  const Color(0xFFF5F5F5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Let\'s Go!',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontFamily: circularBold,
                                  color: const Color(0xFF1A1A1A),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Close button (X) at top right
                Positioned(
                  top: 24.h,
                  right: 24.w,
                  child: GestureDetector(
                    onTap: _handleClose,
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.7),
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
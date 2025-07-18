import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/constants/color-constants.dart';

class PremiumPaywallScreen extends StatefulWidget {
  const PremiumPaywallScreen({super.key});

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen> {
  int selectedPlan = 0; // 0: Annual, 1: Monthly, 2: Lifetime
  final PageController _pageController = PageController();
  int _currentFeaturePage = 0;

  final List<Map<String, dynamic>> _features = [
    {
      "emoji": "📊",
      "title": "Advanced",
      "subtitle": "Analytics",
      "description": "Get detailed insights into your quitting progress"
    },
    {
      "emoji": "🎯",
      "title": "Unlimited",
      "subtitle": "Goals",
      "description": "Set multiple personalized goals for your journey"
    },
    {
      "emoji": "🏆",
      "title": "Complete",
      "subtitle": "Badges",
      "description": "Access to all achievement badges and rewards"
    },
    {
      "emoji": "✍️",
      "title": "Unlimited Quit",
      "subtitle": "Changes",
      "description": "Change your quit method anytime without limits"
    },
    {
      "emoji": "📅",
      "title": "Full Timeline",
      "subtitle": "Access",
      "description": "View complete timeline of your quitting journey"
    },
    {
      "emoji": "✅",
      "title": "Unlimited",
      "subtitle": "Daily Tasks",
      "description": "Access to all daily tasks and activities"
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:
        Stack(
          children: [
        Column(
          children: [
            // Top section with background image
            Container(
              height: 240.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(premiumBGImg),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildHeroSection(),
                  ],
                ),
              ),
            ),

            // Bottom section with white background
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildBenefitsSection(),
                  _buildFeatureSlider(),
                  _buildPlanSection(),
                  _buildFooterLinks(),
                  SizedBox(height: 60.w,)
                ],
              ),
            ),
          ],
        ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildContinueButton(),

              ],
            )
            ,
          )

          ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.close,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextAutoSize(
              "Unlock\nNicotrack Premium",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.1,
                fontSize: 32.sp,
                fontFamily: circularBold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Container(
      width: 310.w,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 26.w),
      child: Column(
        children: [
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 17.sp,
                    fontFamily: circularBook,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                        text: "Enjoy these benefits freely "
                            "when you get on the "),
                    TextSpan(
                      text: "premium plan",
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 17.sp,
                        fontFamily: circularBold,
                        color: Colors.black87,
                      ),
                    ),
                  ])),
        ],
      ),
    );
  }

  Widget _buildFeatureSlider() {
    // Split features into pages of 3
    final pageCount = (_features.length / 3).ceil();

    return Container(
      height: 120.w,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentFeaturePage = index;
                });
              },
              itemCount: pageCount,
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * 3;
                final endIndex = (startIndex + 3).clamp(0, _features.length);
                final pageFeatures = _features.sublist(startIndex, endIndex);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pageFeatures.map((feature) {
                      return Expanded(
                        flex: 3,
                        child: Container(
                          height: 104.w,
                          width: 110.w,
                          margin: EdgeInsets.only(
                              right: pageIndex == endIndex ? 0 : 8.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: Color(0xfff1f1f1), width: 1.sp)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: TextAutoSize(
                                  feature["emoji"],
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.w),
                              TextAutoSize(
                                feature["title"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  height: 1.1,
                                  fontFamily: circularBold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextAutoSize(
                                feature["subtitle"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: circularBold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageCount, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: 4.w),
                width: _currentFeaturePage == index ? 20.w : 5.w,
                height: 5.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: _currentFeaturePage == index
                      ? Colors.black87
                      : Colors.grey.withOpacity(0.3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 8.w),
          TextAutoSize(
            "Choose your plan",
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: circularBold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.w),
          Row(
            children: [
              _buildPlanCard(0, "Annual", "\$39.99", "🎉Save 50%", true),
              SizedBox(width: 8.w),
              _buildPlanCard(1, "Monthly", "\$6.99", "per month", false),
              SizedBox(width: 8.w),
              _buildPlanCard(2, "Lifetime", "\$79.99", "one-time", false),
            ],
          ),
          SizedBox(height: 20.w),
          SizedBox(
            width: 320.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextAutoSize(
                  "📱 Cancel anytime",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularBook,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 0.w),
                TextAutoSize(
                  "🧧 Costs less than cigarettes in 2 weeks",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularBook,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlanCard(
      int index, String title, String price, String subtitle, bool isPopular) {
    final isSelected = selectedPlan == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPlan = index;
          });
        },
        child: Container(
          height: 150.w,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 18.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextAutoSize(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: circularMedium,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextAutoSize(
                        price,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontFamily: circularBold,
                          color: (index == 0
                              ? nicotrackGreen
                              : (index == 1 ? Colors.red : Colors.red)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextAutoSize(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: circularBook,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.w),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (index == 0) ...[
                    SizedBox(height: 4.w),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextAutoSize(
                        "Billed annually",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: circularBook,
                          color: isSelected
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      )
                    ])
                  ],
                  if (index == 1) ...[
                    SizedBox(height: 4.w),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextAutoSize(
                        "Billed monthly",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: circularBook,
                          color: isSelected
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      ),
                    ])
                  ],
                  if (index == 2) ...[
                    SizedBox(height: 4.w),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextAutoSize(
                        "Billed once",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: circularBook,
                          color: isSelected
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      ),
                    ])
                  ],
                  SizedBox(
                    height: 12.w,
                  )
                ],
              ),
              isSelected
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 14.w,
                          height: 14.w,
                          margin: EdgeInsets.only(top: 6.w, right: 6.w),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.white, width: 3.sp),
                              shape: BoxShape.circle),
                        )
                      ],
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: GestureDetector(
        onTap: _handleSubscribe,
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Center(
            child: TextAutoSize(
              "Continue",
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: circularBold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              // Handle restore purchase
            },
            child: TextAutoSize(
              "Restore purchase",
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: circularBook,
                color: Colors.black87,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle terms of use
            },
            child: TextAutoSize(
              "Terms of use",
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: circularBook,
                color: Colors.black87,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle privacy policy
            },
            child: TextAutoSize(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: circularBook,
                color: Colors.black87,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscribe() {
    // TODO: Implement subscription logic
    String planType = ["Annual", "Monthly", "Lifetime"][selectedPlan];
    print("User selected: $planType plan");

    // Show success message for now
    Get.snackbar(
      "Coming Soon",
      "Subscription for $planType plan will be implemented",
      backgroundColor: Color(0xffFF4800),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
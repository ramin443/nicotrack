import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double getDynamicHeightWeeklyCalendar(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight <= 667) {
    // iPhone SE (screen height is small)
    return 112.h;
  } else if (screenHeight >= 812) {
    // iPhone 11 Pro / Plus / Large devices
    return 94.h;
  } else {
    // Default case for mid-range devices
    return 94.h;
  }
}
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../../getx-controllers/app-preferences-controller.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../../getx-controllers/home-controller.dart';
import '../../../elements/textAutoSize.dart';

class ChangeCurrencyBottomSheet extends StatefulWidget {
  const ChangeCurrencyBottomSheet({super.key});

  @override
  State<ChangeCurrencyBottomSheet> createState() => _ChangeCurrencyBottomSheetState();
}

class _ChangeCurrencyBottomSheetState extends State<ChangeCurrencyBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();
  AppPreferencesController appPreferencesController = Get.find<AppPreferencesController>();
  late FixedExtentScrollController currencyController;
  int selectedCurrencyIndex = 0;

  @override
  void initState() {
    super.initState();
    // Find current currency index
    final currencies = appPreferencesController.getCurrencyList();
    final currentCurrency = appPreferencesController.currencyCode;
    selectedCurrencyIndex = currencies.indexWhere((currency) => currency['code'] == currentCurrency);
    if (selectedCurrencyIndex == -1) selectedCurrencyIndex = 0;
    
    currencyController = FixedExtentScrollController(initialItem: selectedCurrencyIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPreferencesController>(
        builder: (appController) {
          final currencies = appController.getCurrencyList();
          
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            child: Column(
              children: [
                SizedBox(
                  height: 18.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4.8.w,
                      width: 52.w,
                      decoration: BoxDecoration(
                          color: nicotrackBlack1,
                          borderRadius: BorderRadius.circular(18.r)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                            color: nicotrackOrange.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            size: 20.w,
                            color: nicotrackOrange,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selectedCurrency = currencies[selectedCurrencyIndex];
                            await appController.updateCurrency(
                              selectedCurrency['code']!,
                              selectedCurrency['symbol']!,
                            );
                            // Trigger all controllers update to refresh currency symbols
                            Get.find<SettingsController>().update();
                            try {
                              Get.find<ProgressController>().update();
                            } catch (e) {
                              // Controller might not be available in all contexts
                            }
                            try {
                              Get.find<HomeController>().update();
                            } catch (e) {
                              // Controller might not be available in all contexts
                            }
                            Navigator.of(context).pop();
                          },
                          child: TextAutoSize(
                            context.l10n.done,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBook,
                              color: nicotracklightBlue,
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.w,
                ),
                TextAutoSize(
                  context.l10n.change_currency,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),

                Expanded(
                  child: CupertinoPicker(
                    scrollController: currencyController,
                    itemExtent: 60.w,
                    onSelectedItemChanged: (index) {
                      selectedCurrencyIndex = index;
                    },
                    children: currencies.map((currency) {
                      return Center(
                        child: TextAutoSize(
                          '${currency['symbol']} ${currency['name']} (${currency['code']})',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontFamily: circularMedium,
                            color: nicotrackBlack1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 24.w,
                ),
              ],
            ),
          );
        });
  }
}
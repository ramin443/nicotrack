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
import '../../../elements/textAutoSize.dart';

class ChangeLanguageBottomSheet extends StatefulWidget {
  const ChangeLanguageBottomSheet({super.key});

  @override
  State<ChangeLanguageBottomSheet> createState() => _ChangeLanguageBottomSheetState();
}

class _ChangeLanguageBottomSheetState extends State<ChangeLanguageBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();
  AppPreferencesController appPreferencesController = Get.find<AppPreferencesController>();
  late FixedExtentScrollController languageController;
  int selectedLanguageIndex = 0;

  final List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇧🇷'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'},
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
    {'code': 'nl', 'name': 'Dutch', 'flag': '🇳🇱'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'},
    {'code': 'cs', 'name': 'Czech', 'flag': '🇨🇿'},
    {'code': 'el', 'name': 'Greek', 'flag': '🇬🇷'},
    {'code': 'he', 'name': 'Hebrew', 'flag': '🇮🇱'},
    {'code': 'hu', 'name': 'Hungarian', 'flag': '🇭🇺'},
    {'code': 'id', 'name': 'Indonesian', 'flag': '🇮🇩'},
    {'code': 'pl', 'name': 'Polish', 'flag': '🇵🇱'},
    {'code': 'ro', 'name': 'Romanian', 'flag': '🇷🇴'},
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'},
    {'code': 'tr', 'name': 'Turkish', 'flag': '🇹🇷'},
  ];

  @override
  void initState() {
    super.initState();
    // Find current language index
    final currentLocale = appPreferencesController.locale;
    selectedLanguageIndex = supportedLanguages.indexWhere((language) => language['code'] == currentLocale);
    if (selectedLanguageIndex == -1) selectedLanguageIndex = 0;
    
    languageController = FixedExtentScrollController(initialItem: selectedLanguageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPreferencesController>(
        builder: (appController) {
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
                            final selectedLanguage = supportedLanguages[selectedLanguageIndex];
                            await appController.updateLanguage(
                              selectedLanguage['code']!,
                              selectedLanguage['name']!,
                            );
                            // Trigger settings controller update
                            Get.find<SettingsController>().update();
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
                  context.l10n.change_language,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),

                Expanded(
                  child: CupertinoPicker(
                    scrollController: languageController,
                    itemExtent: 60.w,
                    onSelectedItemChanged: (index) {
                      selectedLanguageIndex = index;
                    },
                    children: supportedLanguages.map((language) {
                      return Center(
                        child: TextAutoSize(
                          '${language['flag']} ${language['name']}',
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
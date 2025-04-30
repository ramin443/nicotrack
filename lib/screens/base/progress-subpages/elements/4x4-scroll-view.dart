import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
class FourxFourScrollView extends StatefulWidget {
  const FourxFourScrollView({super.key});

  @override
  State<FourxFourScrollView> createState() => _FourxFourScrollViewState();
}

class _FourxFourScrollViewState extends State<FourxFourScrollView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (context) {
        return Column(
          children: [

          ],
        );
      }
    );
  }
}
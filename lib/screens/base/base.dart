import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/base-controller.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(
        init: BaseController(),
        builder: (baseController) {
          return Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, -6),
                          color: Color(0x0000000D),
                          blurRadius: 25)
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: baseController.bottomBavBar2(context),
              ),
          body: baseController.mainPages[baseController.selectedIndex],

          );
        });
  }
}
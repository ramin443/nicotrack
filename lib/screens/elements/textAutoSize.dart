// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextAutoSize extends StatefulWidget {
  final data;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final double minFontSize;
  final double maxFontSize;

  const TextAutoSize(
      String this.data, {
        Key? key,
        this.style,
        this.overflow,
        this.textAlign,
        this.maxLines,
        this.minFontSize = 12,
        this.maxFontSize = double.infinity,
      }) : super(key: key);

  //const TextAutoSize({Key? key}) : super(key: key);

  @override
  State<TextAutoSize> createState() => _TextAutoSizeState();
}

class _TextAutoSizeState extends State<TextAutoSize> {
  @override
  Widget build(BuildContext context) {
    //var textFonSize = widget.style?.fontSize ?? 18;
    final mediaQueryData = MediaQuery.of(context);
    final num constrainedTextScaleFactor =
    mediaQueryData.textScaleFactor.clamp(1.0, 1.1);

    return AutoSizeText(
      widget.data,
      style: widget.style,
      //maxFontSize: 50,
      textScaleFactor: constrainedTextScaleFactor as double?,
      overflow: widget.overflow,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      minFontSize: widget.minFontSize,
      maxFontSize: widget.maxFontSize,
    );
  }
}

/*
class TextAutoSize extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const TextAutoSize(this.data, {Key? key, this.style}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var textFonSize = style?.fontSize ?? 18.sp;

    return TextAutoSize(
      data,
      style: style,
      maxFontSize: textFonSize * 1.5,
    );
  }
}
*/

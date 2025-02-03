import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight? weight;
  final double? size;
  final bool? alignCenter;
  final Color? color;
  const CustomText(
      {super.key,
      required this.text,
      this.weight,
      this.size,
      this.alignCenter,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign:
          (alignCenter != null && alignCenter!) ? TextAlign.center : null,
      style: custonTextStyle(weight: weight, size: size, color: color),
    );
  }
}

TextStyle custonTextStyle({FontWeight? weight, double? size, Color? color}) {
  return TextStyle(
      fontWeight: weight ?? FontWeight.normal,
      fontSize: size ?? 44,
      color: color);
}

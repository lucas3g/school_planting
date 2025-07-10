// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

class AppCustomButton extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final Function()? onPressed;
  final bool expands;
  final double height;
  final Key? buttonKey;
  Color? backgroundColor;
  double radius;

  AppCustomButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.expands = false,
    this.height = 40,
    this.buttonKey,
    this.backgroundColor,
    this.radius = AppThemeConstants.mediumBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    backgroundColor ??= context.myTheme.onPrimary;

    return icon != null
        ? ElevatedButton.icon(
            key: buttonKey,
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              textStyle: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              fixedSize: expands ? Size(context.screenWidth, height) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            icon: icon!,
            label: label,
          )
        : ElevatedButton(
            key: buttonKey,
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              textStyle: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              padding: EdgeInsets.zero,
              fixedSize: expands ? Size(context.screenWidth, height) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            child: label,
          );
  }
}

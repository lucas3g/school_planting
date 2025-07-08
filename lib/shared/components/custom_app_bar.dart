import 'package:flutter/material.dart';

import '../themes/app_theme_constants.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    required Widget super.title,
    super.leading,
    super.flexibleSpace,
    super.actions,
  }) : super(
         shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.only(
             bottomLeft: Radius.circular(AppThemeConstants.largeBorderRadius),
             bottomRight: Radius.circular(AppThemeConstants.largeBorderRadius),
           ),
         ),
       );
}

import 'package:flutter/material.dart';

import '../themes/app_theme_constants.dart';

class SpacerWidth extends StatelessWidget {
  const SpacerWidth({super.key, this.multiply = 1});

  final int multiply;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: AppThemeConstants.padding * multiply);
  }
}

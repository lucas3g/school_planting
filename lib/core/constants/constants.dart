import 'dart:io';

import 'package:flutter/material.dart';

const double kPadding = 20;

const SUPABASE_URL = String.fromEnvironment('SUPABASE_URL');
const SUPABASE_ANON_KEY = String.fromEnvironment('SUPABASE_ANON_KEY');
const PLANTNET_BASE_URL = String.fromEnvironment('PLANTNET_BASE_URL');
const PLANTNET_API_KEY = String.fromEnvironment('PLANTNET_API_KEY');

extension ContextExtensions on BuildContext {
  ColorScheme get myTheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;

  void closeKeyboard() => FocusScope.of(this).unfocus();

  Size get sizeAppbar {
    final height = AppBar().preferredSize.height;

    return Size(
      screenWidth,
      height +
          (Platform.isWindows
              ? 75
              : Platform.isIOS
              ? 50
              : 70),
    );
  }
}

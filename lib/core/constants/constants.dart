import 'dart:io';

import 'package:flutter/material.dart';

const double kPadding = 20;

const SUPABASE_URL = String.fromEnvironment('SUPABASE_URL');
const SUPABASE_ANON_KEY = String.fromEnvironment('SUPABASE_ANON_KEY');
const ANDROID_ID_GOOGLE_ACCOUNT = String.fromEnvironment(
  'ANDROID_ID_GOOGLE_ACCOUNT',
);
const WEB_APPLICATION_CLIENT_ID = String.fromEnvironment(
  'WEB_APPLICATION_CLIENT_ID',
);

extension ContextExtensions on BuildContext {
  ColorScheme get myTheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

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

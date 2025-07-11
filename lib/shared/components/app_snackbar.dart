import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_planting/core/domain/entities/app_assets.dart';

import '../themes/app_theme_constants.dart';

enum TypeSnack { success, error, warning, help }

void showAppSnackbar(
  BuildContext context, {
  required String title,
  required String message,
  required TypeSnack type,
  int duration = 4,
}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

  final SnackBar snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: Duration(seconds: duration),
    behavior: SnackBarBehavior.fixed,
    content: Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _returnBackgroundColor(type),
            borderRadius: BorderRadius.circular(
              AppThemeConstants.largeBorderRadius,
            ),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 70),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: type == TypeSnack.success
              ? -30
              : type == TypeSnack.help
              ? 8
              : 20,
          child: Lottie.asset(
            _returnLottieFile(type),
            width: type == TypeSnack.success
                ? 150
                : type == TypeSnack.help
                ? 65
                : 50,
          ),
        ),
        Positioned(
          top: -5,
          right: -2,
          child: IconButton(
            onPressed: () {
              messenger.hideCurrentSnackBar();
            },
            icon: const Icon(Icons.close),
            color: Colors.white,
          ),
        ),
      ],
    ),
  );

  messenger.showSnackBar(snackBar);
}

Color _returnBackgroundColor(TypeSnack type) {
  final Map<TypeSnack, Color> map = <TypeSnack, Color>{
    TypeSnack.success: Colors.green.shade800,
    TypeSnack.error: Colors.red.shade800,
    TypeSnack.warning: Colors.yellow.shade900,
    TypeSnack.help: Colors.blue.shade800,
  };

  return map[type]!;
}

String _returnLottieFile(TypeSnack type) {
  final Map<TypeSnack, String> map = <TypeSnack, String>{
    TypeSnack.success: AppAssets.lottieSuccess,
    TypeSnack.error: AppAssets.lottieError,
    TypeSnack.warning: AppAssets.lottieWarning,
    TypeSnack.help: AppAssets.lottieInfo,
  };

  return map[type]!;
}

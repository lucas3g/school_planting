import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/domain/entities/app_assets.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool userLoggedLicenseActiveHasIpServer() {
    final AppGlobal appGlobal = AppGlobal.instance;

    return appGlobal.user != null;
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (userLoggedLicenseActiveHasIpServer()) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        NamedRoutes.home.route,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        NamedRoutes.auth.route,
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // Para iOS
      ),
    );

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.logo, width: context.screenWidth * .5),
              const SizedBox(height: 20),
              AppCircularIndicatorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

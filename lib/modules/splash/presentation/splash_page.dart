import 'package:flutter/material.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';

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
      Navigator.pushReplacementNamed(context, NamedRoutes.home.route);
    } else {
      Navigator.pushReplacementNamed(context, NamedRoutes.auth.route);
    }
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'School Planting',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

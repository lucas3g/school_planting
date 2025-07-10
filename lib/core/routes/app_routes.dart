import 'package:flutter/material.dart';
import 'package:school_planting/modules/auth/presentation/auth_page.dart';
import 'package:school_planting/modules/home/presentation/home_page.dart';
import 'package:school_planting/modules/my_plantings/presentation/my_plantings_page.dart';
import 'package:school_planting/modules/impact/presentation/impact_page.dart';
import 'package:school_planting/modules/splash/presentation/splash_page.dart';
import 'package:school_planting/modules/planting/presentation/planting_page.dart';

import '../domain/entities/named_routes.dart';
import 'domain/entities/custom_transition.dart';
import 'presenter/custom_page_builder.dart';

class CustomNavigator {
  CustomNavigator({required this.generateAnimation});

  final CustomTransition Function(RouteSettings) generateAnimation;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Map<String, WidgetBuilder> appRoutes = <String, WidgetBuilder>{
      NamedRoutes.splash.route: (BuildContext context) => const SplashPage(),
      NamedRoutes.auth.route: (BuildContext context) => const AuthPage(),
      NamedRoutes.home.route: (BuildContext context) => const HomePage(),
      NamedRoutes.planting.route: (BuildContext context) => const PlantingPage(),
      NamedRoutes.myPlantings.route: (BuildContext context) => const MyPlantingsPage(),
      NamedRoutes.impact.route: (BuildContext context) => const ImpactPage(),
    };

    final WidgetBuilder? builder = appRoutes[settings.name];

    if (builder != null) {
      final CustomTransition customTransition = generateAnimation(settings);

      return CustomPageRouteBuilder(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return builder(context);
            },
        customTransition: customTransition,
        settings: settings,
      );
    }

    return null;
  }
}

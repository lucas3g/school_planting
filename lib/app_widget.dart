import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';
import 'package:school_planting/core/routes/app_routes.dart';
import 'package:school_planting/core/routes/domain/entities/custom_transition.dart';
import 'package:school_planting/core/routes/domain/entities/custom_transition_type.dart';
import 'package:school_planting/shared/themes/theme.dart';
import 'package:school_planting/shared/utils/global_context.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Map',
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalContext.navigatorKey,
      theme: lightThemeApp,
      darkTheme: darkThemeApp,
      themeMode: ThemeMode.dark,
      initialRoute: NamedRoutes.splash.route,
      supportedLocales: const <Locale>[Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const <LocalizationsDelegate>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: CustomNavigator(
        generateAnimation: _generateAnimation,
      ).onGenerateRoute,
    );
  }

  CustomTransition _generateAnimation(RouteSettings settings) {
    return CustomTransition(
      transitionType: CustomTransitionType.fade,
      duration: const Duration(milliseconds: 200),
    );
  }
}

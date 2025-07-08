import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/core/domain/entities/app_assets.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_bloc.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_events.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_states.dart';
import 'package:school_planting/shared/components/app_snackbar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();

  StreamSubscription<AuthStates>? _authSubscription;

  void _listenAuthStates() {
    _authSubscription = _authBloc.stream.listen((state) {
      if (state is AuthSuccessState) {
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, NamedRoutes.home.route);
      }
      if (state is AuthFailureState) {
        if (!mounted) return;

        showAppSnackbar(
          context,
          title: 'Erro',
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _listenAuthStates();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: SizedBox(
            width: context.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      width: context.screenWidth * .5,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Marque onde você plantou uma árvore',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text('Ajude a mapear um mundo mais verde'),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: context.myTheme.onPrimary,
                        textStyle: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        fixedSize: Size(context.screenWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        _authBloc.add(LoginWithGoogleAccountEvent());
                      },
                      icon: Image.asset(AppAssets.google, width: 25),
                      label: Text(
                        'Entrar com o Google',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Suas plantações. Nosso planeta.',
                      style: context.textTheme.bodyLarge?.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

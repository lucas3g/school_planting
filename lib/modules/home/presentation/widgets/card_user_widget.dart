import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_bloc.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_events.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_states.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/app_snackbar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

class CardUserWidget extends StatefulWidget {
  const CardUserWidget({super.key});

  @override
  State<CardUserWidget> createState() => _CardUserWidgetState();
}

class _CardUserWidgetState extends State<CardUserWidget> {
  final AuthBloc _authBloc = getIt<AuthBloc>();

  StreamSubscription<AuthStates>? _authSubscription;

  Widget _handleButtonLogout(AuthStates states) {
    if (states is AuthLoadingState) {
      return Padding(
        padding: const EdgeInsets.only(right: 15),
        child: const AppCircularIndicatorWidget(size: 20),
      );
    }

    if (states is LogoutAccountState) {
      return IconButton(icon: Icon(Icons.check, size: 25), onPressed: () {});
    }

    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: _confirmLogout,
    );
  }

  Future<void> _confirmLogout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.myTheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeConstants.largeBorderRadius,
          ),
        ),
        title: Text(
          'Sair',
          style: context.textTheme.titleMedium,
        ),
        content: Text(
          'Deseja realmente sair do aplicativo?',
          style: context.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      _authBloc.add(LogoutAccountEvent());
    }
  }

  void _listenAuthStates() {
    _authSubscription = _authBloc.stream.listen((state) async {
      if (state is LogoutAccountState) {
        await Future.delayed(const Duration(milliseconds: 350));

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, NamedRoutes.auth.route);
      }

      if (state is AuthFailureState) {
        if (!mounted) return;

        showAppSnackbar(
          context,
          title: 'Ocorrreu um erro',
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: AppThemeConstants.mediumPadding),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppThemeConstants.mediumPadding,
          ),
          padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
          decoration: BoxDecoration(
            color: context.myTheme.primaryContainer,
            borderRadius: BorderRadius.circular(
              AppThemeConstants.largeBorderRadius,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  AppGlobal.instance.user!.imageUrl.value,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppGlobal.instance.user!.name.value,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.list, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.myPlantings.route,
                  );
                },
              ),
              BlocBuilder<AuthBloc, AuthStates>(
                bloc: _authBloc,
                builder: (context, states) {
                  return _handleButtonLogout(states);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

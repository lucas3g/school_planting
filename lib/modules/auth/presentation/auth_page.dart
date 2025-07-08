import 'package:flutter/material.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_bloc.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_events.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authBloc.add(LoginWithGoogleAccountEvent());
          },
          child: const Text('Login with Google'),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/auth/data/adapters/user_adapter.dart';
import 'package:school_planting/modules/auth/data/datasources/auth_datasource.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';

@Injectable(as: AuthDatasource)
class AuthDatasourceImpl implements AuthDatasource {
  final ISupabaseClient _supabaseClient;

  AuthDatasourceImpl({required ISupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;
  @override
  Future<UserEntity> loginWithGoogleAccount() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize();

      final GoogleSignInAccount googleUser = await signIn.authenticate();

      const List<String> scopes = <String>[
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      final GoogleSignInClientAuthorization authorization = await googleUser
          .authorizationClient
          .authorizeScopes(scopes);

      final accessToken = authorization.accessToken;

      final idToken = googleUser.authentication.idToken;

      final result = await _supabaseClient.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken!,
        accessToken: accessToken,
      );

      if (result.user == null) {
        throw 'Usuário não encontrado após autenticação com o Google.';
      }

      final user = UserAdapter.fromSupabase(result.user!);

      AppGlobal.instance.setUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> autoLogin() async {
    final user = _supabaseClient.currentUser;

    if (user == null) {
      return null;
    }

    final userEntity = UserAdapter.fromSupabase(user);

    AppGlobal.instance.setUser(userEntity);

    return userEntity;
  }

  @override
  Future<void> logout() async {
    await _supabaseClient.signOut();
  }
}

import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/modules/auth/data/adapters/user_adapter.dart';
import 'package:school_planting/modules/auth/data/datasources/auth_datasource.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AuthDatasource)
class AuthDatasourceImpl implements AuthDatasource {
  @override
  Future<UserEntity> loginWithGoogleAccount() async {
    try {
      await GoogleSignInPlatform.instance
          .init(
            InitParameters(
              clientId: ANDROID_ID_GOOGLE_ACCOUNT,
              serverClientId: WEB_APPLICATION_CLIENT_ID,
            ),
          )
          .catchError(
            (error) =>
                throw Exception('Erro ao inicializar o Google Sign-In: $error'),
          );

      final googleUser = await GoogleSignInPlatform.instance
          .attemptLightweightAuthentication(
            const AttemptLightweightAuthenticationParameters(),
          );

      if (googleUser == null) {
        throw Exception('Google sign-in failed');
      }

      const List<String> scopes = <String>[
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      final ClientAuthorizationTokenData? tokens = await GoogleSignInPlatform
          .instance
          .clientAuthorizationTokensForScopes(
            ClientAuthorizationTokensForScopesParameters(
              request: AuthorizationRequestDetails(
                scopes: scopes,
                userId: googleUser.user.id,
                email: googleUser.user.email,
                promptIfUnauthorized: true,
              ),
            ),
          );

      final accessToken = tokens?.accessToken;

      final idToken = googleUser.authenticationTokens.idToken;

      if (accessToken == null) {
        throw 'Token de acesso não encontrado.';
      }
      if (idToken == null) {
        throw 'Id token não encontrado.';
      }

      final result = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (result.user == null) {
        throw 'Usuário não encontrado após autenticação com o Google.';
      }

      return UserAdapter.fromSupabase(result.user!);
    } catch (e) {
      rethrow;
    }
  }
}

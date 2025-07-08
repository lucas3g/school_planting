import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client_interface.dart';

@Singleton(as: ISupabaseClient)
class SupabaseClientImpl implements ISupabaseClient {
  final GoTrueClient _auth;

  SupabaseClientImpl() : _auth = Supabase.instance.client.auth;

  @override
  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  }) {
    return _auth.signInWithIdToken(
      provider: provider,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> signOut() => _auth.signOut();
}

import "package:supabase_flutter/supabase_flutter.dart";

abstract class ISupabaseClient {
  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  });

  User? get currentUser;

  Future<void> signOut();
}

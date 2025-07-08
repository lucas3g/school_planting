import "dart:io";

import "package:supabase_flutter/supabase_flutter.dart";

abstract class ISupabaseClient {
  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  });

  User? get currentUser;

  Future<void> signOut();

  Future<void> uploadFile({
    required String bucket,
    required String path,
    required File file,
  });

  Future<void> insert({
    required String table,
    required Map<String, dynamic> data,
  });

  Future<List<dynamic>> select({
    required String table,
    required String columns,
    required String orderBy,
  });

  String getPublicUrl({
    required String bucket,
    required String path,
  });
}

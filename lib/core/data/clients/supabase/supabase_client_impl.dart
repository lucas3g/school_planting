import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client_interface.dart';

@Singleton(as: ISupabaseClient)
class SupabaseClientImpl implements ISupabaseClient {
  final GoTrueClient _auth;
  final SupabaseClient _client;

  SupabaseClientImpl()
    : _client = Supabase.instance.client,
      _auth = Supabase.instance.client.auth;

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

  @override
  Future<void> uploadFile({
    required String bucket,
    required String path,
    required File file,
  }) async {
    await _client.storage.from(bucket).upload(path, file);
  }

  @override
  Future<void> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    await _client.from(table).insert(data);
  }

  @override
  Future<List<dynamic>> select({
    required String table,
    required String columns,
    String? orderBy,
  }) async {
    dynamic data;

    if (orderBy == null || orderBy.isEmpty) {
      data = await _client.from(table).select(columns);
    } else {
      data = await _client.from(table).select(columns).order(orderBy);
    }

    return data;
  }

  @override
  Future<String> getImageUrl({required String bucket, required String path}) {
    return _client.storage.from(bucket).createSignedUrl(path, 60 * 60);
  }
}

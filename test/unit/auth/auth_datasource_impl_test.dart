import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/modules/auth/data/datasources/auth_datasource_impl.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AuthDatasourceImpl', () {
    late MockISupabaseClient client;
    late AuthDatasourceImpl datasource;

    setUp(() {
      client = MockISupabaseClient();
      datasource = AuthDatasourceImpl(supabaseClient: client);
    });

    test('autoLogin returns null when no user', () async {
      when(client.currentUser).thenReturn(null);

      final result = await datasource.autoLogin();

      expect(result, isNull);
    });

    test('autoLogin returns entity when user exists', () async {
      final user = MockSupabaseUser();
      when(user.id).thenReturn('1');
      when(user.email).thenReturn('mail@test.com');
      when(user.userMetadata).thenReturn({'name': 'User', 'avatar_url': 'img'});
      when(client.currentUser).thenReturn(user);

      final result = await datasource.autoLogin();

      expect(result, isA<UserEntity>());
      expect(result!.id.value, '1');
    });

    test('logout calls signOut', () async {
      when(client.signOut()).thenAnswer((_) async => {});
      await datasource.logout();
      verify(client.signOut()).called(1);
    });
  });
}

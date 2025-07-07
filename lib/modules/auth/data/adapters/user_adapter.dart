import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAdapter {
  static UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['photoUrl'],
    );
  }

  static UserEntity fromGoogle(AuthenticationResults results) {
    return UserEntity(
      id: results.user.id,
      name: results.user.displayName ?? 'Sem nome',
      email: results.user.email,
      imageUrl: results.user.photoUrl,
    );
  }

  static UserEntity fromSupabase(User user) {
    return UserEntity(
      id: user.id,
      name: user.userMetadata!['name'] ?? 'Sem nome',
      email: user.email!,
      imageUrl: user.userMetadata!['avatar_url'],
    );
  }
}

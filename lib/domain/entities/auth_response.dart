import 'package:equatable/equatable.dart';
import 'base_entity.dart';
import 'user.dart';

class AuthResponse extends BaseEntity {
  final User user;
  final String accessToken;
  final String? refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}

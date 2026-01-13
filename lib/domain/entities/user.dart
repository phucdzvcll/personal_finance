import 'package:equatable/equatable.dart';
import 'base_entity.dart';

class User extends BaseEntity {
  final int id;
  final String email;
  final String? name;
  final String? avatar;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, email, name, avatar];
}

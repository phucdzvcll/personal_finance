import 'base_entity.dart';
import 'category_type.dart';

class Category extends BaseEntity {
  final int id;
  final String name;
  final CategoryType type;
  final String? icon;
  final String? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, type, icon, color, createdAt, updatedAt];
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_type.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required int id,
    required String name,
    @JsonKey(name: 'type', fromJson: _typeFromJson, toJson: _typeToJson)
    required CategoryType type,
    String? icon,
    String? color,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      type: type,
      icon: icon,
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

CategoryType _typeFromJson(String value) => CategoryType.fromString(value);
String _typeToJson(CategoryType type) => type.value;

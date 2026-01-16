import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/category_type.dart';

part 'create_category_request.freezed.dart';
part 'create_category_request.g.dart';

@freezed
class CreateCategoryRequest with _$CreateCategoryRequest {
  const CreateCategoryRequest._();

  const factory CreateCategoryRequest({
    required String name,
    @JsonKey(name: 'type', fromJson: _typeFromJson, toJson: _typeToJson)
    required CategoryType type,
    String? icon,
    String? color,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}

CategoryType _typeFromJson(String value) => CategoryType.fromString(value);
String _typeToJson(CategoryType type) => type.value;

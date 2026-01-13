import '../../domain/entities/base_entity.dart';

/// Base model class
/// All models should extend this and implement fromJson/toJson
abstract class BaseModel<T extends BaseEntity> {
  /// Converts model to entity
  T toEntity();

  /// Creates model from JSON
  BaseModel<T> fromJson(Map<String, dynamic> json);

  /// Converts model to JSON
  Map<String, dynamic> toJson();
}

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/category_type.dart';
import 'base_repository.dart';

abstract class CategoryRepository extends BaseRepository {
  /// Create a new category
  Future<Either<Failure, Category>> createCategory({
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  });

  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get category by id
  Future<Either<Failure, Category>> getCategoryById(int id);

  /// Update category
  Future<Either<Failure, Category>> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  });

  /// Delete category
  Future<Either<Failure, void>> deleteCategory(int id);
}

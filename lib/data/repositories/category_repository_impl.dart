import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_datasource.dart';
import '../models/create_category_request.dart';
import '../models/update_category_request.dart';
import 'base_repository_impl.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl extends BaseRepositoryImpl
    implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Category>> createCategory({
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  }) async {
    try {
      final request = CreateCategoryRequest(
        name: name,
        type: type,
        icon: icon,
        color: color,
      );
      final categoryModel = await remoteDataSource.createCategory(request);
      return Right(categoryModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      final categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(int id) async {
    try {
      final categoryModel = await remoteDataSource.getCategoryById(id);
      return Right(categoryModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  }) async {
    try {
      final request = UpdateCategoryRequest(
        name: name,
        icon: icon,
        color: color,
      );
      final categoryModel = await remoteDataSource.updateCategory(id, request);
      return Right(categoryModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/category_model.dart';
import '../../models/create_category_request.dart';
import '../../models/update_category_request.dart';
import 'remote_datasource.dart';

abstract class CategoryRemoteDataSource extends RemoteDataSource {
  Future<CategoryModel> createCategory(CreateCategoryRequest request);

  Future<List<CategoryModel>> getCategories();

  Future<CategoryModel> getCategoryById(int id);

  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest request);

  Future<void> deleteCategory(int id);
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl(this.apiClient);

  @override
  Future<CategoryModel> createCategory(CreateCategoryRequest request) async {
    try {
      return await apiClient.createCategory(request);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to create category'
            : 'Failed to create category';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await apiClient.getCategories();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to fetch categories'
            : 'Failed to fetch categories';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    try {
      return await apiClient.getCategoryById(id);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to fetch category'
            : 'Failed to fetch category';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest request) async {
    try {
      return await apiClient.updateCategory(id, request);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to update category'
            : 'Failed to update category';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      return await apiClient.deleteCategory(id);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to delete category'
            : 'Failed to delete category';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}

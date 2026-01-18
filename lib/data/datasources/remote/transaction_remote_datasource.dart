import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/exceptions.dart';
import '../../models/transaction_model.dart';
import '../../models/create_transaction_request.dart';
import '../../models/update_transaction_request.dart';
import 'remote_datasource.dart';

abstract class TransactionRemoteDataSource extends RemoteDataSource {
  Future<TransactionModel> createTransaction(CreateTransactionRequest request);
  Future<List<TransactionModel>> getTransactions();
  Future<TransactionModel> updateTransaction(int id, UpdateTransactionRequest request);
  Future<void> deleteTransaction(int id);
}

@LazySingleton(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient apiClient;

  TransactionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<TransactionModel> createTransaction(CreateTransactionRequest request) async {
    try {
      return await apiClient.createTransaction(request);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to create transaction'
            : 'Failed to create transaction';
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
  Future<List<TransactionModel>> getTransactions() async {
    try {
      return await apiClient.getTransactions();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to fetch transactions'
            : 'Failed to fetch transactions';
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
  Future<TransactionModel> updateTransaction(int id, UpdateTransactionRequest request) async {
    try {
      return await apiClient.updateTransaction(id, request);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to update transaction'
            : 'Failed to update transaction';
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
  Future<void> deleteTransaction(int id) async {
    try {
      return await apiClient.deleteTransaction(id);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to delete transaction'
            : 'Failed to delete transaction';
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

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/exceptions.dart';
import '../../models/transaction_model.dart';
import '../../models/create_transaction_request.dart';
import 'remote_datasource.dart';

abstract class TransactionRemoteDataSource extends RemoteDataSource {
  Future<TransactionModel> createTransaction(CreateTransactionRequest request);
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
}

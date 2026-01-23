import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/exceptions.dart';
import '../../models/summary_model.dart';
import 'remote_datasource.dart';

abstract class SummaryRemoteDataSource extends RemoteDataSource {
  Future<SummaryModel> getMonthlySummary(int year, int month);
}

@LazySingleton(as: SummaryRemoteDataSource)
class SummaryRemoteDataSourceImpl implements SummaryRemoteDataSource {
  final ApiClient apiClient;

  SummaryRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SummaryModel> getMonthlySummary(int year, int month) async {
    try {
      return await apiClient.getMonthlySummary(year, month);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Failed to get summary'
            : 'Failed to get summary';
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

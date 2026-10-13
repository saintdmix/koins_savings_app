import 'package:dio/dio.dart';

import '../core/app_exception.dart';
import '../core/constants.dart';

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Accept': 'application/json'},
            ));

  final Dio _dio;

  Future<List<dynamic>> getList(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.get<List<dynamic>>(path, queryParameters: query);
      return response.data ?? <dynamic>[];
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (_) {
      throw const AppException('Unexpected error. Please try again.');
    }
  }

  AppException _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException('The request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const AppException('No internet connection. Check your network and retry.');
      case DioExceptionType.badResponse:
        return AppException('Server error (${e.response?.statusCode ?? 'unknown'}). Please try again later.');
      default:
        return const AppException('Something went wrong. Please try again.');
    }
  }
}

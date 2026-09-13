import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import 'api_response.dart';
import 'package:flutter/foundation.dart' show kIsWeb;






String get kApiBaseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kApiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );

    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage();

  Dio get dio => _dio;

  
  
  Future<T> unwrap<T>(
    Future<Response> Function() request,
    T Function(dynamic data) fromData,
  ) async {
    try {
      final response = await request();
      final body = ApiResponse<T>.fromJson(response.data, (d) => fromData(d));
      if (!body.success) {
        throw ApiException(body.message, statusCode: response.statusCode);
      }
      return body.data as T;
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message']?.toString() ?? e.message ?? 'Error de red')
          : (e.message ?? 'Error de red');
      throw ApiException(msg, statusCode: e.response?.statusCode);
    }
  }
}

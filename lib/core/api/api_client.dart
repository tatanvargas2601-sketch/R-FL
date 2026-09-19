import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import 'api_response.dart';
import 'api_url_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiClient {
  ApiClient._internal();

  static final ApiClient _instance = ApiClient._internal();

  static ApiClient get instance => _instance;

  static final _dio = Dio();
  static final TokenStorage _tokenStorage = TokenStorage();

  static Future<void> init() async {
    final url = kIsWeb ? 'http://localhost:5000' : await ApiUrlStorage.getUrl();
    _dio.options = BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
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
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clear();
          }
          handler.next(error);
        },
      ),
    );
  }

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

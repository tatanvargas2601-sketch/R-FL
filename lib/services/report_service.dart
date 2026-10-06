import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/api/api_response.dart';

class ReportService {
  final _client = ApiClient.instance;

  Future<Uint8List> downloadQuarterlyReport({
    required int year,
    required int quarter,
  }) async {
    try {
      final response = await _client.dio.get<List<int>>(
        '/api/reportes/trimestral/excel',
        queryParameters: {'year': year, 'quarter': quarter},
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw ApiException('El servidor devolvió un reporte vacío.');
      }
      return Uint8List.fromList(bytes);
    } on DioException catch (error) {
      final responseData = error.response?.data;
      var message = 'No fue posible descargar el reporte.';
      if (responseData is List<int>) {
        try {
          final body = jsonDecode(utf8.decode(responseData));
          if (body is Map && body['message'] != null) {
            message = body['message'].toString();
          }
        } on FormatException {
          message = 'Error HTTP ${error.response?.statusCode ?? 'desconocido'} al descargar el reporte.';
        }
      } else if (responseData is Map && responseData['message'] != null) {
        message = responseData['message'].toString();
      }
      throw ApiException(message, statusCode: error.response?.statusCode);
    }
  }
}

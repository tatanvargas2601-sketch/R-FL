


class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromData,
  ) {
    final rawData = json['data'];
    return ApiResponse<T>(
      success: json['status'] == 'success',
      message: json['message']?.toString() ?? '',
      data: rawData != null && fromData != null ? fromData(rawData) : rawData,
    );
  }
}


class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
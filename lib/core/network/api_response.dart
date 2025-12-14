class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? result;
  final int? errorCode;

  ApiResponse({required this.success, this.message, this.result, this.errorCode});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json)? dataFromJson) {
    final success = json['success'] as bool;
    final message = json['message'] as String?;
    final errorCode = json['errorCode'] as int?;

    T? resultData;
    if (json['result'] != null && dataFromJson != null) {
      resultData = dataFromJson(json['result']);
    } else if (success && json['result'] is String && json['result'] == "Unknown Type: object,null") {
      resultData = json['result'] as T?;
    }

    return ApiResponse<T>(success: success, message: message, result: resultData, errorCode: errorCode);
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, errorCode: $errorCode, result: $result)';
  }
}

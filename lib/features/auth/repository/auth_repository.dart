import 'package:dio/dio.dart';
import 'package:flutter_mytech_case/core/network/api_service.dart';
import 'package:flutter_mytech_case/core/network/api_response.dart';
import '../model/auth_request.dart';
import '../model/auth_response.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<LoginResponse> login(AuthRequest request) async {
    try {
      final response = await api.post("/api/v1/users/login", data: request.toJson());

      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success) {
        if (apiResponse.result != null) {
          return apiResponse.result!;
        }
        throw Exception(apiResponse.message ?? "Giriş başarılı, ancak yanıt verisi eksik.");
      } else {
        throw Exception(apiResponse.message ?? "Giriş işlemi başarısız oldu.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> register(AuthRequest request) async {
    try {
      final response = await api.post("/api/v1/users", data: request.toJson());

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success) {
        if (apiResponse.result != null) {
          return apiResponse.result!;
        }
        throw Exception(apiResponse.message ?? "Kayıt başarılı, ancak kullanıcı verisi eksik.");
      } else {
        throw Exception(apiResponse.message ?? "Kayıt işlemi başarısız oldu.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> fetchUserProfile() async {
    try {
      const String path = '/api/v1/users/profile';
      final response = await api.get(path);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.result != null) {
        final userProfile = User.fromJson(apiResponse.result!);
        return userProfile;
      } else {
        throw Exception(apiResponse.message ?? "Profil bilgileri alınamadı.");
      }
    } catch (e) {
      throw Exception("Profil bilgileri yüklenirken hata oluştu: $e");
    }
  }
}

import 'package:flutter_mytech_case/core/network/api_service.dart';
import 'package:flutter_mytech_case/features/auth/model/register_request.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await api.post("/api/v1/users/login", data: request.toJson());

    return LoginResponse.fromJson(response.data);
  }

  // AuthRepository.dart
  Future<User> register(RegisterRequest request) async {
    try {
      final response = await api.post("/api/v1/users", data: request.toJson());

      // BAŞARILI YANIT GELDİ, LOGLA
      print("✅ Repository: Register API Yanıtı Başarılı (Status: ${response.statusCode})");
      print("✅ Repository: Yanıt Verisi (Data): ${response.data}");

      // DİKKAT: response.data null veya boş ise bu satırda hata verebilir.
      return User.fromJson(response.data);
    } catch (e) {
      // BURADA BİR HATA YAKALANIRSA, BU MUHTEMELEN MODEL DÖNÜŞÜM HATASIDIR.
      print("❌ Repository: Register Model Dönüşüm Hatası: $e");
      rethrow; // Hatayı ViewModel'e geri fırlat.
    }
  }
}

import 'package:flutter_mytech_case/core/network/api_service.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await api.post("/api/v1/users/login", data: request.toJson());

    return LoginResponse.fromJson(response.data);
  }
}

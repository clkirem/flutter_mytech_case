import 'package:flutter_mytech_case/features/auth/repository/auth_repository.dart';
import 'package:flutter_mytech_case/features/auth/view_models/auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../model/login_request.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthViewModel(this.repository) : super(AuthState());

  Future<void> login(String email, String password) async {
    try {
      // Loading başlasın
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Request model
      final request = LoginRequest(email: email.trim(), password: password);

      // API çağrısı
      final response = await repository.login(request);

      // Başarılı response → token ve user bilgileri burada gelir
      print("💡 Login başarılı!");
      print("TOKEN: ${response.accessToken}");
      print("USER EMAIL: ${response.user.email}");

      // Burada token'ı secure storage / hive / shared prefs'e yazabilirsin.
      // ör: await TokenStorage.saveToken(response.accessToken);

      state = state.copyWith(isLoading: false, errorMessage: null, isLoggedIn: true);
    } catch (e) {
      // Hata varsa kullanıcıya gösterilecek
      state = state.copyWith(isLoading: false, errorMessage: e.toString(), isLoggedIn: false);
    }
  }

  // Logout (istersen kullanabilirsin)
  Future<void> logout() async {
    state = AuthState(isLoggedIn: false);
  }
}

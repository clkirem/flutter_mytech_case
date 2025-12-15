import 'dart:developer';

import 'package:flutter_mytech_case/features/auth/model/auth_response.dart';
import 'package:flutter_mytech_case/features/auth/repository/auth_repository.dart';
import 'package:flutter_mytech_case/features/auth/view_models/auth_state.dart';
import 'package:flutter_mytech_case/utils/token_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../model/auth_request.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository repository;
  final Ref ref;

  AuthViewModel(this.repository, this.ref) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> fetchUserProfile() async {
    if (!state.isLoggedIn) return;

    try {
      final User profile = await repository.fetchUserProfile();

      state = state.copyWith(userProfile: profile);
      log("👤 Profil bilgileri başarıyla çekildi: ${profile.name}");
    } catch (e) {
      log("🚨 Profil çekme hatası: $e");
      state = state.copyWith(errorMessage: "Profil yüklenemedi: $e");
    }
  }

  Future<void> checkAuthStatus() async {
    final tokenManager = ref.read(tokenManagerProvider);
    final token = await tokenManager.getToken();

    if (token != null) {
      state = state.copyWith(isLoggedIn: true);
      log("✅ Oturum doğrulandı. Token mevcut.");
      await fetchUserProfile();
    } else {
      state = state.copyWith(isLoggedIn: false);
      log("❌ Oturum doğrulanamadı. Token yok.");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

      final request = AuthRequest(email: email.trim(), password: password);

      final response = await repository.login(request);
      final tokenManager = ref.read(tokenManagerProvider);
      if (response.accessToken != null) {
        await tokenManager.saveToken(response.accessToken!);
      }

      log("💡 Login başarılı!");
      log("TOKEN kaydedildi.");
      log("TOKEN: ${response.accessToken}");
      log("USER EMAIL: ${response.user?.email}");

      state = state.copyWith(isLoading: false, errorMessage: null, isLoggedIn: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString(), isLoggedIn: false);
    }
  }

  Future<void> register(String email, String password, String confirmPassword) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
        throw Exception("Geçersiz e-mail adresi formatı.");
      }

      if (password != confirmPassword) {
        throw Exception("Şifreler uyuşmuyor.");
      }

      if (password.length < 6) {
        throw Exception("Şifre en az 6 karakter olmalıdır.");
      }

      final request = AuthRequest(email: email.trim(), password: password);

      final User newUser = await repository.register(request);
      log("$newUser");

      log("🎉 Kayıt başarılı!");

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Kayıt başarılı, lütfen giriş yapın.',
        errorMessage: null,
      );
    } catch (e) {
      log("🚨 Register API Hatası: ${e.runtimeType} - $e");

      String errorMsg;

      if (e.toString().contains('Exception:')) {
        errorMsg = e.toString().replaceFirst('Exception: ', '');
      } else {
        if (e.toString().contains('DioError') || e.toString().contains('40') || e.toString().contains('50')) {
          errorMsg = "API'den hata döndü. Detay: ${e.toString().split(':').last.trim()}";
        } else {
          errorMsg = "Kayıt işlemi sırasında beklenmeyen bir hata oluştu.";
        }
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMsg, successMessage: null);
    }
  }

  Future<void> logout() async {
    await ref.read(tokenManagerProvider).deleteToken();
    state = AuthState(isLoggedIn: false);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

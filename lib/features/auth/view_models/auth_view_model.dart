import 'package:flutter_mytech_case/features/auth/model/login_response.dart';
import 'package:flutter_mytech_case/features/auth/repository/auth_repository.dart';
import 'package:flutter_mytech_case/features/auth/view_models/auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';

// Gerekli Model İçe Aktarımları:
import '../model/login_request.dart';
import '../model/register_request.dart'; // <-- Bunu eklediğinizi varsayıyorum

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthViewModel(this.repository) : super(AuthState());

  // ===================================
  //           LOGIN METODU
  // ===================================

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
      print("USER EMAIL: ${response.user?.email}");

      // Burada token'ı secure storage / hive / shared prefs'e yazabilirsin.
      // ör: await TokenStorage.saveToken(response.accessToken);

      state = state.copyWith(isLoading: false, errorMessage: null, isLoggedIn: true);
    } catch (e) {
      // Hata varsa kullanıcıya gösterilecek
      state = state.copyWith(isLoading: false, errorMessage: e.toString(), isLoggedIn: false);
    }
  }

  //         REGISTER METODU (NAME KALDIRILDI)
  // ===================================

  Future<void> register(
    String email,
    String password,
    String confirmPassword, // Sadece frontend kontrolü için
  ) async {
    try {
      // 1. Loading başlasın ve hata mesajını temizle
      state = state.copyWith(isLoading: true, errorMessage: null);

      // =================================
      //           FRONTEND VALIDASYONLARI
      // =================================

      // A. E-mail Validasyonu (Basit Format Kontrolü)
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
        throw Exception("Geçersiz e-mail adresi formatı.");
      }

      // B. Şifre Eşleşme Validasyonu (Confirm Password kontrolü)
      if (password != confirmPassword) {
        throw Exception("Şifreler uyuşmuyor.");
      }

      // C. Şifre Minimum Uzunluk Validasyonu
      if (password.length < 6) {
        throw Exception("Şifre en az 6 karakter olmalıdır.");
      }

      // Validasyonlar başarılıysa devam et.

      // 2. Register Request modelini oluştur
      // Burada RegisterRequest'e sadece email ve password gönderiliyor.
      final request = RegisterRequest(
        email: email.trim(),
        password: password,
        // Name alanı RegisterRequest modelinde zorunluysa, bu kısım hata verir.
        // name: '', // Eğer name zorunlu ise buraya boş string koymanız gerekebilir.
      );

      // 3. Repository üzerinden API çağrısı
      final User newUser = await repository.register(request);

      // 4. Başarılı kayıt sonrası
      print("🎉 Kayıt başarılı!");

      state = state.copyWith(isLoading: false, errorMessage: 'Kayıt başarılı, lütfen giriş yapın.');
    } catch (e) {
      print("🚨 Register API Hatası: ${e.runtimeType} - $e");

      String errorMsg;

      // 1. Kendi attığımız validasyon hataları
      if (e.toString().contains('Exception:')) {
        errorMsg = e.toString().replaceFirst('Exception: ', '');
      }
      // 2. API veya Ağ bağlantısı hatası
      else {
        // Eğer bir DioError veya benzeri bir API hatası ise
        if (e.toString().contains('DioError') || e.toString().contains('40') || e.toString().contains('50')) {
          // Hatanın API'den gelen detayını çekmeye çalışın
          // Bu kısım, API istemcinizin (örn. Dio) hata yapısına bağlıdır.
          errorMsg = "API'den hata döndü. Detay: ${e.toString().split(':').last.trim()}";
        } else {
          errorMsg = "Kayıt işlemi sırasında beklenmeyen bir hata oluştu.";
        }
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
    }
  }

  // Logout (istersen kullanabilirsin)
  Future<void> logout() async {
    state = AuthState(isLoggedIn: false);
  }
}

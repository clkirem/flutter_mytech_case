import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/features/auth/providers.dart'; // authViewModelProvider buradan gelmeli
import 'package:flutter_mytech_case/features/auth/views/widgets/custom_input_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod importu
import 'package:go_router/go_router.dart';

// 1. ConsumerStatefulWidget olarak değiştirildi
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  // Controller'ları tanımla
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Color primaryColor = Colors.blue;
  final Color backgroundColor = const Color(0xFF101922);
  final Color inputFillColor = const Color(0xFF18212D);
  final Color hintTextColor = const Color(0xFF555D6B);
  final Color errorColor = Colors.red;

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Şifre görünürlüğünü değiştiren metod
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Hata/Bilgi mesajlarını göstermek için yardımcı metod
  void _showSnackBar(String message, {Color color = Colors.red}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Giriş işlemini başlatan metod
  void _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Basit Boş Alan Kontrolü (Daha detaylı validasyon VM içinde)
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Lütfen e-posta ve şifrenizi giriniz.", color: errorColor);
      return;
    }

    // ViewModel'i oku
    final viewModel = ref.read(authViewModelProvider.notifier);

    // Login metodunu çağır
    await viewModel.login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod State Dinleme
    ref.listen(authViewModelProvider, (previous, current) {
      // 1. Başarılı Giriş Kontrolü
      if (current.isLoggedIn && !previous!.isLoggedIn) {
        // Giriş başarılıysa ana sayfaya/haber kaynağına yönlendir.
        context.go('/newssource');
        return;
      }

      // 2. Hata Mesajı Kontrolü
      if (current.errorMessage != null && current.errorMessage != previous?.errorMessage) {
        _showSnackBar(current.errorMessage!, color: errorColor);
      }
    });

    // ViewModel'in loading durumunu al
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),
              Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Sign in or create an account to continue',
                  style: TextStyle(color: hintTextColor, fontSize: 16),
                ),
              ),
              const SizedBox(height: 60),

              // Email Alanı
              CustomInputField(
                label: 'Email Address',
                hintText: 'Enter your email',
                inputFillColor: inputFillColor,
                hintTextColor: hintTextColor,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Şifre Alanı
              CustomInputField(
                label: 'Password',
                hintText: 'Enter your password',
                inputFillColor: inputFillColor,
                hintTextColor: hintTextColor,
                // Görünürlük durumuna göre obscureText ayarı
                isPassword: !_isPasswordVisible,
                controller: _passwordController,
                // Şifre görünürlüğü simgesi
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: hintTextColor),
                  onPressed: _togglePasswordVisibility,
                ),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Şifremi Unuttum sayfasına git
                    // context.push('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Sign In Butonu (Giriş Yap)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  // Loading ise butonu devre dışı bırak
                  onPressed: isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    disabledBackgroundColor: primaryColor.withOpacity(0.5),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Butonu (Kayıt Ol)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    // Kayıt sayfasına yönlendir (Geri dönüşü sağlamak için push)
                    context.push('/register');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: inputFillColor,
                    side: BorderSide(color: hintTextColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

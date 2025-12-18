import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/features/auth/providers.dart';
import 'package:flutter_mytech_case/features/auth/views/widgets/custom_input_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Color primaryColor = Colors.blue;
  final Color backgroundColor = const Color(0xFF101922);
  final Color inputFillColor = const Color(0xFF18212D);
  final Color hintTextColor = const Color(0xFF555D6B);
  final Color errorColor = Colors.red;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    _emailController.text;
    _passwordController.text;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

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

  void _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Lütfen e-posta ve şifrenizi giriniz.", color: errorColor);
      return;
    }

    final viewModel = ref.read(authViewModelProvider.notifier);

    await viewModel.login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, current) {
      if (current.isLoggedIn && !previous!.isLoggedIn) {
        context.go('/newssource');
        return;
      }

      if (current.errorMessage != null && current.errorMessage != previous?.errorMessage) {
        _showSnackBar(current.errorMessage!, color: errorColor);
      }
    });

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

              CustomInputField(
                label: 'Email Address',
                hintText: 'Enter your email',
                inputFillColor: inputFillColor,
                hintTextColor: hintTextColor,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              CustomInputField(
                label: 'Password',
                hintText: 'Enter your password',
                inputFillColor: inputFillColor,
                hintTextColor: hintTextColor,

                isPassword: !_isPasswordVisible,
                controller: _passwordController,

                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: hintTextColor),
                  onPressed: _togglePasswordVisibility,
                ),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
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

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/');
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

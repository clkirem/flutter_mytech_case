import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/features/auth/providers.dart';

import 'package:flutter_mytech_case/features/auth/views/widgets/custom_input_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _passwordsMatchError = false;

  final Color primaryColor = Colors.blue;
  final Color backgroundColor = const Color(0xFF101922);
  final Color inputFillColor = const Color(0xFF18212D);
  final Color hintTextColor = const Color(0xFF555D6B);
  final Color errorColor = Colors.red;

  @override
  void initState() {
    _passwordController.addListener(_checkPasswordMatch);
    _confirmPasswordController.addListener(_checkPasswordMatch);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordMatch() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    bool shouldShowError = confirmPassword.isNotEmpty && (password != confirmPassword);

    if (_passwordsMatchError != shouldShowError) {
      setState(() {
        _passwordsMatchError = shouldShowError;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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

  void _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      _showSnackBar("Geçersiz e-mail adresi formatı.");
    }

    if (password.length < 6) {
      _showSnackBar("Şifre en az 6 karakter olmalıdır.");
    }

    if (_passwordsMatchError) {
      _showSnackBar("Şifreler uyuşmuyor.", color: errorColor);
      return;
    }

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("Lütfen tüm alanları doldurunuz.", color: errorColor);
      return;
    }

    final viewModel = ref.read(authViewModelProvider.notifier);
    await viewModel.register(email, password, confirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, current) {
      if (current.successMessage != null && current.successMessage != previous?.successMessage) {
        _showSnackBar(current.successMessage!, color: Colors.green);
        context.go('/login');
      }

      if (current.errorMessage != null && current.errorMessage != previous?.errorMessage) {
        _showSnackBar(current.errorMessage!, color: errorColor);
      }
    });
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  'Create Your Account',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Join us to get the latest news updates.', style: TextStyle(color: hintTextColor, fontSize: 13)),
                const SizedBox(height: 40),

                CustomInputField(
                  label: 'Email',
                  hintText: 'you@example.com',
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
                const SizedBox(height: 20),

                CustomInputField(
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  inputFillColor: inputFillColor,
                  hintTextColor: hintTextColor,

                  isPassword: !_isConfirmPasswordVisible,
                  hasError: _passwordsMatchError,
                  controller: _confirmPasswordController,
                  errorColor: errorColor,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: hintTextColor,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 8),

                if (_passwordsMatchError)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        Text(
                          'Passwords do not match.',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: errorColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: _passwordsMatchError ? 30 : 50),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading || _passwordsMatchError ? null : _registerUser,
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
                            'Create Account',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 40),

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'By creating an account, you agree to our ',
                      style: TextStyle(color: hintTextColor, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: hintTextColor, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push('/login');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

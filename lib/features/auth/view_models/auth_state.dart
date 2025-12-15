import 'package:flutter_mytech_case/features/auth/model/auth_response.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? errorMessage;
  final String? successMessage;
  final User? userProfile;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.errorMessage,
    this.successMessage,
    this.userProfile,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? errorMessage,
    String? successMessage,
    User? userProfile,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage,
      successMessage: successMessage,
      userProfile: userProfile ?? userProfile,
    );
  }
}

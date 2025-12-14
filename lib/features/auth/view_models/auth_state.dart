class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? errorMessage;
  final String? successMessage;

  AuthState({this.isLoading = false, this.isLoggedIn = false, this.errorMessage, this.successMessage});

  AuthState copyWith({bool? isLoading, bool? isLoggedIn, String? errorMessage, String? successMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

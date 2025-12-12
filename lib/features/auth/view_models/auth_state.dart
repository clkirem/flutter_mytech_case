class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.isLoggedIn = false, this.errorMessage});

  AuthState copyWith({bool? isLoading, bool? isLoggedIn, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage,
    );
  }
}

import 'package:flutter_mytech_case/core/di/core_provider.dart';
import 'package:flutter_mytech_case/features/auth/repository/auth_repository.dart';
import 'package:flutter_mytech_case/features/auth/view_models/auth_state.dart';
import 'package:flutter_mytech_case/features/auth/view_models/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AuthRepository(api);
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthViewModel(repo, ref);
});

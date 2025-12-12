import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Eğer auth guard kullanacaksan provider buraya gelecek
final routerProvider = Provider<GoRouter>((ref) {
  // AuthState okumak:
  // final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      // GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
      // GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomePage()),
    ],

    // Eğer auth guard istersen:
    // redirect: (context, state) {
    //   final loggedIn = ref.read(authViewModelProvider).isLoggedIn;
    //
    //   final loggingIn = state.matchedLocation == '/login';
    //
    //   if (!loggedIn) {
    //     return loggingIn ? null : '/login';
    //   }
    //
    //   if (loggedIn && loggingIn) {
    //     return '/home';
    //   }
    //
    //   return null;
    // },
  );
});

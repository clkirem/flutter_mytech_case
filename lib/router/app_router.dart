import 'package:flutter_mytech_case/features/news/views/home/views/home_screen.dart';
import 'package:flutter_mytech_case/features/auth/views/login_screen.dart';
import 'package:flutter_mytech_case/features/auth/views/register_screen.dart';
import 'package:flutter_mytech_case/features/category_news/views/category_news_screen.dart';
import 'package:flutter_mytech_case/features/news_source/views/news_source_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/', name: 'register', builder: (context, state) => const CreateAccountScreen()),
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/newssource', name: 'newssource', builder: (context, state) => const SelectNewsSourcesScreen()),
      GoRoute(path: '/home', name: 'home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/category', name: 'category', builder: (context, state) => CategoryNewsScreen()),
    ],
  );
});

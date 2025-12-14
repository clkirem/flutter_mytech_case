import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/di/cache_provider.dart';
import 'package:flutter_mytech_case/router/app_router.dart';
import 'package:flutter_mytech_case/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cacheManager = await CacheManager.init();

  runApp(
    ProviderScope(
      overrides: [cacheManagerProvider.overrideWithValue(AsyncValue.data(cacheManager))],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        return Container(color: Colors.black, child: child);
      },
      theme: ThemeData(
        useSystemColors: false,
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, background: Colors.white),
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}

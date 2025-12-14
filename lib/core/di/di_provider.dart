import 'package:dio/dio.dart';
import 'package:flutter_mytech_case/core/config/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mytech_case/core/network/auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(baseUrl: Env.baseUrl, headers: {"Content-Type": "application/json", "x-api-key": Env.apiKey}),
  );

  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
});

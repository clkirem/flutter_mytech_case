import 'package:dio/dio.dart';
import 'package:flutter_mytech_case/core/config/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(baseUrl: Env.baseUrl, headers: {"Content-Type": "application/json", "x-api-key": Env.apiKey}),
  );

  return dio;
});

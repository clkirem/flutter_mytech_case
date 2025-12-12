import 'package:flutter_mytech_case/core/di/di_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

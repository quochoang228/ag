import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../api_gateway.dart';

class AgDi {
  // Khởi tạo GetIt
  final getIt = GetIt.instance;

  void setup({
    required Future<String?> Function() getAccessToken,
    required Connectivity connectivity,
    required void Function(String event, Map<String, dynamic> data) onTrack,
    required Dio dio,
    required Function() onTokenExpired,
    Future<String?> Function()? refreshAccessToken,
    int? maxRequests,
    Duration? rateLimitDuration,
    Duration? cacheDuration,
    int? failureThreshold,
    Duration? circuitResetTimeout,
  }) {
    getIt.registerLazySingleton<ApiGateway>(
      () => ApiGateway(
        dio: dio,
        getAccessToken: getAccessToken,
        onTokenExpired: onTokenExpired,
        connectivity: connectivity,
        onTrack: onTrack,
        cacheDuration: cacheDuration,
        refreshAccessToken: refreshAccessToken,
        maxRequests: maxRequests,
        rateLimitDuration: rateLimitDuration,
        failureThreshold: failureThreshold,
        circuitResetTimeout: circuitResetTimeout,
      ),
    );
  }
}

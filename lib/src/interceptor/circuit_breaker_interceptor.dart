import 'dart:async';

import 'package:dio/dio.dart';

class CircuitBreakerInterceptor extends Interceptor {
  final int failureThreshold;
  final Duration resetTimeout;
  int _failureCount = 0;
  bool _circuitOpen = false;
  Timer? _resetTimer;

  CircuitBreakerInterceptor(
      {this.failureThreshold = 3,
      this.resetTimeout = const Duration(seconds: 30)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_circuitOpen) {
      handler.reject(DioException(
        requestOptions: options,
        message: "⛔ Circuit Breaker is OPEN - API temporarily unavailable",
        type: DioExceptionType.badResponse,
      ));
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _resetFailureCount();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _failureCount++;
    if (_failureCount >= failureThreshold) {
      _openCircuit();
    }
    handler.next(err);
  }

  void _openCircuit() {
    if (!_circuitOpen) {
      _circuitOpen = true;
      print(
          "⚠️ Circuit Breaker is OPEN - Blocking requests for ${resetTimeout.inSeconds} seconds");

      _resetTimer?.cancel();
      _resetTimer = Timer(resetTimeout, _closeCircuit);
    }
  }

  void _closeCircuit() {
    _circuitOpen = false;
    _resetFailureCount();
    print("✅ Circuit Breaker is CLOSED - Requests are now allowed");
  }

  void _resetFailureCount() {
    _failureCount = 0;
  }
}

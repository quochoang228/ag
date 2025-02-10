

import 'package:dio/dio.dart';

import '../utils/rate_limiter.dart';

class RateLimiterInterceptor extends Interceptor {
  final RateLimiter rateLimiter;

  RateLimiterInterceptor({required int maxRequests, required Duration duration})
      : rateLimiter = RateLimiter(maxRequests: maxRequests, duration: duration);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!rateLimiter.allow(options.path)) {
      return handler.reject(DioException(requestOptions: options, error: "Rate limit exceeded"));
    }
    handler.next(options);
  }
}

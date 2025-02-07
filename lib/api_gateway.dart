import 'package:ag/src/interceptor/connectivity_interceptor.dart';
import 'package:pub/pub.dart';

import 'src/interceptor/auth_interceptor.dart';
import 'src/interceptor/cache_interceptor.dart';
import 'src/interceptor/circuit_breaker_interceptor.dart';
import 'src/interceptor/log_interceptor.dart';
import 'src/interceptor/rate_limiter_interceptor.dart';
import 'src/interceptor/retry_interceptor.dart';
import 'src/utils/event_tracker.dart';

export 'src/di/ag_di.dart';
export 'src/interceptor/auth_interceptor.dart';
export 'src/interceptor/cache_interceptor.dart';
export 'src/interceptor/circuit_breaker_interceptor.dart';
export 'src/interceptor/connectivity_interceptor.dart';
export 'src/interceptor/log_interceptor.dart';
export 'src/interceptor/rate_limiter_interceptor.dart';
export 'src/interceptor/retry_interceptor.dart';
export 'src/utils/cache_manager.dart';
export 'src/utils/event_tracker.dart';
export 'src/utils/rate_limiter.dart';
export 'package:ag/api_gateway.dart';
/// ApiGateway handles HTTP requests with built-in interceptors for auth, caching
/// rate limiting, circuit breaking, and request tracking.
class ApiGateway {
  final Dio _dio;
  final EventTracker _eventTracker;

  ApiGateway({
    required Future<String?> Function() getAccessToken,
    required Connectivity connectivity,
    required void Function(String event, Map<String, dynamic> data) onTrack,
    Future<String?> Function()? refreshAccessToken,
    int? maxRequests = 10,
    Duration? rateLimitDuration = const Duration(seconds: 60),
    Duration? cacheDuration = const Duration(minutes: 5),
    int? failureThreshold = 3,
    Duration? circuitResetTimeout = const Duration(seconds: 30),
  })  : _dio = Dio(),
        _eventTracker = EventTracker(onTrack: onTrack) {
    _dio.interceptors.addAll(
      [
        LoggingInterceptor(),
        AuthInterceptor(
          getAccessToken: getAccessToken,
          refreshAccessToken: refreshAccessToken,
        ),
        RateLimiterInterceptor(
          maxRequests: maxRequests!,
          duration: rateLimitDuration!,
        ),
        CacheInterceptor(cacheDuration: cacheDuration!),
        RetryInterceptor(dio: _dio),
        CircuitBreakerInterceptor(
          failureThreshold: failureThreshold!,
          resetTimeout: circuitResetTimeout!,
        ),
        ConnectivityInterceptor(connectivity),
      ],
    );
  }

  /// Generic method to handle HTTP requests and track events
  Future<Response<T>> _request<T>(
    String path,
    String method,
    Future<Response<T>> Function() requestFn,
  ) async {
    _eventTracker.trackRequest(path, method: method);
    try {
      final response = await requestFn();
      _eventTracker.trackSuccess(path, response.statusCode ?? 200);
      return response;
    } catch (e) {
      _eventTracker.trackError(path, e.toString());
      rethrow;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request(
        path,
        'GET',
        () => _dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request(
        path,
        'POST',
        () => _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request(
        path,
        'PUT',
        () => _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _request(
        path,
        'DELETE',
        () => _dio.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );
}

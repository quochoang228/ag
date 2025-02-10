import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'ag.dart';
import 'src/interceptor/curl_interceptor.dart';

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
        CurlLoggerDioInterceptor(),
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

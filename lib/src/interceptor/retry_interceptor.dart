import 'package:logs/logs.dart';
import 'package:pub/pub.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    var retryCount = 0;

    // Only retry on network errors or 5xx server errors
    if (_shouldRetry(err) && retryCount < maxRetries) {
      for (var delay in retryDelays) {
        LogUtils.d(
            '🔄 [Retry] Attempt $retryCount/$maxRetries for ${err.requestOptions.uri}',
            tag: 'RetryInterceptor');

        try {
          retryCount++;
          await Future.delayed(delay);

          // Retry the request
          final response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
          );

          return handler.resolve(response);
        } on DioException catch (e) {
          err = e;
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.unknown ||
        (error.response?.statusCode ?? 0) >= 500;
  }
}

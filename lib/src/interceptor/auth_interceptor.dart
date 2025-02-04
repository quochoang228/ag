
import 'package:pub/pub.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function()? refreshAccessToken;

  AuthInterceptor({
    required this.getAccessToken,
    this.refreshAccessToken,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && refreshAccessToken != null) {
      final newToken = await refreshAccessToken!();
      if (newToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        try {
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(err);
        }
      }
    }
    handler.reject(err);
  }
}

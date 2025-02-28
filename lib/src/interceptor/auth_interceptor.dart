import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function()? refreshAccessToken;
  final Function() onTokenExpired;
  String? _token;

  AuthInterceptor({
    required this.getAccessToken,
    required this.onTokenExpired,
    this.refreshAccessToken,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _token ?? await getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (refreshAccessToken != null) {
        final newToken = await refreshAccessToken!();
        if (newToken != null) {
          _token = newToken;
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          try {
            final response = await Dio().fetch(err.requestOptions);
            return handler.resolve(response);
          } catch (e) {
            return handler.reject(err);
          }
        } else {
          onTokenExpired();
        }
      } else {
        onTokenExpired();
      }
    }
    handler.reject(err);
  }

  void updateToken(String newToken) {
    _token = newToken;
  }
}

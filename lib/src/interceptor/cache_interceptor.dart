import 'package:dio/dio.dart';

import '../utils/cache_manager.dart';

class CacheInterceptor extends Interceptor {
  final CacheManager cacheManager;

  CacheInterceptor({Duration cacheDuration = const Duration(minutes: 5)})
      : cacheManager = CacheManager(cacheDuration: cacheDuration);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cachedResponse = cacheManager.get(options);
    if (cachedResponse != null) {
      return handler.resolve(cachedResponse);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    cacheManager.save(response.requestOptions, response);
    handler.next(response);
  }
}

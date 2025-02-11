import 'dart:collection';

import 'package:dio/dio.dart';

class CacheManager {
  final Map<String, Response> _cache = HashMap<String, Response>();
  final Duration cacheDuration;

  CacheManager({this.cacheDuration = const Duration(minutes: 5)});

  String _getCacheKey(RequestOptions options) {
    return "${options.method}-${options.uri.toString()}";
  }

  Response? get(RequestOptions options) {
    final key = _getCacheKey(options);
    final response = _cache[key];
    if (response != null && DateTime.now().difference(DateTime.parse(response.headers.value('date') ?? DateTime.now().toString())) < cacheDuration) {
      return response;
    }
    return null;
  }

  void save(RequestOptions options, Response response) {
    final key = _getCacheKey(options);
    _cache[key] = response;
  }
}

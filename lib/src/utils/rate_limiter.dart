import 'dart:collection';

class RateLimiter {
  final int maxRequests;
  final Duration duration;
  final Queue<DateTime> _timestamps = Queue<DateTime>();

  RateLimiter({required this.maxRequests, required this.duration});

  bool allow(String endpoint) {
    final now = DateTime.now();
    _timestamps.removeWhere((time) => now.difference(time) > duration);

    if (_timestamps.length >= maxRequests) {
      return false;
    }

    _timestamps.add(now);
    return true;
  }
}

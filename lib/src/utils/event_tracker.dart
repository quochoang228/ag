class EventTracker {
  final void Function(String event, Map<String, dynamic> data) onTrack;

  EventTracker({required this.onTrack});

  void trackRequest(String endpoint, {String method = "GET"}) {
    onTrack("API_REQUEST", {"endpoint": endpoint, "method": method});
  }

  void trackSuccess(String endpoint, int statusCode) {
    onTrack("API_SUCCESS", {"endpoint": endpoint, "status": statusCode});
  }

  void trackError(String endpoint, String errorMessage) {
    onTrack("API_ERROR", {"endpoint": endpoint, "error": errorMessage});
  }
}

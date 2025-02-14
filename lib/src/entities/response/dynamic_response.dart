class DynamicResponse {
  final String? message;

  final int? status;

  final String? clientMessageId;

  final List<String>? errors;

  final String? type;

  dynamic data;

  DynamicResponse({
    this.status,
    this.message,
    this.clientMessageId,
    this.errors,
    this.type,
    this.data,
  });

  factory DynamicResponse.fromJson(Map<String, dynamic> json) {
    return DynamicResponse(
      status: json['status'],
      message: json['message'],
      clientMessageId: json['clientMessageId'],
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : <String>[],
      type: json['type'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'clientMessageId': clientMessageId,
      'errors': errors,
      'type': type,
      'data': data,
    };
  }
}

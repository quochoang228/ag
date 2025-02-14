class BaseResponse<T> {
  final dynamic metadata;
  final String? message;
  final String? status;
  final T? data;

  BaseResponse({this.metadata, this.message, this.status, this.data});

  Map<String, dynamic> toMap() {
    return {
      'metadata': this.metadata,
      'message': this.message,
      'status': this.status,
      'data': this.data,
    };
  }

  factory BaseResponse.fromMap(Map<String, dynamic> map) {
    return BaseResponse<T>(
      metadata: map['metadata'] as dynamic,
      message: map['message'] as String?,
      status: map['status'] as String?,
      data: map['data'] as T?,
    );
  }
}

class ListDataResponse<T> {
  List<T>? data;
  final int? status;
  final String? message;
  final bool? success;
  final int? total;
  final int? page;
  final int? pageSize;

  ListDataResponse({
    this.data,
    this.status,
    this.message,
    this.success,
    this.total,
    this.page,
    this.pageSize,
  });

  factory ListDataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ListDataResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ListDataResponseToJson(this, toJsonT);
}

ListDataResponse<T> _$ListDataResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ListDataResponse<T>(
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
      status: json['status'] as int?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
      total: json['total'] as int?,
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
    );

Map<String, dynamic> _$ListDataResponseToJson<T>(
  ListDataResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data?.map(toJsonT).toList(),
      'status': instance.status,
      'message': instance.message,
      'success': instance.success,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

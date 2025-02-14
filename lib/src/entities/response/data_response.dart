class DataResponse<T> {
  final String? message;

  final int? status;

  final String? type;

  T? data;

  DataResponse(
    this.status,
    this.message,
    this.type,
    this.data,
  );

  factory DataResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$DataResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$DataResponseToJson<T>(this, toJsonT);
}

DataResponse<T> _$DataResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    DataResponse<T>(
      (json['status'] as num?)?.toInt(),
      json['message'] as String?,
      json['type'] as String?,
      _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$DataResponseToJson<T>(
  DataResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'type': instance.type,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

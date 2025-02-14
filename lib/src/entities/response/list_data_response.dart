class ListDataResponse<T> {
  List<T>? data;
  final int? total;
  final int? page;
  final int? pageSize;

  ListDataResponse({
    this.data,
    this.total,
    this.page,
    this.pageSize,
  });

  factory ListDataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ListDataResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ListDataResponseToJson(this, toJsonT);
}

ListDataResponse<T> _$ListDataResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ListDataResponse<T>(
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
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
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

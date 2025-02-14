// class BasePagingResponse<T> {
//   final List<T>? content;

//   final Pageable? pageable;

//   final int? totalElements;

//   final int? totalPages;

//   final bool? last;

//   final int? size;

//   final int? number;

//   final Sort? sort;

//   final bool? first;

//   final int? numberOfElements;

//   final bool? empty;

//   BasePagingResponse({
//     this.content,
//     this.pageable,
//     this.totalElements,
//     this.totalPages,
//     this.last,
//     this.size,
//     this.number,
//     this.sort,
//     this.first,
//     this.numberOfElements,
//     this.empty,
//   });

//   factory BasePagingResponse.fromJson(Map<String, dynamic> json) {
//     return BasePagingResponse(
//       content: json['content'] != null
//           ? (json['content'] as List).map((i) => T.fromJson(i)).toList()
//           : null,
//       pageable: json['pageable'] != null
//           ? Pageable.fromJson(json['pageable'])
//           : null,
//       totalElements: json['totalElements'],
//       totalPages: json['totalPages'],
//       last: json['last'],
//       size: json['size'],
//       number: json['number'],
//       sort: json['sort'] != null ? Sort.fromJson(json['sort']) : null,
//       first: json['first'],
//       numberOfElements: json['numberOfElements'],
//       empty: json['empty'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'name': name,
//     };
//   }
// }

// class Pageable {
//   final int? pageNumber;

//   final int? pageSize;

//   final Sort? sort;

//   final int? offset;

//   final bool? paged;

//   final bool? unpaged;

//   Pageable({
//     this.pageNumber,
//     this.pageSize,
//     this.sort,
//     this.offset,
//     this.paged,
//     this.unpaged,
//   });

//   factory Pageable.fromJson(Map<String, dynamic> json) =>
//       _$PageableFromJson(json);

//   Map<String, dynamic> toJson() => _$PageableToJson(this);
// }

// class Sort {
//   final bool? empty;

//   final bool? sorted;

//   final bool? unsorted;

//   Sort({
//     this.empty,
//     this.sorted,
//     this.unsorted,
//   });

//   factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

//   Map<String, dynamic> toJson() => _$SortToJson(this);
// }

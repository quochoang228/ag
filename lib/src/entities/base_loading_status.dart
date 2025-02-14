

import 'loading_data_enum.dart';

class BaseLoadingStatus<T> {
  final LoadDataStatus? status;
  final String? message;
  final T? data;

  BaseLoadingStatus({
    this.message,
    this.status,
    this.data,
  });
}

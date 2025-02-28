/// Enum biểu diễn các trạng thái dữ liệu
enum CurrentDataState {
  notLoaded,
  loading,
  fetched,
  noData,
  failed,
}

/// Extension để thêm các getter tiện lợi cho enum
extension CurrentDataStateX on CurrentDataState {
  bool get isNotLoaded => this == CurrentDataState.notLoaded;
  bool get isLoading => this == CurrentDataState.loading;
  bool get isFetched => this == CurrentDataState.fetched;
  bool get isNoData => this == CurrentDataState.noData;
  bool get isFailed => this == CurrentDataState.failed;
}

/// Lớp sealed chính để quản lý trạng thái dữ liệu.
/// [T] là kiểu dữ liệu (dùng trong NotLoaded, Loading, Fetched, NoData).
/// [E] là kiểu lỗi (dùng trong Failed).
sealed class DataState<T, E> {
  DataState({required this.state});

  final CurrentDataState state;

  /// Phương thức match để xử lý từng trạng thái.
  R match<R>({
    required R Function(NotLoaded<T>) notLoaded,
    required R Function(Loading<T>) loading,
    required R Function(Fetched<T>) fetched,
    required R Function(NoData<T>) noData,
    required R Function(Failed<E>) failed,
  }) {
    // Ép kiểu rõ ràng để đảm bảo tính đầy đủ
    final self = this;
    return switch (self) {
      NotLoaded<T> s => notLoaded(s),
      Loading<T> s => loading(s),
      Fetched<T> s => fetched(s),
      NoData<T> s => noData(s),
      Failed<E> s => failed(s),
    // Nếu Dart vẫn phàn nàn về exhaustiveness, thêm trường hợp mặc định
      _ => throw UnimplementedError('Trạng thái không được xử lý: $self'),
    };
  }
}

/// Trạng thái chưa tải dữ liệu, chỉ dùng T
class NotLoaded<T> extends DataState<T, Never> {
  NotLoaded() : super(state: CurrentDataState.notLoaded);
}

/// Trạng thái đang tải dữ liệu, chỉ dùng T
class Loading<T> extends DataState<T, Never> {
  Loading() : super(state: CurrentDataState.loading);
}

/// Trạng thái đã tải dữ liệu thành công, chỉ dùng T
class Fetched<T> extends DataState<T, Never> {
  Fetched(this.data) : super(state: CurrentDataState.fetched);

  final T data;

  T get value => data;
}

/// Trạng thái không có dữ liệu, chỉ dùng T
class NoData<T> extends DataState<T, Never> {
  NoData() : super(state: CurrentDataState.noData);
}

/// Trạng thái thất bại với lỗi, chỉ dùng E
class Failed<E> extends DataState<Never, E> {
  Failed(this.err) : super(state: CurrentDataState.failed);

  final E err;

  E get error => err;
}



///--------------


// sealed class DataSate<T> {
//   DataSate({required this.state, this.error, this.valueOrNull});
//
//   T? valueOrNull;
//   Object? error;
//   CurrentDataState state;
//
//   T get value => valueOrNull!;
//
//   R onState<R>({
//     required R Function() notLoaded,
//     required R Function() loading,
//     required R Function(T data) fetched,
//     required R Function() noData,
//     required R Function(Object error) failed,
//   }) {
//     if (state.isNotLoaded) {
//       return notLoaded();
//     } else if (state.isLoading) {
//       return loading();
//     } else if (state.isFetched) {
//       return fetched(valueOrNull as T);
//     }  else if (state.isNoData) {
//       return noData();
//     } else {
//       return failed(error!);
//     }
//   }
// }
//
// class NotLoaded<T> extends DataSate<T> {
//   NotLoaded() : super(state: CurrentDataState.notLoaded);
// }
//
// class Loading<T> extends DataSate<T> {
//   Loading() : super(state: CurrentDataState.loading);
// }
//
// class Fetched<T> extends DataSate<T> {
//   final T data;
//
//   Fetched(this.data) : super(state: CurrentDataState.fetched, valueOrNull: data);
// }
//
// class NoData<T> extends DataSate<T> {
//   NoData() : super(state: CurrentDataState.noData);
// }
//
// class Failed<T> extends DataSate<T> {
//   final Object err;
//
//   Failed(this.err) : super(state: CurrentDataState.failed, error: err);
// }
//
// enum CurrentDataState {
//   notLoaded,
//   loading,
//   fetched,
//   noData,
//   failed;
//
//   bool get isNotLoaded => this == CurrentDataState.notLoaded;
//
//   bool get isLoading => this == CurrentDataState.loading;
//
//   bool get isFetched => this == CurrentDataState.fetched;
//
//   bool get isNoData => this == CurrentDataState.noData;
//
//   bool get isFailed => this == CurrentDataState.failed;
// }

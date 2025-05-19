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

  /// Getter để lấy dữ liệu, chỉ hợp lệ nếu trạng thái là `Fetched`
  T? get data {
    if (this is Fetched<T>) {
      return (this as Fetched<T>).data;
    }
    return null;
    // throw StateError("Không thể lấy dữ liệu từ trạng thái $runtimeType");
  }

  /// Getter để lấy lỗi, chỉ hợp lệ nếu trạng thái là `Failed`
  E get error {
    if (this is Failed<E>) {
      return (this as Failed<E>).err;
    }
    throw StateError("Không thể lấy lỗi từ trạng thái $runtimeType");
  }

  /// Phương thức `when()` để xử lý trạng thái một cách linh hoạt hơn
  R when<R>({
    R Function()? notLoaded,
    R Function()? loading,
    required R Function(T data) fetched,
    R Function()? noData,
    required R Function(E error) failed,
  }) {
    return switch (this) {
      NotLoaded<T> _ => notLoaded?.call() ?? (throw UnimplementedError()),
      Loading<T> _ => loading?.call() ?? (throw UnimplementedError()),
      Fetched<T> s => fetched(s.data),
      NoData<T> _ => noData?.call() ?? (throw UnimplementedError()),
      Failed<E> s => failed(s.err),
      _ => throw UnimplementedError('Trạng thái không được xử lý: $this'),
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

  @override
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

  @override
  E get error => err;
}

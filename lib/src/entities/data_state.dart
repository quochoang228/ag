sealed class DataSate<T> {
  DataSate({required this.state, this.error, this.valueOrNull});

  T? valueOrNull;
  Object? error;
  CurrentDataState state;

  T get value => valueOrNull!;

  R onState<R>({
    required R Function() notLoaded,
    required R Function() loading,
    required R Function(T data) fetched,
    required R Function() noData,
    required R Function(Object error) failed,
  }) {
    if (state.isNotLoaded) {
      return notLoaded();
    } else if (state.isLoading) {
      return loading();
    } else if (state.isFetched) {
      return fetched(valueOrNull as T);
    }  else if (state.isNoData) {
      return noData();
    } else {
      return failed(error!);
    }
  }
}

class NotLoaded<T> extends DataSate<T> {
  NotLoaded() : super(state: CurrentDataState.notLoaded);
}

class Loading<T> extends DataSate<T> {
  Loading() : super(state: CurrentDataState.loading);
}

class Fetched<T> extends DataSate<T> {
  final T data;

  Fetched(this.data) : super(state: CurrentDataState.fetched, valueOrNull: data);
}

class NoData<T> extends DataSate<T> {
  NoData() : super(state: CurrentDataState.noData);
}

class Failed<T> extends DataSate<T> {
  final Object err;

  Failed(this.err) : super(state: CurrentDataState.failed, error: err);
}

enum CurrentDataState {
  notLoaded,
  loading,
  fetched,
  noData,
  failed;

  bool get isNotLoaded => this == CurrentDataState.notLoaded;

  bool get isLoading => this == CurrentDataState.loading;

  bool get isFetched => this == CurrentDataState.fetched;

  bool get isNoData => this == CurrentDataState.noData;

  bool get isFailed => this == CurrentDataState.failed;
}

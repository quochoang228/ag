import 'package:dio/dio.dart';

sealed class BaseResult<T> with SealedResult<T> {
  bool get isSuccessful => this is BaseSuccess<T>;

  BaseResult<T> transform({
    required T Function(T)? success,
    BaseError<T> Function(BaseError<T>)? error,
  }) {
    if (this is BaseSuccess<T> && success != null) {
      (this as BaseSuccess<T>).data =
          success.call((this as BaseSuccess<T>).data);
    }
    if (this is BaseError<T> && error != null) {
      return error.call(this as BaseError<T>);
    }
    return this;
  }

  T? getData() {
    final state = this;
    if (state is BaseSuccess<T>) {
      return state.data;
    } else {
      return null;
    }
  }
}

class BaseSuccess<T> extends BaseResult<T> {
  T data;

  BaseSuccess(this.data);
}

class BaseError<T> extends BaseResult<T> {
  DioExceptionType type;
  String message;
  int? statusCode = 0;

  BaseError(this.type, this.message, {this.statusCode});
}

class BaseLoading<T> extends BaseResult<T> {
  BaseLoading();
}

class Init<T> extends BaseResult<T> {
  Init();
}

mixin SealedResult<T> {
  R? when<R>({
    R Function(T)? success,
    R Function(BaseError)? error,
  }) {
    if (this is BaseSuccess<T>) {
      return success?.call((this as BaseSuccess).data);
    }
    if (this is BaseError<T>) {
      return error?.call(this as BaseError);
    }
    throw Exception(
        'If you got here, probably you forgot to regenerate the classes? '
        'Try running flutter packages pub run build_runner build');
  }
}

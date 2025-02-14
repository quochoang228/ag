import 'package:dio/dio.dart';
import 'base_exception.dart';
import 'base_result.dart';

typedef ResponseToModel<Model> = Model Function(dynamic);

abstract class BaseRepository {
  Future<BaseResult<Model>> safeApiCall<Model>(
    Future<Response> call, {
    required ResponseToModel<Model> mapper,
  }) async {
    try {
      var response = await call;
      try {
        return BaseSuccess<Model>(mapper.call(response.data));
      } catch (e) {
        return BaseError(
          DioExceptionType.unknown,
          'Lỗi mapper dữ liệu',
          statusCode: -1,
        );
      }
    } on Exception catch (exception) {
      if (exception is DioException) {
        switch (exception.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            return BaseError(DioExceptionType.badCertificate,
                exception.response?.data["message"] ?? 'Connection Timeout');
          case DioExceptionType.cancel:
          case DioExceptionType.badCertificate:
            return BaseError(DioExceptionType.badCertificate,
                exception.response?.data["message"] ?? 'BadCertificate');
          case DioExceptionType.badResponse:
            return BaseError(DioExceptionType.badResponse,
                exception.response?.data["message"] ?? 'BadResponse',
                statusCode: exception.response?.statusCode);

          case DioExceptionType.connectionError:
            return BaseError(
              DioExceptionType.connectionError,
              exception.response?.data["message"] ??
                  'Hãy kiểm tra kết nối mạng của bạn!',
            );

          case DioExceptionType.unknown:
            return BaseError(DioExceptionType.connectionError,
                exception.response?.data["message"] ?? 'Lỗi không xác định!');
        }
      }
      if (exception is BaseException) {
        return BaseError(DioExceptionType.unknown, exception.message);
      }
      return BaseError(DioExceptionType.unknown, "Xảy ra lỗi, hãy thử lại!");
    }
  }
}

import 'package:logs/logs.dart';
import 'package:pub/pub.dart';

class LoggingInterceptor extends Interceptor {
  DateTime? startTime;
  DateTime? endTime;

  static const String httpTAG = 'HTTP - LOG';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    startTime = DateTime.now();
    LogUtils.d(' ', tag: httpTAG);
    LogUtils.d(
      '------------------- Start -------------------',
      tag: httpTAG,
    );
    if (options.queryParameters.isEmpty) {
      LogUtils.d(
        'Request Url         : '
        '${options.method}'
        ' '
        '${options.baseUrl}'
        '${options.path}',
        tag: httpTAG,
      );
    } else {
      LogUtils.d(
        'Request Url         : '
        '${options.method}  '
        '${options.baseUrl}${options.path}?'
        '${Transformer.urlEncodeMap(options.queryParameters)}',
        tag: httpTAG,
      );
    }
    LogUtils.d(
      'Request ContentType : ${options.contentType}',
      tag: httpTAG,
    );
    if (options.data != null) {
      LogUtils.d(
        'Request Data        : ${options.data.toString()}',
        tag: httpTAG,
      );
    }
    LogUtils.d(
      'Request Headers     : ${options.headers.toString()}',
      tag: httpTAG,
    );
    LogUtils.d('--', tag: httpTAG);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    endTime = DateTime.now();
    final int duration =
        endTime!.difference(startTime ?? DateTime.now()).inMilliseconds;
    LogUtils.d(
      'Response_Code       : ${response.statusCode}',
      tag: httpTAG,
    );
    // 输出结果
    LogUtils.d(
      'Response_Data       : ${response.data.toString()}',
      tag: httpTAG,
    );
    LogUtils.d(
      '------------- End: $duration ms -------------',
      tag: httpTAG,
    );
    LogUtils.d('' '', tag: httpTAG);
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    LogUtils.e(
      '------------------- Error -------------------',
      tag: httpTAG,
    );
    handler.next(err);
  }
}

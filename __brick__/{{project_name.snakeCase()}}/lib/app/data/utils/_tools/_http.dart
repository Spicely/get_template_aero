// ignore_for_file: unused_element_parameter

part of '../utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 网络请求工具类（Isolate 版本）
///
/// Date: 2024年12月13日 09:34:17 Friday
///
//////////////////////////////////////////////////////////////////////////

/// 主线程提供动态 headers 的回调类型
typedef HttpHeaderBuilder = Future<Map<String, String>> Function();

/// 响应校验回调类型 — 在主线程执行，用于校验业务 code 并提取 data
typedef HttpResponseValidator = dynamic Function(dynamic responseData);

enum HttpMethod { get, post, put, patch, delete }

/// 传给 Isolate 的纯数据参数
class _IsolateRequestParams {
  final String baseUrl;
  final String url;
  final String methodStr;
  final dynamic data;
  final Map<String, dynamic> headers;
  final String contentType;
  final String? responseTypeName;
  final int maxRetries;
  final int sendTimeoutMs;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;
  final bool debug;

  const _IsolateRequestParams({
    required this.baseUrl,
    required this.url,
    required this.methodStr,
    required this.data,
    required this.headers,
    required this.contentType,
    required this.responseTypeName,
    required this.maxRetries,
    required this.sendTimeoutMs,
    required this.connectTimeoutMs,
    required this.receiveTimeoutMs,
    required this.debug,
  });
}

/// 在 Isolate 中执行网络请求的顶层函数
///
/// 注意：此函数必须为顶层函数，不可是实例方法或匿名闭包
Future<dynamic> _isolateExecute(_IsolateRequestParams params) async {
  ResponseType? responseType;
  if (params.responseTypeName != null) {
    responseType = ResponseType.values.firstWhere((e) => e.name == params.responseTypeName, orElse: () => ResponseType.json);
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: params.baseUrl,
      sendTimeout: Duration(milliseconds: params.sendTimeoutMs),
      connectTimeout: Duration(milliseconds: params.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: params.receiveTimeoutMs),
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ),
  );

  int attempt = 0;
  while (true) {
    try {
      final Response<dynamic> response = await dio.request(
        params.url,
        queryParameters: params.methodStr == 'GET' ? params.data : null,
        data: params.methodStr != 'GET' ? params.data : null,
        options: Options(method: params.methodStr, headers: params.headers, contentType: params.contentType, responseType: responseType),
      );

      return response.data;
    } on DioException catch (e) {
      if (!_shouldRetryInIsolate(e, attempt, params.maxRetries)) rethrow;
      attempt++;
      await Future<void>.delayed(Duration(milliseconds: 150 * attempt));
    }
  }
}

/// Isolate 内的重试判断（顶层纯函数）
bool _shouldRetryInIsolate(DioException e, int attempt, int maxRetries) {
  if (attempt >= maxRetries) return false;
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return true;
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      return status >= 500 && status < 600;
    default:
      return false;
  }
}

class _Http {
  final bool debug;

  _Http._({this.debug = false});

  final Map<String, Future<dynamic>> _inflightRequests = <String, Future<dynamic>>{};

  /// 请求基地址
  String baseUrl = '';

  final Duration _sendTimeout = const Duration(seconds: 10);
  Duration _connectTimeout = const Duration(seconds: 10);
  Duration _receiveTimeout = const Duration(seconds: 10);

  set receiveTimeout(Duration time) => _receiveTimeout = time;

  set connectTimeout(Duration time) => _connectTimeout = time;

  /// 主线程 headers 构建器 — 在主线程调用，收集 token/设备信息/语言等
  HttpHeaderBuilder? headerBuilder;

  /// 响应校验器 — 在主线程调用，用于校验业务 code 并提取有效 data
  HttpResponseValidator? responseValidator;

  /// request method
  Future<T> request<T>(
    String url, {
    dynamic data,
    HttpMethod method = HttpMethod.post,
    Map<String, dynamic>? headers,
    String? contentType,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    ResponseType? responseType,
    T Function(dynamic)? convert,
    bool dedupe = true,
    int maxRetries = 1,
  }) async {
    data = data ?? (method == HttpMethod.get ? null : {});
    headers = headers ?? {};
    contentType = contentType ?? Headers.jsonContentType;

    // 在主线程收集动态 headers（token、设备信息、语言等）
    if (headerBuilder != null) {
      final dynamicHeaders = await headerBuilder!();
      headers = {...dynamicHeaders, ...headers};
    }

    final requestKey = _buildRequestKey(url: url, method: method, data: data, headers: headers, contentType: contentType, responseType: responseType);

    if (dedupe && _inflightRequests.containsKey(requestKey)) {
      final dynamic reused = await _inflightRequests[requestKey]!;
      return reused as T;
    }

    final Future<T> pending = _performRequest<T>(url: url, data: data, method: method, headers: headers, contentType: contentType, responseType: responseType, convert: convert, maxRetries: maxRetries);
    if (dedupe) {
      _inflightRequests[requestKey] = pending;
    }
    try {
      return await pending;
    } finally {
      _inflightRequests.remove(requestKey);
    }
  }

  String _getMethod(HttpMethod method) {
    switch (method.index) {
      case 1:
        return 'POST';
      case 2:
        return 'PUT';
      case 3:
        return 'PATCH';
      case 4:
        return 'DELETE';
      default:
        return 'GET';
    }
  }

  Future<T> _performRequest<T>({required String url, required dynamic data, required HttpMethod method, required Map<String, dynamic> headers, required String contentType, ResponseType? responseType, T Function(dynamic)? convert, int maxRetries = 1}) async {
    final params = _IsolateRequestParams(
      baseUrl: baseUrl,
      url: url,
      methodStr: _getMethod(method),
      data: data,
      headers: headers,
      contentType: contentType,
      responseTypeName: responseType?.name,
      maxRetries: maxRetries,
      sendTimeoutMs: _sendTimeout.inMilliseconds,
      connectTimeoutMs: _connectTimeout.inMilliseconds,
      receiveTimeoutMs: _receiveTimeout.inMilliseconds,
      debug: debug,
    );

    // 在后台 Isolate 中执行网络请求
    final dynamic rawResult = await Isolate.run(() => _isolateExecute(params));

    // 在主线程执行业务层响应校验（code 提取等）
    final dynamic result = responseValidator != null ? responseValidator!(rawResult) : rawResult;

    // convert 也在 Isolate 中执行（纯函数）
    if (convert != null) {
      return await compute(convert, result);
    }
    return result as T;
  }

  String _buildRequestKey({required String url, required HttpMethod method, required dynamic data, required Map<String, dynamic> headers, required String contentType, ResponseType? responseType}) {
    return '${_getMethod(method)}|$url|${data.toString()}|${headers.toString()}|$contentType|${responseType?.name ?? ''}';
  }
}

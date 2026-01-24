// ignore_for_file: unused_element_parameter

part of '../utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 网络请求工具类
///
/// Date: 2024年12月13日 09:34:17 Friday
///
//////////////////////////////////////////////////////////////////////////

typedef HttpInterceptors = List<Interceptor> Function(Dio? dio);

enum HttpMethod {
  get,

  post,

  put,

  patch,

  delete,
}

class _Http {
  final bool debug;

  _Http._({this.debug = false});

  /// global dio object
  Dio? _dio;

  /// 请求地址
  set baseUrl(String v) => _dio == null ? _options.baseUrl = v : _dio?.options.baseUrl = v;

  String get baseUrl => _dio == null ? _options.baseUrl : _dio!.options.baseUrl;

  set receiveTimeout(Duration time) => _dio == null ? _options.receiveTimeout = time : _dio!.options.receiveTimeout = time;

  set connectTimeout(Duration time) => _dio == null ? _options.connectTimeout = time : _dio!.options.connectTimeout = time;

  /// 代理设置 代理地址
  String? proxyUrl;

  /// 添加额外功能
  HttpInterceptors? interceptors;

  late final BaseOptions _options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

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
  }) async {
    data = data ?? (method == HttpMethod.get ? null : {});
    headers = headers ?? {};
    contentType = contentType ?? Headers.jsonContentType;

    _dio = await createInstance();
    T result;

    Response<dynamic> response = await _dio!.request(
      url,
      queryParameters: method == HttpMethod.get ? data : null,
      data: method != HttpMethod.get ? data : null,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: Options(
        method: _getMethod(method),
        headers: headers,
        contentType: contentType,
        responseType: responseType,
      ),
    );

    if (convert != null) {
      result = await compute((data) => convert(data), response.data);
    } else {
      result = response.data;
    }

    return result;
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

  /// 创建 dio 实例对象
  Future<Dio?> createInstance() async {
    if (_dio == null) {
      _dio = Dio(_options);

      interceptors?.call(_dio).forEach((i) {
        _dio!.interceptors.add(i);
      });

      /// 设置代理
      if (proxyUrl != null) {
        _dio!.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            HttpClient client = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
            client.findProxy = (uri) {
              return "PROXY $proxyUrl";
            };
            return client;
          },
        );
      }

      if (debug) {
        _dio!.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
            filter: (options, args) => !args.isResponse || !args.hasUint8ListData,
          ),
        );
      }
    }

    return _dio;
  }
}

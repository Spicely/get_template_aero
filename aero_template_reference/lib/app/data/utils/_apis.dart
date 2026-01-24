part of 'utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 请求接口
///
/// Date: 2024年12月09日 22:43:42 Monday
///
//////////////////////////////////////////////////////////////////////////

class _Apis {
  final _Http _http = _Http._(debug: kDebugMode);

  _Apis._();

  void init() {
    _http.baseUrl = kReleaseMode ? config.BASE_URL : config.BASE_URL_DEV;

    _http.interceptors = (Dio? d) {
      return [
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers = {
              ...options.headers,

              /// 增加固定参数
              'channel': 'ACJL001',
            };
            handler.next(options);
          },
          onResponse: (Response<dynamic> response, ResponseInterceptorHandler handler) {
            switch (response.data['code']) {
              case 100:
                response.data = response.data['data'];
                handler.next(response);
                break;
              default:
                handler.reject(DioException(requestOptions: response.requestOptions, error: response.data['code'], message: response.data['message']));
            }
          },
        ),
      ];
    };
  }

  /// 登录
  Future<dynamic> login(dynamic data) => _http.request('/login', data: data);
}

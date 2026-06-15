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

    _http.headerBuilder = () async {
      return {
        /// 增加固定参数
        'channel': 'ACJL001',
      };
    };
    _http.responseValidator = (data) {
      if (data is! Map<String, dynamic>) {
        throw DioException(requestOptions: RequestOptions(), error: 'invalid_response', message: 'Response payload must be a JSON object.');
      }
      switch (data['code']) {
        case 100:
          return data['data'];
        default:
          throw DioException(requestOptions: RequestOptions(), error: data['code'], message: data['message']);
      }
    };
  }

  /// 登录
  Future<dynamic> login(dynamic data) => _http.request('/login', data: data);
}

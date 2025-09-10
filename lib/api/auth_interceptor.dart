import 'package:dio/dio.dart';
import 'package:first_app/utils/app_settings.dart';


class AuthInterceptor extends Interceptor {
  final _settings = AppSettings.getInstance();
  bool _loggingOut = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _settings.getToken();
    if (token.isNotEmpty) {

      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final code = err.response?.statusCode ?? 0;


    if ((code == 401 || code == 403) && !_loggingOut) {
      _loggingOut = true;
      await _settings.logout();
      _loggingOut = false;
    }

    super.onError(err, handler);
  }
}

import 'package:dio/dio.dart';
import 'package:first_app/utils/app_settings.dart';

class AuthInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler){
    String token = AppSettings.getInstance().getToken();
    if(token.isNotEmpty){
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }
}
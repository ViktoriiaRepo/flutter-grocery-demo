// lib/api/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:first_app/utils/app_settings.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final p = options.path;
    final authFree = p.endsWith('/login') || p.endsWith('/register');
    if (!authFree) {
      final token = AppSettings.getInstance().getToken();
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

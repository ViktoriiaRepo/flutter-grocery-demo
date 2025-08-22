import 'dart:io';

import 'package:dio/dio.dart';
import 'package:first_app/api/auth_interceptor.dart';
import 'package:first_app/api/http_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';

class HttpApi {
  late Dio dio;

  HttpApi({
    required String server,
  }){
    dio = Dio(
        BaseOptions(
            baseUrl: server,
            validateStatus: (s) => true,
        )
      );
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true ));

    }


  Future<HttpServerResponse> sendPost({
    required String path,
    required Map<String, dynamic> data,
  }) async {
      try {
        var response = await dio.post(path,
            data: data
        );
        return _mapSuccess(response);
      } on DioException catch (e){
        return _mapError(e);
      }
  }

  Future<HttpServerResponse> sendGet({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: data,
      );
      return _mapSuccess(response);
    } on DioException catch (e) {
      return _mapError(e);
    }
  }

  Future<HttpServerResponse> sendFile({
    required String path,
    required FormData data,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        options: Options(contentType: 'multipart/form-data'),
      );
      return _mapSuccess(response);
    } on DioException catch (e) {
      return _mapError(e);
    }
  }

  HttpServerResponse _mapSuccess(Response response){
      return HttpServerResponse(
          code: response.statusCode ?? 200,
          message: "",
          data: response.data
      );
  }

  HttpServerResponse _mapError(DioException exception){
    return HttpServerResponse(
        code: exception.response?.statusCode ?? -1,
        message: exception.message ?? "Error load data from server",
        data: exception.response?.data
    );
  }

  Future<HttpServerResponse> sendForm({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: FormData.fromMap(data),
        options: Options(contentType: 'multipart/form-data'),
      );
      return _mapSuccess(response);
    } on DioException catch (e) {
      return _mapError(e);
    }
  }
}
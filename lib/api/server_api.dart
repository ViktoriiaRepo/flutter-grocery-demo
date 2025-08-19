import 'package:first_app/api/http_api.dart';
import 'package:dio/dio.dart';
import 'package:first_app/api/response/login_response.dart';
import 'package:first_app/api/response/server_response.dart';


class ServerApi {
  HttpApi api = HttpApi(server: "https://it-flutter.wdscode.guru/wp-json/flutter/v1"
  );

  Future<LoginResponse> login({
    required String login,
    required String password,
  }){
    Map<String, dynamic> data = {
      "username": login,
      "password": password,
    };

    return api.sendPost(path: "/login", data: data)
    .then((value) => LoginResponse(value));
  }


  Future<ServerResponse> loadHome() {
    return api.sendGet(path: "/home", data: {})
        .then((value) => ServerResponse(value));
  }

  Future<LoginResponse> uploadIcon({
    required String path,
}){
    Map<String, dynamic> data = {
      "file": MultipartFile.fromFileSync(path),
    };
    return api.sendFile(path:"/login", data: FormData.fromMap(data))
    .then((value) => LoginResponse(value));
  }
}
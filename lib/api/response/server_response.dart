import 'package:first_app/api/http_response.dart';

class ServerResponse {
  bool isSuccess = false;
  String message = "";

  ServerResponse(HttpServerResponse response) {
    try {
      parse(response);
    } catch (e) {
      isSuccess = false;
      message = e.toString();
    }
  }

  void parse(HttpServerResponse response) {
    Map<String, dynamic>? data = response.data is Map<String, dynamic> ? response.data : null;
    if(data != null && data.containsKey("status")){
      isSuccess = data["status"]!;
      message = data["message"] ?? "";
    } else {
      isSuccess = response.code >= 200 && response.code < 300;
      message = response.message;
    }
  }
}
import 'package:first_app/api/http_response.dart';
import 'package:first_app/api/response/server_response.dart';
import 'package:first_app/utils/json_map.dart';

class LoginResponse extends ServerResponse {
  String token = "";
  String username = "";
  String userNicename = "";
  String userDisplayName = "";
  String message = "";

  LoginResponse(HttpServerResponse response) : super(response);

  @override
  parse(HttpServerResponse response) {
    super.parse(response);
    if(isSuccess) {
      var json = JsonMap.toMap(response.data)["data"] ?? {};
      token = json["token"] ?? "";
      userNicename = json["user_nicename"] ?? "";
      userDisplayName = json["user_display_name"] ?? "";
    } else {
        message = response.message;
    }

  }
}
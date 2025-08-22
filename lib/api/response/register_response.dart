import 'package:first_app/api/http_response.dart';
import 'package:first_app/api/response/server_response.dart';
import 'package:first_app/utils/json_map.dart';

class RegisterResponse extends ServerResponse {
  String token = "";
  String userEmail = "";
  String userDisplayName = "";
  String message = "";

  RegisterResponse(HttpServerResponse response) : super(response);

  @override
  parse(HttpServerResponse response) {
    super.parse(response);
    if(isSuccess) {
      var json = JsonMap.toMap(response.data)["data"] ?? {};
      token = json["token"] ?? "";

      userEmail = json["user_email"] ?? "";
      userDisplayName = json["user_display_name"] ?? "";
    } else {
      message = response.message;
    }

  }
}
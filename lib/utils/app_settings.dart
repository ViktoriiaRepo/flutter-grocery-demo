import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static AppSettings? _instance;

  static AppSettings getInstance() {
    _instance ??= AppSettings._();
    return _instance!;
  }

  AppSettings._();

  void logout() {
    prefs.remove("token");
    prefs.remove("email");
    prefs.remove("name");
  }

  saveToken(String token) {
    prefs.setString("token", token);
  }

  String getToken() {
    return prefs.getString("token") ?? "";
  }
  void saveUserEmail(String email) => prefs.setString("email", email);
  String getUserEmail() => prefs.getString("email") ?? "";

  void saveUserName(String name) => prefs.setString("name", name);
  String getUserName() => prefs.getString("name") ?? "";


}
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

  logout() {
    prefs.remove("token");
  }

  saveToken(String token) {
    prefs.setString("token", token);
  }

  String getToken() {
    return prefs.getString("token") ?? "";
  }
}
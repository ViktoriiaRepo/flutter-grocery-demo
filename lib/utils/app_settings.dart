// lib/utils/app_settings.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings _instance = AppSettings._();
  static AppSettings getInstance() => _instance;

  SharedPreferences? _prefs;
  bool get isReady => _prefs != null;

  static Future<void> init() async {
    if (_instance._prefs == null) {
      _instance._prefs = await SharedPreferences.getInstance();
    }
  }

  SharedPreferences get _sp {
    final p = _prefs;
    if (p == null) {
      throw StateError('AppSettings.init() was not awaited before use.');
    }
    return p;
  }


  String getToken() => _sp.getString('token') ?? '';
  String getUserEmail() => _sp.getString('email') ?? '';
  String getUserName() => _sp.getString('name') ?? '';


  Future<void> saveToken(String token) async {
    await _sp.setString('token', token);
    notifyListeners();
  }

  Future<void> clearToken() async => _sp.remove('token');

  Future<void> saveUserEmail(String email) async {
    await _sp.setString('email', email);
    notifyListeners();
  }

  Future<void> saveUserName(String name) async {
    await _sp.setString('name', name);
    notifyListeners();
  }

  Future<void> logout() async {
    await _sp.remove('token');
    await _sp.remove('email');
    await _sp.remove('name');
    notifyListeners();
  }
  SharedPreferences get prefs => _sp;

  bool getSeenIntro() => _prefs?.getBool('seen_intro') ?? false;
  Future<void> markIntroSeen() async => _prefs?.setBool('seen_intro', true);

}

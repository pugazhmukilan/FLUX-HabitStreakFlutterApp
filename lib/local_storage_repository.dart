import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  static late SharedPreferences _prefs;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) => _prefs.getString(key);
  static Future<void> setString(String key, String value) async => await _prefs.setString(key, value);

  static bool? getBool(String key) => _prefs.containsKey(key) ? _prefs.getBool(key) : null;
  static Future<void> setBool(String key, bool value) async => await _prefs.setBool(key, value);

  static Future<void> remove(String key) async => await _prefs.remove(key);
  
  static Future<bool> getTheme() async => _prefs.getBool('theme')!;
  static Future<void> setTheme(bool token) async => await _prefs.setBool('theme', token);
 
  
  // Cooking experience methods

}
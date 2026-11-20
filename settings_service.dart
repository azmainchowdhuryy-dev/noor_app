import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ভাষা, থিম, হিজরি অফসেট ও মাযহাব এক জায়গায়।
/// বদলালেই পুরো অ্যাপ তাৎক্ষণিক আপডেট হয় এবং মান সেভ থাকে।
class SettingsService extends ChangeNotifier {
  static const _kLang = 'language_code';
  static const _kTheme = 'theme_mode';
  static const _kHijriOffset = 'hijri_offset';
  static const _kMadhab = 'madhab';

  String _languageCode = 'bn';
  ThemeMode _themeMode = ThemeMode.system;
  int _hijriOffset = 0; // -1, 0, +1
  String _madhab = 'hanafi'; // 'hanafi' বা 'shafii'

  String get languageCode => _languageCode;
  ThemeMode get themeMode => _themeMode;
  int get hijriOffset => _hijriOffset;
  String get madhab => _madhab;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString(_kLang) ?? 'bn';
    final themeIndex = prefs.getInt(_kTheme) ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    _hijriOffset = (prefs.getInt(_kHijriOffset) ?? 0).clamp(-1, 1);
    _madhab = prefs.getString(_kMadhab) ?? 'hanafi';
  }

  Future<void> toggleLanguage() async {
    _languageCode = _languageCode == 'bn' ? 'en' : 'bn';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLang, _languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kTheme, mode.index);
  }

  Future<void> setHijriOffset(int offset) async {
    _hijriOffset = offset.clamp(-1, 1);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kHijriOffset, _hijriOffset);
  }

  Future<void> setMadhab(String madhab) async {
    _madhab = madhab;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kMadhab, _madhab);
  }
}

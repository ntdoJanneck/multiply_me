import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ThemeMode get theme => _theme;

  static const THEME_MODE = "theme_mode";

  ThemeModel() {
    loadTheme();
  }

  void _setThemeModePrefs(ThemeMode mode) async {
    Map<ThemeMode, String> themeMap = {
      ThemeMode.system: "system",
      ThemeMode.dark: "dark",
      ThemeMode.light: "light",
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeString = themeMap[mode];
    if (themeString != null) {
      sharedPreferences.setString(THEME_MODE, themeString);
    }
  }

  Future<ThemeMode> _getThemeModePrefs() async {
    Map<String, ThemeMode> themeMap = {
      "system": ThemeMode.system,
      "dark": ThemeMode.dark,
      "light": ThemeMode.light,
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String themeString = sharedPreferences.getString(THEME_MODE) ?? "system";
    ThemeMode theme = themeMap[themeString] ?? ThemeMode.dark;
    return theme;
  }

  ThemeMode setTheme(ThemeMode mode) {
    _theme = mode;
    _setThemeModePrefs(mode);
    notifyListeners();
    return _theme;
  }

  void loadTheme() async {
    _theme = await _getThemeModePrefs();
    log(_theme.toString());
    notifyListeners();
  }
}

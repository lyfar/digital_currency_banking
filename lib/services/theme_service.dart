import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeService {
  static const String _themeKey = "theme_mode";
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    String value = "";
    switch (themeMode) {
      case ThemeMode.light:
        value = "light";
        break;
      case ThemeMode.dark:
        value = "dark";
        break;
      case ThemeMode.system:
      default:
        value = "system";
        break;
    }
    await prefs.setString(_themeKey, value);
  }

  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey) ?? "system";
    switch (value) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      case "system":
      default:
        return ThemeMode.system;
    }
  }
}

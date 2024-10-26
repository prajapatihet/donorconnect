import 'package:donorconnect/cubit/theme_toggle/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<Themestate> {
  static final ThemeData _light = ThemeData.light();
  static final ThemeData _dark = ThemeData.dark();

  ThemeCubit() : super(Themestate(_light)) {
    setInitialTheme();  // Load saved theme on startup
  }

  void toggle(bool isDark) {
    final themeData = isDark ? _dark : _light;
    emit(Themestate(themeData));
    _savetheme(isDark);  // Save selected theme
  }

  Future<void> _savetheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  static Future<bool> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? false;
  }

  Future<void> setInitialTheme() async {
    final isDark = await _loadTheme();
    final themeData = isDark ? _dark : _light;
    emit(Themestate(themeData));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeStateNotifier extends StateNotifier<ThemeMode> {
  ThemeStateNotifier() : super(ThemeMode.light);

  void toggleTheme(bool isDarkMode) {
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode getCurrentTheme() {
    return state;
  }
}

final themeProvider = StateNotifierProvider<ThemeStateNotifier, ThemeMode>((ref) => ThemeStateNotifier());
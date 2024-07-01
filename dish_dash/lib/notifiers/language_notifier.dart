import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageStateNotifier extends StateNotifier<String> {
  LanguageStateNotifier() : super('en');

  void toggleLanguage() {
    state = state == 'en' ? 'ru' : 'en';
  }
}

final languageProvider = StateNotifierProvider<LanguageStateNotifier, String>((ref) => LanguageStateNotifier());
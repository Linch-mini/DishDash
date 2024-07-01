import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends StateNotifier<String> {
  CategoryNotifier() : super('');

  void updateCategory(String newValue) {
    state = newValue;
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, String>((ref) => CategoryNotifier());
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storages/favorite_meals_storage.dart';
import '../meal.dart';
import 'package:http/http.dart' as http;

final favoriteMealsProvider =
    StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier(ref.read(favoriteMealsStorageProvider));
});

final favoriteMealsStorageProvider = Provider<FavoriteMealsStorage>((ref) {
  return FavoriteMealsStorage();
});

class FavoritesNotifier extends StateNotifier<List<int>> {
  final FavoriteMealsStorage _storage;

  FavoritesNotifier(this._storage) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = await _storage.getFavoriteMealIds();
  }

  Future<void> addFavorite(int mealId) async {
    await _storage.addFavoriteMealId(mealId);
    await _loadFavorites();
  }

  Future<int> getCurrentMealId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('currentMealId') ?? 0;
  }

  Future<void> removeFavorite(int mealId) async {
    await _storage.removeFavoriteMealId(mealId);
    await _loadFavorites();
  }

  Future<void> saveCurrentMealId(int mealId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentMealId', mealId);
  }

  bool isFavorite(int mealId) => state.contains(mealId);

  Future<List<Meal>> getFavoriteMeals() async {
    List<int> favoriteIds = state;
    List<Meal> favoriteMeals = [];
    for (int id in favoriteIds) {
      Meal meal = await getMeal(id);
      favoriteMeals.add(meal);
    }
    return favoriteMeals;
  }

  Future<Meal> getMeal(int id) async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['meals'] != null && jsonResponse['meals'].isNotEmpty) {
        Map<String, dynamic> mealData = jsonResponse['meals'][0];
        return Meal.fromJson(mealData);
      } else {
        throw Exception('No meal data found');
      }
    } else {
      throw Exception('Failed to load meal');
    }
  }
}

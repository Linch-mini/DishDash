import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storages/favorite_meals_storage.dart';

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
    _loadFavorites();
  }

  Future<int> getCurrentMealId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('currentMealId') ?? 0;
  }

  Future<void> removeFavorite(int mealId) async {
    await _storage.removeFavoriteMealId(mealId);
    _loadFavorites();
  }

  Future<void> saveCurrentMealId(int mealId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentMealId', mealId);
  }

  bool isFavorite(int mealId) => state.contains(mealId);
}

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMealsStorage {
  static const _favoritesKey = 'favoriteMeals';

  Future<List<int>> getFavoriteMealIds() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> stringList = prefs.getStringList(_favoritesKey) ?? [];
    return stringList.map((id) => int.parse(id)).toList();
  }

  Future<void> addFavoriteMealId(int mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteMealIds();
    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      await prefs.setStringList(_favoritesKey, favorites.map((id) => id.toString()).toList());
    }
  }

  Future<void> removeFavoriteMealId(int mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteMealIds();
    if (favorites.contains(mealId)) {
      favorites.remove(mealId);
      await prefs.setStringList(_favoritesKey, favorites.map((id) => id.toString()).toList());
    }
  }
}
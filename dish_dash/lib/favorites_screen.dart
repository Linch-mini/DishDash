import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'meal.dart';
import 'notifiers/favorites_notifier.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Meals'),
      ),
      body: FutureBuilder<List<Meal>>(
        future: ref.watch(favoriteMealsProvider.notifier).getFavoriteMeals(),
        builder: (context, favoritesMealsSnapshot) {
          if (favoritesMealsSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (favoritesMealsSnapshot.hasError) {
            return Center(
                child: Text('Error: ${favoritesMealsSnapshot.error}'));
          } else if (favoritesMealsSnapshot.hasData) {
            return favoritesMealsSnapshot.data!.isEmpty
                ? const Center(child: Text('No favorites added yet.'))
                : ListView.builder(
                    itemCount: favoritesMealsSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(favoritesMealsSnapshot.data![index].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref
                                .read(favoriteMealsProvider.notifier)
                                .removeFavorite(int.parse(
                                    favoritesMealsSnapshot.data![index].id));
                          },
                        ),
                      );
                    },
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

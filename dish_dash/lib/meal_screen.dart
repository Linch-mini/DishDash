// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'custom_appbar.dart';
import 'notifiers/favorites_notifier.dart';

class MealScreen extends ConsumerWidget {
  MealScreen({super.key});

  late bool isFavorited;
  late Future<int> mealId;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.read(favoriteMealsProvider.notifier);
    mealId = favoritesNotifier.getCurrentMealId();
    // final isFavorite = ref.watch(favoriteMealsProvider).contains(mealId);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Meal Detailes',
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<int>(
            future: mealId,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                isFavorited =
                    ref.watch(favoriteMealsProvider).contains(snapshot.data);

                return FutureBuilder<Meal>(
                  future: getMeal(snapshot.data!),
                  builder: (context, mealSnapshot) {
                    if (mealSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (mealSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${mealSnapshot.error}'));
                    } else if (mealSnapshot.hasData) {
                      return ListView(
                        children: <Widget>[
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: constraints.maxWidth / 2,
                                    height: constraints.maxWidth / 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Image.network(
                                          mealSnapshot.data!.imageUrl),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 3.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            mealSnapshot.data!.name,
                                            style: const TextStyle(
                                              fontSize: 28.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 30.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Category: ${mealSnapshot.data!.category}',
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Area: ${mealSnapshot.data!.area}',
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                const Text(
                                                  'Ingredients:',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                ...List.generate(
                                                  mealSnapshot
                                                      .data!.ingredients.length,
                                                  (index) => Text(
                                                    '${mealSnapshot.data!.ingredients[index]}: ${mealSnapshot.data!.measures[index]}',
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const Text('Instructions:',
                              style: TextStyle(fontSize: 24.0)),
                          Text(mealSnapshot.data!.instructions),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No meal data found'));
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          FutureBuilder(
            future: favoritesNotifier.getCurrentMealId(),
            builder: (context, mealIdSnapshot) {
              return Positioned(
                top: 10.0,
                right: 10.0,
                child: FloatingActionButton(
                  onPressed: () {
                    if (isFavorited) {
                      favoritesNotifier.removeFavorite(mealIdSnapshot.data!);
                    } else {
                      favoritesNotifier.addFavorite(mealIdSnapshot.data!);
                    }
                  },
                  child: Icon(
                    Icons.favorite,
                    color: isFavorited ? Colors.red : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

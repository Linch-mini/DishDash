// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal.dart';
import 'custom_appbar.dart';
import 'notifiers/favorites_notifier.dart';

class PickedMealsScreen extends ConsumerWidget {
  PickedMealsScreen({super.key});

  late Future<List<Meal>> _pickedMealsFuture;
  late String category;

  Future<List<Meal>> getPickedMeals(String category) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List meals = jsonResponse['meals'];
      return meals
          .map((meal) => Meal(
                id: meal['idMeal'] as String,
                name: meal['strMeal'] as String,
                category: '',
                area: '',
                instructions: '',
                imageUrl: meal['strMealThumb'] as String,
                ingredients: [],
                measures: [],
              ))
          .toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    category = arguments['category'];
    _pickedMealsFuture = getPickedMeals(category);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Picked Meals',
      ),
      body: FutureBuilder<List<Meal>>(
        future: _pickedMealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Meal> meals = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      final favoritesNotifier =
                          ref.read(favoriteMealsProvider.notifier);
                      favoritesNotifier
                          .saveCurrentMealId(int.parse(meals[index].id));
                      Navigator.pushNamed(
                        context,
                        '/meal_card',
                        arguments: {'mealId': int.parse(meals[index].id)},
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 150.0,
                          height: 150.0,
                          child: Image.network(meals[index].imageUrl),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                meals[index].name,
                                style: const TextStyle(fontSize: 20.0),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

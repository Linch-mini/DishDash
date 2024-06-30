// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_appbar.dart';
import 'meal.dart';
import 'package:http/http.dart' as http;

import 'notifiers/favorites_notifier.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dish Dash',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 60),
          Center(
            child: Image.asset(
              'assets/images/Chef.png',
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 205,
                  height: 62, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 184, 60, 206),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Favourites'),
                    onPressed: () {
                      // Navigate to Favourites Screen
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 205,
                  height: 62, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 184, 60, 206),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('All Food'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/categories',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 205,
                  height: 62, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 184, 60, 206),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Random Meal'),
                    onPressed: () async {
                      Meal randomMeal = await getRandomMeal();
                      final favoritesNotifier = ref.read(favoriteMealsProvider.notifier);
                      favoritesNotifier.saveCurrentMealId(int.parse(randomMeal.id));
                      Navigator.pushNamed(
                        context,
                        '/meal_card',
                        arguments: {'mealId': int.parse(randomMeal.id)},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<Meal> getRandomMeal() async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var meal = jsonResponse['meals'][0];
      return Meal.fromJson(meal);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}

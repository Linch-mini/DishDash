// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'meal.dart';
import 'package:http/http.dart' as http;

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Dish Dash',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Favourites'),
              onPressed: () {
                // Navigate to Favourites Screen
              },
            ),
            ElevatedButton(
              child: const Text('All Food'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/categories',
                );
              },
            ),
            ElevatedButton(
              child: const Text('Random Meal'),
              onPressed: () async {
                Meal randomMeal = await getRandomMeal();
                Navigator.pushNamed(
                  context,
                  '/meal_card',
                  arguments: {'mealId': int.parse(randomMeal.id)},
                );
              },
            ),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'meal_screen.dart';
import 'meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Favourites'),
              onPressed: () {
                // Navigation to favourites screen
              },
            ),
            ElevatedButton(
              child: const Text('All Food'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Random Meal'),
              onPressed: () async {
                Meal randomMeal = await getRandomMeal();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MealScreen(mealId: int.parse(randomMeal.id)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal_screen.dart';
import 'meal.dart';
import 'custom_appbar.dart';

class PickedMealsScreen extends StatefulWidget {
  final String category;

  const PickedMealsScreen({super.key, required this.category});

  @override
  _PickedMealsScreenState createState() => _PickedMealsScreenState();
}

class _PickedMealsScreenState extends State<PickedMealsScreen> {
  late Future<List<Meal>> _pickedMealsFuture;

  @override
  void initState() {
    super.initState();
    _pickedMealsFuture = getPickedMeals(widget.category);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Picked Meals'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MealScreen(mealId: int.parse(meals[index].id)),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 250.0,
                          height: 250.0,
                          child: Image.network(meals[index].imageUrl),
                        ),
                        Expanded(
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

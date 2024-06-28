import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal_screen.dart';
import 'meal.dart';
import 'custom_appbar.dart';

class PickedMealsScreen extends StatefulWidget {
  final String category;

  const PickedMealsScreen({Key? key, required this.category}) : super(key: key);

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
                imageUrl: '',
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
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealScreen(
                            mealId: int.parse(snapshot.data![index].id)),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

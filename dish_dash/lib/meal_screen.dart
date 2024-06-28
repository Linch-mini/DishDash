import 'package:flutter/material.dart';
import 'meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'custom_appbar.dart';

class MealScreen extends StatefulWidget {
  final int mealId;

  const MealScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  late Future<Meal> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = getMeal(widget.mealId);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Meal Details'),
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Meal meal = snapshot.data!;
            return ListView(
              children: <Widget>[
                Image.network(meal.imageUrl),
                Text('ID: ${meal.id}'),
                Text('Name: ${meal.name}'),
                Text('Category: ${meal.category}'),
                Text('Area: ${meal.area}'),
                Text('Instructions: ${meal.instructions}'),
                ...meal.ingredients
                    .map((ingredient) => Text('Ingredient: $ingredient')),
                ...meal.measures.map((measure) => Text('Measure: $measure')),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

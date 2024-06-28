import 'package:flutter/material.dart';
import 'meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class MealScreen extends StatefulWidget {
  final int mealId;

  const MealScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  late Future<Meal> _mealFuture;
  bool isFavorited = false;

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
      appBar: AppBar(
        title: const Text('Meal Details'),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<Meal>(
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
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: <Widget>[
                            Container(
                              width: constraints.maxWidth / 2, // ширина изображения
                              height: constraints.maxWidth / 2, // высота изображения
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Image.network(meal.imageUrl),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0), // добавьте отступ слева
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${meal.name}', style: TextStyle(fontSize: 28.0)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0), // добавьте отступ слева
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Category: ${meal.category}', style: TextStyle(fontSize: 18.0)),
                                          Text('Area: ${meal.area}', style: TextStyle(fontSize: 18.0)),
                                          Text('Ingredients:', style: TextStyle(fontSize: 18.0)),
                                          ...List.generate(meal.ingredients.length, (index) =>
                                              Text('${meal.ingredients[index]}: ${meal.measures[index]}', style: TextStyle(fontSize: 14.0))
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
                    Text('Instructions:', style: TextStyle(fontSize: 24.0)),
                    Text('${meal.instructions}'),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFavorited = !isFavorited;
                });
              },
              child: Icon(
                Icons.favorite,
                color: isFavorited ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
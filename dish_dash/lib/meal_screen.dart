import 'package:flutter/material.dart';
import 'meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'background_painter.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  late Future<Meal> _mealFuture;
  bool isFavorited = false;
  late int mealId;

  @override
  void initState() {
    super.initState();
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
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    mealId = arguments['mealId'];
    _mealFuture = getMeal(mealId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Details',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
      ),
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Stack(
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            meal.name,
                            style: const TextStyle(
                              fontSize: 28.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 4.0), 
                        child: Text(
                          'Category: ${meal.category}',
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding( 
                        padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                        child: Text(
                          'Area: ${meal.area}',
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Image.network(meal.imageUrl),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: <Widget>[
                              const Text(
                                'Ingredients:',
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                                textAlign: TextAlign.center, 
                              ),
                              ...List.generate(
                                meal.ingredients.length,
                                (index) => Text(
                                  '${meal.ingredients[index]}: ${meal.measures[index]}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.center, 
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Instructions:\n${meal.instructions}',
                          style: const TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center, 
                        ),
                      ),
                      
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
      ),
    );
  }
}

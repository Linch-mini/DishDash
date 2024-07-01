// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:dish_dash/custom_theme.dart';
import 'package:dish_dash/notifiers/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal.dart';
import 'notifiers/favorites_notifier.dart';
import 'background_painter.dart';
import 'package:translator/translator.dart';

import 'notifiers/language_notifier.dart';

class PickedMealsScreen extends ConsumerStatefulWidget {
  PickedMealsScreen({super.key});

  @override
  _PickedMealScreenState createState() => _PickedMealScreenState();
}

class _PickedMealScreenState extends ConsumerState<PickedMealsScreen> {

  late Future<List<Meal>> _pickedMealsFuture;
  late String category;
  final translator = GoogleTranslator();

  Future<String> translate(String input) async {
    var translation = await translator.translate(input,
        from: 'en', to: ref.watch(languageProvider));
    return translation.text;
  }

  @override
  void initState() {
    super.initState();
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
    category = ref.watch(categoryProvider);
    _pickedMealsFuture = getPickedMeals(category);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: translate('Picked Meals'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        centerTitle: true,
      ),
      body: CustomPaint(
        painter: BackgroundPainter(themeMode: ref.watch(themeProvider)),
        child: FutureBuilder<List<Meal>>(
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
                  crossAxisCount: 2,
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
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 5),
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Image.network(
                              meals[index].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FutureBuilder<String>(
                                  future: translate(meals[index].name),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!.split(" ").length > 4
                                            ? "${snapshot.data!.split(" ").take(4).join(" ")}..."
                                            : snapshot.data!,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
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
      ),
    );
  }
}

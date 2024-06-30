import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final translator = GoogleTranslator();
  String currentLanguage = 'en';

  Future<String> translate(String input) async {
    var translation = await translator.translate(input, from: 'en', to: currentLanguage);
    return translation.text;
  }

  void changeLanguage() {
    setState(() {
      currentLanguage = currentLanguage == 'en' ? 'ru' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dish Dash',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: changeLanguage,
          ),
        ],
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
                    child: FutureBuilder<String>(
                      future: translate('Favourites'),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
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
                    child: FutureBuilder<String>(
                      future: translate('All Food'),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
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
                    child: FutureBuilder<String>(
                      future: translate('Random Meal'),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    onPressed: () async {
                      Meal randomMeal = await getRandomMeal();
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

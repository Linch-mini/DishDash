// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dish_dash/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_appbar.dart';
import 'meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'background_painter.dart';
import 'notifiers/favorites_notifier.dart';
import 'notifiers/language_notifier.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen>
    with SingleTickerProviderStateMixin {
  final translator = GoogleTranslator();
  late AnimationController _controller;
  late Animation<double> _animation;

  Future<String> translate(String input) async {
    var translation = await translator.translate(input,
        from: 'en', to: ref.watch(languageProvider));
    return translation.text;
  }

  @override
  _StartScreenState createState() => _StartScreenState();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dish Dash',
        changeLanguageCallback:
            ref.read(languageProvider.notifier).toggleLanguage,
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: BackgroundPainter(themeMode: ref.read(themeProvider)),
          ),
          Positioned.fill(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double offset = 300 * (1 - _animation.value);
                    double opacity = _animation.value;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: Opacity(
                        opacity: opacity,
                        child: Center(
                          child: Image.asset(
                            'assets/images/Chef.png',
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double offset = 300 * (1 - _animation.value);
                    double opacity = _animation.value;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: Opacity(
                        opacity: opacity,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: 205,
                                height: 62,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 184, 60, 206),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  child: FutureBuilder<String>(
                                    future: translate('Favourites'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data!);
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/favorites',
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
                                    backgroundColor:
                                        const Color.fromARGB(255, 184, 60, 206),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  child: FutureBuilder<String>(
                                    future: translate('All Recipes'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data!);
                                      } else {
                                        return const CircularProgressIndicator();
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
                                    backgroundColor:
                                        const Color.fromARGB(255, 184, 60, 206),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  child: FutureBuilder<String>(
                                    future: translate('Random Recipe'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data!);
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  onPressed: () async {
                                    Meal randomMeal = await getRandomMeal();
                                    final favoritesNotifier = ref
                                        .read(favoriteMealsProvider.notifier);
                                    favoritesNotifier.saveCurrentMealId(
                                        int.parse(randomMeal.id));
                                    Navigator.pushNamed(
                                      context,
                                      '/meal_card',
                                      arguments: {
                                        'mealId': int.parse(randomMeal.id)
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
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

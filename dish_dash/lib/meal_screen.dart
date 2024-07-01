// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'meal.dart';
import 'notifiers/favorites_notifier.dart';
import 'background_painter.dart';
import 'package:translator/translator.dart';

class MealScreen extends ConsumerWidget {
  MealScreen({super.key});

  late bool isFavorited;
  late Future<int> mealId;

  final translator = GoogleTranslator();

  Future<String> translate(String input) async {
    var translation = await translator.translate(input, from: 'en', to: 'ru');
    return translation.text;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.read(favoriteMealsProvider.notifier);
    mealId = favoritesNotifier.getCurrentMealId();

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: translate('Meal Details'),
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
        painter: BackgroundPainter(),
        child: Stack(
          children: <Widget>[
            FutureBuilder<int>(
              future: mealId,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  isFavorited =
                      ref.watch(favoriteMealsProvider).contains(snapshot.data);

                return FutureBuilder<Meal>(
                  future: favoritesNotifier.getMeal(snapshot.data!),
                  builder: (context, mealSnapshot) {
                    if (mealSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (mealSnapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${mealSnapshot.error}',
                        ),
                      );
                    } else if (mealSnapshot.hasData) {
                      return ListView(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: FutureBuilder<String>(
                                  future: translate(mealSnapshot.data!.name),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                        style: const TextStyle(
                                          fontSize: 28.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0, 8.0, 4.0),
                            child: Text(
                              'Category: ${mealSnapshot.data!.category}',
                              style: const TextStyle(
                                fontSize: 22.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Area: ${mealSnapshot.data!.area}',
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
                              child: Image.network(mealSnapshot.data!.imageUrl),
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
                                    mealSnapshot.data!.ingredients.length,
                                    (index) => FutureBuilder<String>(
                                        future: translate(
                                            '${mealSnapshot.data!.ingredients[index]}: ${mealSnapshot.data!.measures[index]}'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!,
                                              style: const TextStyle(
                                                  fontSize: 18.0),
                                              textAlign: TextAlign.center,
                                            );
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Instructions:\n${mealSnapshot.data!.instructions}',
                              style: const TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No meal data found'));
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          FutureBuilder(
            future: favoritesNotifier.getCurrentMealId(),
            builder: (context, mealIdSnapshot) {
              return Positioned(
                top: 10.0,
                right: 10.0,
                child: FloatingActionButton(
                  onPressed: () {
                    if (isFavorited) {
                      favoritesNotifier.removeFavorite(mealIdSnapshot.data!);
                    } else {
                      favoritesNotifier.addFavorite(mealIdSnapshot.data!);
                    }
                  },
                  child: Icon(
                    Icons.favorite,
                    color: isFavorited ? Colors.red : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

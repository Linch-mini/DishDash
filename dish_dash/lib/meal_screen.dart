// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:dish_dash/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'meal.dart';
import 'notifiers/favorites_notifier.dart';
import 'background_painter.dart';
import 'package:translator/translator.dart';

import 'notifiers/language_notifier.dart';

class MealScreen extends ConsumerStatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends ConsumerState<MealScreen> {

  late bool isFavorited;
  late Future<int> mealId;

  final translator = GoogleTranslator();

  Future<String> translate(String input) async {
    var translation = await translator.translate(
      input,
      from: 'en',
      to: ref.watch(languageProvider),
    );
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          FutureBuilder(
            future: favoritesNotifier.getCurrentMealId(),
            builder: (context, mealIdSnapshot) {
              if (mealIdSnapshot.connectionState == ConnectionState.done) {
                return IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: isFavorited ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (isFavorited) {
                      favoritesNotifier.removeFavorite(mealIdSnapshot.data!);
                    } else {
                      favoritesNotifier.addFavorite(mealIdSnapshot.data!);
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: CustomPaint(
        painter: BackgroundPainter(themeMode: ref.read(themeProvider)),
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
                              child: FutureBuilder<String>(
                                  future: translate(
                                      'Category: ${mealSnapshot.data!.category}'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FutureBuilder<String>(
                                  future: translate(
                                      'Area: ${mealSnapshot.data!.area}'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.95,
                                child:
                                    Image.network(mealSnapshot.data!.imageUrl),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FutureBuilder<String>(
                                        future: translate('Ingredients:'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!,
                                              style: const TextStyle(
                                                fontSize: 22.0,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
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
                              child: FutureBuilder<String>(
                                  future: translate(
                                      'Instructions:\n${mealSnapshot.data!.instructions}'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                        style: const TextStyle(fontSize: 18.0),
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
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
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator/translator.dart';
import 'background_painter.dart';
import 'custom_theme.dart';
import 'meal.dart';
import 'notifiers/favorites_notifier.dart';

class FavoritesScreen extends ConsumerWidget {
  FavoritesScreen({super.key});
  final translator = GoogleTranslator();

  Future<String> translate(String input) async {
    var translation = await translator.translate(input,
        from: 'en', to: 'ru');
    return translation.text;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          future: ref.watch(favoriteMealsProvider.notifier).getFavoriteMeals(),
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

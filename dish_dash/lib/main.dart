import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_theme.dart';
import 'favorites_screen.dart';
import 'start_screen.dart';
import 'category_screen.dart';
import 'meal_screen.dart';
import 'picked_meals_screen.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        "/": (context) => const StartScreen(),
        "/categories": (context) => const CategoryScreen(),
        "/meals": (context) => PickedMealsScreen(),
        "/meal_card": (context) => MealScreen(),
        "/favorites": (context) => const FavoritesScreen(),
      },
    );
  }
}
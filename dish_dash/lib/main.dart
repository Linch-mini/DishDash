import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_screen.dart';
import 'meal_screen.dart';
import 'picked_meals_screen.dart';
import 'start_screen.dart';
import 'custom_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            initialRoute: "/",
            routes: {
              "/": (context) => StartScreen(),
              "/categories": (context) => const CategoryScreen(),
              "/meals": (context) => const PickedMealsScreen(),
              "/meal_card": (context) => const MealScreen(),
            },
          );
        },
      ),
    );
  }
}

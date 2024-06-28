import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'custom_appbar.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dish Dash'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Favourites'),
              onPressed: () {
                // Navigate to Favourites Screen
              },
            ),
            ElevatedButton(
              child: const Text('All Food'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Random Meal'),
              onPressed: () {
                // Navigate to Random Meal Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

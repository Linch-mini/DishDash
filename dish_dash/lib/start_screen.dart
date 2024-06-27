import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal App'),
      ),
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
                // Navigate to All Food Screen
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

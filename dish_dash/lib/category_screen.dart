// ignore_for_file: library_private_types_in_public_api

import 'package:dish_dash/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'background_painter.dart';
import 'notifiers/category_notifier.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  late Future<List<String>> _categoriesFuture;
  final translator = GoogleTranslator();

  Future<String> translate(String input) async {
    var translation = await translator.translate(input,
        from: 'en', to: 'ru');
    return translation.text;
  }

  @override
  void initState() {
    super.initState();
    _categoriesFuture = getCategories();
  }

  Future<List<String>> getCategories() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List categories = jsonResponse['categories'];
      return categories
          .map((category) => category['strCategory'] as String)
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: translate('Categories'),
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
        child: FutureBuilder<List<String>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        ref.read(categoryProvider.notifier).updateCategory(snapshot.data![index]);
                        Navigator.pushNamed(
                          context,
                          '/meals',
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(height: 5),
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Image.asset(
                              'assets/images/${snapshot.data![index]}.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FutureBuilder<String>(
                                future: translate(snapshot.data![index]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!);
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

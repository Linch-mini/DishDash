// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<String>> _categoriesFuture;

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
      title: const Text('Categories',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
      ),
      centerTitle: true,
    ),
    
    body: CustomPaint(
      painter: BackgroundPainter(),
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
                      Navigator.pushNamed(
                        context,
                        '/meals',
                        arguments: {'category': snapshot.data![index]},
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
                            child: Text(
                              snapshot.data![index],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.purple.shade100],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
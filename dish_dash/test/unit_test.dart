import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'dart:convert';

Future<bool> isValid(String apiUrl) async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var mealsList = jsonResponse['meals'];

    return mealsList != null && mealsList.isNotEmpty;
  } else {
    throw Exception('Failed to load meals from API');
  }
}

void main() {
  group('API tests', () {
    test('Beef API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Beef'), isTrue, reason: 'Beef API does not return a non-null list');
    });

    test('Breakfast API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Breakfast'), isTrue, reason: 'Breakfast API does not return a non-null list');
    });

    test('Chicken API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Chicken'), isTrue, reason: 'Chicken API does not return a non-null list');
    });

    test('Dessert API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert'), isTrue, reason: 'Dessert API does not return a non-null list');
    });

    test('Goat API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Goat'), isTrue, reason: 'Goat API does not return a non-null list');
    });

    test('Lamb API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Lamb'), isTrue, reason: 'Lamb API does not return a non-null list');
    });

    test('Miscellaneous API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Miscellaneous'), isTrue, reason: 'Miscellaneous API does not return a non-null list');
    });

    test('Pasta API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Pasta'), isTrue, reason: 'Pasta API does not return a non-null list');
    });

    test('Pork API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Pork'), isTrue, reason: 'Pork API does not return a non-null list');
    });

    test('Seafood API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'), isTrue, reason: 'Seafood API does not return a non-null list');
    });

    test('Side API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Side'), isTrue, reason: 'Side API does not return a non-null list');
    });

    test('Starter API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Starter'), isTrue, reason: 'Starter API does not return a non-null list');
    });

    test('Vegan API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Vegan'), isTrue, reason: 'Vegan API does not return a non-null list');
    });

    test('Vegetarian API returns non-empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=Vegetarian'), isTrue, reason: 'Vegetarian API does not return a non-null list');
    });
    test('Random API returns empty list', () async {
      expect(await isValid('https://www.themealdb.com/api/json/v1/1/filter.php?c=pivo'), isFalse, reason: 'Random API return a non-null list');
    });
  });
}
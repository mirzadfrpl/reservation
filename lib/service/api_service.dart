import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce/models/restaurant.dart';
import 'package:ecommerce/models/restaurant_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<RestaurantListItem>> fetchAllRestaurants() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> restaurantsJson = json['restaurants'];
      return restaurantsJson
          .map((json) => RestaurantListItem.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<Restaurant> fetchRestaurantDetails(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['error'] == false &&
          jsonResponse['restaurant'] != null) {
        return Restaurant.fromJson(jsonResponse['restaurant']);
      } else {
        throw Exception(
          'Failed to parse restaurant details: ${jsonResponse['message']}',
        );
      }
    } else {
      throw Exception(
        'Failed to load details. Status Code: ${response.statusCode}',
      );
    }
  }

  Future<List<RestaurantListItem>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['error'] == false) {
        final List<dynamic> restaurantsJson = jsonResponse['restaurants'];
        return restaurantsJson
            .map((json) => RestaurantListItem.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Error searching restaurants: ${jsonResponse['message']}',
        );
      }
    } else {
      throw Exception(
        'Failed to load search results. Status Code: ${response.statusCode}',
      );
    }
  }
}

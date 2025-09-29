import 'package:flutter/material.dart';
import 'package:ecommerce/models/restaurant_detail.dart' as detail_model;
import 'package:ecommerce/service/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId,
  }) {
    _fetchRestaurantDetails();
  }

  late detail_model.Restaurant _restaurant;
  detail_model.Restaurant get restaurant => _restaurant;

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> _fetchRestaurantDetails() async {
    try {
      final result = await apiService.fetchRestaurantDetails(restaurantId);

      _state = ResultState.hasData;
      _restaurant = result;
      notifyListeners();
        } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal memuat detail: $e';
      notifyListeners();
    }
  }
}

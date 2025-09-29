import 'package:flutter/material.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:ecommerce/models/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurants();
  }

  List<RestaurantListItem> _restaurants = [];
  ResultState _state = ResultState.loading;
  String _message = '';

  List<RestaurantListItem> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  Future<void> _fetchAllRestaurants() async {
    try {
      final fetchedRestaurants = await apiService.fetchAllRestaurants();

      if (fetchedRestaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'Tidak ada data restoran yang ditemukan.';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurants = fetchedRestaurants;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal memuat data. Periksa koneksi internet Anda.';
      notifyListeners();
    }
  }
}

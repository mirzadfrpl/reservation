import 'package:flutter/material.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:ecommerce/models/restaurant.dart';

enum SearchState { initial, loading, noData, hasData, error }

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService});

  SearchState _state = SearchState.initial;
  String _message = '';
  List<RestaurantListItem> _searchResults = [];
  String _query = '';

  SearchState get state => _state;
  String get message => _message;
  List<RestaurantListItem> get searchResults => _searchResults;
  String get query => _query;

  Future<void> searchRestaurants(String query) async {
    _query = query;
    if (query.isEmpty) {
      _state = SearchState.initial;
      _message = 'Ketik untuk mencari restoran favoritmu.';
      notifyListeners();
      return;
    }

    try {
      _state = SearchState.loading;
      notifyListeners();

      final results = await apiService.searchRestaurants(query);
      if (results.isEmpty) {
        _state = SearchState.noData;
        _message = 'Restoran tidak ditemukan.';
        notifyListeners();
      } else {
        _state = SearchState.hasData;
        _searchResults = results;
        notifyListeners();
      }
    } catch (e) {
      _state = SearchState.error;
      _message = 'Gagal memuat data. Periksa koneksi internet Anda.';
      notifyListeners();
    }
  }
}

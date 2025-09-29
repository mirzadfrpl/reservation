import 'package:flutter/material.dart';
import 'package:ecommerce/db/database_helper.dart';
import 'package:ecommerce/models/restaurant_favourite.dart';
import 'package:ecommerce/models/restaurant_detail.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  FavoriteProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  List<FavoriteRestaurant> _favorites = [];
  List<FavoriteRestaurant> get favorites => _favorites;

  Future<void> _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    notifyListeners();
  }

  Future<void> addOrRemoveFavorite(Restaurant restaurant) async {
    final isFav = await databaseHelper.isFavorite(restaurant.id);
    if (isFav) {
      await databaseHelper.removeFavorite(restaurant.id);
    } else {
      await databaseHelper.insertFavorite(
        FavoriteRestaurant(
          id: restaurant.id,
          name: restaurant.name,
          description: restaurant.description,
          pictureId: restaurant.pictureId,
          city: restaurant.city,
          rating: restaurant.rating,
        ),
      );
    }
    _getFavorites();
  }

  Future<bool> isFavorite(String id) async {
    return await databaseHelper.isFavorite(id);
  }

  void removeFavorite(String id) {}
}

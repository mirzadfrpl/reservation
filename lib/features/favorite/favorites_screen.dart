import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/favourite_provider.dart';
import 'package:ecommerce/models/restaurant_favourite.dart';
import 'package:ecommerce/features/home/Screens/detail_screens.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restoran Favorit Anda')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return const Center(child: Text('Tidak ada restoran favorit.'));
          } else {
            return ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final restaurant = provider.favorites[index];
                return _buildRestaurantCard(context, restaurant);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRestaurantCard(
    BuildContext context,
    FavoriteRestaurant restaurant,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreens(restaurantId: restaurant.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(restaurant.city),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(restaurant.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  Provider.of<FavoriteProvider>(
                    context,
                    listen: false,
                  ).removeFavorite(restaurant.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

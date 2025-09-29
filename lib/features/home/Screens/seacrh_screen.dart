import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/restaurant.dart';
import 'package:ecommerce/providers/search_provider.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:ecommerce/features/home/Screens/detail_screens.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(apiService: ApiService()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: _buildSearchField(),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        return TextField(
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              provider.searchRestaurants(value);
            }
          },
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          decoration: InputDecoration(
            hintText: 'Cari restoran atau kafe...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(178), 
            ),
            border: InputBorder.none,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        switch (provider.state) {
          case SearchState.loading:
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          case SearchState.error:
            return _MessageDisplay(
              icon: Icons.error_outline,
              message: provider.message,
            );
          case SearchState.initial:
            return const _MessageDisplay(
              icon: Icons.search,
              message: 'Ketik untuk mencari restoran favoritmu.',
            );
          case SearchState.noData:
            return _MessageDisplay(
              icon: Icons.search_off,
              message: 'Tidak ada hasil untuk "${provider.query}"',
            );
          case SearchState.hasData:
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.searchResults.length,
              itemBuilder: (context, index) {
                final restaurant = provider.searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RestaurantCard(restaurant: restaurant),
                );
              },
            );
        }
      },
    );
  }
}

class _MessageDisplay extends StatelessWidget {
  final IconData icon;
  final String message;

  const _MessageDisplay({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(77), 
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final RestaurantListItem restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreens(restaurantId: restaurant.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(12), 
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                restaurant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(153), 
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      restaurant.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(153), 
                      ),
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/restaurant.dart';
import 'package:ecommerce/providers/restaurant_provider.dart';
import 'package:ecommerce/providers/home_provider.dart';
import 'package:ecommerce/features/home/Screens/detail_screens.dart';
import 'package:ecommerce/features/home/Screens/seacrh_screen.dart';
import 'dart:ui';
import 'dart:async';

class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final int index;
  const AnimatedGridItem({super.key, required this.child, required this.index});
  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        Provider.of<HomeProvider>(
          context,
          listen: false,
        ).animateGridItem(widget.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final bool isAnimated = homeProvider.animatedGridItems.contains(
          widget.index,
        );

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isAnimated ? 1 : 0,
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            transform: Matrix4.translationValues(0, isAnimated ? 0 : 50, 0),
            curve: Curves.easeInOut,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).startHeaderAnimation();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, child) {
          switch (restaurantProvider.state) {
            case ResultState.loading:
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            case ResultState.error:
              return _buildError(context, restaurantProvider.message);
            case ResultState.noData:
              return _buildError(context, restaurantProvider.message);
            case ResultState.hasData:
              return Stack(
                children: [
                  _buildHeaderBackground(context),
                  _buildContentSheet(context, restaurantProvider),
                ],
              );
            // Default clause tidak diperlukan karena semua case sudah ditangani
          }
        },
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final nameToShow = userName.isNotEmpty ? userName : 'Guest';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.5),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child: homeProvider.headerAnimated
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            key: const ValueKey('header_content'),
                            children: [
                              Text(
                                'Hello,',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary.withAlpha(204),
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              Text(
                                nameToShow,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 60,
                          key: ValueKey('header_placeholder'),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(153),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Search your favorite restaurant...",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSheet(BuildContext context, RestaurantProvider provider) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildCategoryFilters(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Recommendations',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final restaurant = provider.restaurants[index];
                    return AnimatedGridItem(
                      index: index,
                      child: RestaurantCard(restaurant: restaurant),
                    );
                  }, childCount: provider.restaurants.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _buildCategoryFilters(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final List<String> categories = [
      'All',
      'Popular',
      'Nearby',
      'Western',
      'Asian',
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 24, top: 20),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == homeProvider.selectedCategory;
            return GestureDetector(
              onTap: () {
                homeProvider.selectCategory(category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: isSelected
                      ? null
                      : Border.all(color: Theme.of(context).dividerColor),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withAlpha(77),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to Load Data',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(204),
              ),
              textAlign: TextAlign.center,
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
        'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreens(restaurantId: restaurant.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(26),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Hero(
                    tag: 'restaurant_image_${restaurant.id}',
                    child: Image.network(
                      imageUrl,
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 125,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Icon(
                          Icons.restaurant,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(77),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Text(
                restaurant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(153),
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(153),
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
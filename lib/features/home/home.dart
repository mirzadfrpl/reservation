import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce/features/home/Screens/detail_screens.dart';


class RestaurantListItem {
  final String id;
  final String name;
  final String pictureId;
  final String city;
  final double rating;

  RestaurantListItem({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantListItem.fromJson(Map<String, dynamic> json) {
    return RestaurantListItem(
      id: json['id'],
      name: json['name'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
    );
  }
}


Future<List<RestaurantListItem>> fetchRestaurants() async {
  final url = 'https://restaurant-api.dicoding.dev/list';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List restaurants = jsonResponse['restaurants'];
    return restaurants.map((json) => RestaurantListItem.fromJson(json)).toList();
  } else {
    throw Exception('Gagal memuat daftar restoran');
  }
}


class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RestaurantListItem> _allRestaurants = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAndSetRestaurants();
  }

  Future<void> _fetchAndSetRestaurants() async {
    try {
      final restaurants = await fetchRestaurants();
      if (mounted) {
        setState(() {
          _allRestaurants = restaurants;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A9D8F),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.white)))
            : ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildWelcomeText(),
            const SizedBox(height: 32),
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildRestaurantGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.menu_rounded, color: Colors.white, size: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Color(0xFF2A9D8F), size: 28),
              SizedBox(width: 8),
              Text('reservation', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2A9D8F))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    final nameToShow = widget.userName.isNotEmpty ? widget.userName : 'Guest';
    return Text(
      'Hello $nameToShow,\nFind your favorite restaurant today!',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.3,
      ),
    );
  }

  Widget _buildRestaurantGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _allRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = _allRestaurants[index];
        return RestaurantCard(restaurant: restaurant);
      },
    );
  }
}


class RestaurantCard extends StatelessWidget {
  final RestaurantListItem restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}';

    return GestureDetector(
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreens(restaurantId: restaurant.id)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      restaurant.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ),
                  const Icon(Icons.star, color: Color(0xFFE9C46A), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.rating.toString(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
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

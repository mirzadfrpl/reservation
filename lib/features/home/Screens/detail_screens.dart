import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Restaurant {
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Restaurant({
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.foods,
    required this.drinks,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    var foodsList = json['menus']['foods'] as List;
    var drinksList = json['menus']['drinks'] as List;
    List<MenuItem> foodItems =
    foodsList.map((i) => MenuItem.fromJson(i)).toList();
    List<MenuItem> drinkItems =
    drinksList.map((i) => MenuItem.fromJson(i)).toList();
    return Restaurant(
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      rating: json['rating'].toDouble(),
      foods: foodItems,
      drinks: drinkItems,
    );
  }
}

class MenuItem {
  final String name;
  MenuItem({required this.name});
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name']);
  }
}

Future<Restaurant> fetchRestaurantDetails(String id) async {
  final url = 'https://restaurant-api.dicoding.dev/detail/$id';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['restaurant'] != null) {
      return Restaurant.fromJson(jsonResponse['restaurant']);
    } else {
      throw Exception('Struktur data restoran tidak valid.');
    }
  } else {
    throw Exception(
        'Gagal memuat detail restoran. Status Code: ${response.statusCode}');
  }
}

class DetailScreens extends StatefulWidget {
  final String restaurantId;
  const DetailScreens({super.key, required this.restaurantId});
  @override
  State<DetailScreens> createState() => _DetailScreensState();
}

class _DetailScreensState extends State<DetailScreens> {
  late Future<Restaurant> _restaurantFuture;
  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color accentColor = Color(0xFFE9C46A);
  static const Color textColor = Color(0xFF264653);

  @override
  void initState() {
    super.initState();
    _restaurantFuture = fetchRestaurantDetails(widget.restaurantId);
  }

  void _showReservationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: _ReservationForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Restaurant>(
        future: _restaurantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final restaurant = snapshot.data!;
            return _buildContent(context, restaurant);
          }
          return const Center(child: Text('Restoran tidak ditemukan.'));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Restaurant restaurant) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(restaurant),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(restaurant),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildDescription(restaurant),
                const SizedBox(height: 24),
                _buildMenuSection('Menu Makanan 🍔', restaurant.foods),
                const SizedBox(height: 24),
                _buildMenuSection('Menu Minuman 🍹', restaurant.drinks),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Reservasi Meja'),
                    onPressed: () {
                      _showReservationBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(Restaurant restaurant) {
    final imageUrl =
        'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}';
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      backgroundColor: primaryColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: const CircleAvatar(
            backgroundColor: Colors.white70,
            child: Icon(Icons.arrow_back, color: textColor),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(restaurant.name,
            style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        background: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.restaurant_menu,
                  size: 100, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: accentColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 18),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${restaurant.address}, ${restaurant.city}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Deskripsi',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        Text(restaurant.description,
            style:
            const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) {
            return Chip(
              label: Text(item.name),
              backgroundColor: primaryColor.withOpacity(0.1),
              labelStyle: const TextStyle(
                  color: primaryColor, fontWeight: FontWeight.w600),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ReservationForm extends StatefulWidget {
  @override
  __ReservationFormState createState() => __ReservationFormState();
}

class __ReservationFormState extends State<_ReservationForm> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _numberOfPeople = 2;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<bool> submitReservation() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Buat Reservasi',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.date_range),
          title: Text(_selectedDate == null
              ? 'Pilih Tanggal'
              : 'Tanggal: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
          onTap: () => _selectDate(context),
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(_selectedTime == null
              ? 'Pilih Waktu'
              : 'Waktu: ${_selectedTime!.format(context)}'),
          onTap: () => _selectTime(context),
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: Text('Jumlah Orang: $_numberOfPeople'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (_numberOfPeople > 1) {
                    setState(() => _numberOfPeople--);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _numberOfPeople++),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_selectedDate == null || _selectedTime == null || _isLoading)
                ? null
                : () async {
              bool success = await submitReservation();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Reservasi Anda berhasil dibuat!'
                        : 'Gagal membuat reservasi. Coba lagi.'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A9D8F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
                : const Text('Konfirmasi Reservasi'),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
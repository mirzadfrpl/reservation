import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/restaurant_detail.dart';
import 'package:ecommerce/providers/restaurant_detail_provider.dart';
import 'package:ecommerce/providers/reservation_provider.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:ecommerce/providers/favourite_provider.dart';

class DetailScreens extends StatelessWidget {
  final String restaurantId;
  const DetailScreens({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(
        apiService: ApiService(),
        restaurantId: restaurantId,
      ),
      child: Scaffold(
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, child) {
            switch (provider.state) {
              case ResultState.loading:
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              case ResultState.error:
                return Center(
                  child: Text('Gagal memuat data: ${provider.message}'),
                );
              case ResultState.hasData:
                return _buildContent(context, provider.restaurant);
              default:
                return const Center(child: Text('Restoran tidak ditemukan.'));
            }
          },
        ),
      ),
    );
  }

  void _showReservationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ReservationProvider(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: const _ReservationForm(),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Restaurant restaurant) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, restaurant),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, restaurant),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildDescription(context, restaurant),
                const SizedBox(height: 24),
                _buildMenuSection(
                  context,
                  'Menu Makanan 🍔',
                  restaurant.menus.foods,
                ),
                const SizedBox(height: 24),
                _buildMenuSection(
                  context,
                  'Menu Minuman 🍹',
                  restaurant.menus.drinks,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Reservasi Meja'),
                    onPressed: () => _showReservationBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: Theme.of(context).textTheme.labelLarge,
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

  SliverAppBar _buildSliverAppBar(BuildContext context, Restaurant restaurant) {
    final imageUrl =
        'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}';
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(24),
          child: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withAlpha(204),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
      actions: [
        Consumer<FavoriteProvider>(
          builder: (context, provider, child) {
            final isFavorite = provider.favorites.any(
              (fav) => fav.id == restaurant.id,
            );
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? Colors.red
                    : Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                provider.addOrRemoveFavorite(restaurant);
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          restaurant.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        background: Hero(
          tag: 'restaurant_image_${restaurant.id}',
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withAlpha(77),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.restaurant_menu,
                size: 100,
                color: Theme.of(context).colorScheme.onPrimary,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              size: 18,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${restaurant.address}, ${restaurant.city}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deskripsi', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          restaurant.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) {
            return Chip(
              label: Text(item.name),
              backgroundColor: Theme.of(context).primaryColor.withAlpha(26),
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ReservationForm extends StatelessWidget {
  const _ReservationForm();

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Buat Reservasi',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(
                Icons.date_range,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                provider.selectedDate == null
                    ? 'Pilih Tanggal'
                    : 'Tanggal: ${provider.selectedDate!.day}/${provider.selectedDate!.month}/${provider.selectedDate!.year}',
              ),
              onTap: () => provider.selectDate(context),
            ),
            ListTile(
              leading: Icon(
                Icons.access_time,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                provider.selectedTime == null
                    ? 'Pilih Waktu'
                    : 'Waktu: ${provider.selectedTime!.format(context)}',
              ),
              onTap: () => provider.selectTime(context),
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Jumlah Orang: ${provider.numberOfPeople}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: provider.decrementPeople,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: provider.incrementPeople,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (provider.selectedDate == null ||
                        provider.selectedTime == null ||
                        provider.isLoading)
                    ? null
                    : () async {
                        bool success = await provider.submitReservation();
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Reservasi Anda berhasil dibuat!'
                                    : 'Gagal membuat reservasi. Coba lagi.',
                              ),
                              backgroundColor: success
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: provider.isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Konfirmasi Reservasi'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

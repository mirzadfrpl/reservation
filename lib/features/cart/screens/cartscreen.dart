import 'package:flutter/material.dart';

class OrderItem {
  final String imageUrl;
  final String title;
  final String packs;
  final String price;

  const OrderItem({
    required this.imageUrl,
    required this.title,
    required this.packs,
    required this.price,
  });
}

const List<OrderItem> orderItems = [
  OrderItem(
    imageUrl: 'asset/images/splash1.png',
    title: 'Melting Pot',
    packs: '2 packs',
    price: '₦ 20,000',
  ),
  OrderItem(
    imageUrl: 'asset/images/splash1.png',
    title: 'Kafe Kita',
    packs: '1 pack',
    price: '₦ 10,000',
  ),
  OrderItem(
    imageUrl: 'asset/images/splash1.png',
    title: 'Kafein',
    packs: '3 packs',
    price: '₦ 30,000',
  ),
];

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                itemBuilder: (context, index) {
                  return _BasketListItem(item: orderItems[index]);
                },
              ),
            ),
            const _CheckoutSection(),
          ],
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'My Basket',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BasketListItem extends StatelessWidget {
  final OrderItem item;

  const _BasketListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.delete_outline, color: Colors.white, size: 28)],
        ),
      ),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.packs,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(153), 
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const _QuantityChanger(),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityChanger extends StatelessWidget {
  const _QuantityChanger();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildQuantityButton(context, Icons.remove, () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('1', style: Theme.of(context).textTheme.titleMedium),
        ),
        _buildQuantityButton(context, Icons.add, () {}),
      ],
    );
  }

  Widget _buildQuantityButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(20), 
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: Theme.of(context).textTheme.bodyLarge),
              Text('₦ 60,000', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text('₦ 5,000', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: Theme.of(context).textTheme.titleLarge),
              Text(
                '₦ 65,000',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Text(
                'Checkout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
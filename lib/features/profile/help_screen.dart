import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Help Center',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Frequently Asked Questions'),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'How do I change my password?',
            answer:
                'You can change your password from the "Settings" menu, under the "Privacy & Security" section. Follow the on-screen instructions to update your credentials.',
          ),
          _buildFaqItem(
            context,
            question: 'How do I update my payment method?',
            answer:
                'To update your payment method, go to the "Payments" section in your profile and add a new card or update an existing one.',
          ),
          _buildFaqItem(
            context,
            question: 'Is my data secure?',
            answer:
                'Yes, we use industry-standard encryption to protect your data. For more details, please review our Privacy Policy.',
          ),
          const SizedBox(height: 30),
          _buildContactUsButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for help...',
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153), 
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ExpansionTile(
        title: Text(question, style: Theme.of(context).textTheme.titleMedium),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: <Widget>[
          Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(178), 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactUsButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.headset_mic_outlined),
      label: const Text('Contact Support'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
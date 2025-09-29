import 'package:flutter/material.dart';
import 'package:ecommerce/features/profile/edit_profile_screens.dart';
import 'package:ecommerce/features/profile/setting_screen.dart';
import 'package:ecommerce/features/profile/help_screen.dart';

class ProfileScreens extends StatelessWidget {
  const ProfileScreens({super.key});

  @override
  Widget build(BuildContext context) {
    const String name = 'Mirza';
    const String email = 'mirza@example.com';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _buildProfileHeader(context, name, email),
          const SizedBox(height: 20.0),
          _buildActionMenu(context, name, email),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String email) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            email,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, String name, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildMenuCard(
            context: context,
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(initialName: name, initialEmail: email),
                ),
              );
            },
          ),
          _buildMenuCard(
            context: context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          _buildMenuCard(
            context: context,
            icon: Icons.help_outline,
            title: 'Help Center',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpCenterScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildMenuCard(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            textColor: Theme.of(context).colorScheme.error,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      elevation: 1.0,
      shadowColor: Theme.of(context).shadowColor.withAlpha(26),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: textColor),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(102),
        ),
        onTap: onTap,
      ),
    );
  }
}

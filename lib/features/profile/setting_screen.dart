import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/providers/daily_reminder_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
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
          _buildSettingsCard(
            context: context,
            title: 'Account',
            children: [
              _buildSettingsTile(
                context: context,
                icon: Icons.notifications_none,
                title: 'Notifications',
                trailing: Consumer<DailyReminderProvider>(
                  builder: (context, reminderProvider, child) {
                    return Switch(
                      value: reminderProvider.isDailyReminderActive,
                      onChanged: (val) {
                        reminderProvider.toggleDailyReminder(val);
                      },
                      activeThumbColor: Theme.of(context).primaryColor,
                    );
                  },
                ),
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context: context,
            title: 'General',
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return _buildSettingsTile(
                    context: context,
                    icon: Icons.dark_mode,
                    title: 'Tema Gelap',
                    trailing: Switch(
                      value: themeProvider.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                      activeThumbColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () {},
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1.0,
      color: Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor.withAlpha(25), 
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(153), 
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: subtitle != null
          ? Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withAlpha(102), 
                )
              : null),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
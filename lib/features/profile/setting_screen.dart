import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2A9D8F),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              _buildSettingsTile(icon: Icons.notifications_none, title: 'Notifications', trailing: Switch(value: true, onChanged: (val) {}, activeColor: const Color(0xFF2A9D8F))),
              _buildSettingsTile(icon: Icons.lock_outline, title: 'Privacy & Security', onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context: context,
            title: 'General',
            children: [
              _buildSettingsTile(icon: Icons.language, title: 'Language', subtitle: 'English', onTap: () {}),
              _buildSettingsTile(icon: Icons.info_outline, title: 'About Us', onTap: () {}),
              _buildSettingsTile(icon: Icons.description_outlined, title: 'Terms of Service', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required BuildContext context, required String title, required List<Widget> children}) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}

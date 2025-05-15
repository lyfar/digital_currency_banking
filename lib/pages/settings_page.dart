import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsPage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeModeChanged;
  final VoidCallback onLogout;

  const SettingsPage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // User section
          _buildUserSection(context, isDarkMode),
          
          const SizedBox(height: 24),
          
          // Settings section
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : HSBCColors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Theme toggle
          _buildSettingItem(
            context,
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: isDarkMode,
              activeColor: HSBCColors.red,
              onChanged: (val) {
                onThemeModeChanged(val ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          
          _buildSettingItem(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            isDarkMode: isDarkMode,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          
          _buildSettingItem(
            context,
            icon: Icons.security_outlined,
            title: 'Security',
            isDarkMode: isDarkMode,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          
          _buildSettingItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            isDarkMode: isDarkMode,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          
          const Divider(height: 32),
          
          // Logout button
          _buildSettingItem(
            context,
            icon: Icons.logout,
            title: 'Log Out',
            isDarkMode: isDarkMode,
            isDestructive: true,
            onTap: onLogout,
          ),
          
          const SizedBox(height: 16),
          
          // App version
          Center(
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserSection(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: HSBCColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 36,
                color: HSBCColors.red,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // User details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Smith',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : HSBCColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    fontSize: 14,
                    color: HSBCColors.red,
                  ),
                ),
              ],
            ),
          ),
          
          // Edit profile button
          Icon(
            Icons.edit,
            color: isDarkMode ? Colors.white : HSBCColors.black,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDarkMode,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final Color textColor = isDestructive
        ? HSBCColors.red
        : (isDarkMode ? Colors.white : HSBCColors.black);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: textColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: isDestructive ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
} 
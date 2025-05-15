import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme.dart';
import '../platform_widgets.dart';

class HSBCDrawer extends StatelessWidget {
  final Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;
  final VoidCallback? onLogout;
  final bool isLoggedIn;

  const HSBCDrawer({
    super.key,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
    this.onLogout,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Drawer(
      backgroundColor: isDarkMode ? HSBCColors.darkBackground : HSBCColors.white,
      elevation: 16,
      child: Column(
        children: [
          // Drawer header with logo
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode ? HSBCColors.darkSurface : HSBCColors.appBarGrey,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: HSBCColors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        'images/bank-hsbc.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'HSBC',
                            style: TextStyle(
                              color: HSBCColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'HSBC Digital',
                    style: TextStyle(
                      color: HSBCColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Portfolio',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.swap_horiz_outlined,
                  title: 'Trade',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.history_outlined,
                  title: 'Transaction History',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Market Analysis',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Security Center',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  isDarkMode: isDarkMode,
                  onTap: () => Navigator.pop(context),
                ),
                _buildThemeSelector(context, isDarkMode),
                if (isLoggedIn && onLogout != null)
                  _buildMenuItem(
                    context,
                    icon: isAppleOrWeb() ? CupertinoIcons.square_arrow_left : Icons.logout,
                    title: 'Log Out',
                    isDarkMode: isDarkMode,
                    onTap: onLogout,
                    isDestructive: true,
                  ),
              ],
            ),
          ),
          
          // Version info at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.25.2',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? HSBCColors.grey : HSBCColors.mediumGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDarkMode,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? HSBCColors.red
            : isDarkMode
                ? HSBCColors.white
                : HSBCColors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? HSBCColors.red
              : isDarkMode
                  ? HSBCColors.white
                  : HSBCColors.black,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeSelector(BuildContext context, bool isDarkMode) {
    return ListTile(
      leading: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: isDarkMode ? HSBCColors.white : HSBCColors.black,
      ),
      title: Text(
        'Theme: ${isDarkMode ? 'Dark' : 'Light'}',
        style: TextStyle(
          color: isDarkMode ? HSBCColors.white : HSBCColors.black,
        ),
      ),
      trailing: Switch.adaptive(
        value: isDarkMode,
        activeColor: HSBCColors.red,
        onChanged: (bool value) {
          onThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light);
        },
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../theme.dart';

class CryptoBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const CryptoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final iconColor = isDarkMode 
        ? Colors.white.withOpacity(0.6)
        : Colors.black.withOpacity(0.6);
    final selectedIconColor = isDarkMode 
        ? Colors.white
        : HSBCColors.red;
    
    // Add a thin divider above the navigation
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          thickness: 0.5,
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.black.withOpacity(0.1),
        ),
        Container(
          color: bgColor,
          padding: const EdgeInsets.only(top: 8, bottom: 10),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: "Home",
                  index: 0,
                  iconColor: iconColor,
                  selectedIconColor: selectedIconColor,
                ),
                _buildNavItem(
                  icon: Icons.swap_horiz_outlined,
                  selectedIcon: Icons.swap_horiz,
                  label: "Trade",
                  index: 1,
                  iconColor: iconColor,
                  selectedIconColor: selectedIconColor,
                ),
                _buildNavItem(
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  label: "Discover",
                  index: 2,
                  iconColor: iconColor,
                  selectedIconColor: selectedIconColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required Color iconColor,
    required Color selectedIconColor,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 28,
              color: isSelected ? selectedIconColor : iconColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? selectedIconColor : iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
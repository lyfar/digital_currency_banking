import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../platform_widgets.dart';
import '../theme.dart';

class HSBCAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onRefreshPressed;
  final VoidCallback onSearchTap;

  const HSBCAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onRefreshPressed,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDarkMode ? HSBCColors.darkSurface : HSBCColors.appBarGrey,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            // Menu icon
            IconButton(
              icon: const Icon(Icons.menu, color: HSBCColors.white),
              onPressed: onMenuPressed,
            ),
            
            // HSBC logo centered
            Expanded(
              child: Center(
                child: Image.asset(
                  'images/bank-hsbc.png',
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to text if image is not found
                    return const Text(
                      'HSBC',
                      style: TextStyle(
                        color: HSBCColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Refresh icon
            IconButton(
              icon: const Icon(Icons.refresh, color: HSBCColors.white),
              onPressed: onRefreshPressed,
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? HSBCColors.darkCardColor : HSBCColors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.search,
                    color: isDarkMode ? HSBCColors.grey.withOpacity(0.7) : HSBCColors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Search digital asset',
                    style: TextStyle(
                      color: isDarkMode ? HSBCColors.grey.withOpacity(0.7) : HSBCColors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 56);
} 
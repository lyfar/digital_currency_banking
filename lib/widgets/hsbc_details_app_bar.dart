import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../platform_widgets.dart';
import '../theme.dart';

class HSBCDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const HSBCDetailsAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
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
            // Back button
            IconButton(
              icon: Icon(
                isAppleOrWeb() ? CupertinoIcons.back : Icons.arrow_back,
                color: HSBCColors.white
              ),
              onPressed: onBackPressed,
            ),
            
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: HSBCColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Empty space for balance
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 
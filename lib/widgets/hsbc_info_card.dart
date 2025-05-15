import 'package:flutter/material.dart';
import '../theme.dart';

class HSBCInfoCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  const HSBCInfoCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDarkMode 
            ? HSBCColors.darkSurface 
            : HSBCColors.grey.withOpacity(0.3)),
          boxShadow: isDarkMode 
            ? [] 
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Light bulb icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDarkMode ? HSBCColors.darkBackground : const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFFFD700), // Gold color
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode 
                          ? HSBCColors.white.withOpacity(0.7) 
                          : HSBCColors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode ? HSBCColors.white.withOpacity(0.5) : HSBCColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
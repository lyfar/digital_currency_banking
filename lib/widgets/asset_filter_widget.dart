import 'package:flutter/material.dart';
import '../theme.dart';

enum AssetFilterType {
  all,
  tokens,
  gold,
  bonds,
  reits
}

class AssetFilterWidget extends StatefulWidget {
  final AssetFilterType selectedFilter;
  final Function(AssetFilterType) onFilterChanged;

  const AssetFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  
  @override
  State<AssetFilterWidget> createState() => _AssetFilterWidgetState();
}

class _AssetFilterWidgetState extends State<AssetFilterWidget> {
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToSelectedFilter(AssetFilterType filter) {
    // Calculate approximate positions based on filter index
    final filterIndex = AssetFilterType.values.indexOf(filter);
    // Approximate width of each tab (adjust as needed based on your UI)
    const tabWidth = 100.0;
    
    // Calculate the target scroll position
    final scrollTo = (filterIndex * tabWidth) - 40; // Subtract offset to center it
    
    // Animate to the position if the controller is attached
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollTo.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(context, AssetFilterType.all, 'All'),
          _buildFilterChip(context, AssetFilterType.tokens, 'Tokens'),
          _buildFilterChip(context, AssetFilterType.gold, 'Gold'),
          _buildFilterChip(context, AssetFilterType.bonds, 'Bonds'),
          _buildFilterChip(context, AssetFilterType.reits, 'REITs'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, AssetFilterType filter, String label) {
    final isSelected = widget.selectedFilter == filter;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        widget.onFilterChanged(filter);
        // Scroll to make the tapped filter visible
        _scrollToSelectedFilter(filter);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isDarkMode ? HSBCColors.darkCardColor : Colors.white)
            : (isDarkMode ? HSBCColors.darkCardColor : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
            ? Border.all(color: HSBCColors.red, width: 2)
            : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (filter == AssetFilterType.all)
              Icon(
                Icons.apps,
                size: 18,
                color: isSelected 
                  ? HSBCColors.red
                  : (isDarkMode ? HSBCColors.darkIconColor : Colors.black54),
              ),
            if (filter == AssetFilterType.tokens)
              Icon(
                Icons.token,
                size: 18,
                color: isSelected 
                  ? HSBCColors.red
                  : (isDarkMode ? HSBCColors.darkIconColor : Colors.black54),
              ),
            if (filter == AssetFilterType.gold)
              Icon(
                Icons.monetization_on,
                size: 18,
                color: isSelected 
                  ? HSBCColors.red
                  : (isDarkMode ? HSBCColors.darkIconColor : Colors.black54),
              ),
            if (filter == AssetFilterType.bonds)
              Icon(
                Icons.account_balance,
                size: 18,
                color: isSelected 
                  ? HSBCColors.red
                  : (isDarkMode ? HSBCColors.darkIconColor : Colors.black54),
              ),
            if (filter == AssetFilterType.reits)
              Icon(
                Icons.business,
                size: 18,
                color: isSelected 
                  ? HSBCColors.red
                  : (isDarkMode ? HSBCColors.darkIconColor : Colors.black54),
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                  ? HSBCColors.red
                  : (isDarkMode ? HSBCColors.white : Colors.black),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
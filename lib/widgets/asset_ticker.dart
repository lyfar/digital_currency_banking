import 'package:flutter/material.dart';
import '../theme.dart';
import '../pages/asset_details_page.dart';
import 'dart:async';
import 'dart:math' as math;

class AssetTicker extends StatefulWidget {
  final List<AssetTickerItem> items;
  final double height;

  const AssetTicker({
    super.key,
    required this.items,
    this.height = 48,
  });

  @override
  State<AssetTicker> createState() => _AssetTickerState();
}

class _AssetTickerState extends State<AssetTicker> {
  late ScrollController _scrollController;
  Timer? _scrollTimer;
  Timer? _priceUpdateTimer;
  bool _isScrolling = true;
  late List<AssetTickerItem> _extendedItems;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Create an extended list by duplicating items for continuous scrolling
    _extendedItems = [...widget.items, ...widget.items, ...widget.items];
    
    _startScrolling();
    _startPriceUpdates();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _priceUpdateTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_isScrolling || !_scrollController.hasClients) return;
      
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      // Check if we've scrolled one-third through the list
      if (currentScroll >= maxScroll / 3) {
        // Jump back to the start of the second set of items without animation
        // This creates the illusion of continuous scrolling
        _scrollController.jumpTo(0);
      } else {
        // Continue scrolling
        _scrollController.animateTo(
          currentScroll + 1,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  void _startPriceUpdates() {
    // Update prices randomly every 3 seconds
    _priceUpdateTimer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
      if (!mounted) return;
      
      setState(() {
        // Update random items with new prices
        final random = math.Random();
        
        for (int i = 0; i < _extendedItems.length; i++) {
          // Only update some items each time (30% chance)
          if (random.nextDouble() < 0.3) {
            final originalItem = _extendedItems[i];
            final changePercent = (random.nextDouble() * 2 - 1) / 10; // -0.1% to +0.1%
            
            // Calculate new price
            final originalPrice = double.parse(originalItem.price.replaceAll(',', ''));
            final newPrice = originalPrice * (1 + changePercent);
            final formattedNewPrice = newPrice.toStringAsFixed(2);
            
            // Calculate new change amount
            final newChange = originalItem.change + (originalItem.change * changePercent * 2);
            
            // Calculate new percent
            final absChange = newChange.abs();
            final newPercent = '${absChange.toStringAsFixed(2)}%';
            
            // Update the item
            _extendedItems[i] = AssetTickerItem(
              symbol: originalItem.symbol,
              price: formattedNewPrice,
              change: newChange,
              changeAbs: '${newChange.toStringAsFixed(2)}',
              percent: newPercent,
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => _isScrolling = false,
      onTapUp: (_) => _isScrolling = true,
      onTapCancel: () => _isScrolling = true,
      child: Container(
        color: isDarkMode ? HSBCColors.darkSurface : HSBCColors.white,
        height: widget.height,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: _extendedItems.length,
          separatorBuilder: (context, index) => Container(
            width: 1,
            height: 32,
            color: isDarkMode 
              ? HSBCColors.darkCardColor 
              : HSBCColors.grey.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          itemBuilder: (context, index) {
            final item = _extendedItems[index];
            final isNegative = item.change < 0;
            final changeColor = isNegative ? HSBCColors.red : Colors.green;
            final arrow = isNegative ? '▼' : '▲';
            
            return GestureDetector(
              onTap: () {
                // Stop scrolling
                _isScrolling = false;
                
                // Navigate to asset details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetDetailsPage(symbol: item.symbol),
                  ),
                ).then((_) {
                  // Resume scrolling when returning from details page
                  _isScrolling = true;
                });
              },
              child: Container(
                width: 150, // Fixed width for consistent layout
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.symbol,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.price,
                          style: monospaceDigits(
                            TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                            ),
                          ),
                        ),
                        Text(
                          '$arrow ${item.percent}',
                          style: monospaceDigits(
                            TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: changeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AssetTickerItem {
  final String symbol;
  final String price;
  final double change;
  final String changeAbs;
  final String percent;

  AssetTickerItem({
    required this.symbol,
    required this.price,
    required this.change,
    required this.changeAbs,
    required this.percent,
  });
} 
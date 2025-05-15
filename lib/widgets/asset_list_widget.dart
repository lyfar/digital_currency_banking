import 'package:flutter/material.dart';
import '../models/digital_asset.dart';
import '../theme.dart';
import 'dart:async';
import 'dart:math' as math;

class AssetListWidget extends StatefulWidget {
  final List<DigitalAsset> assets;
  final Function(DigitalAsset) onAssetTap;

  const AssetListWidget({
    super.key,
    required this.assets,
    required this.onAssetTap,
  });

  @override
  State<AssetListWidget> createState() => _AssetListWidgetState();
}

class _AssetListWidgetState extends State<AssetListWidget> with TickerProviderStateMixin {
  late List<DigitalAsset> _assets;
  Timer? _priceUpdateTimer;
  final Map<String, AnimationController> _animationControllers = {};
  final Map<String, bool> _priceIncreased = {};

  @override
  void initState() {
    super.initState();
    _assets = List.from(widget.assets);
    
    // Initialize animation controllers for each asset
    for (var asset in _assets) {
      _animationControllers[asset.symbol] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
      _priceIncreased[asset.symbol] = false;
    }
    
    _startPriceUpdates();
  }
  
  @override
  void didUpdateWidget(AssetListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the assets list has changed
    if (widget.assets != oldWidget.assets) {
      setState(() {
        _assets = List.from(widget.assets);
      });
      
      // Update animation controllers for new assets
      for (var asset in _assets) {
        if (!_animationControllers.containsKey(asset.symbol)) {
          _animationControllers[asset.symbol] = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 800),
          );
          _priceIncreased[asset.symbol] = false;
        }
      }
    }
  }
  
  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    // Dispose all animation controllers
    _animationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
  
  void _startPriceUpdates() {
    // Update prices randomly every 2 seconds
    _priceUpdateTimer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (!mounted) return;
      
      setState(() {
        final random = math.Random();
        
        // Create a new list with updated assets
        final updatedAssets = <DigitalAsset>[];
        
        for (var asset in _assets) {
          // 50% chance to update each asset
          if (random.nextDouble() < 0.5) {
            // Calculate price change between -0.5% and +0.5%
            final changePercent = (random.nextDouble() * 2 - 1) * 0.5;
            
            // Calculate new price
            final newPrice = asset.price * (1 + changePercent / 100);
            
            // Calculate new 24h change
            final newChange = asset.change24h + changePercent / 10;
            
            // Determine if price increased
            final increased = newPrice > asset.price;
            _priceIncreased[asset.symbol] = increased;
            
            // Create updated asset
            final updatedAsset = DigitalAsset(
              symbol: asset.symbol,
              name: asset.name,
              price: newPrice,
              change24h: newChange,
              marketCap: asset.marketCap,
              volume24h: asset.volume24h * (1 + (random.nextDouble() * 0.1 - 0.05)), // Slight volume change
            );
            
            // Add to updated list
            updatedAssets.add(updatedAsset);
            
            // Trigger animation
            _animationControllers[asset.symbol]?.reset();
            _animationControllers[asset.symbol]?.forward();
          } else {
            // Keep asset unchanged
            updatedAssets.add(asset);
          }
        }
        
        // Update state with new assets
        _assets = updatedAssets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Volume',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Scrollable list of assets
        Expanded(
          child: ListView.builder(
            itemCount: _assets.length,
            itemBuilder: (context, index) => 
              _buildAssetListItem(context, _assets[index], index + 1),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetListItem(BuildContext context, DigitalAsset asset, int ranking) {
    final isPositiveChange = asset.change24h >= 0;
    final changeColor = isPositiveChange ? Colors.green : HSBCColors.red;
    final changeIcon = isPositiveChange ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Format the volume with appropriate suffix (M for millions, B for billions)
    String formattedVolume = '';
    if (asset.volume24h >= 1000000000) {
      formattedVolume = '\$${(asset.volume24h / 1000000000).toStringAsFixed(2)}B Vol';
    } else if (asset.volume24h >= 1000000) {
      formattedVolume = '\$${(asset.volume24h / 1000000).toStringAsFixed(2)}M Vol';
    } else {
      formattedVolume = '\$${(asset.volume24h / 1000).toStringAsFixed(2)}K Vol';
    }

    return AnimatedBuilder(
      animation: _animationControllers[asset.symbol] ?? const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        final animation = _animationControllers[asset.symbol]?.value ?? 0;
        final increased = _priceIncreased[asset.symbol] ?? false;
        
        // Create gradient that animates across the item
        final gradientColor = increased
          ? Colors.green.withOpacity(0.3 * (1 - animation))
          : HSBCColors.red.withOpacity(0.3 * (1 - animation));
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Add a small delay to prevent gesture conflicts
              Future.delayed(const Duration(milliseconds: 50), () {
                widget.onAssetTap(asset);
              });
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 72),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: animation > 0 ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    gradientColor,
                    isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
                  ],
                  stops: [animation, animation],
                ) : null,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? HSBCColors.darkSurface : Colors.grey.shade200,
                  ),
                ),
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ranking number
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$ranking',
                        style: monospaceDigits(
                          TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    
                    // Asset icon
                    _buildAssetIcon(asset.symbol, isDarkMode),
                    
                    const SizedBox(width: 12),
                    
                    // Asset name and volume
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            asset.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedVolume,
                            style: monospaceDigits(
                              TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Price and change
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${asset.formattedPrice}',
                          style: monospaceDigits(
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              changeIcon,
                              color: changeColor,
                              size: 16,
                            ),
                            Text(
                              '${asset.change24h.abs().toStringAsFixed(2)}%',
                              style: monospaceDigits(
                                TextStyle(
                                  fontSize: 14,
                                  color: changeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAssetIcon(String symbol, bool isDarkMode) {
    Color iconColor;
    Color backgroundColor;
    IconData iconData;
    
    switch (symbol) {
      case 'XGT':
        iconColor = const Color(0xFFFFD700); // Gold
        backgroundColor = isDarkMode 
          ? HSBCColors.darkCardColor 
          : HSBCColors.red.withOpacity(0.1);
        iconData = Icons.monetization_on;
        break;
      case 'WSG':
        iconColor = const Color(0xFFFFD700); // Gold
        backgroundColor = isDarkMode 
          ? HSBCColors.darkCardColor 
          : HSBCColors.red.withOpacity(0.1);
        iconData = Icons.monetization_on;
        break;
      case 'HGST':
        iconColor = HSBCColors.red;
        backgroundColor = isDarkMode 
          ? HSBCColors.darkCardColor 
          : const Color(0xFFE0E0E0);
        iconData = Icons.account_balance;
        break;
      case 'HREIT':
        iconColor = HSBCColors.red;
        backgroundColor = isDarkMode 
          ? HSBCColors.darkCardColor 
          : const Color(0xFFE0E0E0);
        iconData = Icons.business;
        break;
      case 'HTST':
        iconColor = HSBCColors.red;
        backgroundColor = isDarkMode 
          ? HSBCColors.darkCardColor 
          : const Color(0xFFE0E0E0);
        iconData = Icons.description;
        break;
      default:
        iconColor = HSBCColors.red;
        backgroundColor = isDarkMode 
          ? HSBCColors.darkCardColor 
          : const Color(0xFFE0E0E0);
        iconData = Icons.token;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
} 
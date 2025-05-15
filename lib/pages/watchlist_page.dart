import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/digital_asset_service.dart';
import '../models/digital_asset.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final DigitalAssetService _assetService = DigitalAssetService();
  late List<DigitalAsset> _watchlistAssets;
  
  @override
  void initState() {
    super.initState();
    _loadWatchlistData();
  }
  
  void _loadWatchlistData() {
    // In a real app, this would come from a watchlist service
    // For demo, we'll just use some assets from the asset service
    final allAssets = _assetService.getAllAssets();
    
    // Simulate watchlist (different assets than portfolio)
    _watchlistAssets = [allAssets[1], allAssets[3], allAssets[4]];
  }
  
  void _removeFromWatchlist(DigitalAsset asset) {
    setState(() {
      _watchlistAssets.remove(asset);
    });
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${asset.name} removed from watchlist'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _watchlistAssets.add(asset);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Watchlist header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Watchlist',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: HSBCColors.red,
                onPressed: () {
                  // Show add to watchlist dialog - not implemented in demo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add to watchlist not implemented in demo')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Watchlist items
          Expanded(
            child: _watchlistAssets.isEmpty
                ? _buildEmptyState(isDarkMode)
                : ListView.builder(
                    itemCount: _watchlistAssets.length,
                    itemBuilder: (context, index) {
                      final asset = _watchlistAssets[index];
                      return _buildWatchlistItem(context, asset, isDarkMode);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 60,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add assets to track their performance',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Show add to watchlist dialog - not implemented in demo
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add to watchlist not implemented in demo')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Assets'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HSBCColors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWatchlistItem(BuildContext context, DigitalAsset asset, bool isDarkMode) {
    final isPositiveChange = asset.change24h >= 0;
    final changeColor = isPositiveChange ? Colors.green : HSBCColors.red;
    
    return Dismissible(
      key: Key(asset.symbol),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: HSBCColors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        _removeFromWatchlist(asset);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Asset icon placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: HSBCColors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  asset.symbol.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: HSBCColors.red,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Asset details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    asset.symbol,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Price and change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset.formattedPrice,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isPositiveChange ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: changeColor,
                      size: 16,
                    ),
                    Text(
                      '${isPositiveChange ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 
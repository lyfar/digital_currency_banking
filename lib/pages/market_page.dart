import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/digital_asset.dart';
import '../services/digital_asset_service.dart';
import '../widgets/asset_filter_widget.dart';
import '../widgets/asset_list_widget.dart';
import '../pages/asset_details_page.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final DigitalAssetService _assetService = DigitalAssetService();
  AssetFilterType _currentFilter = AssetFilterType.all;
  List<DigitalAsset> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _applyFilter(_currentFilter);
  }

  void _applyFilter(AssetFilterType filter) {
    setState(() {
      _currentFilter = filter;
      
      // Get all assets
      final allAssets = _assetService.getAllAssets();
      
      // Apply filter
      switch (filter) {
        case AssetFilterType.all:
          _filteredAssets = allAssets;
          break;
        case AssetFilterType.tokens:
          _filteredAssets = allAssets.where((asset) => 
            !asset.symbol.contains('WSG') && !asset.symbol.contains('XGT')
          ).toList();
          break;
        case AssetFilterType.gold:
          _filteredAssets = allAssets.where((asset) => 
            asset.symbol.contains('WSG') || asset.symbol.contains('XGT')
          ).toList();
          break;
        case AssetFilterType.bonds:
          _filteredAssets = allAssets.where((asset) => 
            asset.symbol.contains('HGST') || asset.symbol.contains('HTST')
          ).toList();
          break;
        case AssetFilterType.reits:
          _filteredAssets = allAssets.where((asset) => 
            asset.symbol.contains('HREIT')
          ).toList();
          break;
      }
    });
  }

  void _handleAssetTap(DigitalAsset asset) {
    // Navigate to asset details page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetDetailsPage(symbol: asset.symbol),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Market heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Market',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark 
                  ? HSBCColors.white 
                  : HSBCColors.black,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Filter tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AssetFilterWidget(
              selectedFilter: _currentFilter,
              onFilterChanged: _applyFilter,
            ),
          ),
          
          // Asset list
          Expanded(
            child: AssetListWidget(
              assets: _filteredAssets,
              onAssetTap: _handleAssetTap,
            ),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../models/digital_asset.dart';
import '../services/digital_asset_service.dart';
import '../theme.dart';
import '../pages/asset_details_page.dart';
import 'asset_filter_widget.dart';
import 'asset_list_widget.dart';

class ExploreAssetsWidget extends StatefulWidget {
  const ExploreAssetsWidget({super.key});

  @override
  State<ExploreAssetsWidget> createState() => _ExploreAssetsWidgetState();
}

class _ExploreAssetsWidgetState extends State<ExploreAssetsWidget> {
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
    // Add a small delay to prevent gesture conflicts
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      
      // Navigate to asset details page with a fade transition
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => AssetDetailsPage(symbol: asset.symbol),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
} 
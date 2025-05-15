import '../models/digital_asset.dart';

class DigitalAssetService {
  // Singleton instance
  static final DigitalAssetService _instance = DigitalAssetService._internal();
  factory DigitalAssetService() => _instance;
  DigitalAssetService._internal();

  // HSBC Digital Assets based on their strategy
  final List<DigitalAsset> _assets = [
    DigitalAsset(
      symbol: 'XGT',
      name: 'HSBC Gold Token',
      price: 234.56,
      change24h: 1.2,
      marketCap: 750000000,
      volume24h: 15000000,
    ),
    DigitalAsset(
      symbol: 'WSG',
      name: 'Wayfoong Statement Gold',
      price: 2301.75,
      change24h: 0.8,
      marketCap: 950000000,
      volume24h: 22000000,
    ),
    DigitalAsset(
      symbol: 'HGST',
      name: 'HSBC Green Bond Token',
      price: 98.45,
      change24h: -0.3,
      marketCap: 350000000,
      volume24h: 8500000,
    ),
    DigitalAsset(
      symbol: 'HREIT',
      name: 'HSBC REIT Token',
      price: 10.75,
      change24h: 0.5,
      marketCap: 180000000,
      volume24h: 4500000,
    ),
    DigitalAsset(
      symbol: 'HTST',
      name: 'HSBC Treasury Token',
      price: 99.85,
      change24h: -0.1,
      marketCap: 420000000,
      volume24h: 9200000,
    ),
  ];

  // Get all assets
  List<DigitalAsset> getAllAssets() => List.unmodifiable(_assets);

  // Get asset by symbol
  DigitalAsset? getAssetBySymbol(String symbol) {
    try {
      return _assets.firstWhere((asset) => asset.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  // Search assets by name or symbol
  List<DigitalAsset> searchAssets(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _assets.where((asset) {
      return asset.symbol.toLowerCase().contains(lowercaseQuery) ||
             asset.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get top gainers
  List<DigitalAsset> getTopGainers() {
    final sorted = List<DigitalAsset>.from(_assets);
    sorted.sort((a, b) => b.change24h.compareTo(a.change24h));
    return sorted.take(3).toList();
  }

  // Get top losers
  List<DigitalAsset> getTopLosers() {
    final sorted = List<DigitalAsset>.from(_assets);
    sorted.sort((a, b) => a.change24h.compareTo(b.change24h));
    return sorted.take(3).toList();
  }
} 
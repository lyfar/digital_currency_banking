import '../utils/number_formatter.dart';

class DigitalAsset {
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double marketCap;
  final double volume24h;

  DigitalAsset({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.marketCap,
    required this.volume24h,
  });

  String get formattedPrice => NumberFormatter.formatCurrency(price);
  String get formattedChange => NumberFormatter.formatNumber(change24h);
  String get changePercent => NumberFormatter.formatPercentage(change24h);
  String get formattedMarketCap => NumberFormatter.formatCurrency(marketCap);
  String get formattedVolume => NumberFormatter.formatCurrency(volume24h);
  String get compactMarketCap => NumberFormatter.formatCompactNumber(marketCap);
  String get compactVolume => NumberFormatter.formatCompactNumber(volume24h);
} 
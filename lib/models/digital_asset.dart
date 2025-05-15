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

  String get formattedPrice => price.toStringAsFixed(2);
  String get formattedChange => change24h.toStringAsFixed(2);
  String get changePercent => '${change24h >= 0 ? '+' : ''}${(change24h).toStringAsFixed(2)}%';
  String get formattedMarketCap => marketCap.toStringAsFixed(2);
  String get formattedVolume => volume24h.toStringAsFixed(2);
} 
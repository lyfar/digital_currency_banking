import 'package:flutter/material.dart';
import 'dart:async';
import '../models/digital_asset.dart';
import '../theme.dart';
import '../widgets/hsbc_details_app_bar.dart';
import '../models/digital_asset.dart';
import '../services/digital_asset_service.dart';
import '../services/auth_service.dart';
import '../widgets/login_button.dart';
import '../pages/login_loading_page.dart';
import '../pages/purchase_amount_page.dart';

class AssetDetailsPage extends StatefulWidget {
  final String symbol;

  const AssetDetailsPage({
    super.key,
    required this.symbol,
  });

  @override
  State<AssetDetailsPage> createState() => _AssetDetailsPageState();
}

class _AssetDetailsPageState extends State<AssetDetailsPage> {
  final DigitalAssetService _assetService = DigitalAssetService();
  final AuthService _authService = AuthService();
  late DigitalAsset? _asset;
  bool _isLoading = true;
  bool _isLoggedIn = false;
  late StreamSubscription<bool> _authSubscription;

  @override
  void initState() {
    super.initState();
    _loadAssetData();
    
    // Check initial login state
    _isLoggedIn = _authService.isLoggedIn;
    
    // Listen for auth state changes
    _authSubscription = _authService.authStateStream.listen((isAuthenticated) {
      if (mounted) {
        setState(() {
          _isLoggedIn = isAuthenticated;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  void _loadAssetData() {
    // In a real app, this would be an async API call
    // For demo, we'll just get it from our service
    setState(() {
      _asset = _assetService.getAssetBySymbol(widget.symbol);
      _isLoading = false;
    });
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        appBar: HSBCDetailsAppBar(
          title: 'Loading...',
          onBackPressed: () => Navigator.pop(context),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_asset == null) {
      return Scaffold(
        appBar: HSBCDetailsAppBar(
          title: 'Asset Not Found',
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Center(
          child: Text(
            'Asset not found',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
            ),
          ),
        ),
      );
    }

    final isPositiveChange = _asset!.change24h >= 0;
    final changeColor = isPositiveChange ? Colors.green : HSBCColors.red;
    final changeIcon = isPositiveChange ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Scaffold(
      appBar: HSBCDetailsAppBar(
        title: _asset!.symbol,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            // Add padding at bottom to ensure content isn't hidden behind the fixed button
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header with icon and name
              Row(
                children: [
                  _buildAssetIcon(_asset!.symbol, isDarkMode),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _asset!.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _asset!.symbol,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Current price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Price',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _asset!.formattedPrice,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: changeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                changeIcon,
                                color: changeColor,
                                size: 16,
                              ),
                              Text(
                                _asset!.changePercent,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: changeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Price Chart
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                height: 200,
                decoration: BoxDecoration(
                  color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price Chart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                          ),
                        ),
                        Row(
                          children: [
                            _buildTimeframeChip('1D', true, isDarkMode),
                            const SizedBox(width: 8),
                            _buildTimeframeChip('1W', false, isDarkMode),
                            const SizedBox(width: 8),
                            _buildTimeframeChip('1M', false, isDarkMode),
                            const SizedBox(width: 8),
                            _buildTimeframeChip('1Y', false, isDarkMode),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomPaint(
                          size: const Size(double.infinity, 150),
                          painter: ChartPainter(
                            isPositiveChange: isPositiveChange,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Market Data
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDataRow(
                      context, 
                      'Market Cap', 
                      _asset!.compactMarketCap, 
                      isDarkMode
                    ),
                    _buildDataRow(
                      context, 
                      '24h Volume', 
                      _asset!.compactVolume, 
                      isDarkMode
                    ),
                    _buildDataRow(
                      context, 
                      '24h Change', 
                      _asset!.changePercent, 
                      isDarkMode,
                      valueColor: changeColor,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Asset Description - Placeholder
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About ${_asset!.name}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This is a placeholder description for ${_asset!.name} (${_asset!.symbol}). In a real application, this would contain detailed information about the asset, its use cases, technology, and other relevant information.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
          
        // Fixed button at the bottom - trade button only when logged in
        if (_isLoggedIn) 
          Positioned(
            left: 16,
            right: 16,
            bottom: 24, // Reduced from 80 to be closer to bottom but still above menu
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(24),
              color: Colors.transparent,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HSBCColors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    if (_isLoggedIn) {
                      // Go directly to purchase page if already logged in
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PurchaseAmountPage(asset: _asset!),
                        ),
                      );
                    } else {
                      // Show login page if not logged in
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginLoadingPage(
                            onLoginComplete: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PurchaseAmountPage(asset: _asset!),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        'Buy ${_asset!.symbol}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
  }
  
  Widget _buildDataRow(
    BuildContext context, 
    String label, 
    String value, 
    bool isDarkMode, 
    {Color? valueColor}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? (isDarkMode ? HSBCColors.white : HSBCColors.black),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method for timeframe selection chips
  Widget _buildTimeframeChip(String label, bool isActive, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? HSBCColors.red 
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive 
              ? Colors.white 
              : (isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700),
        ),
      ),
    );
  }
}

// Custom painter for the price chart
class ChartPainter extends CustomPainter {
  final bool isPositiveChange;
  final bool isDarkMode;
  
  ChartPainter({
    required this.isPositiveChange,
    required this.isDarkMode,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Define chart color based on price movement
    final chartColor = isPositiveChange ? Colors.green : HSBCColors.red;
    final gridColor = isDarkMode 
        ? Colors.grey.shade800.withOpacity(0.5) 
        : Colors.grey.shade300.withOpacity(0.8);
    
    // Draw grid lines
    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    
    // Horizontal grid lines
    for (int i = 1; i < 4; i++) {
      final y = height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    
    // Vertical grid lines
    for (int i = 1; i < 6; i++) {
      final x = width / 6 * i;
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }
    
    // Draw chart line
    final Paint linePaint = Paint()
      ..color = chartColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    
    // Generate random-looking but smooth price movements
    final path = Path();
    final random = isPositiveChange ? 1 : -1;
    final points = <Offset>[];
    
    // Starting point
    points.add(Offset(0, height * 0.6));
    
    // Middle points with trend
    points.add(Offset(width * 0.2, height * (0.65 - 0.1 * random)));
    points.add(Offset(width * 0.4, height * (0.55 - 0.15 * random)));
    points.add(Offset(width * 0.6, height * (0.6 - 0.2 * random)));
    points.add(Offset(width * 0.8, height * (0.4 - 0.25 * random)));
    
    // End point
    points.add(Offset(width, height * (0.45 - 0.3 * random)));
    
    // Draw curve through points
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = i > 0 ? points[i - 1] : points[0];
      final p1 = points[i];
      final p2 = i < points.length - 1 ? points[i + 1] : p1;
      
      final cp1x = p0.dx + (p1.dx - p0.dx) / 2;
      final cp1y = p0.dy;
      final cp2x = p1.dx - (p2.dx - p1.dx) / 2;
      final cp2y = p1.dy;
      
      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p1.dx, p1.dy);
    }
    
    canvas.drawPath(path, linePaint);
    
    // Fill gradient below the line
    final fillPath = Path.from(path);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();
    
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          chartColor.withOpacity(0.3),
          chartColor.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    
    canvas.drawPath(fillPath, fillPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../platform_widgets.dart';
import '../theme.dart';
import '../widgets/login_button.dart';
import '../widgets/hsbc_app_bar.dart';
import '../widgets/hsbc_drawer.dart';
import '../widgets/asset_ticker.dart';
import '../widgets/hsbc_info_card.dart';
import '../widgets/hsbc_info_drawer.dart';
import '../widgets/explore_assets_widget.dart';
import '../services/digital_asset_service.dart';

class HomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;
  final Future<void> Function()? onLogin;

  const HomePage({
    super.key,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
    this.onLogin,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DigitalAssetService _assetService = DigitalAssetService();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _refreshPage() {
    // In a real app, would refresh data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing...')),
    );
  }

  void _showInfoDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HSBCInfoDrawer(
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showSearchModal() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: isDarkMode ? HSBCColors.darkCardColor : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Digital Assets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              color: isDarkMode ? HSBCColors.darkSurface : Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Search functionality will be implemented in the future',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.currentThemeMode == ThemeMode.dark ||
        (widget.currentThemeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final screenSize = MediaQuery.of(context).size;

    // Get digital assets from service
    final assets = _assetService.getAllAssets();
    final tickerItems = assets.map((asset) => AssetTickerItem(
      symbol: asset.symbol,
      price: asset.formattedPrice,
      change: asset.change24h,
      changeAbs: asset.formattedChange,
      percent: asset.changePercent,
    )).toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: HSBCAppBar(
        onMenuPressed: _openDrawer,
        onRefreshPressed: _refreshPage,
        onSearchTap: _showSearchModal,
      ),
      drawer: HSBCDrawer(
        onThemeModeChanged: widget.onThemeModeChanged,
        currentThemeMode: widget.currentThemeMode,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Asset ticker at the top
            AssetTicker(items: tickerItems),
            // Add spacing between ticker and info card
            const SizedBox(height: 16),
            // Add HSBC Digital Gold and Asset Trading info card at the top
            HSBCInfoCard(
              title: 'HSBC Digital Gold and Asset Trading',
              subtitle: 'Explore HSBC\'s offerings and future platform features for digital assets',
              onTap: _showInfoDrawer,
            ),
            // Explore assets widget (takes most of the space)
            Expanded(
              child: const ExploreAssetsWidget(),
            ),
            // Login button at the bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: LoginButton(
                onPressed: () async {
                  // Handle login action
                  if (widget.onLogin != null) {
                    await widget.onLogin!();
                  } else {
                    await _showLoginNotImplementedDialog(context);
                  }
                },
              ),
            ),
            
            // Disclaimer link
            GestureDetector(
              onTap: () => _showDisclaimerDrawer(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureIcon(
    BuildContext context, 
    bool isDarkMode,
    IconData materialIcon, 
    IconData cupertinoIcon,
    String label
  ) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: HSBCColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAppleOrWeb() ? cupertinoIcon : materialIcon,
              color: HSBCColors.red,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Future<void> _showLoginNotImplementedDialog(BuildContext context) async {
    await PlatformAlertDialog(
      title: 'Feature Not Available',
      message: 'Login functionality is not implemented in this demo.',
      primaryButtonText: 'OK',
      onPrimaryButtonPressed: () {},
    ).show(context);
  }
  
  // Shows the disclaimer in a bottom drawer
  void _showDisclaimerDrawer() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Legal Disclaimer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              color: isDarkMode ? HSBCColors.darkSurface : Colors.grey.shade200,
            ),
            
            // Scrollable disclaimer content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDisclaimerSection(
                      'Time of Quotes',
                      'Free real-time quotes as at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} on ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year} HKT',
                      isDarkMode,
                    ),
                    
                    _buildDisclaimerSection(
                      'Information Source',
                      'Information and data published on this page is provided by The Hongkong and Shanghai Banking Corporation Limited.',
                      isDarkMode,
                    ),
                    
                    _buildDisclaimerSection(
                      'Copyright',
                      '© The Hongkong and Shanghai Banking Corporation Limited ${DateTime.now().year}. All rights reserved. Republication or redistribution of The Hongkong and Shanghai Banking Corporation Limited content, including by framing or similar means, is prohibited without the prior written consent of The Hongkong and Shanghai Banking Corporation Limited.',
                      isDarkMode,
                    ),
                    
                    _buildDisclaimerSection(
                      'Trading Fees',
                      'It should be noted that frequent trading in digital assets will incur higher brokerage and associated trading fees, and this may impact your investment returns from trading.',
                      isDarkMode,
                    ),
                    
                    _buildDisclaimerSection(
                      'No Investment Advice',
                      'The information on this page is neither a recommendation, an offer to sell, nor solicitation of an offer to purchase any investment. The Bank does not provide investment advice.',
                      isDarkMode,
                    ),
                    
                    _buildDisclaimerSection(
                      'Risk Disclosure',
                      'Digital assets involve significant risks including price volatility, liquidity, market, and cybersecurity risks. The value of digital assets can decrease rapidly and investors may lose the entire value of their investment.',
                      isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper to build a section in the disclaimer
  Widget _buildDisclaimerSection(String title, String content, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to convert month number to month name
  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    // Month is 1-based (1-12), array is 0-based (0-11)
    return monthNames[month - 1];
  }
} 
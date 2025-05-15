import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../platform_widgets.dart';
import '../theme.dart';
import '../widgets/hsbc_app_bar.dart';
import '../widgets/hsbc_drawer.dart';
import '../widgets/asset_ticker.dart';
import '../services/digital_asset_service.dart';
import '../services/auth_service.dart';
import '../widgets/crypto_bottom_nav.dart';

// Pages for each tab
import 'portfolio_page.dart'; // Home tab
import 'market_page.dart';    // Trade tab
import 'news_page.dart';      // Discover tab

class AuthenticatedHomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const AuthenticatedHomePage({
    super.key,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
  });

  @override
  State<AuthenticatedHomePage> createState() => _AuthenticatedHomePageState();
}

class _AuthenticatedHomePageState extends State<AuthenticatedHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DigitalAssetService _assetService = DigitalAssetService();
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  
  // List of pages to show in tabs
  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize pages with unique keys for proper state management
    _pages = [
      const PortfolioPage(key: PageStorageKey('portfolio')),
      const MarketPage(key: PageStorageKey('market')),
      const NewsPage(key: PageStorageKey('news')),
    ];
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _refreshPage() {
    // In a real app, would refresh data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing...')),
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
  
  void _logout() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
        title: Text(
          'Log Out',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HSBCColors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _authService.logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get digital assets from service
    final assets = _assetService.getAllAssets();
    final tickerItems = assets.map((asset) => AssetTickerItem(
      symbol: asset.symbol,
      price: asset.formattedPrice,
      change: asset.change24h,
      changeAbs: asset.formattedChange,
      percent: asset.changePercent,
    )).toList();

    bool isDarkMode = widget.currentThemeMode == ThemeMode.dark ||
        (widget.currentThemeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: HSBCAppBar(
          onMenuPressed: _openDrawer,
          onRefreshPressed: _refreshPage,
          onSearchTap: _showSearchModal,
        ),
        drawer: HSBCDrawer(
          onThemeModeChanged: widget.onThemeModeChanged,
          currentThemeMode: widget.currentThemeMode,
          onLogout: _logout,
          isLoggedIn: true,
        ),
        bottomNavigationBar: CryptoBottomNav(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          isDarkMode: isDarkMode,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Asset ticker at the top
              AssetTicker(items: tickerItems),
              
              // Main content - current tab page
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'platform_widgets.dart';
import 'theme.dart';
import 'services/theme_service.dart';
import 'services/auth_service.dart';
import 'pages/home_page.dart';
import 'pages/authenticated_home_page.dart';
import 'pages/login_loading_page.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Configure Flutter for web
  setUrlStrategy(PathUrlStrategy());
  
  // Disable debug painting to remove the yellow/red debug indicators
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;
  
  // Ensure Flutter is initialized before accessing SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load saved theme mode
  final themeMode = await ThemeService.loadThemeMode();
  
  runApp(MyApp(initialThemeMode: themeMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  
  const MyApp({
    super.key,
    this.initialThemeMode = ThemeMode.system,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  
  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    
    // Listen to auth state changes
    _authService.authStateStream.listen((isAuthenticated) {
      setState(() {
        _isLoggedIn = isAuthenticated;
      });
    });
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    ThemeService.saveThemeMode(mode);
  }
  
  void _handleLoginComplete() {
    setState(() {
      _isLoggedIn = true;
      // Print debug message to confirm this is called
      print('Login complete, redirecting to authenticated home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'HSBC Digital',
      navigatorKey: navigatorKey,
      materialLightTheme: hsbcLightTheme(),
      materialDarkTheme: hsbcDarkTheme(),
      cupertinoLightTheme: hsbcCupertinoLightTheme(),
      cupertinoDarkTheme: hsbcCupertinoDarkTheme(),
      themeMode: _themeMode,
      home: _isLoggedIn 
        ? AuthenticatedHomePage(
            onThemeModeChanged: _setThemeMode,
            currentThemeMode: _themeMode,
          )
        : HomePage(
            onThemeModeChanged: _setThemeMode,
            currentThemeMode: _themeMode,
            onLogin: () async {
              // Show login loading page
              await Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (context) => LoginLoadingPage(
                    onLoginComplete: _handleLoginComplete,
                  ),
                ),
              );
            },
          ),
    );
  }
}

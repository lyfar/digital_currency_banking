import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Platform-aware app wrapper
class PlatformApp extends StatelessWidget {
  final String title;
  final Widget home;
  final ThemeData materialLightTheme;
  final ThemeData materialDarkTheme;
  final CupertinoThemeData cupertinoLightTheme;
  final CupertinoThemeData cupertinoDarkTheme;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final ThemeMode themeMode;
  final GlobalKey<NavigatorState>? navigatorKey;

  const PlatformApp({
    super.key,
    required this.title,
    required this.home,
    required this.materialLightTheme,
    required this.materialDarkTheme,
    required this.cupertinoLightTheme,
    required this.cupertinoDarkTheme,
    this.routes,
    this.initialRoute,
    this.themeMode = ThemeMode.system,
    this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    // For web or Android, use MaterialApp
    if (kIsWeb || (Platform.isAndroid)) {
      return MaterialApp(
        title: title,
        theme: materialLightTheme,
        darkTheme: materialDarkTheme,
        themeMode: themeMode,
        home: home,
        routes: routes ?? const {},
        initialRoute: initialRoute,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      );
    }
    // For iOS, use CupertinoApp
    else if (Platform.isIOS) {
      // CupertinoApp doesn't support darkTheme natively, so we handle it manually
      final effectiveTheme = themeMode == ThemeMode.system
          ? (MediaQuery.platformBrightnessOf(context) == Brightness.dark
              ? cupertinoDarkTheme
              : cupertinoLightTheme)
          : (themeMode == ThemeMode.dark ? cupertinoDarkTheme : cupertinoLightTheme);
      
      return CupertinoApp(
        title: title,
        theme: effectiveTheme,
        home: home,
        routes: routes ?? const {},
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      );
    }
    // For other platforms (like desktop), use MaterialApp as fallback
    else {
      return MaterialApp(
        title: title,
        theme: materialLightTheme,
        darkTheme: materialDarkTheme,
        themeMode: themeMode,
        home: home,
        routes: routes ?? const {},
        initialRoute: initialRoute,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      );
    }
  }
}

// Platform-aware scaffold
class PlatformScaffold extends StatelessWidget {
  final Widget body;
  final PlatformAppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const PlatformScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    if (isAppleOrWeb()) {
      return CupertinoPageScaffold(
        navigationBar: appBar?.buildCupertino(context),
        child: SafeArea(
          child: Stack(
            children: [
              body,
              if (floatingActionButton != null)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: floatingActionButton!,
                ),
              if (bottomNavigationBar != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: bottomNavigationBar!,
                ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar?.buildMaterial(context),
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      );
    }
  }
}

// Platform-aware AppBar
class PlatformAppBar {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;

  const PlatformAppBar({
    required this.title,
    this.actions,
    this.leading,
  });

  PreferredSizeWidget buildMaterial(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: title,
      actions: actions,
      leading: leading,
    );
  }

  CupertinoNavigationBar buildCupertino(BuildContext context) {
    return CupertinoNavigationBar(
      middle: title,
      trailing: actions != null && actions!.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            )
          : null,
      leading: leading,
    );
  }
}

// Platform-aware FloatingActionButton
class PlatformFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final IconData cupertinoIcon;
  final String? tooltip;

  const PlatformFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.cupertinoIcon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    if (isAppleOrWeb()) {
      return CupertinoButton(
        onPressed: onPressed,
        color: CupertinoTheme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
        padding: const EdgeInsets.all(14),
        child: Icon(
          cupertinoIcon,
          color: CupertinoColors.white,
        ),
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(icon),
      );
    }
  }
}

// Platform-aware Button
class PlatformButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool filled;

  const PlatformButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isAppleOrWeb()) {
      return CupertinoButton(
        onPressed: onPressed,
        color: filled ? CupertinoTheme.of(context).primaryColor : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: BorderRadius.zero,
        child: child,
      );
    } else {
      return filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              child: child,
            )
          : TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              child: child,
            );
    }
  }
}

// Platform-aware TextField
class PlatformTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const PlatformTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isAppleOrWeb()) {
      return CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        padding: const EdgeInsets.all(12),
      );
    } else {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: placeholder,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      );
    }
  }
}

// Platform-aware Alert Dialog
class PlatformAlertDialog {
  final String title;
  final String message;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;

  const PlatformAlertDialog({
    required this.title,
    required this.message,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
  });

  Future<void> show(BuildContext context) async {
    if (isAppleOrWeb()) {
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              if (secondaryButtonText != null)
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onSecondaryButtonPressed != null) {
                      onSecondaryButtonPressed!();
                    }
                  },
                  child: Text(secondaryButtonText!),
                ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPrimaryButtonPressed();
                },
                child: Text(primaryButtonText),
              ),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              if (secondaryButtonText != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onSecondaryButtonPressed != null) {
                      onSecondaryButtonPressed!();
                    }
                  },
                  child: Text(secondaryButtonText!),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPrimaryButtonPressed();
                },
                child: Text(primaryButtonText),
              ),
            ],
          );
        },
      );
    }
  }
}

// Helper functions
bool isAppleOrWeb() {
  if (kIsWeb) return true;
  return Platform.isIOS || Platform.isMacOS;
}

TextStyle getPlatformTextStyle(BuildContext context, {bool large = false}) {
  if (isAppleOrWeb()) {
    return large
        ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
        : CupertinoTheme.of(context).textTheme.textStyle;
  } else {
    return large
        ? Theme.of(context).textTheme.headlineMedium!
        : Theme.of(context).textTheme.bodyMedium!;
  }
} 
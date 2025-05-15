import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../platform_widgets.dart';
import '../theme.dart';
import 'loading_overlay.dart';

class LoginButton extends StatefulWidget {
  final Future<void> Function() onPressed;

  const LoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingOverlay();
    }

    return Stack(
      children: [
        // Animated glow effect
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: HSBCColors.red.withOpacity(0.3),
                    blurRadius: _glowAnimation.value * 20,
                    spreadRadius: _glowAnimation.value * 2,
                  ),
                ],
              ),
            );
          },
        ),
        // Main button
        ElevatedButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(HSBCColors.red),
            foregroundColor: MaterialStateProperty.all(HSBCColors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.pressed)
                  ? HSBCColors.red.withOpacity(0.8)
                  : null,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isAppleOrWeb() ? CupertinoIcons.lock : Icons.lock_outline,
                    color: HSBCColors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Log In',
                    style: TextStyle(
                      color: HSBCColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 
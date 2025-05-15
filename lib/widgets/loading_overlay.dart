import 'package:flutter/material.dart';
import '../theme.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({super.key});

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  final List<String> _loadingSteps = [
    'Establishing secure connection...',
    'Verifying credentials...',
    'Checking account status...',
    'Loading your profile...',
  ];

  int _currentStep = 0;
  bool _isDarkTheme = true;

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentStep = (_currentStep + 1) % _loadingSteps.length;
          _isDarkTheme = !_isDarkTheme;
        });
        _startLoadingAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isDarkTheme ? HSBCColors.darkGrey : HSBCColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // HSBC Logo Animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: HSBCColors.red,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: HSBCColors.red.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'HSBC',
                  style: TextStyle(
                    color: HSBCColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Loading Step Text
            Text(
              _loadingSteps[_currentStep],
              style: TextStyle(
                color: _isDarkTheme ? HSBCColors.white : HSBCColors.darkGrey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            // Loading Indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isDarkTheme ? HSBCColors.white : HSBCColors.red,
                ),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class LoginLoadingPage extends StatefulWidget {
  final VoidCallback onLoginComplete;

  const LoginLoadingPage({
    super.key,
    required this.onLoginComplete,
  });

  @override
  State<LoginLoadingPage> createState() => _LoginLoadingPageState();
}

class _LoginLoadingPageState extends State<LoginLoadingPage> {
  final AuthService _authService = AuthService();
  String _currentStep = "Initializing secure connection...";

  @override
  void initState() {
    super.initState();
    _performLogin();
  }

  Future<void> _performLogin() async {
    // Simplified: Just 3 auth steps with messages
    final securitySteps = [
      "Initializing secure connection...",
      "Verifying credentials...",
      "Completing authentication..."
    ];
    
    // Show each step with a delay
    for (int i = 0; i < securitySteps.length; i++) {
      if (!mounted) return;
      
      setState(() {
        _currentStep = securitySteps[i];
      });
      
      await Future.delayed(const Duration(milliseconds: 800));
    }
    
    // Final authentication step
    final success = await _authService.login();
    if (!mounted) return;
    
    if (success) {
      widget.onLoginComplete();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the current app theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? HSBCColors.darkGrey : Colors.white;
    final textColor = isDarkMode ? Colors.white : HSBCColors.darkGrey;
    final indicatorColor = isDarkMode ? Colors.white : HSBCColors.red;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // HSBC Logo
            Image(
              image: const AssetImage('images/bank-hsbc.png'),
              width: 80,
              height: 80,
              color: HSBCColors.red,
            ),
            const SizedBox(height: 40),
            // Current security step message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _currentStep,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
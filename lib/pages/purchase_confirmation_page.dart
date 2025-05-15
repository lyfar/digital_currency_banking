import 'package:flutter/material.dart';
import '../models/digital_asset.dart';
import '../theme.dart';
import '../widgets/hsbc_details_app_bar.dart';
import '../utils/number_formatter.dart';

class PurchaseConfirmationPage extends StatefulWidget {
  final DigitalAsset asset;
  final double amount;
  final double assetQuantity;
  final String account;

  const PurchaseConfirmationPage({
    super.key,
    required this.asset,
    required this.amount,
    required this.assetQuantity,
    required this.account,
  });

  @override
  State<PurchaseConfirmationPage> createState() => _PurchaseConfirmationPageState();
}

class _PurchaseConfirmationPageState extends State<PurchaseConfirmationPage> {
  bool _isLoading = false;
  bool _isComplete = false;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fee = widget.amount * 0.01; // 1% fee for example
    final total = widget.amount + fee;
    
    if (_isComplete) {
      return _buildSuccessScreen(isDarkMode);
    }
    
    return Scaffold(
      backgroundColor: isDarkMode ? HSBCColors.darkBackground : Colors.grey.shade100,
      appBar: HSBCDetailsAppBar(
        title: 'Review Purchase',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purchase summary
                _buildSummaryCard(isDarkMode, fee, total),
                
                const SizedBox(height: 24),
                
                // Disclaimer section
                _buildDisclaimerSection(isDarkMode),
                
                // Add space for the button at bottom
                const SizedBox(height: 80),
              ],
            ),
          ),
          
          // Fixed button at bottom
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _agreedToTerms ? HSBCColors.red : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _agreedToTerms ? _completePurchase : null,
                  child: Text(
                    'Confirm Purchase',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard(bool isDarkMode, double fee, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            'Purchase Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          
          // Asset and amount
          _buildSummaryRow(
            'Buying',
            '${NumberFormatter.formatNumber(widget.assetQuantity, decimalPlaces: 8)} ${widget.asset.symbol}',
            isDarkMode,
          ),
          _buildSummaryRow(
            'Price',
            widget.asset.formattedPrice,
            isDarkMode,
          ),
          _buildSummaryRow(
            'Purchase amount',
            NumberFormatter.formatCurrency(widget.amount),
            isDarkMode,
          ),
          _buildSummaryRow(
            'Fee',
            NumberFormatter.formatCurrency(fee),
            isDarkMode,
          ),
          
          const Divider(height: 32),
          
          // Total
          _buildSummaryRow(
            'Total',
            NumberFormatter.formatCurrency(total),
            isDarkMode,
            isBold: true,
          ),
          
          const SizedBox(height: 16),
          
          // Payment method
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: HSBCColors.red,
                  child: Icon(Icons.account_balance, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        widget.account,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDisclaimerSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Disclaimer text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: Text(
            'Digital assets are high-risk investments. Their value can fluctuate significantly '
            'and past performance is not indicative of future results. '
            'Please be aware that withdrawals may be subject to a holding period.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Terms checkbox
        Row(
          children: [
            Checkbox(
              value: _agreedToTerms,
              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value ?? false;
                });
              },
              activeColor: HSBCColors.red,
            ),
            Expanded(
              child: Text(
                'I understand that I won\'t be able to withdraw these assets for 14 days',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSummaryRow(String label, String value, bool isDarkMode, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _completePurchase() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
      _isComplete = true;
    });
  }
  
  Widget _buildSuccessScreen(bool isDarkMode) {
    return Scaffold(
      backgroundColor: isDarkMode ? HSBCColors.darkBackground : Colors.black,
      appBar: HSBCDetailsAppBar(
        title: 'Purchase Complete',
        onBackPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Visual animation - colored circles
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated coins visual
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        children: List.generate(
                          7,
                          (index) => Positioned(
                            left: (index * 10) % 100,
                            top: (index * 15) % 100,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    HSBCColors.red.withOpacity(0.8),
                                    Colors.purple.withOpacity(0.8),
                                    Colors.blue.withOpacity(0.8),
                                  ][index % 3] == HSBCColors.red.withOpacity(0.8) ? 
                                  [HSBCColors.red.withOpacity(0.8), Colors.orange.withOpacity(0.5)] :
                                  index % 3 == 1 ? 
                                  [Colors.purple.withOpacity(0.8), Colors.pink.withOpacity(0.5)] :
                                  [Colors.blue.withOpacity(0.8), Colors.cyan.withOpacity(0.5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Success message
                    Text(
                      'You bought ${NumberFormatter.formatCurrency(widget.amount)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'worth of ${widget.asset.symbol}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Set take-profit button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: HSBCColors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shield_outlined,
                              color: HSBCColors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Set take-profit or stop-loss',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lock in your gains or limit your losses.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade400,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom action buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Done button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HSBCColors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // View order button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order details not implemented in this demo')),
                        );
                      },
                      child: const Text(
                        'View order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
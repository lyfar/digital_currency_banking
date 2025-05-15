import 'package:flutter/material.dart';
import '../models/digital_asset.dart';
import '../theme.dart';
import '../widgets/hsbc_details_app_bar.dart';
import '../utils/number_formatter.dart';
import 'purchase_confirmation_page.dart';

class PurchaseAmountPage extends StatefulWidget {
  final DigitalAsset asset;

  const PurchaseAmountPage({
    super.key,
    required this.asset,
  });

  @override
  State<PurchaseAmountPage> createState() => _PurchaseAmountPageState();
}

class _PurchaseAmountPageState extends State<PurchaseAmountPage> {
  String amount = "10"; // Default amount
  String selectedAccount = "HSBC One"; // Default account
  double balance = 26809.54; // Mock balance

  void addDigit(String digit) {
    if (amount == "0") {
      setState(() {
        amount = digit;
      });
    } else {
      setState(() {
        amount += digit;
      });
    }
  }

  void removeDigit() {
    if (amount.length > 1) {
      setState(() {
        amount = amount.substring(0, amount.length - 1);
      });
    } else {
      setState(() {
        amount = "0";
      });
    }
  }

  void addDecimalPoint() {
    if (!amount.contains(".")) {
      setState(() {
        amount += ".";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final assetQuantity = (double.tryParse(amount) ?? 0) / widget.asset.price;
    
    return Scaffold(
      backgroundColor: isDarkMode ? HSBCColors.darkBackground : Colors.grey.shade100,
      appBar: HSBCDetailsAppBar(
        title: 'Buy ${widget.asset.symbol}',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Input display section
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Token icon and name
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.asset.symbol.substring(0, 1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: HSBCColors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Buy ${widget.asset.symbol}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Amount display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 32,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            amount,
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "That's ≈${NumberFormatter.formatNumber(assetQuantity, decimalPlaces: 8)} ${widget.asset.symbol}",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Account selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        selectedAccount,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        NumberFormatter.formatCurrency(balance),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
          
          // Quick amount buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAmountButton("20", isDarkMode),
                _buildQuickAmountButton("50", isDarkMode),
                _buildQuickAmountButton("100", isDarkMode),
                _buildQuickAmountButton("250", isDarkMode),
              ],
            ),
          ),

          const SizedBox(height: 16),
          
          // Numeric keypad
          Expanded(
            flex: 3,
            child: Container(
              color: isDarkMode ? Colors.black : Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildKeypadButton("1", isDarkMode),
                        _buildKeypadButton("2", isDarkMode),
                        _buildKeypadButton("3", isDarkMode),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildKeypadButton("4", isDarkMode),
                        _buildKeypadButton("5", isDarkMode),
                        _buildKeypadButton("6", isDarkMode),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildKeypadButton("7", isDarkMode),
                        _buildKeypadButton("8", isDarkMode),
                        _buildKeypadButton("9", isDarkMode),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildKeypadButton(".", isDarkMode),
                        _buildKeypadButton("0", isDarkMode),
                        _buildKeypadButton("<", isDarkMode, isIcon: true),
                      ],
                    ),
                  ),
                  // Next button at bottom
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HSBCColors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PurchaseConfirmationPage(
                              asset: widget.asset,
                              amount: double.tryParse(amount) ?? 0,
                              assetQuantity: assetQuantity,
                              account: selectedAccount,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButton(String value, bool isDarkMode) {
    return InkWell(
      onTap: () {
        setState(() {
          amount = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? HSBCColors.darkCardColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          NumberFormatter.formatCurrency(double.parse(value)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String value, bool isDarkMode, {bool isIcon = false}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (isIcon) {
            removeDigit();
          } else if (value == ".") {
            addDecimalPoint();
          } else {
            addDigit(value);
          }
        },
        child: Container(
          alignment: Alignment.center,
          color: isDarkMode ? Colors.black : Colors.white,
          child: isIcon
              ? Icon(
                  Icons.backspace_outlined,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 24,
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
} 
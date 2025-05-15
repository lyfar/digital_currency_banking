import 'package:flutter/material.dart';
import '../theme.dart';

class HSBCInfoDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const HSBCInfoDrawer({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HSBC Digital Asset Trading',
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
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          
          Divider(
            color: isDarkMode ? HSBCColors.darkSurface : HSBCColors.grey.withOpacity(0.3),
          ),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Introduction section
                    const Text(
                      'Introduction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HSBCColors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hong Kong\'s regulatory push towards digital assets has spurred banks like HSBC to innovate in digital trading services. HSBC Hong Kong (HSBC HK) has introduced new ways for clients to invest in gold digitally, while exploring broader tokenized asset offerings.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // HSBC Gold Token section
                    const Text(
                      'HSBC Gold Token (XGT)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HSBCColors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      'Tokenized Physical Gold',
                      'Each token represents 0.001 troy ounces of physical gold stored in HSBC\'s vault.',
                      Icons.token,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Digital Ownership',
                      'Offers fractional ownership of actual 99.99% gold bars held by HSBC.',
                      Icons.verified_user,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Trading Platform',
                      'Available in HSBC HK Mobile Banking app and online banking website.',
                      Icons.phone_android,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Market Making',
                      'HSBC serves as the market maker with real-time gold prices.',
                      Icons.price_change,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    
                    // Wayfoong Statement Gold section
                    const Text(
                      'Wayfoong Statement Gold (WSG)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HSBCColors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      'Notional Gold',
                      'Paper gold account that allows clients to buy or sell gold units without physical delivery.',
                      Icons.description,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Low Barrier',
                      'Start with as little as one unit (one mace of gold, ~3.7 grams).',
                      Icons.money,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Convenient Trading',
                      'Available via multiple channels including online banking, mobile app, phone, or branches.',
                      Icons.phone_iphone,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Regulated Product',
                      'Authorized by Hong Kong\'s Securities and Futures Commission.',
                      Icons.gavel,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    
                    // Future Platform Features
                    const Text(
                      'Future Platform Features',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HSBCColors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      'Tokenized Bonds',
                      'Green bonds and treasury securities offered as digital tokens.',
                      Icons.account_balance,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Tokenized REITs',
                      'Real estate investment trusts available as digital tokens.',
                      Icons.business,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Enhanced Security',
                      'Leveraging blockchain technology for transparency and security.',
                      Icons.security,
                      isDarkMode,
                    ),
                    _buildFeatureItem(
                      'Interoperability',
                      'Potential future interoperability as regulations evolve.',
                      Icons.swap_horiz,
                      isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    
                    // Call to action
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: HSBCColors.red,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Explore Digital Asset Trading',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(String title, String description, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode 
                ? HSBCColors.darkSurface
                : HSBCColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: HSBCColors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode
                      ? HSBCColors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
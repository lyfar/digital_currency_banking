import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/digital_asset_service.dart';
import '../models/digital_asset.dart';
import '../services/transaction_service.dart';
import '../widgets/activity_widget.dart';
import '../utils/number_formatter.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final DigitalAssetService _assetService = DigitalAssetService();
  final TransactionService _transactionService = TransactionService();
  late List<DigitalAsset> _ownedAssets;
  late List<ActivityItem> _recentTransactions;
  double _totalPortfolioValue = 0.0;
  double _totalGainLoss = 0.0;
  double _gainLossPercentage = 0.0;
  
  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
    _loadTransactionData();
  }
  
  void _loadPortfolioData() {
    final allAssets = _assetService.getAllAssets();
    _ownedAssets = allAssets.take(3).toList();
    
    double totalValue = 0;
    double totalChange = 0;
    
    for (var asset in _ownedAssets) {
      switch (asset.symbol) {
        case 'XGT':
          totalValue += asset.price * 2.5;
          totalChange += (asset.price * asset.change24h / 100) * 2.5;
          break;
        case 'WSG':
          totalValue += asset.price * 0.75;
          totalChange += (asset.price * asset.change24h / 100) * 0.75;
          break;
        case 'HGST':
          totalValue += asset.price * 10.0;
          totalChange += (asset.price * asset.change24h / 100) * 10.0;
          break;
        default:
          break;
      }
    }
    
    setState(() {
      _totalPortfolioValue = totalValue;
      _totalGainLoss = totalChange;
      _gainLossPercentage = totalValue > 0 ? (totalChange / totalValue) * 100 : 0;
    });
  }
  
  void _loadTransactionData() {
    setState(() {
      _recentTransactions = _transactionService.getRecentTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Portfolio value card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Portfolio Value',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${NumberFormatter.formatHKD(_totalPortfolioValue)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _totalGainLoss >= 0 
                              ? Colors.green.withOpacity(0.1) 
                              : HSBCColors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _totalGainLoss >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                              color: _totalGainLoss >= 0 ? Colors.green : HSBCColors.red,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              NumberFormatter.formatPercentage(_gainLossPercentage),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _totalGainLoss >= 0 ? Colors.green : HSBCColors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_totalGainLoss >= 0 ? '+' : ''}${NumberFormatter.formatHKD(_totalGainLoss.abs())} today',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Cash position card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cash Position',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'HSBC One',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Settled cash:',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        NumberFormatter.formatHKD(26809.54),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending deposits:',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        NumberFormatter.formatHKD(0.00),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Transfer funds functionality not implemented in this demo')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HSBCColors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text('Transfer from HSBC One'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Portfolio holdings title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Holdings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Add New'),
                  style: TextButton.styleFrom(
                    foregroundColor: HSBCColors.red,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Holdings list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ownedAssets.length,
              itemBuilder: (context, index) {
                final asset = _ownedAssets[index];
                double quantity = 0;
                double value = 0;
                
                switch (asset.symbol) {
                  case 'XGT':
                    quantity = 2.5;
                    value = asset.price * quantity;
                    break;
                  case 'WSG':
                    quantity = 0.75;
                    value = asset.price * quantity;
                    break;
                  case 'HGST':
                    quantity = 10.0;
                    value = asset.price * quantity;
                    break;
                  default:
                    break;
                }
                
                return _buildHoldingItem(context, asset, quantity, value, isDarkMode);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Activity widget
            ActivityWidget(
              activities: _recentTransactions,
              onViewAll: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View all transactions')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHoldingItem(
    BuildContext context, 
    DigitalAsset asset, 
    double quantity, 
    double value,
    bool isDarkMode
  ) {
    final isPositiveChange = asset.change24h >= 0;
    final changeColor = isPositiveChange ? Colors.green : HSBCColors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? HSBCColors.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Asset icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: HSBCColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                asset.symbol.substring(0, 1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HSBCColors.red,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Asset details
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberFormatter.formatNumber(quantity, decimalPlaces: quantity.truncateToDouble() == quantity ? 0 : 4)} ${asset.symbol}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Price and value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormatter.formatHKD(value),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositiveChange ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: changeColor,
                    size: 16,
                  ),
                  Text(
                    asset.changePercent,
                    style: TextStyle(
                      fontSize: 14,
                      color: changeColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 
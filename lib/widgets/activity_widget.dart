import 'package:flutter/material.dart';
import '../theme.dart';

class ActivityItem {
  final String type;
  final String symbol;
  final String company;
  final String date;
  final String time;
  final double amount;
  final double price;
  final double shares;
  final bool isCancelled;

  ActivityItem({
    required this.type,
    required this.symbol,
    required this.company,
    required this.date,
    required this.time,
    required this.amount,
    required this.price,
    required this.shares,
    this.isCancelled = false,
  });
}

class ActivityWidget extends StatelessWidget {
  final List<ActivityItem> activities;
  final VoidCallback? onViewAll;

  const ActivityWidget({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Header with title and view all button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : HSBCColors.black,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: HSBCColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Activity items list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length > 3 ? 3 : activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _buildActivityItem(context, activity, isDarkMode);
          },
        ),
      ],
    );
  }
  
  Widget _buildActivityItem(BuildContext context, ActivityItem activity, bool isDarkMode) {
    final isPositive = activity.type == 'Buy';
    final amountColor = activity.isCancelled
        ? Colors.grey
        : (isPositive ? Colors.green : HSBCColors.red);
    
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
          // Symbol icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconColor(activity.symbol),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                activity.symbol.substring(0, 1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Activity details
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity.type} ${activity.symbol}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    decoration: activity.isCancelled 
                      ? TextDecoration.lineThrough 
                      : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activity.date} ${activity.time}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '-' : '+'}${activity.amount.toStringAsFixed(2)} HKD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                  decoration: activity.isCancelled 
                    ? TextDecoration.lineThrough 
                    : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${activity.shares} tokens @ ${activity.price}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              if (activity.isCancelled)
                const Text(
                  'Cancelled',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getIconColor(String symbol) {
    switch (symbol) {
      case 'XGT':
        return HSBCColors.red;
      case 'WSG':
        return Colors.purple;
      case 'HGST':
        return Colors.green.shade700;
      default:
        return Colors.blueGrey;
    }
  }
} 
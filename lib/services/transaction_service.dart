import '../widgets/activity_widget.dart';

class TransactionService {
  // Singleton pattern
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();
  
  List<ActivityItem> getRecentTransactions() {
    // This would typically fetch from an API or local database
    // For now, we'll return mock data
    return [
      ActivityItem(
        type: 'Sell',
        symbol: 'XGT',
        company: 'HSBC Gold Token',
        date: '28 Feb',
        time: '19:12',
        amount: 92.55,
        price: 234.56,
        shares: 0.3945,
      ),
      ActivityItem(
        type: 'Sell',
        symbol: 'WSG',
        company: 'Wayfoong Statement Gold',
        date: '28 Feb',
        time: '19:12',
        amount: 1316.60,
        price: 1755.47,
        shares: 0.75,
      ),
      ActivityItem(
        type: 'Sell',
        symbol: 'WSG',
        company: 'Wayfoong Statement Gold',
        date: '28 Feb',
        time: '13:59',
        amount: 1409.17,
        price: 1755.47,
        shares: 0.8028,
        isCancelled: true,
      ),
      ActivityItem(
        type: 'Sell',
        symbol: 'HGST',
        company: 'HSBC Green Bond Token',
        date: '13 Jan',
        time: '10:16',
        amount: 5437.23,
        price: 1087.45,
        shares: 5,
      ),
      ActivityItem(
        type: 'Sell',
        symbol: 'HGST',
        company: 'HSBC Green Bond Token',
        date: '10 Jan',
        time: '17:52',
        amount: 4166.01,
        price: 1087.45,
        shares: 3.8309,
        isCancelled: true,
      ),
      ActivityItem(
        type: 'Buy',
        symbol: 'XGT',
        company: 'HSBC Gold Token',
        date: '05 Jan',
        time: '14:25',
        amount: 3400.50,
        price: 234.56,
        shares: 14.5,
      ),
      ActivityItem(
        type: 'Buy',
        symbol: 'XGT',
        company: 'HSBC Gold Token',
        date: '02 Jan',
        time: '09:30',
        amount: 586.40,
        price: 234.56,
        shares: 2.5,
      ),
    ];
  }
} 
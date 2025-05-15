import 'package:flutter/material.dart';
import '../theme.dart';

class NewsItem {
  final String title;
  final String source;
  final DateTime date;
  final String? imageUrl;
  final String category;

  const NewsItem({
    required this.title,
    required this.source,
    required this.date,
    this.imageUrl,
    required this.category,
  });
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final List<String> _categories = ['All', 'HSBC', 'Markets', 'Tokens', 'Regulation'];
  String _selectedCategory = 'All';
  
  // Mock news data
  final List<NewsItem> _allNews = [
    NewsItem(
      title: 'HSBC Launches Digital Gold Token for Retail Investors',
      source: 'HSBC News',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      category: 'HSBC',
    ),
    NewsItem(
      title: 'Digital Asset Market Trends: Q2 2023 Analysis',
      source: 'Market Insights',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Markets',
    ),
    NewsItem(
      title: 'Regulatory Updates for Digital Asset Custody in Asia',
      source: 'Regulation Today',
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Regulation',
    ),
    NewsItem(
      title: 'New HSBC Treasury Token Shows Strong Initial Demand',
      source: 'HSBC News',
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'HSBC',
    ),
    NewsItem(
      title: 'HSBC REIT Token: Transforming Real Estate Investment',
      source: 'Property Investment',
      date: DateTime.now().subtract(const Duration(days: 4)),
      category: 'Tokens',
    ),
    NewsItem(
      title: 'Market Update: Digital Assets Weekly Roundup',
      source: 'Market Watch',
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Markets',
    ),
  ];
  
  late List<NewsItem> _filteredNews;
  
  @override
  void initState() {
    super.initState();
    _filteredNews = _allNews;
  }
  
  void _filterNewsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      
      if (category == 'All') {
        _filteredNews = _allNews;
      } else {
        _filteredNews = _allNews.where((news) => news.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News heading
          Text(
            'News',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Category tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return GestureDetector(
                  onTap: () => _filterNewsByCategory(category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? HSBCColors.red 
                        : (isDarkMode ? HSBCColors.darkCardColor : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                            ? HSBCColors.white 
                            : (isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // News list
          Expanded(
            child: _filteredNews.isEmpty
                ? _buildEmptyState(isDarkMode)
                : ListView.builder(
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      return _buildNewsItem(context, _filteredNews[index], isDarkMode);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 60,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No news articles found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? HSBCColors.white : HSBCColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNewsItem(BuildContext context, NewsItem news, bool isDarkMode) {
    // Format relative time
    String relativeTime;
    final now = DateTime.now();
    final difference = now.difference(news.date);
    
    if (difference.inMinutes < 60) {
      relativeTime = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      relativeTime = '${difference.inHours}h ago';
    } else {
      relativeTime = '${difference.inDays}d ago';
    }
    
    return GestureDetector(
      onTap: () {
        // Show news details - not implemented in demo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News details not implemented in demo')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News image or category tag
            if (news.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  news.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getCategoryColor(news.category).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(news.category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        news.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // News content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? HSBCColors.white : HSBCColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        news.source,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        relativeTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'HSBC':
        return HSBCColors.red;
      case 'Markets':
        return Colors.blue;
      case 'Tokens':
        return Colors.green;
      case 'Regulation':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 
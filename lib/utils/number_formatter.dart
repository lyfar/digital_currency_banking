import 'package:intl/intl.dart';

/// Utility class for formatting numbers in financial contexts
class NumberFormatter {
  /// Format a number as currency with 2 decimal places
  /// Example: $1,234.56
  static String formatCurrency(double value, {String symbol = '\$', int decimalPlaces = 2}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    );
    return formatter.format(value);
  }

  /// Format a number as HKD currency
  /// Example: HK$1,234.56
  static String formatHKD(double value) {
    return formatCurrency(value, symbol: 'HK\$');
  }

  /// Format a number with thousands separators and the specified decimal places
  /// Example: 1,234.56
  static String formatNumber(double value, {int decimalPlaces = 2}) {
    final formatter = NumberFormat.decimalPattern()
      ..minimumFractionDigits = decimalPlaces
      ..maximumFractionDigits = decimalPlaces;
    return formatter.format(value);
  }

  /// Format a percentage with the specified decimal places
  /// Example: +12.34% or -12.34%
  static String formatPercentage(double value, {int decimalPlaces = 2}) {
    final sign = value >= 0 ? '+' : '';
    final formatter = NumberFormat.decimalPattern()
      ..minimumFractionDigits = decimalPlaces
      ..maximumFractionDigits = decimalPlaces;
    return '$sign${formatter.format(value)}%';
  }

  /// Format a large number with appropriate suffix (K, M, B, T)
  /// Example: 1.2M, 3.4B
  static String formatCompactNumber(double value, {int decimalPlaces = 1}) {
    final formatter = NumberFormat.compact();
    return formatter.format(value);
  }
} 
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/formatters.dart';

/// Stat card widget for displaying financial statistics
class StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final String? trend;
  final bool isPositiveTrend;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showCurrency;

  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    this.trend,
    this.isPositiveTrend = true,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: iconColor ?? AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            showCurrency ? Formatters.currency(amount) : amount.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0d141c),
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositiveTrend
                            ? AppColors.successGreen
                            : AppColors.expenseRed)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isPositiveTrend
                          ? AppColors.successGreen
                          : AppColors.expenseRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Large stat card for total balance display
class BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onVisibilityToggle;
  final bool isVisible;

  const BalanceCard({
    super.key,
    required this.title,
    required this.amount,
    this.trend,
    this.isPositiveTrend = true,
    this.onVisibilityToggle,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              if (onVisibilityToggle != null)
                GestureDetector(
                  onTap: onVisibilityToggle,
                  child: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isVisible ? Formatters.currency(amount) : '••••••',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0d141c),
              letterSpacing: -0.5,
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositiveTrend
                            ? AppColors.successGreen
                            : AppColors.expenseRed)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPositiveTrend
                          ? AppColors.successGreen
                          : AppColors.expenseRed,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'from last month',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

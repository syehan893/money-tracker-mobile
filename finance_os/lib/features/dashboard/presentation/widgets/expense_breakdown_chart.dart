import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_overview.dart';

/// Widget for displaying expense breakdown as a horizontal bar chart
class ExpenseBreakdownChart extends StatelessWidget {
  final List<ExpenseCategory> categories;

  const ExpenseBreakdownChart({
    super.key,
    required this.categories,
  });

  Color _getColorForIndex(int index) {
    final colors = [
      AppColors.primary,
      Colors.green.shade400,
      Colors.amber.shade400,
      Colors.grey.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
              const Text(
                'Expense Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'This Month',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stacked bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 16,
              child: Row(
                children: categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return Expanded(
                    flex: (category.percentage * 100).round(),
                    child: Container(
                      color: _getColorForIndex(index),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getColorForIndex(index),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${category.name} (${(category.percentage * 100).toStringAsFixed(0)}%)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/subscription.dart';

/// Card widget displaying subscription details
class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Logo/Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(subscription.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: subscription.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          subscription.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            _getCategoryIcon(subscription.category),
                            color: _getCategoryColor(subscription.category),
                          ),
                        ),
                      )
                    : Icon(
                        _getCategoryIcon(subscription.category),
                        color: _getCategoryColor(subscription.category),
                      ),
              ),
              const SizedBox(width: 12),

              // Subscription Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subscription.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: subscription.isActive
                                  ? null
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        if (!subscription.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Paused',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getBillingText(subscription),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Next: ${Formatters.dateShort(subscription.nextBillingDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isUpcoming(subscription.nextBillingDate)
                            ? AppColors.warning
                            : Colors.grey[500],
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
                    Formatters.currency(subscription.amount),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: subscription.isActive
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                  Text(
                    _getBillingCycleText(subscription.billingCycle),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),

              // Toggle/Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (value) {
                  switch (value) {
                    case 'toggle':
                      onToggle?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          subscription.isActive
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(subscription.isActive ? 'Pause' : 'Resume'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getBillingText(Subscription subscription) {
    if (subscription.description != null && subscription.description!.isNotEmpty) {
      return subscription.description!;
    }
    return subscription.category ?? 'Subscription';
  }

  String _getBillingCycleText(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.weekly:
        return '/week';
      case BillingCycle.monthly:
        return '/month';
      case BillingCycle.quarterly:
        return '/quarter';
      case BillingCycle.yearly:
        return '/year';
    }
  }

  bool _isUpcoming(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    return difference <= 7 && difference >= 0;
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'streaming':
        return Colors.red;
      case 'music':
        return Colors.green;
      case 'cloud':
        return Colors.blue;
      case 'productivity':
        return Colors.orange;
      case 'gaming':
        return Colors.purple;
      case 'fitness':
        return Colors.teal;
      case 'news':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'streaming':
        return Icons.play_circle_filled;
      case 'music':
        return Icons.music_note;
      case 'cloud':
        return Icons.cloud;
      case 'productivity':
        return Icons.work;
      case 'gaming':
        return Icons.sports_esports;
      case 'fitness':
        return Icons.fitness_center;
      case 'news':
        return Icons.article;
      default:
        return Icons.subscriptions;
    }
  }
}

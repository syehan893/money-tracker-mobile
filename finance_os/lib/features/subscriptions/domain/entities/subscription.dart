import 'package:equatable/equatable.dart';

/// Billing cycle for subscriptions
enum BillingCycle {
  weekly,
  monthly,
  quarterly,
  yearly,
}

/// Subscription entity representing recurring payments
class Subscription extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final DateTime? nextBillingDate;
  final String? category;
  final String? logoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    required this.billingCycle,
    required this.startDate,
    this.nextBillingDate,
    this.category,
    this.logoUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate monthly cost based on billing cycle
  double get monthlyCost {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 4.33;
      case BillingCycle.monthly:
        return amount;
      case BillingCycle.quarterly:
        return amount / 3;
      case BillingCycle.yearly:
        return amount / 12;
    }
  }

  /// Calculate yearly cost
  double get yearlyCost {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 52;
      case BillingCycle.monthly:
        return amount * 12;
      case BillingCycle.quarterly:
        return amount * 4;
      case BillingCycle.yearly:
        return amount;
    }
  }

  /// Check if subscription is due soon (within 7 days)
  bool get isDueSoon {
    if (nextBillingDate == null) return false;
    final daysUntilDue = nextBillingDate!.difference(DateTime.now()).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 7;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        amount,
        billingCycle,
        startDate,
        nextBillingDate,
        category,
        logoUrl,
        isActive,
        createdAt,
        updatedAt,
      ];
}

import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription.dart';

enum SubscriptionsStatus { initial, loading, success, failure }

class SubscriptionsState extends Equatable {
  final SubscriptionsStatus status;
  final List<Subscription> subscriptions;
  final bool isSubmitting;
  final String? errorMessage;

  const SubscriptionsState({
    this.status = SubscriptionsStatus.initial,
    this.subscriptions = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });

  /// Active subscriptions only
  List<Subscription> get activeSubscriptions =>
      subscriptions.where((s) => s.isActive).toList();

  /// Inactive (paused) subscriptions
  List<Subscription> get inactiveSubscriptions =>
      subscriptions.where((s) => !s.isActive).toList();

  /// Total monthly cost of all active subscriptions
  double get totalMonthlyCost {
    return activeSubscriptions.fold(0.0, (sum, sub) {
      switch (sub.billingCycle) {
        case BillingCycle.weekly:
          return sum + (sub.amount * 4);
        case BillingCycle.monthly:
          return sum + sub.amount;
        case BillingCycle.quarterly:
          return sum + (sub.amount / 3);
        case BillingCycle.yearly:
          return sum + (sub.amount / 12);
      }
    });
  }

  /// Total yearly cost of all active subscriptions
  double get totalYearlyCost => totalMonthlyCost * 12;

  /// Subscriptions due this month
  List<Subscription> get upcomingSubscriptions {
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return activeSubscriptions.where((sub) {
      final nextBilling = sub.nextBillingDate;
      return nextBilling.isBefore(endOfMonth) ||
             nextBilling.isAtSameMomentAs(endOfMonth);
    }).toList();
  }

  SubscriptionsState copyWith({
    SubscriptionsStatus? status,
    List<Subscription>? subscriptions,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return SubscriptionsState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, subscriptions, isSubmitting, errorMessage];
}

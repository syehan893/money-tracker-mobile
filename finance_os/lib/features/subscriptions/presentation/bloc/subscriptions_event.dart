import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription.dart';

abstract class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();

  @override
  List<Object?> get props => [];
}

class SubscriptionsLoadRequested extends SubscriptionsEvent {
  const SubscriptionsLoadRequested();
}

class SubscriptionCreateRequested extends SubscriptionsEvent {
  final String name;
  final String? description;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final String? category;
  final String? logoUrl;

  const SubscriptionCreateRequested({
    required this.name,
    this.description,
    required this.amount,
    required this.billingCycle,
    required this.startDate,
    this.category,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        amount,
        billingCycle,
        startDate,
        category,
        logoUrl,
      ];
}

class SubscriptionDeleteRequested extends SubscriptionsEvent {
  final String id;

  const SubscriptionDeleteRequested(this.id);

  @override
  List<Object> get props => [id];
}

class SubscriptionToggleRequested extends SubscriptionsEvent {
  final String id;

  const SubscriptionToggleRequested(this.id);

  @override
  List<Object> get props => [id];
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/subscription.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@freezed
class SubscriptionModel with _$SubscriptionModel {
  const SubscriptionModel._();

  const factory SubscriptionModel({
    required String id,
    required String name,
    String? description,
    required double amount,
    @JsonKey(name: 'billing_cycle') required String billingCycle,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'next_billing_date') DateTime? nextBillingDate,
    String? category,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Subscription toEntity() => Subscription(
        id: id,
        name: name,
        description: description,
        amount: amount,
        billingCycle: _parseBillingCycle(billingCycle),
        startDate: startDate,
        nextBillingDate: nextBillingDate,
        category: category,
        logoUrl: logoUrl,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static BillingCycle _parseBillingCycle(String value) {
    switch (value.toLowerCase()) {
      case 'weekly':
        return BillingCycle.weekly;
      case 'quarterly':
        return BillingCycle.quarterly;
      case 'yearly':
        return BillingCycle.yearly;
      default:
        return BillingCycle.monthly;
    }
  }

  static String billingCycleToString(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.weekly:
        return 'weekly';
      case BillingCycle.monthly:
        return 'monthly';
      case BillingCycle.quarterly:
        return 'quarterly';
      case BillingCycle.yearly:
        return 'yearly';
    }
  }

  factory SubscriptionModel.fromEntity(Subscription entity) => SubscriptionModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        amount: entity.amount,
        billingCycle: billingCycleToString(entity.billingCycle),
        startDate: entity.startDate,
        nextBillingDate: entity.nextBillingDate,
        category: entity.category,
        logoUrl: entity.logoUrl,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

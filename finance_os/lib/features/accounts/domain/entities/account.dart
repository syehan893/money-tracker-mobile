import 'package:equatable/equatable.dart';

/// Account type enumeration
enum AccountType {
  saving,
  spending,
  wallet,
  investment,
  business;

  String get displayName {
    switch (this) {
      case AccountType.saving:
        return 'Saving';
      case AccountType.spending:
        return 'Spending';
      case AccountType.wallet:
        return 'Wallet';
      case AccountType.investment:
        return 'Investment';
      case AccountType.business:
        return 'Business';
    }
  }
}

/// Account entity
class Account extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String currency;
  final bool isActive;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    this.isActive = true,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.empty() => const Account(
        id: '',
        name: '',
        type: AccountType.spending,
        balance: 0,
        currency: 'USD',
      );

  bool get isEmpty => id.isEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        balance,
        currency,
        isActive,
        description,
        createdAt,
        updatedAt,
      ];
}

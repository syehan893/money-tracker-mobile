part of 'accounts_bloc.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class AccountsLoadRequested extends AccountsEvent {
  const AccountsLoadRequested();
}

class AccountsRefreshRequested extends AccountsEvent {
  const AccountsRefreshRequested();
}

class AccountCreateRequested extends AccountsEvent {
  final String name;
  final AccountType type;
  final double balance;
  final String currency;
  final String? description;

  const AccountCreateRequested({
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    this.description,
  });

  @override
  List<Object?> get props => [name, type, balance, currency, description];
}

class AccountUpdateRequested extends AccountsEvent {
  final String id;
  final String? name;
  final AccountType? type;
  final String? currency;
  final String? description;
  final bool? isActive;

  const AccountUpdateRequested({
    required this.id,
    this.name,
    this.type,
    this.currency,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, type, currency, description, isActive];
}

class AccountDeleteRequested extends AccountsEvent {
  final String id;

  const AccountDeleteRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class AccountsFilterChanged extends AccountsEvent {
  final AccountType? type;

  const AccountsFilterChanged({this.type});

  @override
  List<Object?> get props => [type];
}

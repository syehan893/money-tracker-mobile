part of 'accounts_bloc.dart';

enum AccountsStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class AccountsState extends Equatable {
  final AccountsStatus status;
  final List<Account> accounts;
  final double totalBalance;
  final AccountType? filterType;
  final String? errorMessage;
  final String? successMessage;

  const AccountsState({
    this.status = AccountsStatus.initial,
    this.accounts = const [],
    this.totalBalance = 0,
    this.filterType,
    this.errorMessage,
    this.successMessage,
  });

  factory AccountsState.initial() => const AccountsState();

  bool get isLoading => status == AccountsStatus.loading;
  bool get isSubmitting => status == AccountsStatus.submitting;
  bool get hasError => status == AccountsStatus.error;
  bool get isSuccess => status == AccountsStatus.success;

  List<Account> get filteredAccounts {
    if (filterType == null) return accounts;
    return accounts.where((a) => a.type == filterType).toList();
  }

  AccountsState copyWith({
    AccountsStatus? status,
    List<Account>? accounts,
    double? totalBalance,
    AccountType? filterType,
    String? errorMessage,
    String? successMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      totalBalance: totalBalance ?? this.totalBalance,
      filterType: filterType,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        totalBalance,
        filterType,
        errorMessage,
        successMessage,
      ];
}

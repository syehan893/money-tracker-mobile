import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/create_account.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/get_accounts.dart';
import '../../domain/usecases/update_account.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

@injectable
class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final GetAccounts _getAccounts;
  final CreateAccount _createAccount;
  final UpdateAccount _updateAccount;
  final DeleteAccount _deleteAccount;

  AccountsBloc({
    required GetAccounts getAccounts,
    required CreateAccount createAccount,
    required UpdateAccount updateAccount,
    required DeleteAccount deleteAccount,
  })  : _getAccounts = getAccounts,
        _createAccount = createAccount,
        _updateAccount = updateAccount,
        _deleteAccount = deleteAccount,
        super(AccountsState.initial()) {
    on<AccountsLoadRequested>(_onLoadRequested);
    on<AccountsRefreshRequested>(_onRefreshRequested);
    on<AccountCreateRequested>(_onCreateRequested);
    on<AccountUpdateRequested>(_onUpdateRequested);
    on<AccountDeleteRequested>(_onDeleteRequested);
    on<AccountsFilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadRequested(
    AccountsLoadRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.loading));

    final result = await _getAccounts(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountsStatus.error,
        errorMessage: failure.message,
      )),
      (accounts) => emit(state.copyWith(
        status: AccountsStatus.loaded,
        accounts: accounts,
        totalBalance: _calculateTotalBalance(accounts),
      )),
    );
  }

  Future<void> _onRefreshRequested(
    AccountsRefreshRequested event,
    Emitter<AccountsState> emit,
  ) async {
    final result = await _getAccounts(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (accounts) => emit(state.copyWith(
        accounts: accounts,
        totalBalance: _calculateTotalBalance(accounts),
        errorMessage: null,
      )),
    );
  }

  Future<void> _onCreateRequested(
    AccountCreateRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.submitting));

    final result = await _createAccount(CreateAccountParams(
      name: event.name,
      type: event.type,
      balance: event.balance,
      currency: event.currency,
      description: event.description,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountsStatus.loaded,
        errorMessage: failure.message,
      )),
      (account) {
        final accounts = [...state.accounts, account];
        emit(state.copyWith(
          status: AccountsStatus.success,
          accounts: accounts,
          totalBalance: _calculateTotalBalance(accounts),
          successMessage: 'Account created successfully',
        ));
      },
    );
  }

  Future<void> _onUpdateRequested(
    AccountUpdateRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.submitting));

    final result = await _updateAccount(UpdateAccountParams(
      id: event.id,
      name: event.name,
      type: event.type,
      currency: event.currency,
      description: event.description,
      isActive: event.isActive,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountsStatus.loaded,
        errorMessage: failure.message,
      )),
      (account) {
        final accounts = state.accounts.map((a) {
          return a.id == account.id ? account : a;
        }).toList();
        emit(state.copyWith(
          status: AccountsStatus.success,
          accounts: accounts,
          totalBalance: _calculateTotalBalance(accounts),
          successMessage: 'Account updated successfully',
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    AccountDeleteRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.submitting));

    final result = await _deleteAccount(DeleteAccountParams(id: event.id));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountsStatus.loaded,
        errorMessage: failure.message,
      )),
      (_) {
        final accounts = state.accounts.where((a) => a.id != event.id).toList();
        emit(state.copyWith(
          status: AccountsStatus.success,
          accounts: accounts,
          totalBalance: _calculateTotalBalance(accounts),
          successMessage: 'Account deleted successfully',
        ));
      },
    );
  }

  void _onFilterChanged(
    AccountsFilterChanged event,
    Emitter<AccountsState> emit,
  ) {
    emit(state.copyWith(filterType: event.type));
  }

  double _calculateTotalBalance(List<Account> accounts) {
    return accounts
        .where((a) => a.isActive)
        .fold<double>(0, (sum, a) => sum + a.balance);
  }
}

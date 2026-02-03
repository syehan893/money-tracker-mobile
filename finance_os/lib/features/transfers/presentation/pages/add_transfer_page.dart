import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/bloc/accounts_bloc.dart';
import '../bloc/transfers_bloc.dart';

/// Page for creating a new transfer between accounts
class AddTransferPage extends StatefulWidget {
  const AddTransferPage({super.key});

  @override
  State<AddTransferPage> createState() => _AddTransferPageState();
}

class _AddTransferPageState extends State<AddTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Account? _fromAccount;
  Account? _toAccount;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transfer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<TransfersBloc, TransfersState>(
        listener: (context, state) {
          if (state.status == TransfersStatus.success) {
            context.pop();
          }
        },
        child: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (context, accountsState) {
            final accounts = accountsState.accounts;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Input
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                '\$',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0.00',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter an amount';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Enter a valid amount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // From Account
                    _buildAccountSelector(
                      label: 'From Account',
                      value: _fromAccount,
                      accounts: accounts,
                      excludeAccount: _toAccount,
                      onChanged: (account) {
                        setState(() => _fromAccount = account);
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),

                    // Swap button
                    Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            final temp = _fromAccount;
                            _fromAccount = _toAccount;
                            _toAccount = temp;
                          });
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.swap_vert,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // To Account
                    _buildAccountSelector(
                      label: 'To Account',
                      value: _toAccount,
                      accounts: accounts,
                      excludeAccount: _fromAccount,
                      onChanged: (account) {
                        setState(() => _toAccount = account);
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  Formatters.dateFull(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Description (optional)',
                          hintText: 'e.g., Savings contribution',
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    BlocBuilder<TransfersBloc, TransfersState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: 'Create Transfer',
                          onPressed: _submitTransfer,
                          isLoading: state.isSubmitting,
                          icon: Icons.swap_horiz,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountSelector({
    required String label,
    required Account? value,
    required List<Account> accounts,
    required Account? excludeAccount,
    required ValueChanged<Account?> onChanged,
    required bool isDark,
  }) {
    final availableAccounts =
        accounts.where((a) => a.id != excludeAccount?.id).toList();

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
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Account>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            hint: Text('Select $label'),
            items: availableAccounts.map((account) {
              return DropdownMenuItem(
                value: account,
                child: Row(
                  children: [
                    Icon(
                      _getAccountIcon(account.type),
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(account.name),
                    ),
                    Text(
                      Formatters.currency(account.balance),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Select an account';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.cash:
        return Icons.account_balance_wallet;
      case AccountType.credit:
        return Icons.credit_card;
      case AccountType.savings:
        return Icons.savings;
      case AccountType.investment:
        return Icons.trending_up;
      case AccountType.other:
        return Icons.more_horiz;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitTransfer() {
    if (_formKey.currentState!.validate() &&
        _fromAccount != null &&
        _toAccount != null) {
      context.read<TransfersBloc>().add(TransferCreateRequested(
            fromAccountId: _fromAccount!.id,
            toAccountId: _toAccount!.id,
            amount: double.parse(_amountController.text),
            date: _selectedDate,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
          ));
    }
  }
}

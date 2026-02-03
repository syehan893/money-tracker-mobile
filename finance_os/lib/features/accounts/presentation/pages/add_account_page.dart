import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/account.dart';
import '../bloc/accounts_bloc.dart';

/// Page for adding a new account
class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0.00');
  AccountType _selectedType = AccountType.spending;
  String _selectedCurrency = 'USD';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD'];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final balance = double.tryParse(_balanceController.text) ?? 0;
      context.read<AccountsBloc>().add(AccountCreateRequested(
            name: _nameController.text.trim(),
            type: _selectedType,
            balance: balance,
            currency: _selectedCurrency,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AccountsBloc, AccountsState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1a2432) : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: const Text('New Account'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              Text(
                "Let's set up your account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0d141c),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the details below to create a new virtual or physical ledger for your assets.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 32),

              // Account Name
              _buildLabel('Account Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  hintText: 'e.g. Daily Spending',
                  isDark: isDark,
                ),
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 20),

              // Account Type
              _buildLabel('Account Type'),
              const SizedBox(height: 8),
              DropdownButtonFormField<AccountType>(
                value: _selectedType,
                decoration: _inputDecoration(isDark: isDark),
                items: AccountType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? AccountType.spending;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildTypeChips(),
              const SizedBox(height: 20),

              // Initial Balance
              _buildLabel('Initial Balance'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 20),

              // Currency
              _buildLabel('Currency'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: _inputDecoration(isDark: isDark),
                items: _currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(_getCurrencyLabel(currency)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value ?? 'USD';
                  });
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: BlocBuilder<AccountsBloc, AccountsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTypeChips() {
    return Wrap(
      spacing: 8,
      children: AccountType.values.map((type) {
        final color = _getColorForType(type);
        final isSelected = _selectedType == type;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedType = type;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : color.withOpacity(0.3),
              ),
            ),
            child: Text(
              type.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForType(AccountType type) {
    switch (type) {
      case AccountType.saving:
        return AppColors.successGreen;
      case AccountType.spending:
        return AppColors.primary;
      case AccountType.wallet:
        return Colors.orange;
      case AccountType.investment:
        return AppColors.investmentPurple;
      case AccountType.business:
        return Colors.grey;
    }
  }

  String _getCurrencyLabel(String code) {
    switch (code) {
      case 'USD':
        return 'USD - US Dollar';
      case 'EUR':
        return 'EUR - Euro';
      case 'GBP':
        return 'GBP - British Pound';
      case 'JPY':
        return 'JPY - Japanese Yen';
      case 'AUD':
        return 'AUD - Australian Dollar';
      default:
        return code;
    }
  }

  InputDecoration _inputDecoration({
    String? hintText,
    String? prefixText,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/subscription.dart';
import '../bloc/subscriptions_bloc.dart';
import '../bloc/subscriptions_event.dart';
import '../bloc/subscriptions_state.dart';

/// Page for adding a new subscription
class AddSubscriptionPage extends StatefulWidget {
  const AddSubscriptionPage({super.key});

  @override
  State<AddSubscriptionPage> createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  BillingCycle _selectedBillingCycle = BillingCycle.monthly;
  String? _selectedCategory;
  DateTime _startDate = DateTime.now();

  final List<String> _categories = [
    'Streaming',
    'Music',
    'Cloud',
    'Productivity',
    'Gaming',
    'Fitness',
    'News',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<SubscriptionsBloc, SubscriptionsState>(
        listener: (context, state) {
          if (state.status == SubscriptionsStatus.success && !state.isSubmitting) {
            context.pop();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subscription Name
                _buildInputContainer(
                  isDark: isDark,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Subscription Name',
                      hintText: 'e.g., Netflix, Spotify',
                      prefixIcon: Icon(Icons.subscriptions_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter subscription name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                _buildInputContainer(
                  isDark: isDark,
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Amount',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
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
                const SizedBox(height: 16),

                // Billing Cycle
                _buildInputContainer(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Text(
                          'Billing Cycle',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                        child: Row(
                          children: BillingCycle.values.map((cycle) {
                            final isSelected = _selectedBillingCycle == cycle;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(_getBillingCycleLabel(cycle)),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedBillingCycle = cycle);
                                    }
                                  },
                                  selectedColor: AppColors.primary.withOpacity(0.2),
                                  labelStyle: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? AppColors.primary : null,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                _buildInputContainer(
                  isDark: isDark,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    hint: const Text('Select category'),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              size: 20,
                              color: _getCategoryColor(category),
                            ),
                            const SizedBox(width: 8),
                            Text(category),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Start Date
                _buildInputContainer(
                  isDark: isDark,
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.dateFull(_startDate),
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
                ),
                const SizedBox(height: 16),

                // Description
                _buildInputContainer(
                  isDark: isDark,
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Description (optional)',
                      hintText: 'Add notes about this subscription',
                      prefixIcon: Icon(Icons.notes),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 32),

                // Cost Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Estimated Yearly Cost',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        Formatters.currency(_calculateYearlyCost()),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: 'Add Subscription',
                      onPressed: _submitSubscription,
                      isLoading: state.isSubmitting,
                      icon: Icons.add,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: child,
    );
  }

  String _getBillingCycleLabel(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.weekly:
        return 'Weekly';
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.quarterly:
        return 'Quarterly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'streaming':
        return Icons.play_circle_filled;
      case 'music':
        return Icons.music_note;
      case 'cloud':
        return Icons.cloud;
      case 'productivity':
        return Icons.work;
      case 'gaming':
        return Icons.sports_esports;
      case 'fitness':
        return Icons.fitness_center;
      case 'news':
        return Icons.article;
      default:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'streaming':
        return Colors.red;
      case 'music':
        return Colors.green;
      case 'cloud':
        return Colors.blue;
      case 'productivity':
        return Colors.orange;
      case 'gaming':
        return Colors.purple;
      case 'fitness':
        return Colors.teal;
      case 'news':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  double _calculateYearlyCost() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    switch (_selectedBillingCycle) {
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

  void _submitSubscription() {
    if (_formKey.currentState!.validate()) {
      context.read<SubscriptionsBloc>().add(SubscriptionCreateRequested(
            name: _nameController.text,
            amount: double.parse(_amountController.text),
            billingCycle: _selectedBillingCycle,
            startDate: _startDate,
            category: _selectedCategory,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
          ));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/stat_card.dart';
import '../bloc/subscriptions_bloc.dart';
import '../bloc/subscriptions_event.dart';
import '../bloc/subscriptions_state.dart';
import '../widgets/subscription_card.dart';

/// Page displaying all subscriptions with summary statistics
class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<SubscriptionsBloc>().add(const SubscriptionsLoadRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/subscriptions/add'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Paused'),
          ],
        ),
      ),
      body: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
        builder: (context, state) {
          if (state.status == SubscriptionsStatus.loading) {
            return const LoadingIndicator();
          }

          if (state.status == SubscriptionsStatus.failure) {
            return ErrorView(
              message: state.errorMessage ?? 'Failed to load subscriptions',
              onRetry: () => context
                  .read<SubscriptionsBloc>()
                  .add(const SubscriptionsLoadRequested()),
            );
          }

          return Column(
            children: [
              // Summary Section
              _buildSummarySection(context, state, isDark),

              // Subscriptions List
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSubscriptionsList(
                      context,
                      state.activeSubscriptions,
                      isActive: true,
                    ),
                    _buildSubscriptionsList(
                      context,
                      state.inactiveSubscriptions,
                      isActive: false,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/subscriptions/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Subscription'),
      ),
    );
  }

  Widget _buildSummarySection(
    BuildContext context,
    SubscriptionsState state,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Monthly',
                  value: Formatters.currency(state.totalMonthlyCost),
                  icon: Icons.calendar_month,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Yearly',
                  value: Formatters.currency(state.totalYearlyCost),
                  icon: Icons.calendar_today,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Active',
                  value: '${state.activeSubscriptions.length}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Due Soon',
                  value: '${state.upcomingSubscriptions.length}',
                  icon: Icons.notifications_active_outlined,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsList(
    BuildContext context,
    List<dynamic> subscriptions, {
    required bool isActive,
  }) {
    if (subscriptions.isEmpty) {
      return EmptyStateView(
        icon: isActive ? Icons.subscriptions_outlined : Icons.pause_circle_outline,
        title: isActive ? 'No Active Subscriptions' : 'No Paused Subscriptions',
        message: isActive
            ? 'Add your recurring subscriptions to track your spending'
            : 'Paused subscriptions will appear here',
        actionText: isActive ? 'Add Subscription' : null,
        onAction: isActive ? () => context.push('/subscriptions/add') : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = subscriptions[index];
        return SubscriptionCard(
          subscription: subscription,
          onTap: () {
            // Navigate to subscription details
          },
          onToggle: () {
            context
                .read<SubscriptionsBloc>()
                .add(SubscriptionToggleRequested(subscription.id));
          },
          onDelete: () {
            _showDeleteConfirmation(context, subscription.id, subscription.name);
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String id,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Subscription'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<SubscriptionsBloc>()
                  .add(SubscriptionDeleteRequested(id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

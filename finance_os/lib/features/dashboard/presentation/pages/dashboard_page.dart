import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/expense_breakdown_chart.dart';
import '../widgets/transaction_card.dart';

/// Main dashboard page
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthBloc>().state;
    final userName = authState.user?.fullName.split(' ').first ?? 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(const DashboardRefreshRequested());
              },
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Good morning, $userName',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  if (state.isLoading)
                    SliverToBoxAdapter(child: _buildLoadingShimmer(context))
                  else if (state.hasError && !state.hasData)
                    SliverToBoxAdapter(
                      child: ErrorView(
                        message: state.errorMessage ?? 'Failed to load dashboard',
                        onRetry: () {
                          context.read<DashboardBloc>().add(const DashboardLoadRequested());
                        },
                      ),
                    )
                  else
                    _buildContent(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardState state) {
    final overview = state.overview;
    if (overview == null) return const SliverToBoxAdapter(child: SizedBox());

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Balance Card
          BalanceCard(
            title: 'Total Balance',
            amount: overview.totalBalance,
            trend: '+2.4%',
            isPositiveTrend: true,
            isVisible: state.isBalanceVisible,
            onVisibilityToggle: () {
              context.read<DashboardBloc>().add(
                    const DashboardBalanceVisibilityToggled(),
                  );
            },
          ),
          const SizedBox(height: 16),

          // Income & Expense Row
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Monthly Income',
                  amount: overview.monthlyIncome,
                  trend: '+${overview.incomeChange.toStringAsFixed(0)}%',
                  isPositiveTrend: overview.incomeChange >= 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Monthly Expenses',
                  amount: overview.monthlyExpense,
                  trend: '${overview.expenseChange.toStringAsFixed(0)}%',
                  isPositiveTrend: overview.expenseChange <= 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Net Savings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E293B)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NET SAVINGS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.currency(overview.netSavings),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.savings,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Expense Breakdown
          if (overview.expenseBreakdown.isNotEmpty) ...[
            ExpenseBreakdownChart(categories: overview.expenseBreakdown),
            const SizedBox(height: 24),
          ],

          // Recent Activity Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.transactions),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recent Transactions
          ...overview.recentTransactions.take(5).map(
                (transaction) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TransactionCard(transaction: transaction),
                ),
              ),

          const SizedBox(height: 100), // Bottom padding for nav bar
        ]),
      ),
    );
  }
}

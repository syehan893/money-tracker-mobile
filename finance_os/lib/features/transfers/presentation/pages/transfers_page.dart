import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../bloc/transfers_bloc.dart';
import '../widgets/transfer_card.dart';

/// Page for viewing and managing transfers between accounts
class TransfersPage extends StatefulWidget {
  const TransfersPage({super.key});

  @override
  State<TransfersPage> createState() => _TransfersPageState();
}

class _TransfersPageState extends State<TransfersPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransfersBloc>().add(const TransfersLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Transfers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: BlocConsumer<TransfersBloc, TransfersState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.incomeGreen,
              ),
            );
          }
          if (state.errorMessage != null && state.status != TransfersStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.expenseRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransfersStatus.error) {
            return ErrorView(
              message: state.errorMessage ?? 'Failed to load transfers',
              onRetry: () {
                context.read<TransfersBloc>().add(const TransfersLoadRequested());
              },
            );
          }

          if (state.transfers.isEmpty) {
            return EmptyStateView(
              title: 'No transfers yet',
              subtitle: 'Transfer money between your accounts',
              icon: Icons.swap_horiz,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TransfersBloc>().add(const TransfersLoadRequested());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.transfers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transfer = state.transfers[index];
                return TransferCard(
                  transfer: transfer,
                  onDelete: () {
                    context.read<TransfersBloc>().add(
                          TransferDeleteRequested(transfer.id),
                        );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addTransfer),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Transfers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('This Month'),
              onTap: () {
                final now = DateTime.now();
                final startDate = DateTime(now.year, now.month, 1);
                final endDate = DateTime(now.year, now.month + 1, 0);
                context.read<TransfersBloc>().add(TransfersLoadRequested(
                      startDate: startDate,
                      endDate: endDate,
                    ));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Last 30 Days'),
              onTap: () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 30));
                context.read<TransfersBloc>().add(TransfersLoadRequested(
                      startDate: startDate,
                      endDate: endDate,
                    ));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('All Time'),
              onTap: () {
                context.read<TransfersBloc>().add(const TransfersLoadRequested());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

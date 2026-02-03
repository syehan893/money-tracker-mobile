part of 'dashboard_bloc.dart';

/// Dashboard status
enum DashboardStatus {
  initial,
  loading,
  loaded,
  refreshing,
  error,
}

/// Dashboard state
class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardOverview? overview;
  final String? errorMessage;
  final bool isBalanceVisible;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.overview,
    this.errorMessage,
    this.isBalanceVisible = true,
  });

  factory DashboardState.initial() => const DashboardState();

  bool get isLoading => status == DashboardStatus.loading;
  bool get isRefreshing => status == DashboardStatus.refreshing;
  bool get hasData => overview != null;
  bool get hasError => status == DashboardStatus.error;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardOverview? overview,
    String? errorMessage,
    bool? isBalanceVisible,
  }) {
    return DashboardState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      errorMessage: errorMessage,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }

  @override
  List<Object?> get props => [status, overview, errorMessage, isBalanceVisible];
}

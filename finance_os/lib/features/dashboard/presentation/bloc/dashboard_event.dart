part of 'dashboard_bloc.dart';

/// Base class for dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data
class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

/// Event to refresh dashboard data
class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

/// Event to toggle balance visibility
class DashboardBalanceVisibilityToggled extends DashboardEvent {
  const DashboardBalanceVisibilityToggled();
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/usecases/get_dashboard_overview.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardOverview _getDashboardOverview;

  DashboardBloc({
    required GetDashboardOverview getDashboardOverview,
  })  : _getDashboardOverview = getDashboardOverview,
        super(DashboardState.initial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<DashboardBalanceVisibilityToggled>(_onBalanceVisibilityToggled);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final result = await _getDashboardOverview(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: failure.message,
      )),
      (overview) => emit(state.copyWith(
        status: DashboardStatus.loaded,
        overview: overview,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.refreshing));

    final result = await _getDashboardOverview(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.loaded,
        errorMessage: failure.message,
      )),
      (overview) => emit(state.copyWith(
        status: DashboardStatus.loaded,
        overview: overview,
        errorMessage: null,
      )),
    );
  }

  void _onBalanceVisibilityToggled(
    DashboardBalanceVisibilityToggled event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
  }
}

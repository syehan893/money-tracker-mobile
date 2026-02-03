import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/create_subscription.dart';
import '../../domain/usecases/delete_subscription.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../domain/usecases/toggle_subscription.dart';
import 'subscriptions_event.dart';
import 'subscriptions_state.dart';

@injectable
class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final GetSubscriptions _getSubscriptions;
  final CreateSubscription _createSubscription;
  final DeleteSubscription _deleteSubscription;
  final ToggleSubscription _toggleSubscription;

  SubscriptionsBloc(
    this._getSubscriptions,
    this._createSubscription,
    this._deleteSubscription,
    this._toggleSubscription,
  ) : super(const SubscriptionsState()) {
    on<SubscriptionsLoadRequested>(_onLoadRequested);
    on<SubscriptionCreateRequested>(_onCreateRequested);
    on<SubscriptionDeleteRequested>(_onDeleteRequested);
    on<SubscriptionToggleRequested>(_onToggleRequested);
  }

  Future<void> _onLoadRequested(
    SubscriptionsLoadRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionsStatus.loading));

    final result = await _getSubscriptions();

    result.fold(
      (failure) => emit(state.copyWith(
        status: SubscriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (subscriptions) => emit(state.copyWith(
        status: SubscriptionsStatus.success,
        subscriptions: subscriptions,
      )),
    );
  }

  Future<void> _onCreateRequested(
    SubscriptionCreateRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await _createSubscription(CreateSubscriptionParams(
      name: event.name,
      description: event.description,
      amount: event.amount,
      billingCycle: event.billingCycle,
      startDate: event.startDate,
      category: event.category,
      logoUrl: event.logoUrl,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (subscription) {
        final updatedList = [...state.subscriptions, subscription];
        emit(state.copyWith(
          isSubmitting: false,
          subscriptions: updatedList,
          status: SubscriptionsStatus.success,
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    SubscriptionDeleteRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final result = await _deleteSubscription(event.id);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedList =
            state.subscriptions.where((s) => s.id != event.id).toList();
        emit(state.copyWith(subscriptions: updatedList));
      },
    );
  }

  Future<void> _onToggleRequested(
    SubscriptionToggleRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final result = await _toggleSubscription(event.id);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedSubscription) {
        final updatedList = state.subscriptions.map((s) {
          return s.id == event.id ? updatedSubscription : s;
        }).toList();
        emit(state.copyWith(subscriptions: updatedList));
      },
    );
  }
}

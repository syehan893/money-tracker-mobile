part of 'transfers_bloc.dart';

enum TransfersStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class TransfersState extends Equatable {
  final TransfersStatus status;
  final List<Transfer> transfers;
  final String? errorMessage;
  final String? successMessage;

  const TransfersState({
    this.status = TransfersStatus.initial,
    this.transfers = const [],
    this.errorMessage,
    this.successMessage,
  });

  factory TransfersState.initial() => const TransfersState();

  bool get isLoading => status == TransfersStatus.loading;
  bool get isSubmitting => status == TransfersStatus.submitting;

  TransfersState copyWith({
    TransfersStatus? status,
    List<Transfer>? transfers,
    String? errorMessage,
    String? successMessage,
  }) {
    return TransfersState(
      status: status ?? this.status,
      transfers: transfers ?? this.transfers,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, transfers, errorMessage, successMessage];
}

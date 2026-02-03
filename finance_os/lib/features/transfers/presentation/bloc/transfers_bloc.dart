import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/transfer.dart';
import '../../domain/usecases/create_transfer.dart';
import '../../domain/usecases/delete_transfer.dart';
import '../../domain/usecases/get_transfers.dart';

part 'transfers_event.dart';
part 'transfers_state.dart';

@injectable
class TransfersBloc extends Bloc<TransfersEvent, TransfersState> {
  final GetTransfers _getTransfers;
  final CreateTransfer _createTransfer;
  final DeleteTransfer _deleteTransfer;

  TransfersBloc({
    required GetTransfers getTransfers,
    required CreateTransfer createTransfer,
    required DeleteTransfer deleteTransfer,
  })  : _getTransfers = getTransfers,
        _createTransfer = createTransfer,
        _deleteTransfer = deleteTransfer,
        super(TransfersState.initial()) {
    on<TransfersLoadRequested>(_onLoadRequested);
    on<TransferCreateRequested>(_onCreateRequested);
    on<TransferDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    TransfersLoadRequested event,
    Emitter<TransfersState> emit,
  ) async {
    emit(state.copyWith(status: TransfersStatus.loading));

    final result = await _getTransfers(GetTransfersParams(
      startDate: event.startDate,
      endDate: event.endDate,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: TransfersStatus.error,
        errorMessage: failure.message,
      )),
      (transfers) => emit(state.copyWith(
        status: TransfersStatus.loaded,
        transfers: transfers,
      )),
    );
  }

  Future<void> _onCreateRequested(
    TransferCreateRequested event,
    Emitter<TransfersState> emit,
  ) async {
    emit(state.copyWith(status: TransfersStatus.submitting));

    final result = await _createTransfer(CreateTransferParams(
      fromAccountId: event.fromAccountId,
      toAccountId: event.toAccountId,
      amount: event.amount,
      date: event.date,
      description: event.description,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: TransfersStatus.loaded,
        errorMessage: failure.message,
      )),
      (transfer) {
        final transfers = [transfer, ...state.transfers];
        emit(state.copyWith(
          status: TransfersStatus.success,
          transfers: transfers,
          successMessage: 'Transfer created successfully',
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    TransferDeleteRequested event,
    Emitter<TransfersState> emit,
  ) async {
    emit(state.copyWith(status: TransfersStatus.submitting));

    final result = await _deleteTransfer(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TransfersStatus.loaded,
        errorMessage: failure.message,
      )),
      (_) {
        final transfers = state.transfers.where((t) => t.id != event.id).toList();
        emit(state.copyWith(
          status: TransfersStatus.success,
          transfers: transfers,
          successMessage: 'Transfer deleted successfully',
        ));
      },
    );
  }
}

part of 'transfers_bloc.dart';

abstract class TransfersEvent extends Equatable {
  const TransfersEvent();

  @override
  List<Object?> get props => [];
}

class TransfersLoadRequested extends TransfersEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const TransfersLoadRequested({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class TransferCreateRequested extends TransfersEvent {
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final DateTime date;
  final String? description;

  const TransferCreateRequested({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [fromAccountId, toAccountId, amount, date, description];
}

class TransferDeleteRequested extends TransfersEvent {
  final String id;

  const TransferDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transfer.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

@freezed
class TransferModel with _$TransferModel {
  const TransferModel._();

  const factory TransferModel({
    required String id,
    @JsonKey(name: 'from_account_id') required String fromAccountId,
    @JsonKey(name: 'to_account_id') required String toAccountId,
    @JsonKey(name: 'from_account_name') required String fromAccountName,
    @JsonKey(name: 'to_account_name') required String toAccountName,
    required double amount,
    required DateTime date,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);

  Transfer toEntity() => Transfer(
        id: id,
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        fromAccountName: fromAccountName,
        toAccountName: toAccountName,
        amount: amount,
        date: date,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory TransferModel.fromEntity(Transfer entity) => TransferModel(
        id: entity.id,
        fromAccountId: entity.fromAccountId,
        toAccountId: entity.toAccountId,
        fromAccountName: entity.fromAccountName,
        toAccountName: entity.toAccountName,
        amount: entity.amount,
        date: entity.date,
        description: entity.description,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

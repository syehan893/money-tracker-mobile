import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/account.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const AccountModel._();

  const factory AccountModel({
    required String id,
    required String name,
    required String type,
    required double balance,
    required String currency,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  AccountType get accountType {
    switch (type.toLowerCase()) {
      case 'saving':
        return AccountType.saving;
      case 'spending':
        return AccountType.spending;
      case 'wallet':
        return AccountType.wallet;
      case 'investment':
        return AccountType.investment;
      case 'business':
        return AccountType.business;
      default:
        return AccountType.spending;
    }
  }

  Account toEntity() => Account(
        id: id,
        name: name,
        type: accountType,
        balance: balance,
        currency: currency,
        isActive: isActive,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory AccountModel.fromEntity(Account account) => AccountModel(
        id: account.id,
        name: account.name,
        type: account.type.name,
        balance: account.balance,
        currency: account.currency,
        isActive: account.isActive,
        description: account.description,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
      );
}

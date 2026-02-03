import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/income.dart';

part 'income_model.freezed.dart';
part 'income_model.g.dart';

@freezed
class IncomeTypeModel with _$IncomeTypeModel {
  const IncomeTypeModel._();

  const factory IncomeTypeModel({
    required String id,
    required String name,
    @JsonKey(name: 'target_amount') @Default(0) double targetAmount,
    @JsonKey(name: 'icon_name') String? iconName,
    String? color,
  }) = _IncomeTypeModel;

  factory IncomeTypeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeTypeModelFromJson(json);

  IncomeType toEntity() => IncomeType(
        id: id,
        name: name,
        targetAmount: targetAmount,
        iconName: iconName,
        color: color,
      );
}

@freezed
class IncomeModel with _$IncomeModel {
  const IncomeModel._();

  const factory IncomeModel({
    required String id,
    required double amount,
    @JsonKey(name: 'income_type_id') required String incomeTypeId,
    @JsonKey(name: 'income_type_name') String? incomeTypeName,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'account_name') String? accountName,
    required DateTime date,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _IncomeModel;

  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);

  Income toEntity() => Income(
        id: id,
        amount: amount,
        incomeTypeId: incomeTypeId,
        incomeTypeName: incomeTypeName,
        accountId: accountId,
        accountName: accountName,
        date: date,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

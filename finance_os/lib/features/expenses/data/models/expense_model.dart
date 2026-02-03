import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseTypeModel with _$ExpenseTypeModel {
  const ExpenseTypeModel._();

  const factory ExpenseTypeModel({
    required String id,
    required String name,
    @JsonKey(name: 'budget_amount') @Default(0) double budgetAmount,
    @JsonKey(name: 'spent_amount') @Default(0) double spentAmount,
    @JsonKey(name: 'icon_name') String? iconName,
    String? color,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _ExpenseTypeModel;

  factory ExpenseTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTypeModelFromJson(json);

  ExpenseType toEntity() => ExpenseType(
        id: id,
        name: name,
        budgetAmount: budgetAmount,
        spentAmount: spentAmount,
        iconName: iconName,
        color: color,
        imageUrl: imageUrl,
      );
}

@freezed
class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();

  const factory ExpenseModel({
    required String id,
    required double amount,
    @JsonKey(name: 'expense_type_id') required String expenseTypeId,
    @JsonKey(name: 'expense_type_name') String? expenseTypeName,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'account_name') String? accountName,
    required DateTime date,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Expense toEntity() => Expense(
        id: id,
        amount: amount,
        expenseTypeId: expenseTypeId,
        expenseTypeName: expenseTypeName,
        accountId: accountId,
        accountName: accountName,
        date: date,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

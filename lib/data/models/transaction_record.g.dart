// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRecord _$TransactionRecordFromJson(Map<String, dynamic> json) {
  return TransactionRecord(
    note: json['note'] as String?,
    date:
        DateTime.fromMillisecondsSinceEpoch(json['date'] as int, isUtc: false),
    amount: (json['amount'] as num).toDouble(),
    recordType: $enumDecode(_$RecordTypeEnumMap, json['recordType']),
    accountId: json['accountId'] as String,
    transferAccount2Id: json['transferAccount2Id'] as String?,
    expenseCategory:
        $enumDecodeNullable(_$ExpenseCategoryEnumMap, json['expenseCategory']),
    incomeCategory:
        $enumDecodeNullable(_$IncomeCategoryEnumMap, json['incomeCategory']),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$TransactionRecordToJson(TransactionRecord instance) =>
    <String, dynamic>{
      'transferAccount2Id': instance.transferAccount2Id,
      'accountId': instance.accountId,
      'id': instance.id,
      'date': instance.date.millisecondsSinceEpoch,
      'amount': instance.amount,
      'note': instance.note,
      'recordType': _$RecordTypeEnumMap[instance.recordType]!,
      'expenseCategory': _$ExpenseCategoryEnumMap[instance.expenseCategory],
      'incomeCategory': _$IncomeCategoryEnumMap[instance.incomeCategory],
    };

const _$RecordTypeEnumMap = {
  RecordType.income: 'income',
  RecordType.expense: 'expense',
  RecordType.transfer: 'transfer',
  RecordType.balanceAdjustment: 'balanceAdjustment'
};

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'food',
  ExpenseCategory.travel: 'travel',
  ExpenseCategory.shopping: 'shopping',
  ExpenseCategory.leisure: 'leisure',
  ExpenseCategory.savings: 'savings'
};

const _$IncomeCategoryEnumMap = {
  IncomeCategory.salary: 'salary',
  IncomeCategory.gift: 'gift',
  IncomeCategory.investment: 'investment',
  IncomeCategory.freelance: 'freelance',
};

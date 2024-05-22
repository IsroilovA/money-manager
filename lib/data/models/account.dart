import 'package:money_manager/services/helper_functions.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

const uuid = Uuid();

@JsonSerializable()
class Account {
  final String name;
  final double balance;
  final String id;
  Account({
    required this.name,
    required this.balance,
    id,
  }) : id = id ?? uuid.v4();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  String get formattedBalance {
    return currencyFormatter.format(balance);
  }
}

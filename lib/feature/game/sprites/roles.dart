import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum RoleType {
  worker("worker"),
  nature("nature"),
  politician("politician"),
  business("business"),
  undefined("default");

  const RoleType(this.code);
  final String code;

  factory RoleType.getByCode(String code) {
    return RoleType.values.firstWhere((value) => value.code == code,
        orElse: () => RoleType.undefined);
  }
}

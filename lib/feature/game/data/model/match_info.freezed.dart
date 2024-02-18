// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get roomName => throw _privateConstructorUsedError;
  int get playerCount => throw _privateConstructorUsedError;
  List<String>? get players => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;
  int? get day => throw _privateConstructorUsedError;
  Map<GroceryType, bool>? get groceryList => throw _privateConstructorUsedError;
  RuleType? get rule => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String roomName,
      int playerCount,
      List<String>? players,
      String? host,
      int? day,
      Map<GroceryType, bool>? groceryList,
      RuleType? rule});
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomName = null,
    Object? playerCount = null,
    Object? players = freezed,
    Object? host = freezed,
    Object? day = freezed,
    Object? groceryList = freezed,
    Object? rule = freezed,
  }) {
    return _then(_value.copyWith(
      roomName: null == roomName
          ? _value.roomName
          : roomName // ignore: cast_nullable_to_non_nullable
              as String,
      playerCount: null == playerCount
          ? _value.playerCount
          : playerCount // ignore: cast_nullable_to_non_nullable
              as int,
      players: freezed == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      day: freezed == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int?,
      groceryList: freezed == groceryList
          ? _value.groceryList
          : groceryList // ignore: cast_nullable_to_non_nullable
              as Map<GroceryType, bool>?,
      rule: freezed == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as RuleType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String roomName,
      int playerCount,
      List<String>? players,
      String? host,
      int? day,
      Map<GroceryType, bool>? groceryList,
      RuleType? rule});
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomName = null,
    Object? playerCount = null,
    Object? players = freezed,
    Object? host = freezed,
    Object? day = freezed,
    Object? groceryList = freezed,
    Object? rule = freezed,
  }) {
    return _then(_$MatchImpl(
      roomName: null == roomName
          ? _value.roomName
          : roomName // ignore: cast_nullable_to_non_nullable
              as String,
      playerCount: null == playerCount
          ? _value.playerCount
          : playerCount // ignore: cast_nullable_to_non_nullable
              as int,
      players: freezed == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      day: freezed == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int?,
      groceryList: freezed == groceryList
          ? _value._groceryList
          : groceryList // ignore: cast_nullable_to_non_nullable
              as Map<GroceryType, bool>?,
      rule: freezed == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as RuleType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  _$MatchImpl(
      {required this.roomName,
      required this.playerCount,
      final List<String>? players,
      this.host,
      this.day,
      final Map<GroceryType, bool>? groceryList,
      this.rule})
      : _players = players,
        _groceryList = groceryList;

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String roomName;
  @override
  final int playerCount;
  final List<String>? _players;
  @override
  List<String>? get players {
    final value = _players;
    if (value == null) return null;
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? host;
  @override
  final int? day;
  final Map<GroceryType, bool>? _groceryList;
  @override
  Map<GroceryType, bool>? get groceryList {
    final value = _groceryList;
    if (value == null) return null;
    if (_groceryList is EqualUnmodifiableMapView) return _groceryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final RuleType? rule;

  @override
  String toString() {
    return 'Match(roomName: $roomName, playerCount: $playerCount, players: $players, host: $host, day: $day, groceryList: $groceryList, rule: $rule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.roomName, roomName) ||
                other.roomName == roomName) &&
            (identical(other.playerCount, playerCount) ||
                other.playerCount == playerCount) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality()
                .equals(other._groceryList, _groceryList) &&
            (identical(other.rule, rule) || other.rule == rule));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      roomName,
      playerCount,
      const DeepCollectionEquality().hash(_players),
      host,
      day,
      const DeepCollectionEquality().hash(_groceryList),
      rule);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  factory _Match(
      {required final String roomName,
      required final int playerCount,
      final List<String>? players,
      final String? host,
      final int? day,
      final Map<GroceryType, bool>? groceryList,
      final RuleType? rule}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get roomName;
  @override
  int get playerCount;
  @override
  List<String>? get players;
  @override
  String? get host;
  @override
  int? get day;
  @override
  Map<GroceryType, bool>? get groceryList;
  @override
  RuleType? get rule;
  @override
  @JsonKey(ignore: true)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

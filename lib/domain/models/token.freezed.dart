// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Token {
  String get seed => throw _privateConstructorUsedError;
  String get accountSelectedName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  double get initialSupply => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TokenCopyWith<Token> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenCopyWith<$Res> {
  factory $TokenCopyWith(Token value, $Res Function(Token) then) =
      _$TokenCopyWithImpl<$Res, Token>;
  @useResult
  $Res call(
      {String seed,
      String accountSelectedName,
      String name,
      String symbol,
      double initialSupply});
}

/// @nodoc
class _$TokenCopyWithImpl<$Res, $Val extends Token>
    implements $TokenCopyWith<$Res> {
  _$TokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seed = null,
    Object? accountSelectedName = null,
    Object? name = null,
    Object? symbol = null,
    Object? initialSupply = null,
  }) {
    return _then(_value.copyWith(
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as String,
      accountSelectedName: null == accountSelectedName
          ? _value.accountSelectedName
          : accountSelectedName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      initialSupply: null == initialSupply
          ? _value.initialSupply
          : initialSupply // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TokenCopyWith<$Res> implements $TokenCopyWith<$Res> {
  factory _$$_TokenCopyWith(_$_Token value, $Res Function(_$_Token) then) =
      __$$_TokenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String seed,
      String accountSelectedName,
      String name,
      String symbol,
      double initialSupply});
}

/// @nodoc
class __$$_TokenCopyWithImpl<$Res> extends _$TokenCopyWithImpl<$Res, _$_Token>
    implements _$$_TokenCopyWith<$Res> {
  __$$_TokenCopyWithImpl(_$_Token _value, $Res Function(_$_Token) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seed = null,
    Object? accountSelectedName = null,
    Object? name = null,
    Object? symbol = null,
    Object? initialSupply = null,
  }) {
    return _then(_$_Token(
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as String,
      accountSelectedName: null == accountSelectedName
          ? _value.accountSelectedName
          : accountSelectedName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      initialSupply: null == initialSupply
          ? _value.initialSupply
          : initialSupply // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_Token extends _Token {
  const _$_Token(
      {required this.seed,
      required this.accountSelectedName,
      required this.name,
      required this.symbol,
      required this.initialSupply})
      : super._();

  @override
  final String seed;
  @override
  final String accountSelectedName;
  @override
  final String name;
  @override
  final String symbol;
  @override
  final double initialSupply;

  @override
  String toString() {
    return 'Token(seed: $seed, accountSelectedName: $accountSelectedName, name: $name, symbol: $symbol, initialSupply: $initialSupply)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Token &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.accountSelectedName, accountSelectedName) ||
                other.accountSelectedName == accountSelectedName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.initialSupply, initialSupply) ||
                other.initialSupply == initialSupply));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, seed, accountSelectedName, name, symbol, initialSupply);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TokenCopyWith<_$_Token> get copyWith =>
      __$$_TokenCopyWithImpl<_$_Token>(this, _$identity);
}

abstract class _Token extends Token {
  const factory _Token(
      {required final String seed,
      required final String accountSelectedName,
      required final String name,
      required final String symbol,
      required final double initialSupply}) = _$_Token;
  const _Token._() : super._();

  @override
  String get seed;
  @override
  String get accountSelectedName;
  @override
  String get name;
  @override
  String get symbol;
  @override
  double get initialSupply;
  @override
  @JsonKey(ignore: true)
  _$$_TokenCopyWith<_$_Token> get copyWith =>
      throw _privateConstructorUsedError;
}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AccountToken {
  TokenInformation? get tokenInformation => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountTokenCopyWith<AccountToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountTokenCopyWith<$Res> {
  factory $AccountTokenCopyWith(
          AccountToken value, $Res Function(AccountToken) then) =
      _$AccountTokenCopyWithImpl<$Res, AccountToken>;
  @useResult
  $Res call({TokenInformation? tokenInformation, double? amount});

  $TokenInformationCopyWith<$Res>? get tokenInformation;
}

/// @nodoc
class _$AccountTokenCopyWithImpl<$Res, $Val extends AccountToken>
    implements $AccountTokenCopyWith<$Res> {
  _$AccountTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenInformation = freezed,
    Object? amount = freezed,
  }) {
    return _then(_value.copyWith(
      tokenInformation: freezed == tokenInformation
          ? _value.tokenInformation
          : tokenInformation // ignore: cast_nullable_to_non_nullable
              as TokenInformation?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TokenInformationCopyWith<$Res>? get tokenInformation {
    if (_value.tokenInformation == null) {
      return null;
    }

    return $TokenInformationCopyWith<$Res>(_value.tokenInformation!, (value) {
      return _then(_value.copyWith(tokenInformation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountTokenImplCopyWith<$Res>
    implements $AccountTokenCopyWith<$Res> {
  factory _$$AccountTokenImplCopyWith(
          _$AccountTokenImpl value, $Res Function(_$AccountTokenImpl) then) =
      __$$AccountTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TokenInformation? tokenInformation, double? amount});

  @override
  $TokenInformationCopyWith<$Res>? get tokenInformation;
}

/// @nodoc
class __$$AccountTokenImplCopyWithImpl<$Res>
    extends _$AccountTokenCopyWithImpl<$Res, _$AccountTokenImpl>
    implements _$$AccountTokenImplCopyWith<$Res> {
  __$$AccountTokenImplCopyWithImpl(
      _$AccountTokenImpl _value, $Res Function(_$AccountTokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenInformation = freezed,
    Object? amount = freezed,
  }) {
    return _then(_$AccountTokenImpl(
      tokenInformation: freezed == tokenInformation
          ? _value.tokenInformation
          : tokenInformation // ignore: cast_nullable_to_non_nullable
              as TokenInformation?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$AccountTokenImpl extends _AccountToken {
  const _$AccountTokenImpl({this.tokenInformation, this.amount}) : super._();

  @override
  final TokenInformation? tokenInformation;
  @override
  final double? amount;

  @override
  String toString() {
    return 'AccountToken(tokenInformation: $tokenInformation, amount: $amount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountTokenImpl &&
            (identical(other.tokenInformation, tokenInformation) ||
                other.tokenInformation == tokenInformation) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tokenInformation, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountTokenImplCopyWith<_$AccountTokenImpl> get copyWith =>
      __$$AccountTokenImplCopyWithImpl<_$AccountTokenImpl>(this, _$identity);
}

abstract class _AccountToken extends AccountToken {
  const factory _AccountToken(
      {final TokenInformation? tokenInformation,
      final double? amount}) = _$AccountTokenImpl;
  const _AccountToken._() : super._();

  @override
  TokenInformation? get tokenInformation;
  @override
  double? get amount;
  @override
  @JsonKey(ignore: true)
  _$$AccountTokenImplCopyWith<_$AccountTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

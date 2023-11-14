// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_app.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GlobalApp {
  Map<String, AppWallet> get appWallets => throw _privateConstructorUsedError;
  String? get currentKeychainAddress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GlobalAppCopyWith<GlobalApp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalAppCopyWith<$Res> {
  factory $GlobalAppCopyWith(GlobalApp value, $Res Function(GlobalApp) then) =
      _$GlobalAppCopyWithImpl<$Res, GlobalApp>;
  @useResult
  $Res call(
      {Map<String, AppWallet> appWallets, String? currentKeychainAddress});
}

/// @nodoc
class _$GlobalAppCopyWithImpl<$Res, $Val extends GlobalApp>
    implements $GlobalAppCopyWith<$Res> {
  _$GlobalAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appWallets = null,
    Object? currentKeychainAddress = freezed,
  }) {
    return _then(_value.copyWith(
      appWallets: null == appWallets
          ? _value.appWallets
          : appWallets // ignore: cast_nullable_to_non_nullable
              as Map<String, AppWallet>,
      currentKeychainAddress: freezed == currentKeychainAddress
          ? _value.currentKeychainAddress
          : currentKeychainAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalAppImplCopyWith<$Res>
    implements $GlobalAppCopyWith<$Res> {
  factory _$$GlobalAppImplCopyWith(
          _$GlobalAppImpl value, $Res Function(_$GlobalAppImpl) then) =
      __$$GlobalAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, AppWallet> appWallets, String? currentKeychainAddress});
}

/// @nodoc
class __$$GlobalAppImplCopyWithImpl<$Res>
    extends _$GlobalAppCopyWithImpl<$Res, _$GlobalAppImpl>
    implements _$$GlobalAppImplCopyWith<$Res> {
  __$$GlobalAppImplCopyWithImpl(
      _$GlobalAppImpl _value, $Res Function(_$GlobalAppImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appWallets = null,
    Object? currentKeychainAddress = freezed,
  }) {
    return _then(_$GlobalAppImpl(
      appWallets: null == appWallets
          ? _value._appWallets
          : appWallets // ignore: cast_nullable_to_non_nullable
              as Map<String, AppWallet>,
      currentKeychainAddress: freezed == currentKeychainAddress
          ? _value.currentKeychainAddress
          : currentKeychainAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GlobalAppImpl extends _GlobalApp {
  const _$GlobalAppImpl(
      {required final Map<String, AppWallet> appWallets,
      this.currentKeychainAddress})
      : _appWallets = appWallets,
        super._();

  final Map<String, AppWallet> _appWallets;
  @override
  Map<String, AppWallet> get appWallets {
    if (_appWallets is EqualUnmodifiableMapView) return _appWallets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_appWallets);
  }

  @override
  final String? currentKeychainAddress;

  @override
  String toString() {
    return 'GlobalApp(appWallets: $appWallets, currentKeychainAddress: $currentKeychainAddress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalAppImpl &&
            const DeepCollectionEquality()
                .equals(other._appWallets, _appWallets) &&
            (identical(other.currentKeychainAddress, currentKeychainAddress) ||
                other.currentKeychainAddress == currentKeychainAddress));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_appWallets), currentKeychainAddress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalAppImplCopyWith<_$GlobalAppImpl> get copyWith =>
      __$$GlobalAppImplCopyWithImpl<_$GlobalAppImpl>(this, _$identity);
}

abstract class _GlobalApp extends GlobalApp {
  const factory _GlobalApp(
      {required final Map<String, AppWallet> appWallets,
      final String? currentKeychainAddress}) = _$GlobalAppImpl;
  const _GlobalApp._() : super._();

  @override
  Map<String, AppWallet> get appWallets;
  @override
  String? get currentKeychainAddress;
  @override
  @JsonKey(ignore: true)
  _$$GlobalAppImplCopyWith<_$GlobalAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

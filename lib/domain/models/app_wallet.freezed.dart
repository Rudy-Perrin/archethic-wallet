// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppWallet {
  NetworksSetting get walletNetwork => throw _privateConstructorUsedError;
  String get walletSeed => throw _privateConstructorUsedError;
  String get keychainLastAddress => throw _privateConstructorUsedError;
  String get keychainSeed => throw _privateConstructorUsedError;
  String get keychainVersion => throw _privateConstructorUsedError;
  List<KeychainService?> get keychainServices =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppWalletCopyWith<AppWallet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppWalletCopyWith<$Res> {
  factory $AppWalletCopyWith(AppWallet value, $Res Function(AppWallet) then) =
      _$AppWalletCopyWithImpl<$Res, AppWallet>;
  @useResult
  $Res call(
      {NetworksSetting walletNetwork,
      String walletSeed,
      String keychainLastAddress,
      String keychainSeed,
      String keychainVersion,
      List<KeychainService?> keychainServices});
}

/// @nodoc
class _$AppWalletCopyWithImpl<$Res, $Val extends AppWallet>
    implements $AppWalletCopyWith<$Res> {
  _$AppWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletNetwork = null,
    Object? walletSeed = null,
    Object? keychainLastAddress = null,
    Object? keychainSeed = null,
    Object? keychainVersion = null,
    Object? keychainServices = null,
  }) {
    return _then(_value.copyWith(
      walletNetwork: null == walletNetwork
          ? _value.walletNetwork
          : walletNetwork // ignore: cast_nullable_to_non_nullable
              as NetworksSetting,
      walletSeed: null == walletSeed
          ? _value.walletSeed
          : walletSeed // ignore: cast_nullable_to_non_nullable
              as String,
      keychainLastAddress: null == keychainLastAddress
          ? _value.keychainLastAddress
          : keychainLastAddress // ignore: cast_nullable_to_non_nullable
              as String,
      keychainSeed: null == keychainSeed
          ? _value.keychainSeed
          : keychainSeed // ignore: cast_nullable_to_non_nullable
              as String,
      keychainVersion: null == keychainVersion
          ? _value.keychainVersion
          : keychainVersion // ignore: cast_nullable_to_non_nullable
              as String,
      keychainServices: null == keychainServices
          ? _value.keychainServices
          : keychainServices // ignore: cast_nullable_to_non_nullable
              as List<KeychainService?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppWalletImplCopyWith<$Res>
    implements $AppWalletCopyWith<$Res> {
  factory _$$AppWalletImplCopyWith(
          _$AppWalletImpl value, $Res Function(_$AppWalletImpl) then) =
      __$$AppWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NetworksSetting walletNetwork,
      String walletSeed,
      String keychainLastAddress,
      String keychainSeed,
      String keychainVersion,
      List<KeychainService?> keychainServices});
}

/// @nodoc
class __$$AppWalletImplCopyWithImpl<$Res>
    extends _$AppWalletCopyWithImpl<$Res, _$AppWalletImpl>
    implements _$$AppWalletImplCopyWith<$Res> {
  __$$AppWalletImplCopyWithImpl(
      _$AppWalletImpl _value, $Res Function(_$AppWalletImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletNetwork = null,
    Object? walletSeed = null,
    Object? keychainLastAddress = null,
    Object? keychainSeed = null,
    Object? keychainVersion = null,
    Object? keychainServices = null,
  }) {
    return _then(_$AppWalletImpl(
      walletNetwork: null == walletNetwork
          ? _value.walletNetwork
          : walletNetwork // ignore: cast_nullable_to_non_nullable
              as NetworksSetting,
      walletSeed: null == walletSeed
          ? _value.walletSeed
          : walletSeed // ignore: cast_nullable_to_non_nullable
              as String,
      keychainLastAddress: null == keychainLastAddress
          ? _value.keychainLastAddress
          : keychainLastAddress // ignore: cast_nullable_to_non_nullable
              as String,
      keychainSeed: null == keychainSeed
          ? _value.keychainSeed
          : keychainSeed // ignore: cast_nullable_to_non_nullable
              as String,
      keychainVersion: null == keychainVersion
          ? _value.keychainVersion
          : keychainVersion // ignore: cast_nullable_to_non_nullable
              as String,
      keychainServices: null == keychainServices
          ? _value._keychainServices
          : keychainServices // ignore: cast_nullable_to_non_nullable
              as List<KeychainService?>,
    ));
  }
}

/// @nodoc

class _$AppWalletImpl extends _AppWallet {
  const _$AppWalletImpl(
      {required this.walletNetwork,
      required this.walletSeed,
      required this.keychainLastAddress,
      required this.keychainSeed,
      required this.keychainVersion,
      final List<KeychainService?> keychainServices = const []})
      : _keychainServices = keychainServices,
        super._();

  @override
  final NetworksSetting walletNetwork;
  @override
  final String walletSeed;
  @override
  final String keychainLastAddress;
  @override
  final String keychainSeed;
  @override
  final String keychainVersion;
  final List<KeychainService?> _keychainServices;
  @override
  @JsonKey()
  List<KeychainService?> get keychainServices {
    if (_keychainServices is EqualUnmodifiableListView)
      return _keychainServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keychainServices);
  }

  @override
  String toString() {
    return 'AppWallet(walletNetwork: $walletNetwork, walletSeed: $walletSeed, keychainLastAddress: $keychainLastAddress, keychainSeed: $keychainSeed, keychainVersion: $keychainVersion, keychainServices: $keychainServices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppWalletImpl &&
            (identical(other.walletNetwork, walletNetwork) ||
                other.walletNetwork == walletNetwork) &&
            (identical(other.walletSeed, walletSeed) ||
                other.walletSeed == walletSeed) &&
            (identical(other.keychainLastAddress, keychainLastAddress) ||
                other.keychainLastAddress == keychainLastAddress) &&
            (identical(other.keychainSeed, keychainSeed) ||
                other.keychainSeed == keychainSeed) &&
            (identical(other.keychainVersion, keychainVersion) ||
                other.keychainVersion == keychainVersion) &&
            const DeepCollectionEquality()
                .equals(other._keychainServices, _keychainServices));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      walletNetwork,
      walletSeed,
      keychainLastAddress,
      keychainSeed,
      keychainVersion,
      const DeepCollectionEquality().hash(_keychainServices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppWalletImplCopyWith<_$AppWalletImpl> get copyWith =>
      __$$AppWalletImplCopyWithImpl<_$AppWalletImpl>(this, _$identity);
}

abstract class _AppWallet extends AppWallet {
  const factory _AppWallet(
      {required final NetworksSetting walletNetwork,
      required final String walletSeed,
      required final String keychainLastAddress,
      required final String keychainSeed,
      required final String keychainVersion,
      final List<KeychainService?> keychainServices}) = _$AppWalletImpl;
  const _AppWallet._() : super._();

  @override
  NetworksSetting get walletNetwork;
  @override
  String get walletSeed;
  @override
  String get keychainLastAddress;
  @override
  String get keychainSeed;
  @override
  String get keychainVersion;
  @override
  List<KeychainService?> get keychainServices;
  @override
  @JsonKey(ignore: true)
  _$$AppWalletImplCopyWith<_$AppWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keychain_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

KeychainService _$KeychainServiceFromJson(Map<String, dynamic> json) {
  return _KeychainService.fromJson(json);
}

/// @nodoc
mixin _$KeychainService {
// Keychain service infos
  String get derivationPath => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  KeychainServiceKeyPair? get keyPair => throw _privateConstructorUsedError;
  String get curve => throw _privateConstructorUsedError;
  String get hashAlgo => throw _privateConstructorUsedError; // Account infos
  String? get accountNameAccount => throw _privateConstructorUsedError;
  String? get accountGenesisAddress => throw _privateConstructorUsedError;
  int? get accountLastLoadingTransactionInputs =>
      throw _privateConstructorUsedError;
  bool? get accountSelected => throw _privateConstructorUsedError;
  String? get accountLastAddress => throw _privateConstructorUsedError;
  String? get accountServiceType => throw _privateConstructorUsedError;
  double? get accountBalanceNativeTokenValue =>
      throw _privateConstructorUsedError;
  String? get accountBalanceNativeTokenName =>
      throw _privateConstructorUsedError;
  int? get accountBalanceTokensFungiblesNb =>
      throw _privateConstructorUsedError;
  int? get accountBalanceNftNb => throw _privateConstructorUsedError;
  List<RecentTransaction>? get accountRecentTransactions =>
      throw _privateConstructorUsedError;
  List<AccountToken>? get accountTokens => throw _privateConstructorUsedError;
  List<AccountToken>? get accountNFT => throw _privateConstructorUsedError;
  List<AccountToken>? get accountNFTCollections =>
      throw _privateConstructorUsedError;
  List<NftInfosOffChain>? get accountNftInfosOffChainList =>
      throw _privateConstructorUsedError;
  List<int>? get accountNftCategoryList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KeychainServiceCopyWith<KeychainService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeychainServiceCopyWith<$Res> {
  factory $KeychainServiceCopyWith(
          KeychainService value, $Res Function(KeychainService) then) =
      _$KeychainServiceCopyWithImpl<$Res, KeychainService>;
  @useResult
  $Res call(
      {String derivationPath,
      String name,
      KeychainServiceKeyPair? keyPair,
      String curve,
      String hashAlgo,
      String? accountNameAccount,
      String? accountGenesisAddress,
      int? accountLastLoadingTransactionInputs,
      bool? accountSelected,
      String? accountLastAddress,
      String? accountServiceType,
      double? accountBalanceNativeTokenValue,
      String? accountBalanceNativeTokenName,
      int? accountBalanceTokensFungiblesNb,
      int? accountBalanceNftNb,
      List<RecentTransaction>? accountRecentTransactions,
      List<AccountToken>? accountTokens,
      List<AccountToken>? accountNFT,
      List<AccountToken>? accountNFTCollections,
      List<NftInfosOffChain>? accountNftInfosOffChainList,
      List<int>? accountNftCategoryList});

  $KeychainServiceKeyPairCopyWith<$Res>? get keyPair;
}

/// @nodoc
class _$KeychainServiceCopyWithImpl<$Res, $Val extends KeychainService>
    implements $KeychainServiceCopyWith<$Res> {
  _$KeychainServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? derivationPath = null,
    Object? name = null,
    Object? keyPair = freezed,
    Object? curve = null,
    Object? hashAlgo = null,
    Object? accountNameAccount = freezed,
    Object? accountGenesisAddress = freezed,
    Object? accountLastLoadingTransactionInputs = freezed,
    Object? accountSelected = freezed,
    Object? accountLastAddress = freezed,
    Object? accountServiceType = freezed,
    Object? accountBalanceNativeTokenValue = freezed,
    Object? accountBalanceNativeTokenName = freezed,
    Object? accountBalanceTokensFungiblesNb = freezed,
    Object? accountBalanceNftNb = freezed,
    Object? accountRecentTransactions = freezed,
    Object? accountTokens = freezed,
    Object? accountNFT = freezed,
    Object? accountNFTCollections = freezed,
    Object? accountNftInfosOffChainList = freezed,
    Object? accountNftCategoryList = freezed,
  }) {
    return _then(_value.copyWith(
      derivationPath: null == derivationPath
          ? _value.derivationPath
          : derivationPath // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      keyPair: freezed == keyPair
          ? _value.keyPair
          : keyPair // ignore: cast_nullable_to_non_nullable
              as KeychainServiceKeyPair?,
      curve: null == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String,
      hashAlgo: null == hashAlgo
          ? _value.hashAlgo
          : hashAlgo // ignore: cast_nullable_to_non_nullable
              as String,
      accountNameAccount: freezed == accountNameAccount
          ? _value.accountNameAccount
          : accountNameAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      accountGenesisAddress: freezed == accountGenesisAddress
          ? _value.accountGenesisAddress
          : accountGenesisAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      accountLastLoadingTransactionInputs: freezed ==
              accountLastLoadingTransactionInputs
          ? _value.accountLastLoadingTransactionInputs
          : accountLastLoadingTransactionInputs // ignore: cast_nullable_to_non_nullable
              as int?,
      accountSelected: freezed == accountSelected
          ? _value.accountSelected
          : accountSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
      accountLastAddress: freezed == accountLastAddress
          ? _value.accountLastAddress
          : accountLastAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      accountServiceType: freezed == accountServiceType
          ? _value.accountServiceType
          : accountServiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBalanceNativeTokenValue: freezed == accountBalanceNativeTokenValue
          ? _value.accountBalanceNativeTokenValue
          : accountBalanceNativeTokenValue // ignore: cast_nullable_to_non_nullable
              as double?,
      accountBalanceNativeTokenName: freezed == accountBalanceNativeTokenName
          ? _value.accountBalanceNativeTokenName
          : accountBalanceNativeTokenName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBalanceTokensFungiblesNb: freezed ==
              accountBalanceTokensFungiblesNb
          ? _value.accountBalanceTokensFungiblesNb
          : accountBalanceTokensFungiblesNb // ignore: cast_nullable_to_non_nullable
              as int?,
      accountBalanceNftNb: freezed == accountBalanceNftNb
          ? _value.accountBalanceNftNb
          : accountBalanceNftNb // ignore: cast_nullable_to_non_nullable
              as int?,
      accountRecentTransactions: freezed == accountRecentTransactions
          ? _value.accountRecentTransactions
          : accountRecentTransactions // ignore: cast_nullable_to_non_nullable
              as List<RecentTransaction>?,
      accountTokens: freezed == accountTokens
          ? _value.accountTokens
          : accountTokens // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNFT: freezed == accountNFT
          ? _value.accountNFT
          : accountNFT // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNFTCollections: freezed == accountNFTCollections
          ? _value.accountNFTCollections
          : accountNFTCollections // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNftInfosOffChainList: freezed == accountNftInfosOffChainList
          ? _value.accountNftInfosOffChainList
          : accountNftInfosOffChainList // ignore: cast_nullable_to_non_nullable
              as List<NftInfosOffChain>?,
      accountNftCategoryList: freezed == accountNftCategoryList
          ? _value.accountNftCategoryList
          : accountNftCategoryList // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $KeychainServiceKeyPairCopyWith<$Res>? get keyPair {
    if (_value.keyPair == null) {
      return null;
    }

    return $KeychainServiceKeyPairCopyWith<$Res>(_value.keyPair!, (value) {
      return _then(_value.copyWith(keyPair: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KeychainServiceImplCopyWith<$Res>
    implements $KeychainServiceCopyWith<$Res> {
  factory _$$KeychainServiceImplCopyWith(_$KeychainServiceImpl value,
          $Res Function(_$KeychainServiceImpl) then) =
      __$$KeychainServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String derivationPath,
      String name,
      KeychainServiceKeyPair? keyPair,
      String curve,
      String hashAlgo,
      String? accountNameAccount,
      String? accountGenesisAddress,
      int? accountLastLoadingTransactionInputs,
      bool? accountSelected,
      String? accountLastAddress,
      String? accountServiceType,
      double? accountBalanceNativeTokenValue,
      String? accountBalanceNativeTokenName,
      int? accountBalanceTokensFungiblesNb,
      int? accountBalanceNftNb,
      List<RecentTransaction>? accountRecentTransactions,
      List<AccountToken>? accountTokens,
      List<AccountToken>? accountNFT,
      List<AccountToken>? accountNFTCollections,
      List<NftInfosOffChain>? accountNftInfosOffChainList,
      List<int>? accountNftCategoryList});

  @override
  $KeychainServiceKeyPairCopyWith<$Res>? get keyPair;
}

/// @nodoc
class __$$KeychainServiceImplCopyWithImpl<$Res>
    extends _$KeychainServiceCopyWithImpl<$Res, _$KeychainServiceImpl>
    implements _$$KeychainServiceImplCopyWith<$Res> {
  __$$KeychainServiceImplCopyWithImpl(
      _$KeychainServiceImpl _value, $Res Function(_$KeychainServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? derivationPath = null,
    Object? name = null,
    Object? keyPair = freezed,
    Object? curve = null,
    Object? hashAlgo = null,
    Object? accountNameAccount = freezed,
    Object? accountGenesisAddress = freezed,
    Object? accountLastLoadingTransactionInputs = freezed,
    Object? accountSelected = freezed,
    Object? accountLastAddress = freezed,
    Object? accountServiceType = freezed,
    Object? accountBalanceNativeTokenValue = freezed,
    Object? accountBalanceNativeTokenName = freezed,
    Object? accountBalanceTokensFungiblesNb = freezed,
    Object? accountBalanceNftNb = freezed,
    Object? accountRecentTransactions = freezed,
    Object? accountTokens = freezed,
    Object? accountNFT = freezed,
    Object? accountNFTCollections = freezed,
    Object? accountNftInfosOffChainList = freezed,
    Object? accountNftCategoryList = freezed,
  }) {
    return _then(_$KeychainServiceImpl(
      derivationPath: null == derivationPath
          ? _value.derivationPath
          : derivationPath // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      keyPair: freezed == keyPair
          ? _value.keyPair
          : keyPair // ignore: cast_nullable_to_non_nullable
              as KeychainServiceKeyPair?,
      curve: null == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String,
      hashAlgo: null == hashAlgo
          ? _value.hashAlgo
          : hashAlgo // ignore: cast_nullable_to_non_nullable
              as String,
      accountNameAccount: freezed == accountNameAccount
          ? _value.accountNameAccount
          : accountNameAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      accountGenesisAddress: freezed == accountGenesisAddress
          ? _value.accountGenesisAddress
          : accountGenesisAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      accountLastLoadingTransactionInputs: freezed ==
              accountLastLoadingTransactionInputs
          ? _value.accountLastLoadingTransactionInputs
          : accountLastLoadingTransactionInputs // ignore: cast_nullable_to_non_nullable
              as int?,
      accountSelected: freezed == accountSelected
          ? _value.accountSelected
          : accountSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
      accountLastAddress: freezed == accountLastAddress
          ? _value.accountLastAddress
          : accountLastAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      accountServiceType: freezed == accountServiceType
          ? _value.accountServiceType
          : accountServiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBalanceNativeTokenValue: freezed == accountBalanceNativeTokenValue
          ? _value.accountBalanceNativeTokenValue
          : accountBalanceNativeTokenValue // ignore: cast_nullable_to_non_nullable
              as double?,
      accountBalanceNativeTokenName: freezed == accountBalanceNativeTokenName
          ? _value.accountBalanceNativeTokenName
          : accountBalanceNativeTokenName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBalanceTokensFungiblesNb: freezed ==
              accountBalanceTokensFungiblesNb
          ? _value.accountBalanceTokensFungiblesNb
          : accountBalanceTokensFungiblesNb // ignore: cast_nullable_to_non_nullable
              as int?,
      accountBalanceNftNb: freezed == accountBalanceNftNb
          ? _value.accountBalanceNftNb
          : accountBalanceNftNb // ignore: cast_nullable_to_non_nullable
              as int?,
      accountRecentTransactions: freezed == accountRecentTransactions
          ? _value._accountRecentTransactions
          : accountRecentTransactions // ignore: cast_nullable_to_non_nullable
              as List<RecentTransaction>?,
      accountTokens: freezed == accountTokens
          ? _value._accountTokens
          : accountTokens // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNFT: freezed == accountNFT
          ? _value._accountNFT
          : accountNFT // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNFTCollections: freezed == accountNFTCollections
          ? _value._accountNFTCollections
          : accountNFTCollections // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNftInfosOffChainList: freezed == accountNftInfosOffChainList
          ? _value._accountNftInfosOffChainList
          : accountNftInfosOffChainList // ignore: cast_nullable_to_non_nullable
              as List<NftInfosOffChain>?,
      accountNftCategoryList: freezed == accountNftCategoryList
          ? _value._accountNftCategoryList
          : accountNftCategoryList // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KeychainServiceImpl extends _KeychainService {
  const _$KeychainServiceImpl(
      {required this.derivationPath,
      required this.name,
      this.keyPair,
      required this.curve,
      required this.hashAlgo,
      this.accountNameAccount,
      this.accountGenesisAddress,
      this.accountLastLoadingTransactionInputs,
      this.accountSelected,
      this.accountLastAddress,
      this.accountServiceType,
      this.accountBalanceNativeTokenValue,
      this.accountBalanceNativeTokenName,
      this.accountBalanceTokensFungiblesNb,
      this.accountBalanceNftNb,
      final List<RecentTransaction>? accountRecentTransactions,
      final List<AccountToken>? accountTokens,
      final List<AccountToken>? accountNFT,
      final List<AccountToken>? accountNFTCollections,
      final List<NftInfosOffChain>? accountNftInfosOffChainList,
      final List<int>? accountNftCategoryList})
      : _accountRecentTransactions = accountRecentTransactions,
        _accountTokens = accountTokens,
        _accountNFT = accountNFT,
        _accountNFTCollections = accountNFTCollections,
        _accountNftInfosOffChainList = accountNftInfosOffChainList,
        _accountNftCategoryList = accountNftCategoryList,
        super._();

  factory _$KeychainServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeychainServiceImplFromJson(json);

// Keychain service infos
  @override
  final String derivationPath;
  @override
  final String name;
  @override
  final KeychainServiceKeyPair? keyPair;
  @override
  final String curve;
  @override
  final String hashAlgo;
// Account infos
  @override
  final String? accountNameAccount;
  @override
  final String? accountGenesisAddress;
  @override
  final int? accountLastLoadingTransactionInputs;
  @override
  final bool? accountSelected;
  @override
  final String? accountLastAddress;
  @override
  final String? accountServiceType;
  @override
  final double? accountBalanceNativeTokenValue;
  @override
  final String? accountBalanceNativeTokenName;
  @override
  final int? accountBalanceTokensFungiblesNb;
  @override
  final int? accountBalanceNftNb;
  final List<RecentTransaction>? _accountRecentTransactions;
  @override
  List<RecentTransaction>? get accountRecentTransactions {
    final value = _accountRecentTransactions;
    if (value == null) return null;
    if (_accountRecentTransactions is EqualUnmodifiableListView)
      return _accountRecentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AccountToken>? _accountTokens;
  @override
  List<AccountToken>? get accountTokens {
    final value = _accountTokens;
    if (value == null) return null;
    if (_accountTokens is EqualUnmodifiableListView) return _accountTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AccountToken>? _accountNFT;
  @override
  List<AccountToken>? get accountNFT {
    final value = _accountNFT;
    if (value == null) return null;
    if (_accountNFT is EqualUnmodifiableListView) return _accountNFT;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AccountToken>? _accountNFTCollections;
  @override
  List<AccountToken>? get accountNFTCollections {
    final value = _accountNFTCollections;
    if (value == null) return null;
    if (_accountNFTCollections is EqualUnmodifiableListView)
      return _accountNFTCollections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<NftInfosOffChain>? _accountNftInfosOffChainList;
  @override
  List<NftInfosOffChain>? get accountNftInfosOffChainList {
    final value = _accountNftInfosOffChainList;
    if (value == null) return null;
    if (_accountNftInfosOffChainList is EqualUnmodifiableListView)
      return _accountNftInfosOffChainList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _accountNftCategoryList;
  @override
  List<int>? get accountNftCategoryList {
    final value = _accountNftCategoryList;
    if (value == null) return null;
    if (_accountNftCategoryList is EqualUnmodifiableListView)
      return _accountNftCategoryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'KeychainService(derivationPath: $derivationPath, name: $name, keyPair: $keyPair, curve: $curve, hashAlgo: $hashAlgo, accountNameAccount: $accountNameAccount, accountGenesisAddress: $accountGenesisAddress, accountLastLoadingTransactionInputs: $accountLastLoadingTransactionInputs, accountSelected: $accountSelected, accountLastAddress: $accountLastAddress, accountServiceType: $accountServiceType, accountBalanceNativeTokenValue: $accountBalanceNativeTokenValue, accountBalanceNativeTokenName: $accountBalanceNativeTokenName, accountBalanceTokensFungiblesNb: $accountBalanceTokensFungiblesNb, accountBalanceNftNb: $accountBalanceNftNb, accountRecentTransactions: $accountRecentTransactions, accountTokens: $accountTokens, accountNFT: $accountNFT, accountNFTCollections: $accountNFTCollections, accountNftInfosOffChainList: $accountNftInfosOffChainList, accountNftCategoryList: $accountNftCategoryList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeychainServiceImpl &&
            (identical(other.derivationPath, derivationPath) ||
                other.derivationPath == derivationPath) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.keyPair, keyPair) || other.keyPair == keyPair) &&
            (identical(other.curve, curve) || other.curve == curve) &&
            (identical(other.hashAlgo, hashAlgo) ||
                other.hashAlgo == hashAlgo) &&
            (identical(other.accountNameAccount, accountNameAccount) ||
                other.accountNameAccount == accountNameAccount) &&
            (identical(other.accountGenesisAddress, accountGenesisAddress) ||
                other.accountGenesisAddress == accountGenesisAddress) &&
            (identical(other.accountLastLoadingTransactionInputs,
                    accountLastLoadingTransactionInputs) ||
                other.accountLastLoadingTransactionInputs ==
                    accountLastLoadingTransactionInputs) &&
            (identical(other.accountSelected, accountSelected) ||
                other.accountSelected == accountSelected) &&
            (identical(other.accountLastAddress, accountLastAddress) ||
                other.accountLastAddress == accountLastAddress) &&
            (identical(other.accountServiceType, accountServiceType) ||
                other.accountServiceType == accountServiceType) &&
            (identical(other.accountBalanceNativeTokenValue, accountBalanceNativeTokenValue) ||
                other.accountBalanceNativeTokenValue ==
                    accountBalanceNativeTokenValue) &&
            (identical(other.accountBalanceNativeTokenName, accountBalanceNativeTokenName) ||
                other.accountBalanceNativeTokenName ==
                    accountBalanceNativeTokenName) &&
            (identical(other.accountBalanceTokensFungiblesNb, accountBalanceTokensFungiblesNb) ||
                other.accountBalanceTokensFungiblesNb ==
                    accountBalanceTokensFungiblesNb) &&
            (identical(other.accountBalanceNftNb, accountBalanceNftNb) ||
                other.accountBalanceNftNb == accountBalanceNftNb) &&
            const DeepCollectionEquality().equals(
                other._accountRecentTransactions, _accountRecentTransactions) &&
            const DeepCollectionEquality()
                .equals(other._accountTokens, _accountTokens) &&
            const DeepCollectionEquality()
                .equals(other._accountNFT, _accountNFT) &&
            const DeepCollectionEquality()
                .equals(other._accountNFTCollections, _accountNFTCollections) &&
            const DeepCollectionEquality().equals(
                other._accountNftInfosOffChainList,
                _accountNftInfosOffChainList) &&
            const DeepCollectionEquality().equals(
                other._accountNftCategoryList, _accountNftCategoryList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        derivationPath,
        name,
        keyPair,
        curve,
        hashAlgo,
        accountNameAccount,
        accountGenesisAddress,
        accountLastLoadingTransactionInputs,
        accountSelected,
        accountLastAddress,
        accountServiceType,
        accountBalanceNativeTokenValue,
        accountBalanceNativeTokenName,
        accountBalanceTokensFungiblesNb,
        accountBalanceNftNb,
        const DeepCollectionEquality().hash(_accountRecentTransactions),
        const DeepCollectionEquality().hash(_accountTokens),
        const DeepCollectionEquality().hash(_accountNFT),
        const DeepCollectionEquality().hash(_accountNFTCollections),
        const DeepCollectionEquality().hash(_accountNftInfosOffChainList),
        const DeepCollectionEquality().hash(_accountNftCategoryList)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KeychainServiceImplCopyWith<_$KeychainServiceImpl> get copyWith =>
      __$$KeychainServiceImplCopyWithImpl<_$KeychainServiceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeychainServiceImplToJson(
      this,
    );
  }
}

abstract class _KeychainService extends KeychainService {
  const factory _KeychainService(
      {required final String derivationPath,
      required final String name,
      final KeychainServiceKeyPair? keyPair,
      required final String curve,
      required final String hashAlgo,
      final String? accountNameAccount,
      final String? accountGenesisAddress,
      final int? accountLastLoadingTransactionInputs,
      final bool? accountSelected,
      final String? accountLastAddress,
      final String? accountServiceType,
      final double? accountBalanceNativeTokenValue,
      final String? accountBalanceNativeTokenName,
      final int? accountBalanceTokensFungiblesNb,
      final int? accountBalanceNftNb,
      final List<RecentTransaction>? accountRecentTransactions,
      final List<AccountToken>? accountTokens,
      final List<AccountToken>? accountNFT,
      final List<AccountToken>? accountNFTCollections,
      final List<NftInfosOffChain>? accountNftInfosOffChainList,
      final List<int>? accountNftCategoryList}) = _$KeychainServiceImpl;
  const _KeychainService._() : super._();

  factory _KeychainService.fromJson(Map<String, dynamic> json) =
      _$KeychainServiceImpl.fromJson;

  @override // Keychain service infos
  String get derivationPath;
  @override
  String get name;
  @override
  KeychainServiceKeyPair? get keyPair;
  @override
  String get curve;
  @override
  String get hashAlgo;
  @override // Account infos
  String? get accountNameAccount;
  @override
  String? get accountGenesisAddress;
  @override
  int? get accountLastLoadingTransactionInputs;
  @override
  bool? get accountSelected;
  @override
  String? get accountLastAddress;
  @override
  String? get accountServiceType;
  @override
  double? get accountBalanceNativeTokenValue;
  @override
  String? get accountBalanceNativeTokenName;
  @override
  int? get accountBalanceTokensFungiblesNb;
  @override
  int? get accountBalanceNftNb;
  @override
  List<RecentTransaction>? get accountRecentTransactions;
  @override
  List<AccountToken>? get accountTokens;
  @override
  List<AccountToken>? get accountNFT;
  @override
  List<AccountToken>? get accountNFTCollections;
  @override
  List<NftInfosOffChain>? get accountNftInfosOffChainList;
  @override
  List<int>? get accountNftCategoryList;
  @override
  @JsonKey(ignore: true)
  _$$KeychainServiceImplCopyWith<_$KeychainServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

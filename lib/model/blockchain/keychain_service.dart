import 'package:aewallet/domain/models/account_token.dart';
import 'package:aewallet/model/blockchain/keychain_service_keypair.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/data/nft_infos_off_chain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'keychain_service.freezed.dart';
part 'keychain_service.g.dart';

/// Holds keychain service info

@freezed
class KeychainService with _$KeychainService {
  const factory KeychainService({
    // Keychain service infos
    required String derivationPath,
    required String name,
    KeychainServiceKeyPair? keyPair,
    required String curve,
    required String hashAlgo,

    // Account infos
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
    List<int>? accountNftCategoryList,
  }) = _KeychainService;
  const KeychainService._();

  factory KeychainService.fromJson(Map<String, dynamic> json) =>
      _$KeychainServiceFromJson(json);
}

mixin KeychainServiceMixin {
  final kMainDerivation = "m/650'/";

  String getServiceTypeFromPath(String derivationPath) {
    var serviceType = 'other';
    final name = derivationPath.replaceFirst(kMainDerivation, '');

    if (name.startsWith('archethic-wallet-')) {
      serviceType = 'archethicWallet';
    } else {
      if (name.startsWith('aeweb-')) {
        serviceType = 'aeweb';
      }
    }
    return serviceType;
  }

  String getNameFromPath(String derivationPath) {
    final name = derivationPath.replaceFirst(kMainDerivation, '');
    return name.split('/').first;
  }
}

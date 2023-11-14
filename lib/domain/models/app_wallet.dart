import 'package:aewallet/model/available_networks.dart';
import 'package:aewallet/model/blockchain/keychain_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_wallet.freezed.dart';

@freezed
class AppWallet with _$AppWallet {
  const factory AppWallet({
    required NetworksSetting walletNetwork,
    required String walletSeed,
    required String keychainLastAddress,
    required String keychainSeed,
    required String keychainVersion,
    @Default([]) List<KeychainService?> keychainServices,
  }) = _AppWallet;

  const AppWallet._();
}

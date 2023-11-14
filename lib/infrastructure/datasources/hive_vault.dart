/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/domain/models/global_app.dart';
import 'package:aewallet/infrastructure/datasources/secured_datasource_mixin.dart';
import 'package:aewallet/model/blockchain/keychain_service.dart';
import 'package:aewallet/model/data/secured_settings.dart';
import 'package:hive/hive.dart';

class HiveVaultDatasource with SecuredHiveMixin {
  HiveVaultDatasource._(this._box);

  static const String _vaultBox = '_vaultBox';
  final Box<dynamic> _box;

  //
  static const String _seed = 'archethic_wallet_seed';
  static const String _pin = 'archethic_wallet_pin';
  static const String _password = 'archethic_wallet_password';
  static const String _yubikeyClientID = 'archethic_wallet_yubikeyClientID';
  static const String _yubikeyClientAPIKey =
      'archethic_wallet_yubikeyClientAPIKey';
  static const String _keychainSecuredInfos =
      'archethic_keychain_secured_infos';
  static const String _globalApp = 'archethic_global_app';

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static Future<HiveVaultDatasource> getInstance() async {
    final encryptedBox = await SecuredHiveMixin.openSecuredBox(_vaultBox);
    return HiveVaultDatasource._(encryptedBox);
  }

  T _getValue<T>(dynamic key, {T? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);

  Future<void> _removeValue<T>(dynamic key) => _box.delete(key);

  Future<void> deleteSeed() async {
    return _removeValue(_seed);
  }

  Future<void> setPin(String v) => _setValue(_pin, v);

  String? getPin() => _getValue(_pin);

  Future<void> deletePin() async {
    return _removeValue(_pin);
  }

  Future<void> setPassword(String v) => _setValue(_password, v);

  String? getPassword() => _getValue(_password);

  Future<void> deletePassword() async {
    return _removeValue(_password);
  }

  Future<void> setYubikeyClientAPIKey(String v) =>
      _setValue(_yubikeyClientAPIKey, v);

  String getYubikeyClientAPIKey() =>
      _getValue(_yubikeyClientAPIKey, defaultValue: '');

  Future<void> setYubikeyClientID(String v) => _setValue(_yubikeyClientID, v);

  String getYubikeyClientID() => _getValue(_yubikeyClientID, defaultValue: '');

  Future<void> deleteKeychainSecuredInfos() async {
    return _removeValue(_keychainSecuredInfos);
  }

  Future<void> setGlobalApp(GlobalApp v) => _setValue(_globalApp, v);

  GlobalApp? getGlobalApp() => _getValue(_globalApp);

  Future<void> deleteGlobalApp() async {
    return _removeValue(_globalApp);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  SecuredSettings toModel() => SecuredSettings(
        password: getPassword(),
        pin: getPin(),
        yubikeyClientAPIKey: getYubikeyClientAPIKey(),
        yubikeyClientID: getYubikeyClientID(),
        globalApp: getGlobalApp(),
      );

  Future<List<KeychainService>> getKeychainServices(
      String keychainAddress) async {
    return getGlobalApp()!.appWallets[keychainAddress]!.keychainServices;
  }

  Future<KeychainService?> getKeychainService(
      String keychainAddress, String name) async {
    for (final service
        in getGlobalApp()!.appWallets[keychainAddress]!.keychainServices) {
      if (service.name == name) return service;
    }
    return null;
  }

  Future<void> addKeychainService(
      String keychainAddress, KeychainService keychainService) async {
    await setGlobalApp(
      getGlobalApp()!
        ..appWallets[keychainAddress]!.keychainServices.add(keychainService),
    );
  }

  Future<void> clearKeychainServices(String keychainAddress) async {
    await setGlobalApp(
      getGlobalApp()!..appWallets[keychainAddress]!.keychainServices.clear(),
    );
  }

  Future<void> changeService(
    String keychainAddress,
    String keychainServiceName,
  ) async {
    for (var i = 0;
        i <
            getGlobalApp()!
                .appWallets[keychainAddress]!
                .keychainServices
                .length;
        i++) {
      if (getGlobalApp()!
              .appWallets[keychainAddress]!
              .keychainServices[i]
              .name ==
          keychainServiceName) {
        getGlobalApp()!
            .appWallets[keychainAddress]!
            .keychainServices[i]
            .accountSelected = true;
      } else {
        getGlobalApp()!
            .appWallets[keychainAddress]!
            .keychainServices[i]
            .accountSelected = false;
      }
    }
    await setGlobalApp(
      getGlobalApp()!..appWallets[keychainAddress]!.keychainServices,
    );
  }

  Future<void> updateAccountBalance(
    String keychainAddress,
    KeychainService selectedService,
    double? accountBalanceNativeTokenValue,
    String? accountBalanceNativeTokenName,
    int? accountBalanceTokensFungiblesNb,
    int? accountBalanceNftNb,
  ) async {
    for (final keychainService
        in getGlobalApp()!.appWallets[keychainAddress]!.keychainServices) {
      if (selectedService.name == keychainService.name) {
        keychainService.accountBalanceNativeTokenValue =
            accountBalanceNativeTokenValue;
        keychainService.accountBalanceNativeTokenName =
            accountBalanceNativeTokenName;
        keychainService.accountBalanceTokensFungiblesNb =
            accountBalanceTokensFungiblesNb;
        keychainService.accountBalanceNftNb = accountBalanceNftNb;
        await setGlobalApp(
          getGlobalApp()!..appWallets[keychainAddress]!.keychainServices,
        );
        return;
      }
    }
  }

  Future<void> updateAccount(
    String keychainAddress,
    KeychainService selectedKeychainService,
  ) async {
    getGlobalApp()!.appWallets[keychainAddress]!.keychainServices =
        getGlobalApp()!.appWallets[keychainAddress]!.keychainServices.map(
      (keychainService) {
        if (keychainService.name == selectedKeychainService.name)
          return selectedKeychainService;
        return keychainService;
      },
    ).toList();
    await setGlobalApp(
      getGlobalApp()!..appWallets[keychainAddress]!.keychainServices,
    );
  }
}

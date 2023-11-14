import 'dart:async';

import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/notification/providers.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/wallet/state.dart';
import 'package:aewallet/domain/models/app_wallet.dart';
import 'package:aewallet/domain/models/global_app.dart';
import 'package:aewallet/domain/repositories/features_flags.dart';
import 'package:aewallet/infrastructure/datasources/hive_vault.dart';
import 'package:aewallet/model/data/appdb.dart';
import 'package:aewallet/model/data/hive_app_wallet_dto.dart';
import 'package:aewallet/ui/views/messenger/bloc/providers.dart';
import 'package:aewallet/util/cache_manager_hive.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/keychain_util.dart';
import 'package:aewallet/util/mnemonics.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class SessionNotifier extends Notifier<Session> {
  @override
  Session build() {
    return const Session.loggedOut();
  }

  Future<void> restore() async {
    final vault = await HiveVaultDatasource.getInstance();
    final globalApp = vault.getGlobalApp();

    if (globalApp == null || globalApp.appWallets.isEmpty) {
      await logout();
      return;
    }

    state = Session.loggedIn(
      globalApp: globalApp,
    );
  }

  Future<void> refresh() async {
    if (state.isLoggedOut) return;
    final connectivityStatusProvider = ref.read(connectivityStatusProviders);
    if (connectivityStatusProvider == ConnectivityStatus.isDisconnected) {
      return;
    }

    final loggedInState = state.loggedIn!;

    final appWallets = <String, AppWallet>{};
    try {
      loggedInState.globalApp.appWallets.forEach((keychainAddress, appWallet) async {
        final keychain = await sl.get<ApiService>().getKeychain(appWallet.walletSeed);
          
        appWallet = appWallet.copyWith(keychainLastAddress: keychainAddress, keychainSeed: uint8ListToHex(keychain.seed!), keychainVersion: keychain.version.toString(),
      keychainServices: keychain.toKeychainServices(),  
      );
      
        final newWalletDTO = await KeychainUtil().getListAccountsFromKeychain(
          keychain,
          HiveAppWalletDTO.fromModel(appWallet),
        );
        if (newWalletDTO != null) 
        {

        }
      });

      state = Session.loggedIn(
        globalApp: loggedInState.globalApp.copyWith(appWallets: )
        wallet: loggedInState.wallet.copyWith(
          keychainSecuredInfos: keychainSecuredInfos,
          appKeychain: newWalletDTO.appKeychain,
        ),
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> logout() async {
    if (FeatureFlags.messagingActive) {
      await ref.read(NotificationProviders.repository).unsubscribeAll();
    }
    await ref.read(SettingsProviders.settings.notifier).reset();
    await AuthenticationProviders.reset(ref);
    await ContactProviders.reset(ref);
    await MessengerProviders.reset(ref);

    await (await HiveVaultDatasource.getInstance()).clearAll();
    await _dbHelper.clearAppWallet();
    final cache = await Hive.openBox<CacheItemHive>(
      CacheManagerHive.cacheManagerHiveTable,
    );
    await cache.clear();

    state = const Session.loggedOut();
  }

  Future<void> createNewAppWallet({
    required String seed,
    required String keychainAddress,
    required Keychain keychain,
    String? name,
  }) async {
    final newAppWalletDTO = await HiveAppWalletDTO.createNewAppWallet(
      keychainAddress,
      keychain,
      name,
    );

    final keychainSecuredInfos = keychain.toKeychainSecuredInfos();

    final vault = await HiveVaultDatasource.getInstance();
    await vault.setKeychainSecuredInfos(keychainSecuredInfos);

    final appWallet = newAppWalletDTO.toModel(
      seed: seed,
      keychainSecuredInfos: keychainSecuredInfos,
    );
    final globalApp = GlobalApp(appWallets: {seed: appWallet});

    state = Session.loggedIn(
      globalApp: globalApp,
    );
  }

  Future<LoggedInSession?> restoreFromMnemonics({
    required List<String> mnemonics,
    required String languageCode,
  }) async {
    await sl.get<DBHelper>().clearAppWallet();

    final seed = AppMnemomics.mnemonicListToSeed(
      mnemonics,
      languageCode: languageCode,
    );
    final vault = await HiveVaultDatasource.getInstance();
    vault.setSeed(seed);

    try {
      final keychain = await sl.get<ApiService>().getKeychain(seed);

      final appWallet = await KeychainUtil().getListAccountsFromKeychain(
        keychain,
        null,
        loadBalance: false,
      );

      if (appWallet == null) {
        return null;
      }

      final keychainSecuredInfos = keychain.toKeychainSecuredInfos();

      await vault.setKeychainSecuredInfos(keychainSecuredInfos);

      final globalApp = GlobalApp(
        appWallets: {
          seed: appWallet.toModel(
            seed: seed,
            keychainSecuredInfos: keychainSecuredInfos,
          ),
        },
      );

      return state = LoggedInSession(
        globalApp: globalApp,
      );
    } catch (e) {
      return null;
    }
  }
}

abstract class SessionProviders {
  static final session = _sessionNotifierProvider;
}

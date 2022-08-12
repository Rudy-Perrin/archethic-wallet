/// SPDX-License-Identifier: AGPL-3.0-or-later

// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

// Package imports:
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Project imports:
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/app_wallet.dart';
import 'package:aewallet/model/data/appdb.dart';
import 'package:aewallet/model/data/price.dart';
import 'package:aewallet/util/confirmations/subscription_channel.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/preferences.dart';

class KeychainUtil {
  SubscriptionChannel subscriptionChannel = SubscriptionChannel();

  Future<AppWallet?> newAppWallet(String? seed, String? name) async {
    Account? selectedAcct;

    /// Get Wallet KeyPair
    final KeyPair walletKeyPair = deriveKeyPair(seed!, 0);

    /// Generate keyChain Seed from random value
    final String keychainSeed = uint8ListToHex(Uint8List.fromList(
        List<int>.generate(32, (int i) => Random.secure().nextInt(256))));

    String nameEncoded = Uri.encodeFull(name!);

    /// Default service for wallet
    String kServiceName = 'archethic-wallet-$nameEncoded';
    String kDerivationPathWithoutIndex = 'm/650\'/$kServiceName/';
    const String index = '0';
    String kDerivationPath = '$kDerivationPathWithoutIndex$index';

    final String originPrivateKey = sl.get<ApiService>().getOriginKey();

    Keychain keychain = Keychain(hexToUint8List(keychainSeed), version: 1);
    keychain.addService(kServiceName, kDerivationPath);

    /// Create Keychain from keyChain seed and wallet public key to encrypt secret
    final Transaction keychainTransaction = sl
        .get<ApiService>()
        .newKeychainTransaction(
            keychainSeed,
            <String>[uint8ListToHex(walletKeyPair.publicKey)],
            hexToUint8List(originPrivateKey),
            serviceName: kServiceName,
            derivationPath: kDerivationPath);

    /// Create Keychain Access for wallet
    final Transaction accessKeychainTx = sl
        .get<ApiService>()
        .newAccessKeychainTransaction(
            seed,
            hexToUint8List(keychainTransaction.address!),
            hexToUint8List(originPrivateKey));

    final Preferences preferences = await Preferences.getInstance();

    String websocketUri = await preferences.getNetwork().getWebsocketUri();

    print('before sub');

    await subscriptionChannel.connect(
        await preferences.getNetwork().getPhoenixHttpLink(),
        await preferences.getNetwork().getWebsocketUri());

    Future.sync(() => subscriptionChannel.addSubscriptionTransactionConfirmed(
        keychainTransaction.address!, waitConfirmations)).timeout(
      const Duration(seconds: 5),
      onTimeout: () => print('timeout'),
    );

    print('addsub KC ok');

    // ignore: unused_local_variable
    final TransactionStatus transactionStatusKeychain =
        await sl.get<ApiService>().sendTx(keychainTransaction);

    print('sendTx KC');

    Future.sync(() => subscriptionChannel.addSubscriptionTransactionConfirmed(
        accessKeychainTx.address!, waitConfirmations)).timeout(
      const Duration(seconds: 5),
      onTimeout: () => print('timeout'),
    );

    print('addsub KC Access ok');

    // ignore: unused_local_variable
    final TransactionStatus transactionStatusKeychainAccess =
        await sl.get<ApiService>().sendTx(accessKeychainTx);

    print('sendTx KC Access');

    //await Future.delayed(const Duration(seconds: 10));

    // TODO: Crypt Seed
    AppWallet appWallet = await sl
        .get<DBHelper>()
        .createAppWallet('', keychainTransaction.address!);

    Uint8List genesisAddress = keychain.deriveAddress(kServiceName, index: 0);
    selectedAcct = Account(
        lastLoadingTransactionInputs: 0,
        lastAddress: uint8ListToHex(genesisAddress),
        genesisAddress: uint8ListToHex(genesisAddress),
        name: name,
        balance: AccountBalance(
            fiatCurrencyCode: '',
            fiatCurrencyValue: 0,
            nativeTokenName: '',
            nativeTokenValue: 0),
        selected: true,
        recentTransactions: []);
    appWallet = await sl.get<DBHelper>().addAccount(selectedAcct);

    if (subscriptionChannel != null) {
      print('sub end close');
      subscriptionChannel.close();
    }

    return appWallet;
  }

  Future<AppWallet?> addAccountInKeyChain(AppWallet? appWallet, String? seed,
      String? name, String currency, String networkCurrency) async {
    Account? selectedAcct;

    final Keychain keychain = await sl.get<ApiService>().getKeychain(seed!);

    final String originPrivateKey = sl.get<ApiService>().getOriginKey();

    final String genesisAddressKeychain =
        deriveAddress(uint8ListToHex(keychain.seed!), 0);

    String nameEncoded = Uri.encodeFull(name!);

    String kServiceName = 'archethic-wallet-$nameEncoded';
    String kDerivationPathWithoutIndex = 'm/650\'/$kServiceName/';
    const String index = '0';
    String kDerivationPath = '$kDerivationPathWithoutIndex$index';
    keychain.addService(kServiceName, kDerivationPath);

    final Transaction lastTransactionKeychain = await sl
        .get<ApiService>()
        .getLastTransaction(genesisAddressKeychain,
            request:
                'chainLength, data { content, ownerships { authorizedPublicKeys { publicKey } } }');

    final String aesKey = uint8ListToHex(Uint8List.fromList(
        List<int>.generate(32, (int i) => Random.secure().nextInt(256))));

    Transaction keychainTransaction =
        Transaction(type: 'keychain', data: Transaction.initData())
            .setContent(jsonEncode(keychain.toDID()));

    final List<AuthorizedKey> authorizedKeys =
        List<AuthorizedKey>.empty(growable: true);
    List<AuthorizedKey> authorizedKeysList =
        lastTransactionKeychain.data!.ownerships![0].authorizedPublicKeys!;
    authorizedKeysList.forEach((AuthorizedKey authorizedKey) {
      authorizedKeys.add(AuthorizedKey(
          encryptedSecretKey:
              uint8ListToHex(ecEncrypt(aesKey, authorizedKey.publicKey)),
          publicKey: authorizedKey.publicKey));
    });

    keychainTransaction.addOwnership(
        aesEncrypt(keychain.encode(), aesKey), authorizedKeys);

    keychainTransaction
        .build(uint8ListToHex(keychain.seed!),
            lastTransactionKeychain.chainLength!)
        .originSign(originPrivateKey);

    // ignore: unused_local_variable
    final TransactionStatus transactionStatusKeychain =
        await sl.get<ApiService>().sendTx(keychainTransaction);

    Price tokenPrice = await Price.getCurrency(currency);

    Uint8List genesisAddress = keychain.deriveAddress(kServiceName, index: 0);
    selectedAcct = Account(
        lastLoadingTransactionInputs: 0,
        lastAddress: uint8ListToHex(genesisAddress),
        genesisAddress: uint8ListToHex(genesisAddress),
        name: name,
        balance: AccountBalance(
            fiatCurrencyCode: '',
            fiatCurrencyValue: 0,
            nativeTokenName: networkCurrency,
            nativeTokenValue: 0,
            tokenPrice: tokenPrice),
        selected: false,
        recentTransactions: []);

    appWallet!.appKeychain!.accounts!.add(selectedAcct);
    appWallet.appKeychain!.accounts!.sort((a, b) => a.name!.compareTo(b.name!));

    final Transaction lastTransactionKeychainAddress = await sl
        .get<ApiService>()
        .getLastTransaction(genesisAddressKeychain, request: 'address');
    appWallet.appKeychain!.address = lastTransactionKeychainAddress.address;

    await appWallet.save();

    return appWallet;
  }

  Future<AppWallet?> getListAccountsFromKeychain(AppWallet? appWallet,
      String? seed, String currency, String tokenName, Price tokenPrice,
      {String? currentName = '',
      bool loadBalance = true,
      bool loadRecentTransactions = true}) async {
    List<Account> accounts = List<Account>.empty(growable: true);

    try {
      /// Get KeyChain Wallet
      final Keychain keychain = await sl.get<ApiService>().getKeychain(seed!);

      /// Creation of a new appWallet
      if (appWallet == null) {
        final String addressKeychain =
            deriveAddress(uint8ListToHex(keychain.seed!), 0);
        Transaction lastTransaction =
            await sl.get<ApiService>().getLastTransaction(addressKeychain);

        appWallet = await sl
            .get<DBHelper>()
            .createAppWallet('', lastTransaction.address!);
      }

      const String kDerivationPathWithoutService = 'm/650\'/archethic-wallet-';

      /// Get all services for archethic blockchain
      keychain.services!.forEach((serviceName, service) async {
        if (service.derivationPath!.startsWith(kDerivationPathWithoutService)) {
          Uint8List genesisAddress =
              keychain.deriveAddress(serviceName, index: 0);

          final List<String> path = service.derivationPath!
              .replaceAll(kDerivationPathWithoutService, '')
              .split('/');
          path.last = '';
          String name = path.join('/');
          name = name.substring(0, name.length - 1);

          String nameDecoded = Uri.decodeFull(name);

          Account account = Account(
              lastLoadingTransactionInputs:
                  DateTime.now().millisecondsSinceEpoch ~/
                      Duration.millisecondsPerSecond,
              lastAddress: uint8ListToHex(genesisAddress),
              genesisAddress: uint8ListToHex(genesisAddress),
              name: nameDecoded,
              balance: AccountBalance(
                  fiatCurrencyCode: '',
                  fiatCurrencyValue: 0,
                  nativeTokenName: '',
                  nativeTokenValue: 0),
              recentTransactions: []);
          if (currentName == nameDecoded) {
            account.selected = true;
          } else {
            account.selected = false;
          }

          accounts.add(account);
        }
      });

      for (int i = 0; i < accounts.length; i++) {
        String? lastAddress = await sl
            .get<AddressService>()
            .lastAddressFromAddress(accounts[i].genesisAddress!);
        if (lastAddress.isNotEmpty) {
          accounts[i].lastAddress = lastAddress;
        }
        if (loadBalance) {
          await accounts[i].updateBalance(tokenName, currency, tokenPrice);
          await accounts[i].updateFungiblesTokens();
        }
      }
      final String genesisAddressKeychain =
          deriveAddress(uint8ListToHex(keychain.seed!), 0);

      final Transaction lastTransactionKeychain = await sl
          .get<ApiService>()
          .getLastTransaction(genesisAddressKeychain, request: 'address');
      appWallet.appKeychain!.address = lastTransactionKeychain.address;
      appWallet.appKeychain!.accounts = accounts;
      if (loadRecentTransactions) {
        await appWallet.appKeychain!
            .getAccountSelected()!
            .updateRecentTransactions('', seed);
      }

      await appWallet.save();
    } catch (e) {
      throw Exception();
    }

    return appWallet;
  }

  Future<void> waitConfirmations(QueryResult event) async {
    print('wait confirmations');
    if (event.data != null &&
        event.data!['transactionConfirmed'] != null &&
        event.data!['transactionConfirmed']['nbConfirmations'] != null) {
      int nb = event.data!['transactionConfirmed']['nbConfirmations'];

      print('ok $nb');
    } else {
      print('ko');
    }
  }
}
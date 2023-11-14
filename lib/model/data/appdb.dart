/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:developer';

import 'package:aewallet/model/available_currency.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/domain/models/token_information.dart';
import 'package:aewallet/model/data/access_recipient.dart';
import 'package:aewallet/domain/models/account_token.dart';
import 'package:aewallet/model/data/app_keychain.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:aewallet/model/data/messenger/discussion.dart';
import 'package:aewallet/model/data/messenger/message.dart';
import 'package:aewallet/model/data/nft_infos_off_chain.dart';
import 'package:aewallet/model/data/notification_setup_dto.dart';
import 'package:aewallet/model/data/price.dart';
import 'package:aewallet/ui/util/contact_formatters.dart';
import 'package:aewallet/util/cache_manager_hive.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveTypeIds {
  static const contact = 0;
  static const account = 1;
  static const appKeychain = 3;
  static const appWallet = 4;
  static const recentTransactions = 6;
  static const price = 7;
  static const accountToken = 8;
  static const tokenInformation = 9;
  static const nftInfosOffChain = 11;
  static const discussion = 12;
  static const pubKeyAccessRecipient = 13;
  static const contactAccessRecipient = 14;
  static const discussionMessage = 15;
  static const notificationsSetup = 16;
  static const cacheItem = 17;
  static const tokenCollection = 18;
}

class DBHelper {
  static const String contactsTable = 'contacts';
  static const String priceTable = 'price';

  static Future<void> setupDatabase() async {
    if (kIsWeb) {
      Hive.initFlutter();
    } else {
      final suppDir = await getApplicationSupportDirectory();
      Hive.init(suppDir.path);
    }

    Hive
      ..registerAdapter(ContactAdapter())
      ..registerAdapter(AppKeychainAdapter())
      ..registerAdapter(RecentTransactionAdapter())
      ..registerAdapter(PriceAdapter())
      ..registerAdapter(AccountTokenAdapter())
      ..registerAdapter(TokenInformationAdapter())
      ..registerAdapter(NftInfosOffChainAdapter())
      ..registerAdapter(DiscussionImplAdapter())
      ..registerAdapter(DiscussionMessageImplAdapter())
      ..registerAdapter(PubKeyAccessRecipientAdapter())
      ..registerAdapter(ContactAccessRecipientAdapter())
      ..registerAdapter(NotificationsSetupImplAdapter())
      ..registerAdapter(CacheItemHiveAdapter());
  }

  // Contacts
  Future<List<Contact>> getContacts() async {
    final box = await Hive.openBox<Contact>(contactsTable);
    final contactsList = box.values.toList()
      ..sort(
        (Contact a, Contact b) =>
            a.format.toLowerCase().compareTo(b.format.toLowerCase()),
      );
    return contactsList;
  }

  Future<List<Contact>> getContactsWithNameLike(String pattern) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    final contactsList = box.values.toList();

    final contactsListSelected = List<Contact>.empty(growable: true);
    for (final contact in contactsList) {
      if (contact.format.contains(pattern)) {
        contactsListSelected.add(contact);
      }
    }
    return contactsListSelected;
  }

  Future<Contact?> getContactWithAddress(String address) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    final contactsList = box.values.toList();
    final addressContact = <String>[];
    for (final contact in contactsList) {
      if (address == contact.address) {
        return contact;
      }

      addressContact.add(contact.address);
    }

    final lastTransactionMap = await sl.get<ApiService>().getLastTransaction(
      [address, ...addressContact],
      request: 'address',
    );

    var lastAddress = '';
    if (lastTransactionMap[address] != null) {
      lastAddress = lastTransactionMap[address]!.address!.address ?? '';
    }
    if (lastAddress == '') {
      lastAddress = address;
    }

    Contact? contactSelected;
    for (final contact in contactsList) {
      var lastAddressContact = '';
      if (lastTransactionMap[contact.address] != null &&
          lastTransactionMap[contact.address]!.address != null) {
        lastAddressContact =
            lastTransactionMap[contact.address]!.address!.address!;
      }

      if (lastAddressContact.isEmpty) {
        lastAddressContact = contact.address;
      } else {
        final contactToUpdate = contact..address = lastAddressContact;
        await sl.get<DBHelper>().saveContact(contactToUpdate);
      }
      if (lastAddressContact.toLowerCase() == lastAddress.toLowerCase()) {
        contactSelected = contact;
      }
    }
    return contactSelected;
  }

  Future<Contact> getContactWithPublicKey(String publicKey) async {
    Contact? contactSelected;

    final address = hash(publicKey);
    log('address contact: ${uint8ListToHex(address)}');
    contactSelected = await getContactWithAddress(uint8ListToHex(address));

    if (contactSelected == null) {
      throw Exception();
    } else {
      return contactSelected;
    }
  }

  Future<Contact> getContactWithGenesisPublicKey(
    String genesisPublicKey,
  ) async {
    Contact? contactSelected;
    final box = await Hive.openBox<Contact>(contactsTable);
    final contactsList = box.values.toList();

    for (final contact in contactsList) {
      if (contact.publicKey.toLowerCase() == genesisPublicKey.toLowerCase()) {
        contactSelected = contact;
      }
    }
    if (contactSelected == null) {
      throw Exception();
    } else {
      return contactSelected;
    }
  }

  Future<Contact?> getContactWithName(String contactName) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    final contactsList = box.values.toList();
    Contact? contactSelected;
    final nameWithoutAt = contactName.startsWith('@')
        ? contactName.replaceFirst('@', '')
        : contactName;

    for (final contact in contactsList) {
      if (contact.name.replaceFirst('@', '').toLowerCase() ==
          Uri.encodeFull(nameWithoutAt).toLowerCase()) {
        contactSelected = contact;
      }
    }
    return contactSelected;
  }

  Future<bool> contactExistsWithName(String contactName) async {
    return await getContactWithName(contactName) != null;
  }

  Future<bool> contactExistsWithAddress(String address) async {
    // TODO(reddwarf03): Create similar behaviour with contactExistsWithName (3)
    final _contact = await getContactWithAddress(address);
    if (_contact == null) {
      return false;
    }
    return true;
  }

  Future<void> saveContact(Contact contact) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    await box.put(contact.name, contact);
  }

  Future<void> deleteContact(Contact contact) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    await box.delete(contact.name);
  }

  Future<void> deleteContactByName(String name) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    await box.delete(name);
  }

  Future<void> deleteContactByType(String type) async {
    final box = await Hive.openBox<Contact>(contactsTable);
    final contactsList = box.values.toList();
    for (final contact in contactsList) {
      if (contact.type.toLowerCase() == type.toLowerCase()) {
        await box.delete(contact.name);
      }
    }
  }

  Future<void> clearContacts() async {
    final box = await Hive.openBox<Contact>(contactsTable);
    await box.clear();
  }

  Future<void> clearAll() async {
    await clearContacts();
    await clearPrice();
  }

  Future<void> updatePrice(AvailableCurrencyEnum currency, Price price) async {
    final box = await Hive.openBox<Price>(priceTable);
    await box.put(currency.index, price);
  }

  Future<Price?> getPrice(AvailableCurrencyEnum currency) async {
    final box = await Hive.openBox<Price>(priceTable);
    return box.get(currency.index);
  }

  Future<void> clearPrice() async {
    final box = await Hive.openBox<Price>(priceTable);
    await box.clear();
  }
}

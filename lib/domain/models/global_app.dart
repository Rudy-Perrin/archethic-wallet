import 'package:aewallet/domain/models/app_wallet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_app.freezed.dart';

@freezed
class GlobalApp with _$GlobalApp {
  const factory GlobalApp({
    required Map<String, AppWallet> appWallets,
    String? currentKeychainAddress,
  }) = _GlobalApp;

  const GlobalApp._();
}

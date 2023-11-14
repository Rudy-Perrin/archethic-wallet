import 'package:aewallet/domain/models/app_wallet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'secured_settings.freezed.dart';

@freezed
class SecuredSettings with _$SecuredSettings {
  const factory SecuredSettings({
    String? pin,
    String? password,
    String? yubikeyClientID,
    String? yubikeyClientAPIKey,
    GlobalApp? globalApp,
  }) = _SecuredSettings;

  const SecuredSettings._();
}

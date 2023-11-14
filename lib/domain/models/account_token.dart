/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/domain/models/token_information.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_token.freezed.dart';

@freezed
class AccountToken with _$AccountToken {
  const factory AccountToken({
    TokenInformation? tokenInformation,
    double? amount,
  }) = _AccountToken;

  const AccountToken._();
}

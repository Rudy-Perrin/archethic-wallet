/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_information.freezed.dart';

@freezed
class TokenInformation with _$TokenInformation {
  const factory TokenInformation({
    String? address,
    String? name,
    String? type,
    String? symbol,
    double? supply,
    String? id,
    Map<String, dynamic>? tokenProperties,
    List<int>? aeip,
    List<Map<String, dynamic>>? tokenCollection,
    int? decimals,
  }) = _TokenInformation;

  const TokenInformation._();
}

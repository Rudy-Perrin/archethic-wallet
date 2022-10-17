/// SPDX-License-Identifier: AGPL-3.0-or-later
// Project imports:
import 'package:aewallet/application/theme.dart';
import 'package:aewallet/appstate_container.dart';
import 'package:aewallet/localization.dart';
import 'package:aewallet/model/address.dart';
import 'package:aewallet/model/uco_transfer_wallet.dart';
import 'package:aewallet/ui/util/styles.dart';
import 'package:aewallet/util/number_util.dart';
// Package imports:
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UCOTransferListWidget extends ConsumerWidget {
  const UCOTransferListWidget({
    super.key,
    required this.listUcoTransfer,
    required this.feeEstimation,
  });

  final List<UCOTransferWallet>? listUcoTransfer;
  final double? feeEstimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);

    listUcoTransfer!.sort(
      (UCOTransferWallet a, UCOTransferWallet b) => a.to!.compareTo(b.to!),
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.only(left: 3.5, right: 3.5),
      child: Column(
        children: [
          SizedBox(
            height: listUcoTransfer!.length * 90,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listUcoTransfer!.length,
              itemBuilder: (BuildContext context, int index) {
                return _UCOTransferDetail(ucoTransfer: listUcoTransfer![index]);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '+ ${localizations.estimatedFees}',
                      style: theme.textStyleSize14W600Primary,
                    ),
                  ],
                ),
                Text(
                  '${feeEstimation!.toStringAsFixed(8)} ${StateContainer.of(context).curNetwork.getNetworkCryptoCurrencyLabel()}',
                  style: theme.textStyleSize14W600Primary,
                ),
              ],
            ),
          ),
          Divider(height: 4, color: theme.text),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      localizations.total,
                      style: theme.textStyleSize14W600Primary,
                    ),
                  ],
                ),
                Text(
                  '${NumberUtil.formatThousands(_getTotal())} ${StateContainer.of(context).curNetwork.getNetworkCryptoCurrencyLabel()}',
                  style: theme.textStyleSize14W600Primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getTotal() {
    var totalAmount = 0.0;
    for (var i = 0; i < listUcoTransfer!.length; i++) {
      final amount = (Decimal.parse(listUcoTransfer![i].amount!.toString()) /
              Decimal.parse('100000000'))
          .toDouble();
      totalAmount = (Decimal.parse(totalAmount.toString()) +
              Decimal.parse(amount.toString()))
          .toDouble();
    }
    return (Decimal.parse(totalAmount.toString()) +
            Decimal.parse(feeEstimation!.toString()))
        .toDouble();
  }
}

class _UCOTransferDetail extends ConsumerWidget {
  const _UCOTransferDetail({required this.ucoTransfer});

  final UCOTransferWallet ucoTransfer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              localizations.txListTo,
              style: theme.textStyleSize14W600Primary,
            ),
            Text(
              ucoTransfer.toContactName == null
                  ? Address(ucoTransfer.to!).getShortString()
                  : '${ucoTransfer.toContactName!}\n${Address(ucoTransfer.to!).getShortString()}',
              style: theme.textStyleSize14W600Primary,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          '${NumberUtil.formatThousands(fromBigInt(ucoTransfer.amount))} ${StateContainer.of(context).curNetwork.getNetworkCryptoCurrencyLabel()}',
          style: theme.textStyleSize14W600Primary,
        ),
      ],
    );
  }
}
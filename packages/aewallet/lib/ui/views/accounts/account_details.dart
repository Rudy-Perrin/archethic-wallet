// Dart imports:
// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:aeuniverse/appstate_container.dart';
import 'package:aeuniverse/ui/util/styles.dart';
import 'package:aeuniverse/ui/widgets/components/dialog.dart';
import 'package:aeuniverse/ui/widgets/components/sheet_util.dart';
import 'package:aeuniverse/ui/widgets/components/tap_outside_unfocus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:core/localization.dart';
import 'package:core/model/data/hive_db.dart';
import 'package:core_ui/util/case_converter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:

// Account Details Sheet
class AccountDetailsSheet {
  Account? account;
  bool? deleted;

  AccountDetailsSheet(this.account) {
    deleted = false;
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Update name if changed and valid
    /* if (originalName != _nameController.text &&
        _nameController.text.trim().isNotEmpty &&
        !deleted) {
      sl.get<DBHelper>().changeAccountName(account, _nameController.text);
      account.name = _nameController.text;
      EventTaxiImpl.singleton().fire(AccountModifiedEvent(account: account));
    }*/
    return true;
  }

  mainBottomSheet(BuildContext context) {
    Sheets.showAppHeightNineSheet(
        context: context,
        onDisposed: () => _onWillPop(context),
        widget: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return WillPopScope(
              onWillPop: () => _onWillPop(context),
              child: TapOutsideUnfocus(
                  child: SafeArea(
                      minimum: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.035),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsetsDirectional.only(
                                      top: 10.0, start: 10.0),
                                  child: FlatButton(
                                    highlightColor: StateContainer.of(context)
                                        .curTheme
                                        .primary15,
                                    splashColor: StateContainer.of(context)
                                        .curTheme
                                        .primary15,
                                    onPressed: () {
                                      AppDialogs.showConfirmDialog(
                                          context,
                                          'Hide Account',
                                          'Are you sure you want to hide this account? You can re-add it later by tapping the \"%1\" button.',
                                          CaseChange.toUpperCase(
                                              AppLocalization.of(context)!.yes,
                                              StateContainer.of(context)
                                                  .curLanguage
                                                  .getLocaleString()), () {
                                        // Remove account
                                        deleted = true;
                                        /*sl
                                                  .get<DBHelper>()
                                                  .deleteAccount(account)
                                                  .then((id) {
                                                EventTaxiImpl.singleton().fire(
                                                    AccountModifiedEvent(
                                                        account: account,
                                                        deleted: true));
                                                Navigator.of(context).pop();
                                              });*/
                                      },
                                          cancelText: CaseChange.toUpperCase(
                                              AppLocalization.of(context)!.no,
                                              StateContainer.of(context)
                                                  .curLanguage
                                                  .getLocaleString()));
                                    },
                                    padding: const EdgeInsets.all(13.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    child: FaIcon(FontAwesomeIcons.trash,
                                        size: 24,
                                        color: StateContainer.of(context)
                                            .curTheme
                                            .primary),
                                  )),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width -
                                            140),
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      AppLocalization.of(context)!
                                          .accountHeader,
                                      style:
                                          AppStyles.textStyleSize24W700Primary(
                                              context),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      stepGranularity: 0.1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50, width: 50),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          (account!.balance != null || account!.selected!)
                              ? StateContainer.of(context).showBalance
                                  ? Column(
                                      children: [
                                        _balanceNetwork(context, true),
                                        _balanceSelected(context, false),
                                      ],
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                const SizedBox(height: 50),
                                Text(account!.name!,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.textStyleSize16W600Primary(
                                        context)),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 4, bottom: 12),
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.105,
                                    right: MediaQuery.of(context).size.width *
                                        0.105,
                                  ),
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    gradient: StateContainer.of(context)
                                        .curTheme
                                        .gradient!,
                                  ),
                                ),
                              ])),
                        ],
                      ))));
        }));
  }

  Widget _balanceNetwork(BuildContext context, bool primary) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: '',
        children: <InlineSpan>[
          TextSpan(
            text: '(',
            style: primary
                ? AppStyles.textStyleSize16W100Primary(context)
                : AppStyles.textStyleSize14W100Primary(context),
          ),
          TextSpan(
            text: StateContainer.of(context)
                .wallet!
                .accountBalance
                .getNetworkAccountBalanceDisplay(
                    networkCryptoCurrencyLabel: StateContainer.of(context)
                        .curNetwork
                        .getNetworkCryptoCurrencyLabel()),
            style: primary
                ? AppStyles.textStyleSize16W700Primary(context)
                : AppStyles.textStyleSize14W700Primary(context),
          ),
          TextSpan(
            text: ')',
            style: primary
                ? AppStyles.textStyleSize16W100Primary(context)
                : AppStyles.textStyleSize14W100Primary(context),
          ),
        ],
      ),
    );
  }

  Widget _balanceSelected(BuildContext context, bool primary) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: '',
        children: <InlineSpan>[
          TextSpan(
            text: '(',
            style: primary
                ? AppStyles.textStyleSize16W100Primary(context)
                : AppStyles.textStyleSize14W100Primary(context),
          ),
          TextSpan(
            text: StateContainer.of(context)
                .wallet!
                .accountBalance
                .getConvertedAccountBalanceDisplay(),
            style: primary
                ? AppStyles.textStyleSize16W700Primary(context)
                : AppStyles.textStyleSize14W700Primary(context),
          ),
          TextSpan(
            text: ')',
            style: primary
                ? AppStyles.textStyleSize16W100Primary(context)
                : AppStyles.textStyleSize14W100Primary(context),
          ),
        ],
      ),
    );
  }
}
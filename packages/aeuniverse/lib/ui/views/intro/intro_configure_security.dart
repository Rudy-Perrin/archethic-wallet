/// SPDX-License-Identifier: AGPL-3.0-or-later
// ignore_for_file: always_specify_types

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:aeuniverse/appstate_container.dart';
import 'package:aeuniverse/ui/util/styles.dart';
import 'package:aeuniverse/ui/views/authenticate/pin_screen.dart';
import 'package:aeuniverse/ui/widgets/components/icon_widget.dart';
import 'package:aeuniverse/ui/widgets/components/picker_item.dart';
import 'package:aeuniverse/util/preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:core/localization.dart';
import 'package:core/model/authentication_method.dart';
import 'package:core/model/device_lock_timeout.dart';
import 'package:core/util/biometrics_util.dart';
import 'package:core/util/get_it_instance.dart';
import 'package:core/util/vault.dart';

class IntroConfigureSecurity extends StatefulWidget {
  final List<PickerItem>? accessModes;
  const IntroConfigureSecurity({Key? key, this.accessModes}) : super(key: key);

  @override
  _IntroConfigureSecurityState createState() => _IntroConfigureSecurityState();
}

class _IntroConfigureSecurityState extends State<IntroConfigureSecurity> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PickerItem? _accessModesSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              StateContainer.of(context).curTheme.backgroundDark!,
              StateContainer.of(context).curTheme.background!
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SafeArea(
            minimum: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.075),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsetsDirectional.only(start: 15),
                              height: 50,
                              width: 50,
                              child: BackButton(
                                key: const Key('back'),
                                color:
                                    StateContainer.of(context).curTheme.primary,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: buildIconWidget(
                              context,
                              'packages/aeuniverse/assets/icons/finger-print.png',
                              90,
                              90),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(
                            start: 20,
                            end: 20,
                            top: 10,
                          ),
                          alignment: const AlignmentDirectional(-1, 0),
                          child: AutoSizeText(
                            AppLocalization.of(context)!.configureSecurityIntro,
                            style:
                                AppStyles.textStyleSize20W700Warning(context),
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(
                              start: 20, end: 20, top: 15.0),
                          child: AutoSizeText(
                            AppLocalization.of(context)!
                                .configureSecurityExplanation,
                            style:
                                AppStyles.textStyleSize16W600Primary(context),
                            textAlign: TextAlign.justify,
                            maxLines: 6,
                            stepGranularity: 0.5,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (widget.accessModes != null)
                          Container(
                            margin:
                                EdgeInsetsDirectional.only(start: 20, end: 20),
                            child: PickerWidget(
                              pickerItems: widget.accessModes,
                              onSelected: (value) async {
                                setState(() {
                                  _accessModesSelected = value;
                                });
                                if (_accessModesSelected == null) return;
                                AuthMethod _authMethod =
                                    _accessModesSelected!.value as AuthMethod;
                                switch (_authMethod) {
                                  case AuthMethod.biometrics:
                                    await authenticateWithBiometrics();
                                    final Preferences _preferences =
                                        await Preferences.getInstance();
                                    _preferences.setLock(true);
                                    _preferences.setLockTimeout(
                                        LockTimeoutSetting(
                                            LockTimeoutOption.one));
                                    _preferences.setAuthMethod(
                                        AuthenticationMethod(
                                            AuthMethod.biometrics));
                                    break;
                                  case AuthMethod.password:
                                    Navigator.of(context)
                                        .pushNamed('/intro_password');
                                    break;
                                  case AuthMethod.pin:
                                    final String pin =
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                      return const PinScreen(
                                        PinOverlayType.newPin,
                                      );
                                    }));
                                    if (pin.length > 5) {
                                      final Vault _vault =
                                          await Vault.getInstance();
                                      _vault.setPin(pin);
                                      final Preferences _preferences =
                                          await Preferences.getInstance();
                                      _preferences.setLock(true);
                                      _preferences.setLockTimeout(
                                          LockTimeoutSetting(
                                              LockTimeoutOption.one));
                                      _preferences.setAuthMethod(
                                          AuthenticationMethod(AuthMethod.pin));
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        '/home',
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                    break;
                                  case AuthMethod.yubikeyWithYubicloud:
                                    Navigator.of(context)
                                        .pushNamed('/intro_yubikey');
                                    break;
                                  default:
                                    break;
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> authenticateWithBiometrics() async {
    final bool authenticated = await sl
        .get<BiometricUtil>()
        .authenticateWithBiometrics(
            context, AppLocalization.of(context)!.unlockBiometrics);
    if (authenticated) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    }
  }
}
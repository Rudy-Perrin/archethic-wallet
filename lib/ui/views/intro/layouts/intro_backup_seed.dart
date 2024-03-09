/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_backup_confirm.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_new_wallet_disclaimer.dart';
import 'package:aewallet/ui/views/settings/mnemonic_display.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/icon_network_warning.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/haptic_util.dart';
import 'package:aewallet/util/mnemonics.dart';
import 'package:aewallet/util/seeds.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:go_router/go_router.dart';

class IntroBackupSeedPage extends ConsumerStatefulWidget {
  const IntroBackupSeedPage({super.key, this.name});
  final String? name;

  static const routerPage = '/intro_backup';

  @override
  ConsumerState<IntroBackupSeedPage> createState() => _IntroBackupSeedState();
}

class _IntroBackupSeedState extends ConsumerState<IntroBackupSeedPage> {
  String? seed;
  List<String>? mnemonic;
  bool? isPressed;

  @override
  void initState() {
    super.initState();
    isPressed = false;
    seed = AppSeeds.generateSeed();
    mnemonic = AppMnemomics.seedToMnemonic(seed!);
    ref.read(SettingsProviders.settings.notifier).setLanguageSeed('en');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final preferences = ref.watch(SettingsProviders.settings);
    final language = ref.watch(
      SettingsProviders.settings.select(
        (settings) => settings.languageSeed,
      ),
    );
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ArchethicTheme.backgroundDarkest,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ArchethicTheme.backgroundSmall,
            ),
            fit: MediaQuery.of(context).size.width >= 440
                ? BoxFit.fitWidth
                : BoxFit.fitHeight,
            alignment: Alignment.centerRight,
            opacity: 0.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              ArchethicTheme.backgroundDark,
              ArchethicTheme.background,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SafeArea(
            minimum: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.035,
            ),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 15),
                                height: 50,
                                width: 50,
                                child: BackButton(
                                  key: const Key('back'),
                                  color: ArchethicTheme.text,
                                  onPressed: () {
                                    context.go(
                                      IntroNewWalletDisclaimer.routerPage,
                                      extra: widget.name,
                                    );
                                  },
                                ),
                              ),
                              if (connectivityStatusProvider ==
                                  ConnectivityStatus.isConnected)
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: TextButton(
                                        onPressed: () async {
                                          sl.get<HapticUtil>().feedback(
                                                FeedbackType.light,
                                                preferences.activeVibrations,
                                              );
                                          seed = AppSeeds.generateSeed();
                                          mnemonic =
                                              AppMnemomics.seedToMnemonic(
                                            seed!,
                                          );
                                          ref
                                              .read(
                                                SettingsProviders
                                                    .settings.notifier,
                                              )
                                              .setLanguageSeed('en');
                                        },
                                        child: language == 'en'
                                            ? Image.asset(
                                                'assets/icons/languages/united-states.png',
                                              )
                                            : Opacity(
                                                opacity: 0.3,
                                                child: Image.asset(
                                                  'assets/icons/languages/united-states.png',
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: TextButton(
                                        onPressed: () async {
                                          sl.get<HapticUtil>().feedback(
                                                FeedbackType.light,
                                                preferences.activeVibrations,
                                              );
                                          seed = AppSeeds.generateSeed();
                                          mnemonic =
                                              AppMnemomics.seedToMnemonic(
                                            seed!,
                                            languageCode: 'fr',
                                          );

                                          ref
                                              .read(
                                                SettingsProviders
                                                    .settings.notifier,
                                              )
                                              .setLanguageSeed('fr');
                                        },
                                        child: language == 'fr'
                                            ? Image.asset(
                                                'assets/icons/languages/france.png',
                                              )
                                            : Opacity(
                                                opacity: 0.3,
                                                child: Image.asset(
                                                  'assets/icons/languages/france.png',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.only(
                              top: 10,
                            ),
                            child: AutoSizeText(
                              localizations.recoveryPhrase,
                              style: ArchethicThemeStyles
                                  .textStyleSize24W700Primary,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          if (mnemonic != null)
                            Expanded(
                              child: ArchethicScrollbar(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 20,
                                  ),
                                  child: MnemonicDisplay(
                                    seed: seed!,
                                    wordList: mnemonic!,
                                    explanation: Align(
                                      alignment: Alignment.topLeft,
                                      child: AutoSizeText(
                                        localizations
                                            .recoveryPhraseIntroExplanation,
                                        textAlign: TextAlign.justify,
                                        style: ArchethicThemeStyles
                                            .textStyleSize12W100Primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            const Text(''),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AppButtonTinyConnectivity(
                          localizations.iveBackedItUp,
                          Dimens.buttonBottomDimens,
                          key: const Key('iveBackedItUp'),
                          onPressed: () async {
                            context.go(
                              IntroBackupConfirm.routerPage,
                              extra: {'name': widget.name, 'seed': seed},
                            );
                          },
                          disabled: isPressed == true,
                        ),
                      ],
                    ),
                  ],
                ),
                if (connectivityStatusProvider ==
                    ConnectivityStatus.isDisconnected)
                  const IconNetworkWarning(
                    alignment: Alignment.topRight,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

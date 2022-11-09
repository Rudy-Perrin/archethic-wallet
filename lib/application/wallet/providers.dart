part of 'wallet.dart';

@Riverpod(keepAlive: true)
class _SessionNotifier extends Notifier<Session> {
  Vault? __vault;
  Future<Vault> get _vault async => __vault ??= await Vault.getInstance();

  final DBHelper _dbHelper = sl.get<DBHelper>();

  @override
  Session build() {
    return const Session.loggedOut();
  }

  Future<void> restore() async {
    final seed = (await _vault).getSeed();
    final appWalletDTO = await _dbHelper.getAppWallet();

    if (seed == null || appWalletDTO == null) {
      await logout();
      return;
    }

    state = Session.loggedIn(
      wallet: appWalletDTO.toModel(seed: seed),
    );
  }

  Future<void> refresh() async {
    if (state.isLoggedOut) return;

    final loggedInState = state.loggedIn!;
    final selectedCurrency = ref.read(CurrencyProviders.selectedCurrency);

    final newWalletDTO = await KeychainUtil().getListAccountsFromKeychain(
      HiveAppWalletDTO.fromModel(loggedInState.wallet),
      loggedInState.wallet.seed,
      selectedCurrency.currency.name,
      AccountBalance.cryptoCurrencyLabel,
    );
    if (newWalletDTO == null) return;

    state = Session.loggedIn(
      wallet: loggedInState.wallet.copyWith(
        appKeychain: newWalletDTO.appKeychain,
      ),
    );
  }

  Future<void> logout() async {
    (await Vault.getInstance()).clearAll();
    (await Preferences.getInstance()).clearAll();
    sl.get<DBHelper>().clearAll();

    state = const Session.loggedOut();
    // TODO(Chralu): is it useful ?
    // RestartWidget.restartApp(context);
  }

  Future<void> createNewAppWallet({
    required String seed,
    required String keychainAddress,
    required Keychain keychain,
    String? name,
  }) async {
    final newAppWalletDTO = await HiveAppWalletDTO.createNewAppWallet(
      keychainAddress,
      keychain,
      name,
    );
    state = Session.loggedIn(
      wallet: newAppWalletDTO.toModel(seed: seed),
    );
  }

  Future<LoggedInSession?> restoreFromMnemonics({
    required List<String> mnemonics,
    required String languageCode,
  }) async {
    final settings = ref.read(SettingsProviders.settings);

    await sl.get<DBHelper>().clearAppWallet();

    final seed = AppMnemomics.mnemonicListToSeed(
      mnemonics,
      languageCode: languageCode,
    );
    final vault = await Vault.getInstance();
    vault.setSeed(seed);

    try {
      final appWallet = await KeychainUtil().getListAccountsFromKeychain(
        null,
        seed,
        settings.currency.name,
        AccountBalance.cryptoCurrencyLabel,
      );

      if (appWallet == null) {
        return null;
      }

      return state = LoggedInSession(
        wallet: appWallet.toModel(seed: seed),
      );
    } catch (e) {
      return null;
    }
  }
}

@riverpod
Future<Keychain?> _archethicWalletKeychain(Ref ref) async {
  final loggedInSession = ref.watch(SessionProviders.session).loggedIn;
  if (loggedInSession == null) return null;

  return sl.get<ApiService>().getKeychain(loggedInSession.wallet.seed);
}

abstract class SessionProviders {
  static final session = _sessionNotifierProvider;

  static final archethicWalletKeychain = _archethicWalletKeychainProvider;
}
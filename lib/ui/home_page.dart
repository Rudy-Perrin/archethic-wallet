// @dart=2.9

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/base/animation/actor_animation.dart';

import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:logger/logger.dart';
import 'package:uniris_mobile_wallet/ui/particles/particles_flutter.dart';
import 'package:uniris_mobile_wallet/ui/popup_button.dart';
import 'package:uniris_mobile_wallet/appstate_container.dart';
import 'package:uniris_mobile_wallet/localization.dart';
import 'package:uniris_mobile_wallet/service_locator.dart';
import 'package:uniris_mobile_wallet/styles.dart';
import 'package:uniris_mobile_wallet/app_icons.dart';
import 'package:uniris_mobile_wallet/ui/receive/receive_sheet.dart';
import 'package:uniris_mobile_wallet/ui/settings/settings_drawer.dart';
import 'package:uniris_mobile_wallet/ui/widgets/balance.dart';
import 'package:uniris_mobile_wallet/ui/widgets/charts_price_view.dart';
import 'package:uniris_mobile_wallet/ui/widgets/dialog.dart';
import 'package:uniris_mobile_wallet/ui/widgets/line_chart.dart';
import 'package:uniris_mobile_wallet/ui/widgets/sheet_util.dart';
import 'package:uniris_mobile_wallet/ui/util/routes.dart';
import 'package:uniris_mobile_wallet/ui/util/ui_util.dart';
import 'package:uniris_mobile_wallet/util/sharedprefsutil.dart';
import 'package:uniris_mobile_wallet/util/caseconverter.dart';
import 'package:package_info/package_info.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uniris_mobile_wallet/bus/events.dart';

class AppHomePage extends StatefulWidget {
  AppHomePage() : super();

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Logger log = sl.get<Logger>();

  // Controller for placeholder card animations
  AnimationController _placeholderCardAnimationController;
  Animation<double> _opacityAnimation;
  bool _animationDisposed;

  bool _displayReleaseNote;

  // Receive card instance
  ReceiveSheet receive;

  bool _lockDisabled = false; // whether we should avoid locking the app

  // Main card height
  double mainCardHeight;
  double settingsIconMarginTop = 5;

  ScrollController _scrollController;

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

  _checkVersionApp() async {
    String versionAppCached = await sl.get<SharedPrefsUtil>().getVersionApp();
    PackageInfo.fromPlatform().then((packageInfo) async {
      if (versionAppCached != packageInfo.version) {
        // TODO
        _displayReleaseNote = false;
      } else {
        _displayReleaseNote = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _displayReleaseNote = false;
    _checkVersionApp();

    _registerBus();
    WidgetsBinding.instance.addObserver(this);

    // Main Card Size
    mainCardHeight = 120;
    settingsIconMarginTop = 7;

    // Setup placeholder animation and start
    _animationDisposed = false;
    _placeholderCardAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _placeholderCardAnimationController
        .addListener(_animationControllerListener);
    _opacityAnimation = new Tween(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(
        parent: _placeholderCardAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
    _opacityAnimation.addStatusListener(_animationStatusListener);
    _placeholderCardAnimationController.forward();

    _scrollController = new ScrollController();
  }

  void _animationStatusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        _placeholderCardAnimationController.forward();
        break;
      case AnimationStatus.completed:
        _placeholderCardAnimationController.reverse();
        break;
      default:
        return null;
    }
  }

  void _animationControllerListener() {
    setState(() {});
  }

  void _startAnimation() {
    if (_animationDisposed) {
      _animationDisposed = false;
      _placeholderCardAnimationController
          .addListener(_animationControllerListener);
      _opacityAnimation.addStatusListener(_animationStatusListener);
      _placeholderCardAnimationController.forward();
    }
  }

  StreamSubscription<DisableLockTimeoutEvent> _disableLockSub;
  StreamSubscription<AccountChangedEvent> _switchAccountSub;

  void _registerBus() {
    // Hackish event to block auto-lock functionality
    _disableLockSub = EventTaxiImpl.singleton()
        .registerTo<DisableLockTimeoutEvent>()
        .listen((event) {
      if (event.disable) {
        cancelLockEvent();
      }
      _lockDisabled = event.disable;
    });
    // User changed account
    _switchAccountSub = EventTaxiImpl.singleton()
        .registerTo<AccountChangedEvent>()
        .listen((event) {
      setState(() {
        StateContainer.of(context).wallet.loading = true;
        StateContainer.of(context).wallet.historyLoading = true;

        _startAnimation();
        StateContainer.of(context).updateWallet(account: event.account);

        StateContainer.of(context).wallet.loading = false;
        StateContainer.of(context).wallet.historyLoading = false;
      });
      paintQrCode(address: event.account.address);
      if (event.delayPop) {
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.of(context).popUntil(RouteUtils.withNameLike("/home"));
        });
      } else if (!event.noPop) {
        Navigator.of(context).popUntil(RouteUtils.withNameLike("/home"));
      }
    });
  }

  @override
  void dispose() {
    _destroyBus();
    WidgetsBinding.instance.removeObserver(this);
    _placeholderCardAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _destroyBus() {
    if (_disableLockSub != null) {
      _disableLockSub.cancel();
    }
    if (_switchAccountSub != null) {
      _switchAccountSub.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle websocket connection when app is in background
    // terminate it to be eco-friendly
    switch (state) {
      case AppLifecycleState.paused:
        setAppLockEvent();
        super.didChangeAppLifecycleState(state);
        break;
      case AppLifecycleState.resumed:
        cancelLockEvent();
        super.didChangeAppLifecycleState(state);
        break;
      default:
        super.didChangeAppLifecycleState(state);
        break;
    }
  }

  // To lock and unlock the app
  StreamSubscription<dynamic> lockStreamListener;

  Future<void> setAppLockEvent() async {
    if (((await sl.get<SharedPrefsUtil>().getLock()) ||
            StateContainer.of(context).encryptedSecret != null) &&
        !_lockDisabled) {
      if (lockStreamListener != null) {
        lockStreamListener.cancel();
      }
      Future<dynamic> delayed = new Future.delayed(
          (await sl.get<SharedPrefsUtil>().getLockTimeout()).getDuration());
      delayed.then((_) {
        return true;
      });
      lockStreamListener = delayed.asStream().listen((_) {
        try {
          StateContainer.of(context).resetEncryptedSecret();
        } catch (e) {
          log.w(
              "Failed to reset encrypted secret when locking ${e.toString()}");
        } finally {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      });
    }
  }

  Future<void> cancelLockEvent() async {
    if (lockStreamListener != null) {
      lockStreamListener.cancel();
    }
  }

  void paintQrCode({String address}) {
    QrPainter painter = QrPainter(
      //data:
      //    address == null ? StateContainer.of(context).wallet.address : address,
      // TODO:
      data: "05A2525C9C4FDDC02BA97554980A0CFFADA2AEB0650E3EAD05796275F05DDA85",
      version: 6,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
    );
    painter.toImageData(MediaQuery.of(context).size.width).then((byteData) {
      setState(() {
        receive = ReceiveSheet(
          qrWidget: Container(
              width: MediaQuery.of(context).size.width / 2.675,
              child: Image.memory(byteData.buffer.asUint8List())),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _displayReleaseNote
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => displayReleaseNote())
        : null;
    // Create QR ahead of time because it improves performance this way
    if (receive == null && StateContainer.of(context).wallet != null) {
      paintQrCode();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        title: Container(
          child: SvgPicture.asset("assets/uniris_logo.svg"),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          /*Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.search,
            ),
          ),*/
        ],
        iconTheme:
            IconThemeData(color: StateContainer.of(context).curTheme.primary),
      ),
      drawerEdgeDragWidth: 0,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: StateContainer.of(context).curTheme.background,
      drawer: SizedBox(
        width: UIUtil.drawerWidth(context),
        child: Drawer(
          child: SettingsSheet(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              StateContainer.of(context).curTheme.backgroundDark,
              StateContainer.of(context).curTheme.background
            ],
          ),
        ),
        child: SafeArea(
          minimum: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.045,
              bottom: MediaQuery.of(context).size.height * 0.035),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    //Everything else
                    CircularParticle(
                      awayRadius: 80,
                      numberOfParticles: 80,
                      speedOfParticles: 0.5,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      onTapAnimation: true,
                      particleColor: StateContainer.of(context)
                          .curTheme
                          .primary10
                          .withAlpha(150)
                          .withOpacity(0.2),
                      awayAnimationDuration: Duration(milliseconds: 600),
                      maxParticleSize: 8,
                      isRandSize: true,
                      isRandomColor: false,
                      awayAnimationCurve: Curves.easeInOutBack,
                      enableHover: true,
                      hoverColor: StateContainer.of(context).curTheme.primary30,
                      hoverRadius: 90,
                      connectDots: true,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 150.0,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: 3,
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: StateContainer.of(context)
                                      .curTheme
                                      .backgroundDark,
                                  child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height: mainCardHeight,
                                      curve: Curves.easeInOut,
                                      child: index == 0
                                          ? BalanceDisplay
                                              .buildBalanceUCODisplay(
                                                  context, _opacityAnimation)
                                          : index == 1
                                              ? BalanceDisplay
                                                  .buildBalanceNFTDisplay(
                                                      context,
                                                      _opacityAnimation)
                                              : LineChartWidget()
                                      /*new ChartsPriceView(
                                                localCurrency:
                                                    StateContainer.of(context)
                                                        .curCurrency,
                                                nbDays: 1),*/
                                      ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 45,
                            padding: EdgeInsets.all(3.5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: StateContainer.of(context)
                                  .curTheme
                                  .background,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: StateContainer.of(context)
                                      .curTheme
                                      .backgroundDark,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(5.0,
                                      5.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              topLeft: Radius.circular(12))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesome5.arrow_circle_up,
                                              color: StateContainer.of(context)
                                                  .curTheme
                                                  .primary),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(AppLocalization.of(context).send,
                                              style: AppStyles
                                                  .textStyleButtonPrimarySmallOutline(
                                                      context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 1.0,
                                  color: StateContainer.of(context)
                                      .curTheme
                                      .primary,
                                  thickness: 1.5,
                                  indent: 2.0,
                                  endIndent: 2.0,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (receive == null) {
                                        return;
                                      }
                                      Sheets.showAppHeightEightSheet(
                                          context: context, widget: receive);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesome5.arrow_circle_down,
                                            color: StateContainer.of(context)
                                                .curTheme
                                                .primary),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            AppLocalization.of(context).receive,
                                            style: AppStyles
                                                .textStyleButtonPrimarySmallOutline(
                                                    context)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Buttons
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        AppPopupButton(),
                      ],
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void displayReleaseNote() {
    _displayReleaseNote = false;
    PackageInfo.fromPlatform().then((packageInfo) {
      AppDialogs.showConfirmDialog(
          context,
          AppLocalization.of(context).releaseNoteHeader +
              " " +
              packageInfo.version,
          "",
          CaseChange.toUpperCase(AppLocalization.of(context).ok, context),
          () async {
        await sl.get<SharedPrefsUtil>().setVersionApp(packageInfo.version);
      });
    });
  }
}

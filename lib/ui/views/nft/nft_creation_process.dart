/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/model/token_property_with_access_infos.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/views/nft/add_public_key.dart';
import 'package:aewallet/ui/widgets/components/sheet_util.dart';
import 'package:aewallet/util/user_data_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:aewallet/appstate_container.dart';
import 'package:aewallet/bus/authenticated_event.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/localization.dart';
import 'package:aewallet/model/nft_category.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/service/app_service.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/routes.dart';
import 'package:aewallet/ui/util/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/nft/nft_preview.dart';
import 'package:aewallet/ui/widgets/components/app_text_field.dart';
import 'package:aewallet/ui/widgets/components/balance_indicator.dart';
import 'package:aewallet/ui/widgets/components/buttons.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/util/confirmations/confirmations_util.dart';
import 'package:aewallet/util/confirmations/subscription_channel%20copy.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/haptic_util.dart';
import 'package:aewallet/util/mime_util.dart';
import 'package:aewallet/util/preferences.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_dart/mime_dart.dart';
import 'package:path/path.dart' as path;
import 'package:pdfx/pdfx.dart';
import 'package:collection/collection.dart';

enum NFTCreationProcessType { single, collection }

class NFTCreationProcess extends StatefulWidget {
  final int? currentNftCategoryIndex;
  final NFTCreationProcessType? process;
  final PrimaryCurrencySetting? primaryCurrency;

  const NFTCreationProcess(
      {super.key,
      this.currentNftCategoryIndex,
      this.process,
      this.primaryCurrency});

  @override
  State<NFTCreationProcess> createState() => _NFTCreationProcessState();
}

class _NFTCreationProcessState extends State<NFTCreationProcess>
    with TickerProviderStateMixin {
  PageController? pageController;
  int currentPage = 0;

  //
  File? file;
  int importSelection = 0;
  Uint8List? fileDecodedForPreview;
  Uint8List? fileDecoded;
  String typeMime = '';
  String file64 = '';
  int sizeFile = 0;
  FocusNode? nftNameFocusNode;
  FocusNode? nftDescriptionFocusNode;
  FocusNode? nftPropertyNameFocusNode;
  FocusNode? nftPropertyValueFocusNode;
  TextEditingController? nftNameController;
  TextEditingController? nftDescriptionController;
  TextEditingController? nftPropertySearchController;
  TextEditingController? nftPropertyNameController;
  TextEditingController? nftPropertyValueController;
  String addNFTMessage = '';
  String addNFTPropertyMessage = '';
  List<TokenPropertyWithAccessInfos> tokenPropertyWithAccessInfosList =
      List<TokenPropertyWithAccessInfos>.empty(growable: true);
  TokenPropertyWithAccessInfos? tokenPropertyAsset =
      TokenPropertyWithAccessInfos(
          tokenProperty: TokenProperty(name: 'file', value: ''));

  Token token = Token();
  int tabActiveIndex = 0;
  double feeEstimation = 0.0;
  bool? isPressed;

  SubscriptionChannel subscriptionChannel = SubscriptionChannel();

  StreamSubscription<AuthenticatedEvent>? _authSub;
  StreamSubscription<TransactionSendEvent>? _sendTxSub;

  @override
  void initState() {
    _registerBus();
    pageController = PageController()
      ..addListener(() {
        final newPage = pageController!.page!.round();
        if (currentPage != newPage) {
          setState(() => currentPage = newPage);
        }
      });
    nftNameFocusNode = FocusNode();
    nftDescriptionFocusNode = FocusNode();
    nftPropertyNameFocusNode = FocusNode();
    nftPropertyValueFocusNode = FocusNode();
    nftNameController = TextEditingController();
    nftDescriptionController = TextEditingController();
    nftPropertyNameController = TextEditingController();
    nftPropertyValueController = TextEditingController();
    nftPropertySearchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    _destroyBus();
    super.dispose();
  }

  void _destroyBus() {
    if (_authSub != null) {
      _authSub!.cancel();
    }
    if (_sendTxSub != null) {
      _sendTxSub!.cancel();
    }
    subscriptionChannel.close();
  }

  void _showSendingAnimation(BuildContext context) {
    Navigator.of(context).push(AnimationLoadingOverlay(
      AnimationType.send,
      StateContainer.of(context).curTheme.animationOverlayStrong!,
      StateContainer.of(context).curTheme.animationOverlayMedium!,
    ));
  }

  void _registerBus() {
    _authSub = EventTaxiImpl.singleton()
        .registerTo<AuthenticatedEvent>()
        .listen((AuthenticatedEvent event) {
      _doAdd();
    });

    _sendTxSub = EventTaxiImpl.singleton()
        .registerTo<TransactionSendEvent>()
        .listen((TransactionSendEvent event) async {
      if (event.response != 'ok' && event.nbConfirmations == 0) {
        // Send failed

        Navigator.of(context).pop();

        UIUtil.showSnackbar(
            '${AppLocalization.of(context)!.sendError} (${event.response!})',
            context,
            StateContainer.of(context).curTheme.text!,
            StateContainer.of(context).curTheme.snackBarShadow!);
        Navigator.of(context).pop();
      } else {
        if (event.response == 'ok' &&
            ConfirmationsUtil.isEnoughConfirmations(
                event.nbConfirmations!, event.maxConfirmations!)) {
          UIUtil.showSnackbar(
              event.nbConfirmations == 1
                  ? AppLocalization.of(context)!
                      .nftCreationTransactionConfirmed1
                      .replaceAll('%1', event.nbConfirmations.toString())
                      .replaceAll('%2', event.maxConfirmations.toString())
                  : AppLocalization.of(context)!
                      .nftCreationTransactionConfirmed
                      .replaceAll('%1', event.nbConfirmations.toString())
                      .replaceAll('%2', event.maxConfirmations.toString()),
              context,
              StateContainer.of(context).curTheme.text!,
              StateContainer.of(context).curTheme.snackBarShadow!,
              duration: const Duration(milliseconds: 5000));

          await StateContainer.of(context)
              .appWallet!
              .appKeychain!
              .getAccountSelected()!
              .updateNftInfosOffChain(
                  tokenAddress: event.transactionAddress!,
                  categoryNftIndex: widget.currentNftCategoryIndex!,
                  like: false);

          StateContainer.of(context).requestUpdate();

          Navigator.of(context)
              .popUntil(RouteUtils.withNameLike('/nft_list_per_category'));
        } else {
          UIUtil.showSnackbar(
              AppLocalization.of(context)!.notEnoughConfirmations,
              context,
              StateContainer.of(context).curTheme.text!,
              StateContainer.of(context).curTheme.snackBarShadow!);
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  StateContainer.of(context).curTheme.background4Small!),
              fit: BoxFit.fitHeight),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsetsDirectional.only(
                              start: smallScreen(context) ? 15 : 20),
                          height: 50,
                          width: 50,
                          child: BackButton(
                            key: const Key('back'),
                            color: StateContainer.of(context).curTheme.text,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    BalanceIndicatorWidget(
                        primaryCurrency: widget.primaryCurrency,
                        displaySwitchButton: false),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            color: StateContainer.of(context)
                                .curTheme
                                .backgroundDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.white10, width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                NftCategory.getList(context)[
                                        widget.currentNftCategoryIndex!]
                                    .image!,
                                width: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 2,
                  color: StateContainer.of(context).curTheme.text15,
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints.expand(height: 100),
                    child: ContainedTabBarView(
                      tabBarViewProperties: const TabBarViewProperties(
                          physics: NeverScrollableScrollPhysics()),
                      tabBarProperties: TabBarProperties(
                        labelColor: StateContainer.of(context).curTheme.text,
                        labelStyle:
                            AppStyles.textStyleSize10W100Primary(context),
                        labelPadding: const EdgeInsets.all(0),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor:
                            StateContainer.of(context).curTheme.text,
                      ),
                      tabs: [
                        Tab(
                            text: AppLocalization.of(context)!
                                .nftCreationProcessTabImportHeader,
                            icon: const Icon(Icons.arrow_downward)),
                        Tab(
                            text: AppLocalization.of(context)!
                                .nftCreationProcessTabDescriptionHeader,
                            icon: const Icon(Icons.info_outline)),
                        Tab(
                            text: AppLocalization.of(context)!
                                .nftCreationProcessTabPropertiesHeader,
                            icon: const Icon(Icons.insert_comment_rounded)),
                        Tab(
                            text: AppLocalization.of(context)!
                                .nftCreationProcessTabConfirmationHeader,
                            icon: const Icon(
                                Icons.check_circle_outline_outlined)),
                      ],
                      views: [
                        importTab(context),
                        enterInfosTab(context),
                        enterPropertiesTab(context),
                        confirmationTab(context)
                      ],
                      onChange: ((index) {
                        updateToken();
                        tabActiveIndex = index;
                        if (tabActiveIndex == 3) {
                          feeEstimation = getFee(context);
                        }
                        setState(() {});
                      }),
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

  Widget importTab(BuildContext context) {
    if (tabActiveIndex != 0) {
      return const SizedBox();
    } else {
      return SingleChildScrollView(
        physics: file == null
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height + 200,
          child: Container(
            padding:
                const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Import a photo, a document, a piece of information, or any other element that you wish to transform into a non-fungible token.',
                    style: AppStyles.textStyleSize12W100Primary(context),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: InkWell(
                    onTap: () async {
                      importSelection = 1;
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        file = File(result.files.single.path!);
                        await setFileProperties(file!);
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                          child: FaIcon(FontAwesomeIcons.file,
                              size: 18,
                              color: StateContainer.of(context).curTheme.text),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalization.of(context)!.nftAddImportFile,
                          style: AppStyles.textStyleSize12W400Primary(context),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        if (importSelection == 1)
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          )
                      ],
                    ),
                  ),
                ),
                if (kIsWeb == false && (Platform.isAndroid || Platform.isIOS))
                  Divider(
                    height: 2,
                    color: StateContainer.of(context).curTheme.text15,
                  ),
                if (kIsWeb == false && (Platform.isAndroid || Platform.isIOS))
                  SizedBox(
                    height: 40,
                    child: InkWell(
                      onTap: () async {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        if (pickedFile != null) {
                          importSelection = 2;
                          file = File(pickedFile.path);
                          await setFileProperties(file!);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                                child: FaIcon(FontAwesomeIcons.photoFilm,
                                    size: 18,
                                    color: StateContainer.of(context)
                                        .curTheme
                                        .text),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalization.of(context)!.nftAddImportPhoto,
                                style: AppStyles.textStyleSize12W400Primary(
                                    context),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              if (importSelection == 2)
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              sl.get<HapticUtil>().feedback(FeedbackType.light,
                                  StateContainer.of(context).activeVibrations);
                              AppDialogs.showInfoDialog(
                                context,
                                AppLocalization.of(context)!.informations,
                                AppLocalization.of(context)!
                                    .nftAddPhotoFormatInfo,
                              );
                            },
                            child: SizedBox(
                              width: 30,
                              child: FaIcon(FontAwesomeIcons.circleInfo,
                                  size: 18,
                                  color:
                                      StateContainer.of(context).curTheme.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Divider(
                  height: 2,
                  color: StateContainer.of(context).curTheme.text15,
                ),
                if (kIsWeb == false && (Platform.isAndroid || Platform.isIOS))
                  SizedBox(
                    height: 40,
                    child: InkWell(
                      onTap: () async {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        if (pickedFile != null) {
                          importSelection = 3;
                          file = File(pickedFile.path);
                          await setFileProperties(file!);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                                child: FaIcon(FontAwesomeIcons.cameraRetro,
                                    size: 18,
                                    color: StateContainer.of(context)
                                        .curTheme
                                        .text),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Take a photo',
                                style: AppStyles.textStyleSize12W400Primary(
                                    context),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              if (importSelection == 3)
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Divider(
                  height: 2,
                  color: StateContainer.of(context).curTheme.text15,
                ),
                if (file != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () async {},
                      onLongPress: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: tokenPropertyAsset!.publicKeysList != null &&
                                  tokenPropertyAsset!.publicKeysList!.isNotEmpty
                              ? BorderSide(color: Colors.redAccent, width: 2.0)
                              : BorderSide(
                                  color: StateContainer.of(context)
                                      .curTheme
                                      .backgroundAccountsListCardSelected!,
                                  width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                        color: StateContainer.of(context)
                            .curTheme
                            .backgroundAccountsListCardSelected,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: AutoSizeText(
                                              tokenPropertyAsset!
                                                  .tokenProperty!.name!,
                                              style: AppStyles
                                                  .textStyleSize12W600Primary(
                                                      context),
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: AutoSizeText(
                                              tokenPropertyAsset!
                                                  .tokenProperty!.value!,
                                              style: AppStyles
                                                  .textStyleSize12W400Primary(
                                                      context),
                                            ),
                                          ),
                                          tokenPropertyAsset!.publicKeysList !=
                                                      null &&
                                                  tokenPropertyAsset!
                                                      .publicKeysList!
                                                      .isNotEmpty
                                              ? tokenPropertyAsset!
                                                          .publicKeysList!
                                                          .length ==
                                                      1
                                                  ? Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: AutoSizeText(
                                                        'This asset is protected and accessible by ${tokenPropertyAsset!.publicKeysList!.length} public key',
                                                        style: AppStyles
                                                            .textStyleSize12W400Primary(
                                                                context),
                                                      ),
                                                    )
                                                  : Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: AutoSizeText(
                                                        'This asset is protected and accessible by ${tokenPropertyAsset!.publicKeysList!.length} public keys',
                                                        style: AppStyles
                                                            .textStyleSize12W400Primary(
                                                                context),
                                                      ),
                                                    )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      180,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: AutoSizeText(
                                                    'This asset is accessible by everyone',
                                                    style: AppStyles
                                                        .textStyleSize12W400Primary(
                                                            context),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: StateContainer.of(context)
                                            .curTheme
                                            .backgroundDark!
                                            .withOpacity(0.3),
                                        border: Border.all(
                                            color: StateContainer.of(context)
                                                .curTheme
                                                .backgroundDarkest!
                                                .withOpacity(0.2),
                                            width: 2),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.key,
                                            color: StateContainer.of(context)
                                                .curTheme
                                                .backgroundDarkest!,
                                            size: 21),
                                        onPressed: () {
                                          sl.get<HapticUtil>().feedback(
                                              FeedbackType.light,
                                              StateContainer.of(context)
                                                  .activeVibrations);
                                          Sheets.showAppHeightNineSheet(
                                              context: context,
                                              widget: AddPublicKey(
                                                tokenPropertyWithAccessInfos:
                                                    tokenPropertyAsset!,
                                                returnPublicKeys: (List<String>
                                                    publicKeysList) {
                                                  tokenPropertyAsset!
                                                          .publicKeysList =
                                                      publicKeysList;

                                                  setState(() {});
                                                },
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: StateContainer.of(context)
                                            .curTheme
                                            .backgroundDark!
                                            .withOpacity(0.3),
                                        border: Border.all(
                                            color: StateContainer.of(context)
                                                .curTheme
                                                .backgroundDarkest!
                                                .withOpacity(0.2),
                                            width: 2),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.close,
                                            color: StateContainer.of(context)
                                                .curTheme
                                                .backgroundDarkest!,
                                            size: 21),
                                        onPressed: () {
                                          sl.get<HapticUtil>().feedback(
                                              FeedbackType.light,
                                              StateContainer.of(context)
                                                  .activeVibrations);
                                          AppDialogs.showConfirmDialog(
                                              context,
                                              'Delete file',
                                              'Are you sure ?',
                                              AppLocalization.of(context)!
                                                  .deleteOption, () {
                                            sl.get<HapticUtil>().feedback(
                                                FeedbackType.light,
                                                StateContainer.of(context)
                                                    .activeVibrations);
                                            importSelection = 0;
                                            file = null;
                                            file64 = '';
                                            tokenPropertyWithAccessInfosList
                                                .removeWhere((element) =>
                                                    element
                                                        .tokenProperty!.name ==
                                                    tokenPropertyAsset!
                                                        .tokenProperty!.name);
                                            setState(() {});
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (file != null &&
                    (MimeUtil.isImage(typeMime) == true ||
                        MimeUtil.isPdf(typeMime) == true))
                  Container(
                    decoration: BoxDecoration(
                      color: StateContainer.of(context).curTheme.text,
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    child: Image.memory(
                      fileDecodedForPreview!,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                if (file != null &&
                    (MimeUtil.isImage(typeMime) == true ||
                        MimeUtil.isPdf(typeMime) == true))
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${AppLocalization.of(context)!.nftAddFileSize} ${filesize(sizeFile)}',
                        style: AppStyles.textStyleSize12W400Primary(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget enterInfosTab(BuildContext context) {
    if (tabActiveIndex != 1) {
      return const SizedBox();
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Add to your NFT a name and a human readable description.',
                style: AppStyles.textStyleSize12W100Primary(context),
                textAlign: TextAlign.justify,
              ),
            ),
            AppTextField(
              focusNode: nftNameFocusNode,
              controller: nftNameController,
              cursorColor: StateContainer.of(context).curTheme.text,
              textInputAction: TextInputAction.next,
              labelText: AppLocalization.of(context)!.nftNameHint,
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: AppStyles.textStyleSize16W600Primary(context),
              inputFormatters: <LengthLimitingTextInputFormatter>[
                LengthLimitingTextInputFormatter(30),
              ],
              onChanged: (text) {
                tokenPropertyWithAccessInfosList.removeWhere(
                    (element) => element.tokenProperty!.name == 'name');
                tokenPropertyWithAccessInfosList.add(
                    TokenPropertyWithAccessInfos(
                        tokenProperty: TokenProperty(
                            name: 'name', value: nftNameController!.text)));
              },
              suffixButton: kIsWeb == false &&
                      (Platform.isIOS || Platform.isAndroid)
                  ? TextFieldButton(
                      icon: FontAwesomeIcons.qrcode,
                      onPressed: () async {
                        sl.get<HapticUtil>().feedback(FeedbackType.light,
                            StateContainer.of(context).activeVibrations);
                        UIUtil.cancelLockEvent();
                        final String? scanResult =
                            await UserDataUtil.getQRData(DataType.raw, context);
                        QRScanErrs.errorList;
                        if (scanResult == null) {
                          UIUtil.showSnackbar(
                              AppLocalization.of(context)!.qrInvalidAddress,
                              context,
                              StateContainer.of(context).curTheme.text!,
                              StateContainer.of(context)
                                  .curTheme
                                  .snackBarShadow!);
                        } else if (QRScanErrs.errorList.contains(scanResult)) {
                          UIUtil.showSnackbar(
                              scanResult,
                              context,
                              StateContainer.of(context).curTheme.text!,
                              StateContainer.of(context)
                                  .curTheme
                                  .snackBarShadow!);
                          return;
                        } else {
                          setState(() {
                            nftNameController!.text = scanResult;
                          });
                        }
                      },
                    )
                  : null,
            ),
            AppTextField(
              focusNode: nftDescriptionFocusNode,
              controller: nftDescriptionController,
              cursorColor: StateContainer.of(context).curTheme.text,
              textInputAction: TextInputAction.next,
              labelText: AppLocalization.of(context)!.nftDescriptionHint,
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: AppStyles.textStyleSize16W600Primary(context),
              inputFormatters: <LengthLimitingTextInputFormatter>[
                LengthLimitingTextInputFormatter(40),
              ],
              onChanged: (text) {
                tokenPropertyWithAccessInfosList.removeWhere(
                    (element) => element.tokenProperty!.name == 'description');
                tokenPropertyWithAccessInfosList.add(
                    TokenPropertyWithAccessInfos(
                        tokenProperty: TokenProperty(
                            name: 'description',
                            value: nftDescriptionController!.text)));
              },
              suffixButton: kIsWeb == false &&
                      (Platform.isIOS || Platform.isAndroid)
                  ? TextFieldButton(
                      icon: FontAwesomeIcons.qrcode,
                      onPressed: () async {
                        sl.get<HapticUtil>().feedback(FeedbackType.light,
                            StateContainer.of(context).activeVibrations);
                        UIUtil.cancelLockEvent();
                        final String? scanResult =
                            await UserDataUtil.getQRData(DataType.raw, context);
                        QRScanErrs.errorList;
                        if (scanResult == null) {
                          UIUtil.showSnackbar(
                              AppLocalization.of(context)!.qrInvalidAddress,
                              context,
                              StateContainer.of(context).curTheme.text!,
                              StateContainer.of(context)
                                  .curTheme
                                  .snackBarShadow!);
                        } else if (QRScanErrs.errorList.contains(scanResult)) {
                          UIUtil.showSnackbar(
                              scanResult,
                              context,
                              StateContainer.of(context).curTheme.text!,
                              StateContainer.of(context)
                                  .curTheme
                                  .snackBarShadow!);
                          return;
                        } else {
                          setState(() {
                            nftDescriptionController!.text = scanResult;
                          });
                        }
                      },
                    )
                  : null,
            ),
          ],
        ),
      );
    }
  }

  Widget enterPropertiesTab(BuildContext context) {
    if (tabActiveIndex != 2) {
      return const SizedBox();
    } else {
      return SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'You can add additional properties to define, characterize or specify the use of your NFT. Name and value are free.',
                  style: AppStyles.textStyleSize12W100Primary(context),
                  textAlign: TextAlign.justify,
                ),
              ),
              AppTextField(
                focusNode: nftPropertyNameFocusNode,
                controller: nftPropertyNameController,
                cursorColor: StateContainer.of(context).curTheme.text,
                textInputAction: TextInputAction.next,
                labelText: AppLocalization.of(context)!.nftPropertyNameHint,
                autocorrect: false,
                keyboardType: TextInputType.text,
                onChanged: (_) {
                  setState(() {});
                },
                style: AppStyles.textStyleSize16W600Primary(context),
                inputFormatters: <LengthLimitingTextInputFormatter>[
                  LengthLimitingTextInputFormatter(20),
                ],
                suffixButton: kIsWeb == false &&
                        (Platform.isIOS || Platform.isAndroid)
                    ? TextFieldButton(
                        icon: FontAwesomeIcons.qrcode,
                        onPressed: () async {
                          sl.get<HapticUtil>().feedback(FeedbackType.light,
                              StateContainer.of(context).activeVibrations);
                          UIUtil.cancelLockEvent();
                          final String? scanResult =
                              await UserDataUtil.getQRData(
                                  DataType.raw, context);
                          QRScanErrs.errorList;
                          if (scanResult == null) {
                            UIUtil.showSnackbar(
                                AppLocalization.of(context)!.qrInvalidAddress,
                                context,
                                StateContainer.of(context).curTheme.text!,
                                StateContainer.of(context)
                                    .curTheme
                                    .snackBarShadow!);
                          } else if (QRScanErrs.errorList
                              .contains(scanResult)) {
                            UIUtil.showSnackbar(
                                scanResult,
                                context,
                                StateContainer.of(context).curTheme.text!,
                                StateContainer.of(context)
                                    .curTheme
                                    .snackBarShadow!);
                            return;
                          } else {
                            setState(() {
                              nftPropertyNameController!.text = scanResult;
                            });
                          }
                        },
                      )
                    : null,
              ),
              AppTextField(
                focusNode: nftPropertyValueFocusNode,
                controller: nftPropertyValueController,
                cursorColor: StateContainer.of(context).curTheme.text,
                textInputAction: TextInputAction.next,
                labelText: AppLocalization.of(context)!.nftPropertyValueHint,
                autocorrect: false,
                keyboardType: TextInputType.text,
                onChanged: (_) {
                  setState(() {});
                },
                style: AppStyles.textStyleSize16W600Primary(context),
                inputFormatters: <LengthLimitingTextInputFormatter>[
                  LengthLimitingTextInputFormatter(20),
                ],
                suffixButton: kIsWeb == false &&
                        (Platform.isIOS || Platform.isAndroid)
                    ? TextFieldButton(
                        icon: FontAwesomeIcons.qrcode,
                        onPressed: () async {
                          sl.get<HapticUtil>().feedback(FeedbackType.light,
                              StateContainer.of(context).activeVibrations);
                          UIUtil.cancelLockEvent();
                          final String? scanResult =
                              await UserDataUtil.getQRData(
                                  DataType.raw, context);
                          QRScanErrs.errorList;
                          if (scanResult == null) {
                            UIUtil.showSnackbar(
                                AppLocalization.of(context)!.qrInvalidAddress,
                                context,
                                StateContainer.of(context).curTheme.text!,
                                StateContainer.of(context)
                                    .curTheme
                                    .snackBarShadow!);
                          } else if (QRScanErrs.errorList
                              .contains(scanResult)) {
                            UIUtil.showSnackbar(
                                scanResult,
                                context,
                                StateContainer.of(context).curTheme.text!,
                                StateContainer.of(context)
                                    .curTheme
                                    .snackBarShadow!);
                            return;
                          } else {
                            setState(() {
                              nftPropertyValueController!.text = scanResult;
                            });
                          }
                        },
                      )
                    : null,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(addNFTPropertyMessage,
                    textAlign: TextAlign.center,
                    style: AppStyles.textStyleSize12W100Primary(context)),
              ),
              Row(
                children: <Widget>[
                  nftPropertyNameController!.text.isNotEmpty &&
                          nftPropertyValueController!.text.isNotEmpty
                      ? AppButton.buildAppButtonTiny(
                          const Key('addNFTProperty'),
                          context,
                          AppButtonType.primary,
                          AppLocalization.of(context)!.addNFTProperty,
                          Dimens.buttonBottomDimens, onPressed: () async {
                          if (validateAddNFTProperty() == true) {
                            tokenPropertyWithAccessInfosList.sort(
                                (TokenPropertyWithAccessInfos a,
                                        TokenPropertyWithAccessInfos b) =>
                                    a.tokenProperty!.name!
                                        .toLowerCase()
                                        .compareTo(b.tokenProperty!.name!
                                            .toLowerCase()));

                            setState(() {
                              tokenPropertyWithAccessInfosList.add(
                                  TokenPropertyWithAccessInfos(
                                      tokenProperty: TokenProperty(
                                          name: nftPropertyNameController!.text,
                                          value: nftPropertyValueController!
                                              .text)));
                              nftPropertyNameController!.text = '';
                              nftPropertyValueController!.text = '';
                              FocusScope.of(context)
                                  .requestFocus(nftPropertyNameFocusNode);
                            });
                          }
                        })
                      : AppButton.buildAppButtonTiny(
                          const Key('addNFTProperty'),
                          context,
                          AppButtonType.primaryOutline,
                          AppLocalization.of(context)!.addNFTProperty,
                          Dimens.buttonBottomDimens,
                          onPressed: () {}),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: AppTextField(
                  controller: nftPropertySearchController,
                  autofocus: false,
                  maxLines: 1,
                  autocorrect: false,
                  labelText: AppLocalization.of(context)!.searchField,
                  keyboardType: TextInputType.text,
                  style: AppStyles.textStyleSize16W600Primary(context),
                  onChanged: (_) async {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Wrap(
                    alignment: WrapAlignment.start,
                    children: tokenPropertyWithAccessInfosList
                        .asMap()
                        .entries
                        .map((MapEntry<dynamic, TokenPropertyWithAccessInfos>
                            entry) {
                      return entry.value.tokenProperty!.name != 'file' &&
                              entry.value.tokenProperty!.name !=
                                  'description' &&
                              entry.value.tokenProperty!.name != 'name' &&
                              entry.value.tokenProperty!.name != 'type/mime' &&
                              (nftPropertySearchController!.text.isNotEmpty &&
                                      entry.value.tokenProperty!.name!
                                          .toLowerCase()
                                          .contains(nftPropertySearchController!
                                              .text
                                              .toLowerCase()) ||
                                  nftPropertySearchController!.text.isEmpty)
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: _buildTokenProperty(context, entry.value),
                            )
                          : const SizedBox();
                    }).toList()),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildTokenProperty(BuildContext context,
      TokenPropertyWithAccessInfos tokenPropertyWithAccessInfos) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () async {},
        onLongPress: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            side: tokenPropertyWithAccessInfos.publicKeysList != null &&
                    tokenPropertyWithAccessInfos.publicKeysList!.isNotEmpty
                ? const BorderSide(color: Colors.redAccent, width: 2.0)
                : BorderSide(
                    color: StateContainer.of(context)
                        .curTheme
                        .backgroundAccountsListCardSelected!,
                    width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          color: StateContainer.of(context)
              .curTheme
              .backgroundAccountsListCardSelected,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: AutoSizeText(
                                tokenPropertyWithAccessInfos
                                    .tokenProperty!.name!,
                                style: AppStyles.textStyleSize12W600Primary(
                                    context),
                              ),
                            ),
                            Container(
                              width: 200,
                              padding: const EdgeInsets.only(left: 20),
                              child: AutoSizeText(
                                tokenPropertyWithAccessInfos
                                    .tokenProperty!.value!,
                                style: AppStyles.textStyleSize12W400Primary(
                                    context),
                              ),
                            ),
                            tokenPropertyWithAccessInfos.publicKeysList !=
                                        null &&
                                    tokenPropertyWithAccessInfos
                                        .publicKeysList!.isNotEmpty
                                ? tokenPropertyWithAccessInfos
                                            .publicKeysList!.length ==
                                        1
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                180,
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: AutoSizeText(
                                          'This property is protected and accessible by ${tokenPropertyWithAccessInfos.publicKeysList!.length} public key',
                                          style: AppStyles
                                              .textStyleSize12W400Primary(
                                                  context),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                180,
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: AutoSizeText(
                                          'This property is protected and accessible by ${tokenPropertyWithAccessInfos.publicKeysList!.length} public keys',
                                          style: AppStyles
                                              .textStyleSize12W400Primary(
                                                  context),
                                        ),
                                      )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    padding: const EdgeInsets.only(left: 20),
                                    child: AutoSizeText(
                                      'This property is accessible by everyone',
                                      style:
                                          AppStyles.textStyleSize12W400Primary(
                                              context),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: StateContainer.of(context)
                              .curTheme
                              .backgroundDark!
                              .withOpacity(0.3),
                          border: Border.all(
                              color: StateContainer.of(context)
                                  .curTheme
                                  .backgroundDarkest!
                                  .withOpacity(0.2),
                              width: 2),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.key,
                              color: StateContainer.of(context)
                                  .curTheme
                                  .backgroundDarkest!,
                              size: 21),
                          onPressed: () {
                            sl.get<HapticUtil>().feedback(FeedbackType.light,
                                StateContainer.of(context).activeVibrations);
                            Sheets.showAppHeightNineSheet(
                                context: context,
                                widget: AddPublicKey(
                                  tokenPropertyWithAccessInfos:
                                      tokenPropertyWithAccessInfos,
                                  returnPublicKeys:
                                      (List<String> publicKeysList) {
                                    tokenPropertyWithAccessInfos
                                        .publicKeysList = publicKeysList;

                                    setState(() {});
                                  },
                                ));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: StateContainer.of(context)
                              .curTheme
                              .backgroundDark!
                              .withOpacity(0.3),
                          border: Border.all(
                              color: StateContainer.of(context)
                                  .curTheme
                                  .backgroundDarkest!
                                  .withOpacity(0.2),
                              width: 2),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color: StateContainer.of(context)
                                  .curTheme
                                  .backgroundDarkest!,
                              size: 21),
                          onPressed: () {
                            sl.get<HapticUtil>().feedback(FeedbackType.light,
                                StateContainer.of(context).activeVibrations);
                            AppDialogs.showConfirmDialog(
                                context,
                                'Delete property',
                                'Are you sure ?',
                                AppLocalization.of(context)!.deleteOption, () {
                              sl.get<HapticUtil>().feedback(FeedbackType.light,
                                  StateContainer.of(context).activeVibrations);

                              tokenPropertyWithAccessInfosList.removeWhere(
                                  (element) =>
                                      element.tokenProperty!.name ==
                                      tokenPropertyWithAccessInfos
                                          .tokenProperty!.name);
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmationTab(BuildContext context) {
    if (file != null && tabActiveIndex == 3) {
      return SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              feeEstimation > 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 0, left: 20, right: 20),
                      child: Text(
                        '${AppLocalization.of(context)!.estimatedFees}: $feeEstimation ${StateContainer.of(context).curNetwork.getNetworkCryptoCurrencyLabel()}',
                        style: AppStyles.textStyleSize12W100Primary(context),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 0, left: 20, right: 20),
                      child: Text(
                        AppLocalization.of(context)!.estimatedFeesAddNFTNote,
                        style: AppStyles.textStyleSize12W100Primary(context),
                        textAlign: TextAlign.justify,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        isPressed == true
                            ? AppButton.buildAppButton(
                                const Key('addNFTFile'),
                                context,
                                AppButtonType.primaryOutline,
                                AppLocalization.of(context)!.createNFT,
                                Dimens.buttonTopDimens,
                                onPressed: () async {},
                              )
                            : AppButton.buildAppButton(
                                const Key('addNFTFile'),
                                context,
                                AppButtonType.primary,
                                AppLocalization.of(context)!.createNFT,
                                Dimens.buttonTopDimens,
                                onPressed: () async {
                                  setState(() {
                                    isPressed = true;
                                  });

                                  updateToken();
                                  if (await validateAddNFT(context) == true) {
                                    AppDialogs.showConfirmDialog(
                                        context,
                                        AppLocalization.of(context)!.createNFT,
                                        AppLocalization.of(context)!
                                            .createNFTConfirmation,
                                        AppLocalization.of(context)!.yes,
                                        () async {
                                          setState(() {
                                            isPressed = false;
                                          });
                                          // Authenticate
                                          final Preferences preferences =
                                              await Preferences.getInstance();
                                          final AuthenticationMethod
                                              authMethod =
                                              preferences.getAuthMethod();
                                          bool auth =
                                              await AuthFactory.authenticate(
                                                  context, authMethod,
                                                  activeVibrations:
                                                      StateContainer.of(context)
                                                          .activeVibrations);
                                          if (auth) {
                                            EventTaxiImpl.singleton()
                                                .fire(AuthenticatedEvent());
                                          }
                                        },
                                        cancelText:
                                            AppLocalization.of(context)!.no,
                                        cancelAction: () {
                                          setState(() {
                                            isPressed = false;
                                          });
                                        });
                                  } else {
                                    setState(() {
                                      isPressed = false;
                                    });
                                  }
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              if (file != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 35, right: 35),
                  child: GestureDetector(
                    onTap: () async {},
                    onLongPress: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: tokenPropertyAsset!.publicKeysList != null &&
                                tokenPropertyAsset!.publicKeysList!.isNotEmpty
                            ? const BorderSide(
                                color: Colors.redAccent, width: 2.0)
                            : BorderSide(
                                color: StateContainer.of(context)
                                    .curTheme
                                    .backgroundAccountsListCardSelected!,
                                width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      color: StateContainer.of(context)
                          .curTheme
                          .backgroundAccountsListCardSelected,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: AutoSizeText(
                                            tokenPropertyAsset!
                                                .tokenProperty!.name!,
                                            style: AppStyles
                                                .textStyleSize12W600Primary(
                                                    context),
                                          ),
                                        ),
                                        tokenPropertyAsset!.publicKeysList !=
                                                    null &&
                                                tokenPropertyAsset!
                                                    .publicKeysList!.isNotEmpty
                                            ? tokenPropertyAsset!
                                                        .publicKeysList!
                                                        .length ==
                                                    1
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            180,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: AutoSizeText(
                                                      'This asset is protected and accessible by ${tokenPropertyAsset!.publicKeysList!.length} public key',
                                                      style: AppStyles
                                                          .textStyleSize12W400Primary(
                                                              context),
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            180,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: AutoSizeText(
                                                      'This asset is protected and accessible by ${tokenPropertyAsset!.publicKeysList!.length} public keys',
                                                      style: AppStyles
                                                          .textStyleSize12W400Primary(
                                                              context),
                                                    ),
                                                  )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    180,
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: AutoSizeText(
                                                  'This asset is accessible by everyone',
                                                  style: AppStyles
                                                      .textStyleSize12W400Primary(
                                                          context),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              NFTPreviewWidget(
                  nftPropertiesDeleteAction: false,
                  nftName: token.name,
                  context: context,
                  nftDescription: token.tokenProperties == null ||
                          token.tokenProperties![0].firstWhereOrNull(
                                  (element) => element.name == 'description') ==
                              null
                      ? null
                      : token.tokenProperties![0]
                          .firstWhere(
                              (element) => element.name == 'description')
                          .value!,
                  nftTypeMime: token.tokenProperties == null ||
                          token.tokenProperties![0].firstWhereOrNull(
                                  (element) => element.name == 'type/mime') ==
                              null
                      ? null
                      : token.tokenProperties![0]
                          .firstWhere((element) => element.name == 'type/mime')
                          .value!,
                  nftFile: fileDecodedForPreview,
                  nftSize: sizeFile,
                  tokenPropertyWithAccessInfos:
                      tokenPropertyWithAccessInfosList),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> setFileProperties(File file, {bool copyNFTName = false}) async {
    fileDecoded = File(file.path).readAsBytesSync();
    file64 = base64Encode(fileDecoded!);
    sizeFile = fileDecoded!.length;

    tokenPropertyWithAccessInfosList
        .removeWhere((element) => element.tokenProperty!.name == 'file');
    tokenPropertyWithAccessInfosList.add(TokenPropertyWithAccessInfos(
        tokenProperty: TokenProperty(name: 'file', value: file64)));

    try {
      typeMime = Mime.getTypesFromExtension(
          path.extension(file.path).replaceAll('.', ''))![0];

      tokenPropertyWithAccessInfosList
          .removeWhere((element) => element.tokenProperty!.name == 'type/mime');
      tokenPropertyWithAccessInfosList.add(TokenPropertyWithAccessInfos(
          tokenProperty: TokenProperty(name: 'type/mime', value: typeMime)));
    } catch (e) {}

    if (MimeUtil.isImage(typeMime) == true) {
      fileDecodedForPreview = fileDecoded;

      final data = await readExifFromBytes(fileDecoded!);

      for (final entry in data.entries) {
        tokenPropertyWithAccessInfosList.add(TokenPropertyWithAccessInfos(
            tokenProperty:
                TokenProperty(name: entry.key, value: entry.value.printable)));
        tokenPropertyWithAccessInfosList.sort(
            (TokenPropertyWithAccessInfos a, TokenPropertyWithAccessInfos b) =>
                a.tokenProperty!.name!
                    .toLowerCase()
                    .compareTo(b.tokenProperty!.name!.toLowerCase()));
      }
    } else {
      if (MimeUtil.isPdf(typeMime) == true) {
        PdfDocument pdfDocument = await PdfDocument.openData(
          File(file.path).readAsBytesSync(),
        );
        PdfPage pdfPage = await pdfDocument.getPage(1);

        PdfPageImage? pdfPageImage =
            await pdfPage.render(width: pdfPage.width, height: pdfPage.height);
        fileDecodedForPreview = pdfPageImage!.bytes;
      }
    }
    setState(() {});
  }

  bool validateAddNFTProperty() {
    bool isValid = true;
    setState(() {
      addNFTPropertyMessage = '';
    });

    if (nftPropertyNameController!.text.isEmpty) {
      setState(() {
        addNFTPropertyMessage = 'Le nom est obligatoire';
        isValid = false;
      });
    } else {
      if (nftPropertyValueController!.text.isEmpty) {
        setState(() {
          addNFTPropertyMessage = 'La valeur est obligatoire';
          isValid = false;
        });
      } else {
        for (TokenPropertyWithAccessInfos tokenPropertyWithAccessInfos
            in tokenPropertyWithAccessInfosList) {
          if (tokenPropertyWithAccessInfos.tokenProperty!.name ==
              nftPropertyNameController!.text) {
            setState(() {
              addNFTPropertyMessage = 'Le nom existe déjà';
              isValid = false;
            });
          }
        }
      }
    }

    return isValid;
  }

  void updateToken() {
    token = Token(
        name: nftNameController!.text,
        supply: 100000000,
        symbol: '',
        id: '1',
        type: 'non-fungible');
    token.tokenProperties = List<List<TokenProperty>>.empty(growable: true);
    List<TokenProperty> tokenProperties =
        List<TokenProperty>.empty(growable: true);
    for (TokenPropertyWithAccessInfos tokenPropertyWithAccessInfos
        in tokenPropertyWithAccessInfosList) {
      tokenProperties.add(tokenPropertyWithAccessInfos.tokenProperty!);
    }
    token.tokenProperties!.add(tokenProperties);
  }

  double getFee(BuildContext context) {
    double fee = 0;

    if (token.name!.isEmpty) {
      return fee;
    }
    try {
      final String originPrivateKey = sl.get<ApiService>().getOriginKey();
      StateContainer.of(context).getSeed().then((String? seed) {
        sl
            .get<AppService>()
            .getFeesEstimationCreateToken(
                originPrivateKey,
                seed!,
                token,
                StateContainer.of(context)
                    .appWallet!
                    .appKeychain!
                    .getAccountSelected()!
                    .name!)
            .then((value) {
          setState(() {
            fee = value;
          });
        });
      });
    } catch (e) {
      fee = 0;
    }
    return fee;
  }

  Future<bool> validateAddNFT(BuildContext context) async {
    bool isValid = true;
    setState(() {
      addNFTMessage = '';
    });

    if (file == null) {
      setState(() {
        addNFTMessage = 'Veuillez importer un fichier ou une photo.';
        isValid = false;
      });
    } else {
      if (nftNameController!.text.isEmpty) {
        setState(() {
          addNFTMessage = 'Le nom du NFT est obligatoire.';
          isValid = false;
        });
      } else {
        if (MimeUtil.isImage(typeMime) == false &&
            MimeUtil.isPdf(typeMime) == false) {
          setState(() {
            addNFTMessage = 'Le format n\'est pas pris en charge.';
            isValid = false;
          });
        } else {
          if (file64.length > 2500000) {
            setState(() {
              addNFTMessage = 'Le NFT ne peut excéder 2.5 Mo.';
              isValid = false;
            });
          } else {
            // Estimation of fees
            //feeEstimation = await getFee(context);
            if (feeEstimation >
                StateContainer.of(context)
                    .appWallet!
                    .appKeychain!
                    .getAccountSelected()!
                    .balance!
                    .nativeTokenValue!) {
              isValid = false;
              setState(() {
                addNFTMessage = AppLocalization.of(context)!
                    .insufficientBalance
                    .replaceAll(
                        '%1',
                        StateContainer.of(context)
                            .curNetwork
                            .getNetworkCryptoCurrencyLabel());
              });
            }
          }
        }
      }
    }

    return isValid;
  }

  Future<void> _doAdd() async {
    try {
      _showSendingAnimation(context);
      final String? seed = await StateContainer.of(context).getSeed();
      final String originPrivateKey = sl.get<ApiService>().getOriginKey();
      final Keychain keychain = await sl.get<ApiService>().getKeychain(seed!);
      String nameEncoded = Uri.encodeFull(StateContainer.of(context)
          .appWallet!
          .appKeychain!
          .getAccountSelected()!
          .name!);
      final String service = 'archethic-wallet-$nameEncoded';
      final int index = (await sl.get<ApiService>().getTransactionIndex(
              uint8ListToHex(keychain.deriveAddress(service, index: 0))))
          .chainLength!;

      final Transaction transaction =
          Transaction(type: 'token', data: Transaction.initData());
      String content = tokenToJsonForTxDataContent(Token(
          name: token.name,
          supply: token.supply,
          type: token.type,
          symbol: token.symbol,
          tokenProperties: token.tokenProperties));
      transaction.setContent(content);
      Transaction signedTx = keychain
          .buildTransaction(transaction, service, index)
          .originSign(originPrivateKey);

      TransactionStatus transactionStatus = TransactionStatus();

      final Preferences preferences = await Preferences.getInstance();
      await subscriptionChannel.connect(
          await preferences.getNetwork().getPhoenixHttpLink(),
          await preferences.getNetwork().getWebsocketUri());

      void waitConfirmationsNFT(QueryResult event) {
        waitConfirmations(event, transactionAddress: signedTx.address);
      }

      subscriptionChannel.addSubscriptionTransactionConfirmed(
          transaction.address!, waitConfirmationsNFT);

      transactionStatus = await sl.get<ApiService>().sendTx(signedTx);

      if (transactionStatus.status == 'invalid') {
        EventTaxiImpl.singleton().fire(TransactionSendEvent(
            transactionType: TransactionSendEventType.token,
            response: '',
            nbConfirmations: 0));
        subscriptionChannel.close();
      }
    } catch (e) {
      EventTaxiImpl.singleton().fire(TransactionSendEvent(
          transactionType: TransactionSendEventType.token,
          response: e.toString(),
          nbConfirmations: 0));
      subscriptionChannel.close();
    }
  }

  void waitConfirmations(QueryResult event, {String? transactionAddress}) {
    int nbConfirmations = 0;
    int maxConfirmations = 0;
    if (event.data != null && event.data!['transactionConfirmed'] != null) {
      if (event.data!['transactionConfirmed']['nbConfirmations'] != null) {
        nbConfirmations =
            event.data!['transactionConfirmed']['nbConfirmations'];
      }
      if (event.data!['transactionConfirmed']['maxConfirmations'] != null) {
        maxConfirmations =
            event.data!['transactionConfirmed']['maxConfirmations'];
      }
      EventTaxiImpl.singleton().fire(TransactionSendEvent(
          transactionType: TransactionSendEventType.token,
          response: 'ok',
          transactionAddress: transactionAddress,
          nbConfirmations: nbConfirmations,
          maxConfirmations: maxConfirmations));
    } else {
      EventTaxiImpl.singleton().fire(
        TransactionSendEvent(
            transactionType: TransactionSendEventType.token,
            nbConfirmations: 0,
            maxConfirmations: 0,
            response: 'ko'),
      );
    }
    subscriptionChannel.close();
  }
}
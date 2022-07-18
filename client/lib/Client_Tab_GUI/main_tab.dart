import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/connection.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_bottom_bar.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:natour21/Client_Tab_GUI/search_tab.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Accessory_Class/web_socket.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Account_GUI/my_profile_gui.dart';
import '../Entity_Class/fire_base_user.dart';
import 'about_gui.dart';
import 'chats_tab.dart';
import 'home_tab.dart';
import 'my_itinerary_tab.dart';

class MainTab extends StatefulWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final ValueNotifier<int> _selectedItemPosition = ValueNotifier<int>(0);
  final _advancedDrawerController = AdvancedDrawerController();
  final Connection _connectivity = Connection.instance;
  final _streamController = WebSocketPostgres().streamController;

  PageController? _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: _selectedItemPosition.value);
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AdvancedDrawer(
      backdropColor: mainColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(
            Radius.circular(SizeConfig().borderRadiusFourteen * 1.5)),
      ),
      child: GestureDetector(
        onTap: () => _handleMenuButtonPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: context.watch<Elevation>().elevation,
            title: CustomBounce(
                duration: const Duration(milliseconds: 100),
                onPressed: () {
                  _handleMenuButtonPressed();
                },
                child: Container(
                  padding: EdgeInsets.only(
                      right: SizeConfig().paddingTwelve,
                      top: SizeConfig().paddingFive,
                      bottom: SizeConfig().paddingFive),
                  color: Colors.white,
                  child: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          value.visible ? Icons.clear : Ionicons.grid_outline,
                          color: mainColor,
                          size: SizeConfig().iconSize,
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    },
                  ),
                )),
            actions: [
              CustomBounce(
                duration: const Duration(milliseconds: 100),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyProfilePage(),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(
                      left: SizeConfig().paddingTwelve,
                      right: SizeConfig().paddingTwelve * 1.1,
                      top: SizeConfig().paddingFive,
                      bottom: SizeConfig().paddingFive),
                  child: Container(
                      height: 29,
                      width: 29,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: Global().myUser,
                        builder: (BuildContext context, FireBaseUser value,
                            Widget? child) {
                          return CachedNetworkImage(
                            fadeOutDuration: const Duration(milliseconds: 1),
                            fadeInDuration: const Duration(milliseconds: 1),
                            imageUrl: value.avatar!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _selectedItemPosition,
              builder: (BuildContext context, int value, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: CustomBottomBar(
                    borderRadius: SizeConfig().paddingThirty,
                    itemPadding: EdgeInsets.symmetric(
                        vertical: SizeConfig().paddingFive,
                        horizontal: SizeConfig().paddingTwenty),
                    curve: Curves.easeOutCirc,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withAlpha(40),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    currentIndex: _selectedItemPosition.value,
                    dotIndicatorColor: Colors.transparent,
                    marginR: EdgeInsets.symmetric(
                      horizontal: SizeConfig().paddingThirty * 2,
                      vertical: SizeConfig().paddingTwenty,
                    ),
                    unselectedItemColor: Colors.grey[300],
                    selectedItemColor: mainColor,
                    onTap: (index) {
                      _handleIndexChanged(index);
                    },
                    items: [
                      SingleItem(
                        icon: Icon(Ionicons.home_outline,
                            size: SizeConfig().iconSize),
                      ),
                      SingleItem(
                        icon: Icon(Ionicons.search_outline,
                            size: SizeConfig().iconSize),
                      ),
                      SingleItem(
                        icon: Icon(Ionicons.leaf_outline,
                            size: SizeConfig().iconSize),
                      ),
                      SingleItem(
                        icon: Icon(Ionicons.chatbubbles_outline,
                            size: SizeConfig().iconSize),
                      ),
                    ],
                  ),
                );
              }),
          body: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: _onPageChanged,
            children: const <Widget>[
              HomeTab(),
              SearchTab(),
              MyItineraryTab(),
              ChatsTab(),
            ],
          ),
        ),
      ),
      drawer: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig().paddingFive / 1.5),
              decoration: BoxDecoration(color: white, shape: BoxShape.circle),
              child: _buildAvatar(SizeConfig().paddingThirty * 3,
                  SizeConfig().paddingThirty * 3),
            ),
            SizedBox(
              height: SizeConfig().paddingThirty * 1.2,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig().paddingThirty * 2.5,
                  right: SizeConfig().paddingThirty * 2.5),
              child: CustomBounce(
                duration: const Duration(milliseconds: 100),
                onPressed: () {
                  _advancedDrawerController.hideDrawer();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyProfilePage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig().paddingFive * 1.4,
                    bottom: SizeConfig().paddingFive * 1.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        SizeConfig().borderRadiusFourteen),
                    color: white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.person_outline,
                        color: mainColor,
                        size: SizeConfig().iconSize,
                      ),
                      SizedBox(
                        width: SizeConfig().paddingFive,
                      ),
                      Text(
                        'Account',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h3FontSize),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig().paddingTwenty,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig().paddingThirty * 2.5,
                  right: SizeConfig().paddingThirty * 2.5),
              child: CustomBounce(
                duration: const Duration(milliseconds: 100),
                onPressed: () async {
                  _advancedDrawerController.hideDrawer();
                  await _send();
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig().paddingFive * 1.4,
                    bottom: SizeConfig().paddingFive * 1.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        SizeConfig().borderRadiusFourteen),
                    color: white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.mail_outline,
                        color: mainColor,
                        size: SizeConfig().iconSize,
                      ),
                      SizedBox(
                        width: SizeConfig().paddingFive,
                      ),
                      Text(
                        'Contatta',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h3FontSize),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig().paddingTwenty,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig().paddingThirty * 2.5,
                  right: SizeConfig().paddingThirty * 2.5),
              child: CustomBounce(
                duration: const Duration(milliseconds: 100),
                onPressed: () {
                  _advancedDrawerController.hideDrawer();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig().paddingFive * 1.4,
                    bottom: SizeConfig().paddingFive * 1.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        SizeConfig().borderRadiusFourteen),
                    color: white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.information_circle_outline,
                        color: mainColor,
                        size: SizeConfig().iconSize,
                      ),
                      SizedBox(
                        width: SizeConfig().paddingFive,
                      ),
                      Text(
                        'Info',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h3FontSize),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig().paddingTwenty,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig().paddingThirty * 2.5,
                  right: SizeConfig().paddingThirty * 2.5),
              child: CustomBounce(
                duration: const Duration(milliseconds: 100),
                onPressed: () {
                  _advancedDrawerController.hideDrawer();
                  _logoutDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig().paddingFive * 1.4,
                    bottom: SizeConfig().paddingFive * 1.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        SizeConfig().borderRadiusFourteen),
                    color: white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.exit_outline,
                        color: mainColor,
                        size: SizeConfig().iconSize,
                      ),
                      SizedBox(
                        width: SizeConfig().paddingFive,
                      ),
                      Text(
                        'Esci',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h3FontSize),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig().paddingThirty * 1.2,
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: SizeConfig().h4FontSize,
                color: Colors.white54,
              ),
              child: Column(
                children: [
                  const Text('© Copyright NaTour21'),
                  SizedBox(
                    height: SizeConfig().paddingTwelve / 1.5,
                  ),
                  const Text('Versione: 1.1.2 Beta'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void _handleIndexChanged(int index) {
    _selectedItemPosition.value = index;
    _controller!.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    context.read<Elevation>().decrement();
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _send() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'natour21@besimsoft.com',
      query: encodeQueryParameters(
          <String, String>{'subject': 'Inserisci il testo'}),
    );

    launch(emailLaunchUri.toString());

    if (!mounted) return;
  }

  void _onPageChanged(int page) {
    switch (page) {
      case 0:
        _selectedItemPosition.value = page;
        break;
      case 1:
        _selectedItemPosition.value = page;
        break;
      case 2:
        _selectedItemPosition.value = page;
        break;
      case 3:
        _selectedItemPosition.value = page;
        break;
    }
  }

  Widget _buildAvatar(double height, double width) {
    return Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Colors.transparent),
        child: CachedNetworkImage(
          fadeOutDuration: const Duration(milliseconds: 1),
          fadeInDuration: const Duration(milliseconds: 1),
          imageUrl: Global().myUser.value.avatar!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
              ),
            ),
          ),
        ));
  }

  void _logoutDialog(context) async {
    CustomAlertDialog(
        title: 'Esci',
        body: 'Sei sicuro di voler uscire dal tuo account?',
        titleConfirmButton: 'No',
        titleDeclineButton: 'Si',
        declineButton: true,
        onPressDecline: () async {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/login_page');
          if (await UserController().logOutUser(context, null)) {
            await Global().storage.write(key: 'email', value: '');
            await Global().storage.write(key: 'password', value: '');
            await Global().storage.write(key: 'tokenFacebook', value: '');
            await Global().storage.write(key: 'accessToken', value: '');
            await Global().storage.write(key: 'idToken', value: '');
          }
        },
        onPressConfirm: () {
          Navigator.of(context).pop();
        }).showCustomDialog(context);
  }
}

class Elevation with ChangeNotifier, DiagnosticableTreeMixin {
  double _elevation = 0;

  double get elevation => _elevation;

  void increment() {
    _elevation = 0.5;
    notifyListeners();
  }

  void decrement() {
    _elevation = 0;
    notifyListeners();
  }
}

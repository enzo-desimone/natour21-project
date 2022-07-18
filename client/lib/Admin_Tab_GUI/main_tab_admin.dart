import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/connection.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Admin_Tab_GUI/admin_home_tab.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Accessory_Class/global_variable.dart';
import '../Accessory_Class/web_socket.dart';
import '../Accessory_GUI/boucing_animation.dart';

class MainTabAdmin extends StatefulWidget {
  const MainTabAdmin({Key? key}) : super(key: key);

  @override
  _MainTabAdminState createState() => _MainTabAdminState();
}

class _MainTabAdminState extends State<MainTabAdmin> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Connection _connectivity = Connection.instance;
  final _streamController = WebSocketPostgres().streamController;

  @override
  void initState() {
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
              elevation: context.watch<ElevationAdmin>().elevation,
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
            ),
            body: const AdminHomeTab()),
      ),
      drawer: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/first.png',
              width: SizeConfig().paddingThirty * 4.2,
              height: SizeConfig().paddingThirty * 4.2,
              color: white,
            ),
            SizedBox(
              height: SizeConfig().paddingFifteen,
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
            SizedBox(
              height: SizeConfig().paddingTwenty,
            ),
            Opacity(
              opacity: 0,
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig().paddingThirty * 2.5,
                    right: SizeConfig().paddingThirty * 2.5),
                child: CustomBounce(
                  duration: const Duration(milliseconds: 100),
                  onPressed: () {},
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
          if (await UserController().logOutUser(context, 'aws.com')) {
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

class ElevationAdmin with ChangeNotifier, DiagnosticableTreeMixin {
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Accessory_Class/global_variable.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/custom_dialog.dart';
import '../Accessory_GUI/custom_nack_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  final WebViewController _controllerOne = WebViewController()
    ..loadRequest(Uri.parse('https://natour21.besimsoft.com/terms.html'));
  final WebViewController _controllerTwo = WebViewController()
    ..loadRequest(Uri.parse('https://natour21.besimsoft.com/privacy.html'));

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomBounce(
              duration: const Duration(milliseconds: 100),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(
                      right: SizeConfig().paddingTwelve,
                      top: SizeConfig().paddingFive,
                      bottom: SizeConfig().paddingFive),
                  child: Icon(
                    Ionicons.arrow_back_outline,
                    color: black,
                    size: SizeConfig().iconSize,
                  )),
            ),
            SizedBox(
              width: SizeConfig().paddingFive,
            ),
            Text(
              'Info',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig().h2FontSize,
                  color: black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig().paddingFive,
          ),
          GestureDetector(
            onDoubleTap: () async {
              CustomAlertDialog.loadingScreen(context, null);

              int randomLog = 3 + Random().nextInt(11 - 3);

              int time = randomLog;

              var list = List<int>.generate(9, (int index) => index);
              list.shuffle();

              for (int i = 0; i < randomLog; i++) {
                int randomEventTime = 2 + Random().nextInt(8 - 3);
                time += randomEventTime;
                for (int j = 0; j < randomEventTime; j++) {
                  switch (list[i]) {
                    case 0:
                      await Global.analytics.logEvent(
                        name: 'export_gpx_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;
                    case 1:
                      await Global.analytics.logEvent(
                        name: 'export_gpx_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 2:
                      await Global.analytics.logEvent(
                        name: 'export_itinerary_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 3:
                      await Global.analytics.logEvent(
                        name: 'add_itinerary_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 4:
                      await Global.analytics.logEvent(
                        name: 'edit_itinerary_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 5:
                      await Global.analytics.logEvent(
                        name: 'edit_interest_point_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 6:
                      await Global.analytics.logEvent(
                        name: 'search_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 7:
                      await Global.analytics.logEvent(
                        name: 'request_itinerary_info_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;

                    case 8:
                      await Global.analytics.logEvent(
                        name: 'edit_profile_event',
                        parameters: <String, dynamic>{
                          'user': Global().myUser.value.id,
                        },
                      );
                      break;
                  }
                }
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      title: 'eventi selezionati: ' +
                          randomLog.toString() +
                          ' eventi inviati: ' +
                          time.toString())
                  .showSnackBar());
            },
            child: Center(
              child: Image.asset(
                'assets/images/first.png',
                height: SizeConfig().paddingThirty * 4.7,
                width: SizeConfig().paddingThirty * 4.7,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NaTour',
                style: TextStyle(
                    color: black,
                    fontSize: SizeConfig().h1FontSize * 1.1,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '21',
                style: TextStyle(
                    color: mainColor,
                    fontSize: SizeConfig().h1FontSize * 1.1,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig().paddingThirty,
          ),
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig().paddingFive * 2,
                right: SizeConfig().paddingFive * 2),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(100),
                      topRight: Radius.circular(
                          SizeConfig().borderRadiusFourteen * 2),
                      bottomLeft: const Radius.circular(100),
                      bottomRight: Radius.circular(
                          SizeConfig().borderRadiusFourteen * 5))),
              color: Colors.grey.withAlpha(120),
              elevation: 0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            right: SizeConfig().paddingFive * 2),
                        child: Container(
                          padding: EdgeInsets.all(SizeConfig().paddingFive / 3),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            color: Colors.white38,
                          ),
                          child: Image.asset(
                            "assets/images/avatar.png",
                            height: SizeConfig().paddingTwenty * 4,
                            width: SizeConfig().paddingTwenty * 4,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(top: SizeConfig().paddingFive * 2),
                        child: Text(
                          "Enzo De Simone",
                          style: TextStyle(
                              fontSize: SizeConfig().h2FontSize * 1.15,
                              fontWeight: FontWeight.w500,
                              color: black),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            right: SizeConfig().paddingFive * 2,
                            left: SizeConfig().paddingFive * 2,
                            top: SizeConfig().paddingFive / 1.5,
                            bottom: SizeConfig().paddingFive / 1.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig().borderRadiusFourteen * 2.5),
                            bottomRight: Radius.circular(
                                SizeConfig().borderRadiusFourteen * 2),
                          ),
                          color: Colors.white38,
                        ),
                        child: Row(
                          children: [
                            CustomBounce(
                              duration: const Duration(milliseconds: 100),
                              onPressed: () async {
                                await launch(
                                    'https://instagram.com/enzode.simone');
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: SizeConfig().paddingFive),
                                      ),
                                      Icon(
                                        Ionicons.logo_instagram,
                                        color: mainColor,
                                      ),
                                      SizedBox(width: SizeConfig().paddingFive),
                                      Text(
                                        'Instagram',
                                        style: TextStyle(
                                            fontSize: SizeConfig().h3FontSize,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(width: SizeConfig().sizeTwenty),
                            CustomBounce(
                              duration: const Duration(milliseconds: 100),
                              onPressed: () async {
                                await launch(
                                    'https://github.com/enzo-desimone');
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.logo_github,
                                        color: mainColor,
                                      ),
                                      SizedBox(width: SizeConfig().paddingFive),
                                      Text('Github',
                                          style: TextStyle(
                                            fontSize: SizeConfig().h3FontSize,
                                            color: Colors.black54,
                                          )),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig().paddingTwenty,
          ),
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig().paddingFive * 2,
                right: SizeConfig().paddingFive * 2),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(100),
                      topRight: Radius.circular(
                          SizeConfig().borderRadiusFourteen * 2),
                      bottomLeft: const Radius.circular(100),
                      bottomRight: Radius.circular(
                          SizeConfig().borderRadiusFourteen * 5))),
              color: Colors.grey.withAlpha(120),
              elevation: 0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            right: SizeConfig().paddingFive * 2),
                        child: Container(
                          padding: EdgeInsets.all(SizeConfig().paddingFive / 3),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            color: Colors.white38,
                          ),
                          child: Image.asset(
                            "assets/images/avatar-01.png",
                            height: SizeConfig().paddingTwenty * 4,
                            width: SizeConfig().paddingTwenty * 4,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(top: SizeConfig().paddingFive * 2),
                        child: Text(
                          "Crescenzo Di Vano",
                          style: TextStyle(
                              fontSize: SizeConfig().h2FontSize * 1.15,
                              fontWeight: FontWeight.w500,
                              color: black),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            right: SizeConfig().paddingFive * 2,
                            left: SizeConfig().paddingFive * 2,
                            top: SizeConfig().paddingFive / 1.5,
                            bottom: SizeConfig().paddingFive / 1.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig().borderRadiusFourteen * 2.5),
                            bottomRight: Radius.circular(
                                SizeConfig().borderRadiusFourteen * 2),
                          ),
                          color: Colors.white38,
                        ),
                        child: Row(
                          children: [
                            CustomBounce(
                              duration: const Duration(milliseconds: 100),
                              onPressed: () async {
                                await launch(
                                    'https://instagram.com/crescenzo.01');
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: SizeConfig().paddingFive),
                                      ),
                                      Icon(
                                        Ionicons.logo_instagram,
                                        color: mainColor,
                                      ),
                                      SizedBox(width: SizeConfig().paddingFive),
                                      Text(
                                        'Instagram',
                                        style: TextStyle(
                                            fontSize: SizeConfig().h3FontSize,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(width: SizeConfig().sizeTwenty),
                            CustomBounce(
                              duration: const Duration(milliseconds: 100),
                              onPressed: () async {
                                await launch('https://github.com/crescenzo01');
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.logo_github,
                                        color: mainColor,
                                      ),
                                      SizedBox(width: SizeConfig().paddingFive),
                                      Text('Github',
                                          style: TextStyle(
                                            fontSize: SizeConfig().h3FontSize,
                                            color: Colors.black54,
                                          )),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig().paddingThirty,
          ),
          CustomBounce(
            duration: const Duration(milliseconds: 100),
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusFourteen),
              ),
              enableDrag: false,
              builder: (ctx) => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig().borderRadiusFourteen),
                            topRight: Radius.circular(
                                SizeConfig().borderRadiusFourteen)),
                        color: mainColor),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Termini & Condizioni',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig().lostCheckText,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomBounce(
                                duration: const Duration(milliseconds: 100),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Ionicons.close_outline,
                                  size: SizeConfig().iconSize,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: WebViewWidget(
                      controller: _controllerOne,
                    ),
                  ),
                ],
              ),
            ),
            child: Text(
              'Termini & Condizioni',
              style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig().h2FontSize),
            ),
          ),
          SizedBox(
            height: SizeConfig().paddingFifteen,
          ),
          CustomBounce(
            duration: const Duration(milliseconds: 100),
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusFourteen),
              ),
              enableDrag: false,
              builder: (ctx) => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig().borderRadiusFourteen),
                            topRight: Radius.circular(
                                SizeConfig().borderRadiusFourteen)),
                        color: mainColor),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Privacy & Policy',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig().lostCheckText,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomBounce(
                                duration: const Duration(milliseconds: 100),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Ionicons.close_outline,
                                  size: SizeConfig().iconSize,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: WebViewWidget(
                      controller: _controllerTwo,
                    ),
                  ),
                ],
              ),
            ),
            child: Text(
              'Privacy & Policy',
              style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig().h2FontSize),
            ),
          ),
        ],
      ),
    );
  }
}

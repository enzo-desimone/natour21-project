import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/boucing_animation.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Admin_Tab_GUI/client_list_page.dart';
import 'package:natour21/Controller/itinerary_controller.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:natour21/Entity_Class/itinerary.dart';
import 'package:natour21/Entity_Class/search_statistics.dart';
import 'package:provider/provider.dart';

import '../Entity_Class/review.dart';
import 'main_tab_admin.dart';

class AdminHomeTab extends StatefulWidget {
  const AdminHomeTab({Key? key}) : super(key: key);

  @override
  _AdminHomeTabState createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  late Timer _timer;

  final ValueNotifier<double> _fireBaseOpacity = ValueNotifier(0);
  final ValueNotifier<double> _facebookOpacity = ValueNotifier(0);
  final ValueNotifier<double> _googleOpacity = ValueNotifier(0);

  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  bool _isShowFireBase = false;
  bool _isShowFacebook = false;
  bool _isShowGoogle = false;

  @override
  void initState() {
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      var _currentScrollPosition = _scrollViewController.position.pixels;
      if (_currentScrollPosition > 0) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          context.read<ElevationAdmin>().increment();
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});
        }
      } else {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          context.read<ElevationAdmin>().decrement();
          setState(() {});
        }
      }
    });
    _init();
    super.initState();
  }

  _init() async {
    _timer =
        Timer.periodic(const Duration(milliseconds: 1500), (Timer t) async {
      await _changeOpacity(_isShowFireBase, 'firebase');
      await _changeOpacity(_isShowFacebook, 'facebook');
      await _changeOpacity(_isShowGoogle, 'google');
    });
    Global().homeItinerary.value = Global().allItinerary.value;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          controller: _scrollViewController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig().paddingTwelve,
                    left: SizeConfig().paddingFifteen,
                    right: SizeConfig().paddingFifteen),
                child: AnimatedContainer(
                  height: _showAppbar ? SizeConfig().paddingTwenty * 2 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Row(
                    children: [
                      Text(
                        'Bentornato,',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: black,
                            fontSize: SizeConfig().h1FontSize / 1.5),
                      ),
                      SizedBox(
                        width: SizeConfig().paddingFive / 1.5,
                      ),
                      Text(
                        Global().myAdmin.firstName!.capitalizeFirstOfEach,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: black,
                            fontSize: SizeConfig().h1FontSize / 1.5),
                      )
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                height: _showAppbar ? SizeConfig().paddingThirty : 0.0,
                duration: const Duration(milliseconds: 250),
                child: SizedBox(
                  height: SizeConfig().paddingThirty,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig().paddingFifteen,
                    right: SizeConfig().paddingFifteen),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Utenti Registrati',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: black,
                              fontSize: SizeConfig().h2FontSize,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig().paddingFive * 3,
                    ),
                    StreamBuilder<List<FireBaseUser>>(
                        stream: UserController().getUserList(),
                        builder: (context, snapshot) {
                          int _firebase = 0;
                          int _facebook = 0;
                          int _google = 0;

                          if (snapshot.hasData) {
                            _firebase = snapshot.data!
                                .where((element) => (element.avatar!
                                    .contains('firebasestorage')))
                                .toList()
                                .length;
                            _facebook = snapshot.data!
                                .where((element) =>
                                    (element.avatar!.contains('platform')))
                                .toList()
                                .length;
                            _google = snapshot.data!
                                .where((element) => (element.avatar!
                                    .contains('googleusercontent')))
                                .toList()
                                .length;
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ZoomInLeft(
                                child: CustomBounce(
                                  duration: const Duration(milliseconds: 100),
                                  onPressed: () {
                                    if (_firebase > 0) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (_) {
                                        return const ClientListPage(
                                            provider: 'firebasestorage');
                                      }));
                                    }
                                  },
                                  child: Container(
                                    width: SizeConfig().paddingThirty * 3.8,
                                    padding: EdgeInsets.only(
                                        left: SizeConfig().paddingFive * 2,
                                        right: SizeConfig().paddingFive * 2,
                                        top: SizeConfig().paddingFive * 2,
                                        bottom: SizeConfig().paddingFive * 1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[400],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(SizeConfig()
                                              .borderRadiusFourteen)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/firebase_logo.png',
                                          width:
                                              SizeConfig().paddingFifteen * 3.2,
                                          height:
                                              SizeConfig().paddingFifteen * 3.2,
                                          color: Colors.white,
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: _fireBaseOpacity,
                                          builder: (BuildContext context,
                                              double value, Widget? child) {
                                            return AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              opacity: value < 1 ? 0 : 1,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    SizeConfig().paddingFive *
                                                        1.72),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.orange[400]),
                                                child: Text(
                                                  _firebase.toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: SizeConfig()
                                                          .h2FontSize),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ZoomIn(
                                child: CustomBounce(
                                  duration: const Duration(milliseconds: 100),
                                  onPressed: () {
                                    if (_facebook > 0) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (_) {
                                        return const ClientListPage(
                                            provider: 'platform');
                                      }));
                                    }
                                  },
                                  child: Container(
                                    width: SizeConfig().paddingThirty * 3.8,
                                    padding: EdgeInsets.only(
                                        left: SizeConfig().paddingFive * 2,
                                        right: SizeConfig().paddingFive * 2,
                                        top: SizeConfig().paddingFive * 2,
                                        bottom: SizeConfig().paddingFive * 1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(SizeConfig()
                                              .borderRadiusFourteen)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/facebook_logo.png',
                                          width:
                                              SizeConfig().paddingFifteen * 3.2,
                                          height:
                                              SizeConfig().paddingFifteen * 3.2,
                                          color: Colors.white,
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: _facebookOpacity,
                                          builder: (BuildContext context,
                                              double value, Widget? child) {
                                            return AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              opacity: value < 1 ? 0 : 1,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    SizeConfig().paddingFive *
                                                        1.5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue[400]),
                                                child: Text(
                                                  _facebook.toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: SizeConfig()
                                                          .h2FontSize),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ZoomInRight(
                                child: CustomBounce(
                                  duration: const Duration(milliseconds: 100),
                                  onPressed: () {
                                    if (_google > 0) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (_) {
                                        return const ClientListPage(
                                            provider: 'googleusercontent');
                                      }));
                                    }
                                  },
                                  child: Container(
                                    width: SizeConfig().paddingThirty * 3.8,
                                    padding: EdgeInsets.only(
                                        left: SizeConfig().paddingFive * 2,
                                        right: SizeConfig().paddingFive * 2,
                                        top: SizeConfig().paddingFive * 2,
                                        bottom: SizeConfig().paddingFive * 1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.red[400],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(SizeConfig()
                                              .borderRadiusFourteen)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google_logo.png',
                                          width:
                                              SizeConfig().paddingFifteen * 3.2,
                                          height:
                                              SizeConfig().paddingFifteen * 3.2,
                                          color: Colors.white,
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: _googleOpacity,
                                          builder: (BuildContext context,
                                              double value, Widget? child) {
                                            return AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              opacity: value < 1 ? 0 : 1,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    SizeConfig().paddingFive *
                                                        1.5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red[400]),
                                                child: Text(
                                                  _google.toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: SizeConfig()
                                                          .h2FontSize),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig().paddingThirty,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig().paddingFifteen,
                    right: SizeConfig().paddingFifteen),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Itinerari Registrati',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: black,
                              fontSize: SizeConfig().h2FontSize,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig().paddingFive * 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            UserController().getUserList();
                          },
                          child: BounceInLeft(
                            child: Card(
                              elevation: 2.5,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig().borderRadiusFourteen * 1.2),
                              ),
                              child: SizedBox(
                                width: SizeConfig().paddingTwentyFive * 4.6,
                                height: SizeConfig().paddingTwentyFive * 8,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig().borderRadiusFourteen *
                                                1.2),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/category/m/m_4.png'),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        context
                                            .watch<ItineraryCategory>()
                                            .mItinerary
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            shadows: const <Shadow>[
                                              Shadow(
                                                offset: Offset(0, 0),
                                                blurRadius: 10,
                                                color: Colors.black45,
                                              ),
                                            ],
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                SizeConfig().h1FontSize / 1.4),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        BounceIn(
                          child: Card(
                            elevation: 2.5,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusFourteen * 1.2),
                            ),
                            child: SizedBox(
                              width: SizeConfig().paddingTwentyFive * 4.6,
                              height: SizeConfig().paddingTwentyFive * 8,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig().borderRadiusFourteen *
                                              1.2),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/category/c/c_1.png'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      context
                                          .watch<ItineraryCategory>()
                                          .cItinerary
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          shadows: const <Shadow>[
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 10,
                                              color: Colors.black45,
                                            ),
                                          ],
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              SizeConfig().h1FontSize / 1.4),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        BounceInRight(
                          child: Card(
                            elevation: 2.5,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusFourteen * 1.2),
                            ),
                            child: SizedBox(
                              width: SizeConfig().paddingTwentyFive * 4.6,
                              height: SizeConfig().paddingTwentyFive * 8,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig().borderRadiusFourteen *
                                              1.2),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/category/p/p_3.png'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      context
                                          .watch<ItineraryCategory>()
                                          .pItinerary
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          shadows: const <Shadow>[
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 10,
                                              color: Colors.black45,
                                            ),
                                          ],
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              SizeConfig().h1FontSize / 1.4),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig().paddingThirty,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig().paddingFifteen,
                    right: SizeConfig().paddingFifteen),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recensioni',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: black,
                              fontSize: SizeConfig().h2FontSize,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Itinerari',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: black,
                              fontSize: SizeConfig().h2FontSize,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig().paddingFive * 3.5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LightSpeedIn(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 2,
                              right: SizeConfig().paddingFive * 2,
                              top: SizeConfig().paddingFive * 1.2,
                              bottom: SizeConfig().paddingFive * 1.2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig().borderRadiusFourteen)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _generateStar(1),
                                    SizedBox(
                                      width: SizeConfig().paddingFive * 2,
                                    ),
                                    Text(
                                      context
                                          .watch<ReviewItinerary>()
                                          ._reviewOneStars
                                          .keys
                                          .single
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h2FontSize),
                                    )
                                  ],
                                ),
                                Text(
                                  context
                                      .watch<ReviewItinerary>()
                                      ._reviewOneStars
                                      .values
                                      .single
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig().h2FontSize),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFive * 2,
                        ),
                        LightSpeedIn(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 2,
                              right: SizeConfig().paddingFive * 2,
                              top: SizeConfig().paddingFive * 1.2,
                              bottom: SizeConfig().paddingFive * 1.2,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _generateStar(2),
                                    SizedBox(
                                      width: SizeConfig().paddingFive * 2,
                                    ),
                                    Text(
                                      context
                                          .watch<ReviewItinerary>()
                                          ._reviewTwoStars
                                          .keys
                                          .single
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h2FontSize),
                                    )
                                  ],
                                ),
                                Text(
                                  context
                                      .watch<ReviewItinerary>()
                                      ._reviewTwoStars
                                      .values
                                      .single
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig().h2FontSize),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFive * 2,
                        ),
                        LightSpeedIn(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 2,
                              right: SizeConfig().paddingFive * 2,
                              top: SizeConfig().paddingFive * 1.2,
                              bottom: SizeConfig().paddingFive * 1.2,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _generateStar(3),
                                    SizedBox(
                                      width: SizeConfig().paddingFive * 2,
                                    ),
                                    Text(
                                      context
                                          .watch<ReviewItinerary>()
                                          ._reviewThreeStars
                                          .keys
                                          .single
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h2FontSize),
                                    )
                                  ],
                                ),
                                Text(
                                  context
                                      .watch<ReviewItinerary>()
                                      ._reviewThreeStars
                                      .values
                                      .single
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig().h2FontSize),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFive * 2,
                        ),
                        LightSpeedIn(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 2,
                              right: SizeConfig().paddingFive * 2,
                              top: SizeConfig().paddingFive * 1.2,
                              bottom: SizeConfig().paddingFive * 1.2,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _generateStar(4),
                                    SizedBox(
                                      width: SizeConfig().paddingFive * 2,
                                    ),
                                    Text(
                                      context
                                          .watch<ReviewItinerary>()
                                          ._reviewFourStars
                                          .keys
                                          .single
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h2FontSize),
                                    )
                                  ],
                                ),
                                Text(
                                  context
                                      .watch<ReviewItinerary>()
                                      ._reviewFourStars
                                      .values
                                      .single
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig().h2FontSize),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFive * 2,
                        ),
                        LightSpeedIn(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 2,
                              right: SizeConfig().paddingFive * 2,
                              top: SizeConfig().paddingFive * 1.2,
                              bottom: SizeConfig().paddingFive * 1.2,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _generateStar(5),
                                    SizedBox(
                                      width: SizeConfig().paddingFive * 2,
                                    ),
                                    Text(
                                      context
                                          .watch<ReviewItinerary>()
                                          ._reviewFiveStars
                                          .keys
                                          .single
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h2FontSize),
                                    )
                                  ],
                                ),
                                Text(
                                  context
                                      .watch<ReviewItinerary>()
                                      ._reviewFiveStars
                                      .values
                                      .single
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig().h2FontSize),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig().paddingThirty,
                    ),
                    Column(children: [
                      Row(
                        children: [
                          Text(
                            'Ricerche',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: black,
                                fontSize: SizeConfig().h2FontSize,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig().paddingFive * 1.5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: ValueListenableBuilder(
                          valueListenable: Global().searchStats,
                          builder: (BuildContext context,
                              List<SearchStatistics> value, Widget? child) {
                            if (value.isNotEmpty) {
                              return Wrap(
                                children: _chips(value, context),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig().paddingFive * 1),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'nessuna keyword da visualizzare',
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h4FontSize),
                                    )),
                              );
                            }
                          },
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig().paddingThirty * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _chips(List<SearchStatistics> _list, contextIt) =>
      List<Widget>.generate(
          _list.length,
          (index) => Padding(
                padding: EdgeInsets.only(right: SizeConfig().paddingFive * 2),
                child: FadeIn(
                  child: InputChip(
                    backgroundColor: Colors.grey[200],
                    avatar: Text(
                      _list[index].statsCount!.toString(),
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig().h4FontSize),
                    ),
                    label: Text(
                      _list[index].keyword!,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: SizeConfig().h4FontSize),
                    ),
                    onSelected: (bool value) {
                      if (_list[index].itineraryList!.isNotEmpty) {
                        _chipsItineraryDialog(_list[index].itineraryList!,
                            _list[index].keyword!, index, contextIt);
                      }
                    },
                  ),
                ),
              ));

  _chipsItineraryDialog(
      List<Itinerary> list, String keyword, int index, contextIt) {
    showDialog(
        context: contextIt,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusTwelve),
              ),
              title: Text(
                keyword.capitalizeFirstOfEach,
                style: TextStyle(
                    color: black, fontSize: SizeConfig().h1FontSize / 1.5),
              ),
              content: SizedBox(
                width: SizeConfig().paddingThirty * 10,
                child: ListView.builder(
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            list[i].name!.capitalizeFirstOfEach,
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig().h4FontSize),
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig().borderRadiusTen),
                        ),
                        primary: mainColor,
                        onPrimary: black),
                    child: Text(
                      'Chiudi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig().h4FontSize,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    }),
              ]);
        });
  }

  Widget _generateStar(int index) {
    int value = index;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          value > 0
              ? (value < 1 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color:
              value > 0 ? (value < 1 ? mainColor : mainColor) : Colors.black26,
          size: SizeConfig().iconSizeOne,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 1
              ? (value < 2 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color:
              value > 1 ? (value < 2 ? mainColor : mainColor) : Colors.black26,
          size: SizeConfig().iconSizeOne,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 2
              ? (value < 3 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color:
              value > 2 ? (value < 3 ? mainColor : mainColor) : Colors.black26,
          size: SizeConfig().iconSizeOne,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 3
              ? (value < 4 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color:
              value > 3 ? (value < 4 ? mainColor : mainColor) : Colors.black26,
          size: SizeConfig().iconSizeOne,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 4
              ? (value < 5 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color:
              value > 4 ? (value < 5 ? mainColor : mainColor) : Colors.black26,
          size: SizeConfig().iconSizeOne,
        ),
      ],
    );
  }

  _changeOpacity(bool isShow, String provider) async {
    if (provider == 'firebase') {
      if (isShow) {
        _fireBaseOpacity.value = 0.0;
        _isShowFireBase = false;
      } else {
        _fireBaseOpacity.value = 1.0;
        _isShowFireBase = true;
      }
    } else if (provider == 'facebook') {
      if (isShow) {
        _facebookOpacity.value = 0.0;
        _isShowFacebook = false;
      } else {
        _facebookOpacity.value = 1.0;
        _isShowFacebook = true;
      }
    } else {
      if (isShow) {
        _googleOpacity.value = 0.0;
        _isShowGoogle = false;
      } else {
        _googleOpacity.value = 1.0;
        _isShowGoogle = true;
      }
    }
  }
}

class ItineraryCategory with ChangeNotifier, DiagnosticableTreeMixin {
  List<Itinerary> _itinerary = [];
  List<Itinerary> _mItinerary = [];
  List<Itinerary> _cItinerary = [];
  List<Itinerary> _pItinerary = [];

  List<Itinerary> get itinerary => _itinerary;

  List<Itinerary> get mItinerary => _mItinerary;

  List<Itinerary> get cItinerary => _cItinerary;

  List<Itinerary> get pItinerary => _pItinerary;

  Future<void> reloadItinerary() async {
    await ItineraryController().getItinerary();
    _itinerary = Global().allItinerary.value;
    _mItinerary =
        _itinerary.where((element) => (element.category == 1)).toList();
    _cItinerary =
        _itinerary.where((element) => (element.category == 2)).toList();
    _pItinerary =
        _itinerary.where((element) => (element.category == 3)).toList();

    await Global()
        .navigatorKey
        .currentContext!
        .read<ReviewItinerary>()
        .reloadReview(_itinerary);
    notifyListeners();
  }
}

class ReviewItinerary with ChangeNotifier, DiagnosticableTreeMixin {
  final List<Review> _review = [];
  final Map<List<Review>, int> _reviewOneStars = {};
  final Map<List<Review>, int> _reviewTwoStars = {};
  final Map<List<Review>, int> _reviewThreeStars = {};
  final Map<List<Review>, int> _reviewFourStars = {};
  final Map<List<Review>, int> _reviewFiveStars = {};

  List<Review> get review => _review;

  Map<List<Review>, int> get reviewOneStars => _reviewOneStars;

  Map<List<Review>, int> get reviewTwoStars => _reviewTwoStars;

  Map<List<Review>, int> get reviewThreeStars => _reviewThreeStars;

  Map<List<Review>, int> get reviewFourStars => _reviewFourStars;

  Map<List<Review>, int> get reviewFiveStars => _reviewFiveStars;

  Future<void> reloadReview(List<Itinerary> _itinerary) async {
    _review.clear();
    _reviewOneStars.clear();
    _reviewTwoStars.clear();
    _reviewThreeStars.clear();
    _reviewFourStars.clear();
    _reviewFiveStars.clear();

    for (int i = 0; i < _itinerary.length; i++) {
      for (int j = 0; j < _itinerary[i].reviews!.length; j++) {
        review.add(_itinerary[i].reviews![j]);
      }
    }
    _reviewOneStars[_review.where((element) => (element.star == 1)).toList()] =
        _review
            .where((element) => (element.star == 1))
            .toList()
            .toSet()
            .toList()
            .length;
    _reviewTwoStars[_review.where((element) => (element.star == 2)).toList()] =
        _review
            .where((element) => (element.star == 2))
            .toList()
            .toSet()
            .toList()
            .length;
    _reviewThreeStars[
            _review.where((element) => (element.star == 3)).toList()] =
        _review
            .where((element) => (element.star == 3))
            .toList()
            .toSet()
            .toList()
            .length;
    _reviewFourStars[_review.where((element) => (element.star == 4)).toList()] =
        _review
            .where((element) => (element.star == 4))
            .toList()
            .toSet()
            .toList()
            .length;
    _reviewFiveStars[_review.where((element) => (element.star == 5)).toList()] =
        _review
            .where((element) => (element.star == 5))
            .toList()
            .toSet()
            .toList()
            .length;

    notifyListeners();
  }
}

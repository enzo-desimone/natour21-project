import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Entity_Class/itinerary.dart';
import 'package:natour21/Itinerary_GUI/Add/add_itinerary_gui.dart';
import 'package:provider/provider.dart';

import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/utils.dart';
import '../Itinerary_GUI/single_itinerary_gui.dart';
import 'main_tab.dart';

class MyItineraryTab extends StatefulWidget {
  const MyItineraryTab({Key? key}) : super(key: key);

  @override
  _MyItineraryTabState createState() => _MyItineraryTabState();
}

class _MyItineraryTabState extends State<MyItineraryTab>
    with AutomaticKeepAliveClientMixin<MyItineraryTab> {
  @override
  bool get wantKeepAlive => true;
  final ValueNotifier<double> _textOpacity = ValueNotifier(0);

  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      var _currentScrollPosition = _scrollViewController.position.pixels;
      if (_currentScrollPosition > 0) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          context.read<Elevation>().increment();
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});
        }
      } else {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          context.read<Elevation>().decrement();
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: white,
          body: Padding(
            padding: EdgeInsets.only(
                top: _showAppbar ? SizeConfig().paddingTwelve : 0,
                left: SizeConfig().paddingFifteen,
                right: SizeConfig().paddingFifteen),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollViewController,
              child: Column(children: [
                AnimatedContainer(
                  height: _showAppbar ? SizeConfig().paddingTwenty * 2 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'I miei Itinerari',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig().h2FontSize * 1.2),
                      ),
                      CustomBounce(
                        duration: const Duration(milliseconds: 100),
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => const AddItineraryPage(),
                            ),
                          )
                              .then((value) {
                            Global().itinerary = Itinerary();
                            context.read<ValidateField>().setDefault();
                          });
                        },
                        child: AnimatedOpacity(
                          opacity: _showAppbar ? 1 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                              color: white,
                              padding: EdgeInsets.only(
                                  left: SizeConfig().paddingTwelve,
                                  top: SizeConfig().paddingFive,
                                  bottom: SizeConfig().paddingFive),
                              child: Icon(
                                Ionicons.add_circle_outline,
                                color: mainColor,
                                size: SizeConfig().iconSize * 1.05,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: Global().myItinerary,
                    builder: (BuildContext context, List<Itinerary> value,
                        Widget? child) {
                      if (value.isNotEmpty) {
                        changeOpacity(true);
                        return LiveGrid(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          showItemInterval: const Duration(milliseconds: 150),
                          showItemDuration: const Duration(milliseconds: 200),
                          visibleFraction: 0.005,
                          itemCount: value.length,
                          padding: EdgeInsets.only(
                              top: _showAppbar
                                  ? SizeConfig().paddingTwentyFive
                                  : 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: SizeConfig().paddingFive / 2,
                            mainAxisSpacing: SizeConfig().paddingFive / 2,
                            childAspectRatio: (1 / 1.55),
                          ),
                          itemBuilder: animationItemBuilder(
                              (index) => _itineraryCard(index, context)),
                        );
                      } else {
                        changeOpacity(false);
                        return ValueListenableBuilder(
                          valueListenable: _textOpacity,
                          builder: (BuildContext context, double value,
                              Widget? child) {
                            return AnimatedOpacity(
                              opacity: value,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig().paddingThirty * 8,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Non hai nessun itinerario.',
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig().h3FontSize),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('clicca su',
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    SizeConfig().h3FontSize)),
                                        Text(' + ',
                                            style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    SizeConfig().h3FontSize)),
                                        Text('per inserirne dei nuovi.',
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    SizeConfig().h3FontSize)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }),
              ]),
            ),
          ),
        ));
  }

  Widget _itineraryCard(int index, context) {
    String _path = _getRandomImage(index);
    String _randomString = getRandomString(30);
    return Padding(
      padding: index % 2 == 0
          ? EdgeInsets.only(
              right: SizeConfig().paddingFive,
              bottom: SizeConfig().paddingTwenty)
          : EdgeInsets.only(
              left: SizeConfig().paddingFive,
              bottom: SizeConfig().paddingTwenty),
      child: CustomBounce(
        duration: const Duration(milliseconds: 100),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return SingleItineraryPage(
              index: index,
              path: _path,
              tag: _randomString,
            );
          }));
        },
        child: Hero(
          tag: Global().myItinerary.value[index].idItinerary.toString(),
          transitionOnUserGestures: true,
          child: Card(
            elevation: 2.5,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(SizeConfig().borderRadiusFourteen),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: AssetImage(_path), fit: BoxFit.cover),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig().paddingFive * 1.5,
                          top: SizeConfig().paddingFive * 2),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 1.3,
                              right: SizeConfig().paddingFive * 1.3,
                              top: SizeConfig().paddingFive / 2.5,
                              bottom: SizeConfig().paddingFive / 2.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusTen / 1.3),
                              color: Colors.white60),
                          child: Text(
                            Itinerary().getLevelTitle(
                                Global().myItinerary.value[index].level!),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig().h4FontSize / 1.1,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig().paddingThirty * 1.5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig().paddingFive * 1.5,
                          right: SizeConfig().paddingFive),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  Global()
                                      .myItinerary
                                      .value[index]
                                      .name!
                                      .capitalizeFirstOfEach,
                                  style: TextStyle(
                                      shadows: const <Shadow>[
                                        Shadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 10,
                                          color: Colors.black45,
                                        ),
                                      ],
                                      color: white,
                                      fontSize: SizeConfig().h1FontSize / 1.5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingFive / 2,
                          ),
                          _generateStar(false, index)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig().paddingTwenty,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig().paddingFive * 1.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Ionicons.stopwatch_outline,
                                color: Colors.white70,
                                size: SizeConfig().iconSizeOne,
                              ),
                              SizedBox(
                                width: SizeConfig().paddingFive,
                              ),
                              Text(
                                Itinerary.convertMsToHuman(Global()
                                        .myItinerary
                                        .value[index]
                                        .deltaTime! *
                                    60 *
                                    1000),
                                style: TextStyle(
                                    shadows: const <Shadow>[
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: Colors.black45,
                                      ),
                                    ],
                                    color: Colors.white70,
                                    fontSize: SizeConfig().h4FontSize / 1.1,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingFive,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Ionicons.walk_outline,
                                color: Colors.white70,
                                size: SizeConfig().iconSizeOne,
                              ),
                              SizedBox(
                                width: SizeConfig().paddingFive,
                              ),
                              Text(
                                Global()
                                        .myItinerary
                                        .value[index]
                                        .distance
                                        .toString() +
                                    ' km',
                                style: TextStyle(
                                    shadows: const <Shadow>[
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: Colors.black45,
                                      ),
                                    ],
                                    color: Colors.white70,
                                    fontSize: SizeConfig().h4FontSize / 1.1,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
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

  String _getRandomImage(int index) {
    if (Global().myItinerary.value.length < 2) {
      if (Global().myItinerary.value[index].category == 1) {
        return 'assets/images/category/m/m_1.png';
      } else if (Global().myItinerary.value[index].category == 2) {
        return 'assets/images/category/c/c_1.png';
      } else {
        return 'assets/images/category/p/p_1.png';
      }
    } else {
      int m = 0;
      int c = 0;
      int p = 0;

      for (int i = 0;
          i <
              Global().myItinerary.value.length -
                  (Global().myItinerary.value.length - index);
          i++) {
        if (Global().myItinerary.value[i].category == 1) {
          if (m == 4) {
            m = 1;
          } else {
            m++;
          }
        } else if (Global().myItinerary.value[i].category == 2) {
          if (c == 4) {
            c = 1;
          } else {
            c++;
          }
        } else {
          if (p == 4) {
            p = 1;
          } else {
            p++;
          }
        }
      }
      if (Global().myItinerary.value[index].category == 1) {
        return 'assets/images/category/m/m_' +
            (m == 4 ? '1' : (m + 1).toString()) +
            '.png';
      } else if (Global().myItinerary.value[index].category == 2) {
        return 'assets/images/category/c/c_' +
            (c == 4 ? '1' : (c + 1).toString()) +
            '.png';
      } else {
        return 'assets/images/category/p/p_' +
            (p == 4 ? '1' : (p + 1).toString()) +
            '.png';
      }
    }
  }

  Widget _generateStar(bool isSingle, int index) {
    double value = 0;

    for (int i = 0;
        i < Global().myItinerary.value[index].reviews!.length;
        i++) {
      value += Global().myItinerary.value[index].reviews![i].star;
    }
    value /= Global().myItinerary.value[index].reviews!.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          value > 0
              ? (value < 1 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color: value > 0
              ? (value < 1
                  ? Colors.yellowAccent[400]
                  : Colors.yellowAccent[400])
              : Colors.grey,
          size: SizeConfig().iconSizeOne / 1.4,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 1
              ? (value < 2 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color: value > 1
              ? (value < 2
                  ? Colors.yellowAccent[400]
                  : Colors.yellowAccent[400])
              : Colors.grey,
          size: SizeConfig().iconSizeOne / 1.4,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 2
              ? (value < 3 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color: value > 2
              ? (value < 3
                  ? Colors.yellowAccent[400]
                  : Colors.yellowAccent[400])
              : Colors.grey,
          size: SizeConfig().iconSizeOne / 1.4,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 3
              ? (value < 4 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color: value > 3
              ? (value < 4
                  ? Colors.yellowAccent[400]
                  : Colors.yellowAccent[400])
              : Colors.grey,
          size: SizeConfig().iconSizeOne / 1.4,
        ),
        SizedBox(
          width: SizeConfig().paddingFive / 2,
        ),
        Icon(
          value > 4
              ? (value < 5 ? Ionicons.star_half : Ionicons.star)
              : Ionicons.star_outline,
          color: value > 4
              ? (value < 5
                  ? Colors.yellowAccent[400]
                  : Colors.yellowAccent[400])
              : Colors.grey,
          size: SizeConfig().iconSizeOne / 1.4,
        ),
      ],
    );
  }

  changeOpacity(bool isList) {
    if (isList) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _textOpacity.value = 0.0;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        _textOpacity.value = 1.0;
      });
    }
  }
}

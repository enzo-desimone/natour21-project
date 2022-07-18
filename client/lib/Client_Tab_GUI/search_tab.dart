import 'dart:async';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Controller/search_statistics_controller.dart';
import 'package:natour21/Itinerary_GUI/all_itinerary_gui.dart';
import 'package:provider/provider.dart';

import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/utils.dart';
import '../Entity_Class/itinerary.dart';
import 'main_tab.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with AutomaticKeepAliveClientMixin<SearchTab> {
  @override
  bool get wantKeepAlive => true;

  final ValueNotifier<double> _textOpacity = ValueNotifier(0);
  final TextEditingController? _searchController =
      TextEditingController(text: '');
  late ScrollController _scrollViewController;
  final ValueNotifier<bool> _mFilter = ValueNotifier(true);
  final ValueNotifier<bool> _cFilter = ValueNotifier(true);
  final ValueNotifier<bool> _pFilter = ValueNotifier(true);
  final ValueNotifier<bool> _easyFilter = ValueNotifier(true);
  final ValueNotifier<bool> _mediumFilter = ValueNotifier(true);
  final ValueNotifier<bool> _hardFilter = ValueNotifier(true);
  final ValueNotifier<bool> _extremeFilter = ValueNotifier(true);
  final ValueNotifier<bool> _selectAll = ValueNotifier(false);

  bool _showAppbar = true;
  bool isScrollingDown = false;
  Timer? _timer;

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
                  left: SizeConfig().paddingFifteen,
                  right: SizeConfig().paddingFifteen),
              child: SingleChildScrollView(
                controller: _scrollViewController,
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  AnimatedContainer(
                    height: _showAppbar ? SizeConfig().paddingTwenty * 2 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cerca',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig().h2FontSize * 1.2),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    height: _showAppbar ? SizeConfig().paddingTwelve : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: SizedBox(
                      height: SizeConfig().paddingTwelve,
                    ),
                  ),
                  AnimatedContainer(
                    height:
                        _showAppbar ? SizeConfig().paddingTwentyFive * 2 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                                color: black,
                                fontSize: SizeConfig().h2FontSize),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig().borderRadiusTwelve),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'digita il testo',
                              prefixIcon: AnimatedOpacity(
                                opacity: _showAppbar ? 1 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Ionicons.search_outline,
                                  size: SizeConfig().iconSizeOne,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                              contentPadding: EdgeInsets.only(
                                left: SizeConfig().paddingTwelve,
                                right: SizeConfig().paddingTwelve,
                              ),
                              fillColor: grey.withAlpha(130),
                              filled: true,
                            ),
                            onChanged: (value) async {
                              await Global.analytics.logEvent(
                                name: 'search_event',
                                parameters: <String, dynamic>{
                                  'key_word': value,
                                  'user': Global().myUser.value.id,
                                },
                              );
                              if (value.trimAll().isNotEmpty) {
                                await _searchFilterList(false);
                                _timer?.cancel();
                                _timer =
                                    Timer(const Duration(milliseconds: 4000),
                                        () async {
                                  if (Global()
                                      .searchItinerary
                                      .value
                                      .isNotEmpty) {
                                    List<int> _temp = [];

                                    for (int i = 0;
                                        i <
                                            Global()
                                                .searchItinerary
                                                .value
                                                .length;
                                        i++) {
                                      _temp.add(Global()
                                          .searchItinerary
                                          .value[i]
                                          .idItinerary!);
                                    }

                                    await SearchStatisticsController()
                                        .addSearchStats(value, _temp);
                                  }
                                });
                              } else {
                                await _searchFilterList(true);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig().paddingTwelve,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _searchFilterDialog();
                              },
                              child: Icon(
                                Ionicons.filter_circle_outline,
                                size: SizeConfig().iconSize,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig().borderRadiusFourteen),
                                ),
                                primary: mainColor,
                                padding: EdgeInsets.only(
                                  top: SizeConfig().paddingTwelve,
                                  bottom: SizeConfig().paddingTwelve,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: Global().searchItinerary,
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
                        if (_searchController!.text.isNotEmpty) {
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
                                        'La ricerca non ha restituito nessun\n itinerario, riprova con una keyword differente\n oppure con dei filtri differenti',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w400,
                                            fontSize: SizeConfig().h3FontSize),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig().paddingThirty * 8,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'La lista degli itinerari è\n attualmente vuota, riprova più tardi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig().h3FontSize),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ]),
              ),
            )));
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
          int _temp = 0;
          for (int i = 0; i < Global().allItinerary.value.length; i++) {
            if (Global().allItinerary.value[i] ==
                Global().searchItinerary.value[index]) {
              _temp = i;
              break;
            }
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return AllItineraryPage(
              index: _temp,
              path: _path,
              tag: _randomString,
            );
          }));
        },
        child: Hero(
          tag: _randomString,
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
                    borderRadius: BorderRadius.circular(
                        SizeConfig().borderRadiusFourteen),
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
                                Global().searchItinerary.value[index].level!),
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
                                      .searchItinerary
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
                                        .searchItinerary
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
                                        .searchItinerary
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
    if (Global().searchItinerary.value.length < 2) {
      if (Global().searchItinerary.value[index].category == 1) {
        return 'assets/images/category/m/m_1.png';
      } else if (Global().searchItinerary.value[index].category == 2) {
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
              Global().searchItinerary.value.length -
                  (Global().searchItinerary.value.length - index);
          i++) {
        if (Global().searchItinerary.value[i].category == 1) {
          if (m == 4) {
            m = 1;
          } else {
            m++;
          }
        } else if (Global().searchItinerary.value[i].category == 2) {
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
      if (Global().searchItinerary.value[index].category == 1) {
        return 'assets/images/category/m/m_' +
            (m == 4 ? '1' : (m + 1).toString()) +
            '.png';
      } else if (Global().searchItinerary.value[index].category == 2) {
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
        i < Global().searchItinerary.value[index].reviews!.length;
        i++) {
      value += Global().searchItinerary.value[index].reviews![i].star;
    }
    value /= Global().searchItinerary.value[index].reviews!.length;

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

  _searchFilterDialog() {
    List<bool> _tempBool = [
      _easyFilter.value,
      _mediumFilter.value,
      _hardFilter.value,
      _extremeFilter.value,
      _mFilter.value,
      _cFilter.value,
      _pFilter.value
    ];
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(SizeConfig().borderRadiusTwelve),
            ),
            title: Text(
              'Filtri',
              style: TextStyle(
                  color: black, fontSize: SizeConfig().h1FontSize / 1.5),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Livello',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: SizeConfig().h3FontSize),
                      )),
                  const Divider(),
                  SizedBox(
                    height: SizeConfig().paddingFive,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _easyFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_extremeFilter.value ||
                              _mediumFilter.value ||
                              _hardFilter.value) {
                            _easyFilter.value = !_easyFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Semplice',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingFive * 2,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _mediumFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_extremeFilter.value ||
                              _hardFilter.value ||
                              _easyFilter.value) {
                            _mediumFilter.value = !_mediumFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Moderato',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingFive * 2,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _hardFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_extremeFilter.value ||
                              _mediumFilter.value ||
                              _easyFilter.value) {
                            _hardFilter.value = !_hardFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Difficile',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingFive * 2,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _extremeFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_hardFilter.value ||
                              _mediumFilter.value ||
                              _easyFilter.value) {
                            _extremeFilter.value = !_extremeFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Estremo',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Categoria',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: SizeConfig().h3FontSize),
                      )),
                  const Divider(),
                  SizedBox(
                    height: SizeConfig().paddingFive,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _mFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_cFilter.value || _pFilter.value) {
                            _mFilter.value = !_mFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Montagna',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingFive * 2,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _cFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_pFilter.value || _mFilter.value) {
                            _cFilter.value = !_cFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Collina',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingFive * 2,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _pFilter,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          if (_cFilter.value || _mFilter.value) {
                            _pFilter.value = !_pFilter.value;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              value
                                  ? Icons.radio_button_checked_outlined
                                  : Ionicons.radio_button_off_outline,
                              color: value ? mainColor : Colors.grey[500],
                            ),
                            SizedBox(
                              width: SizeConfig().paddingFive,
                            ),
                            Text(
                              'Pianura',
                              style: TextStyle(
                                  color: value ? black : Colors.grey[500],
                                  fontSize: SizeConfig().h2FontSize),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusTen),
                            ),
                            onPrimary: black),
                        child: Icon(
                          Ionicons.layers_outline,
                          color: Colors.grey[500],
                          size: SizeConfig().iconSize,
                        ),
                        onPressed: () {
                          _selectAll.value = !_selectAll.value;
                          if (_selectAll.value) {
                            _easyFilter.value = true;
                            _mediumFilter.value = false;
                            _hardFilter.value = false;
                            _extremeFilter.value = false;
                            _mFilter.value = true;
                            _cFilter.value = false;
                            _pFilter.value = false;
                          } else {
                            _easyFilter.value = true;
                            _mediumFilter.value = true;
                            _hardFilter.value = true;
                            _extremeFilter.value = true;
                            _mFilter.value = true;
                            _cFilter.value = true;
                            _pFilter.value = true;
                          }
                        }),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusTen),
                            ),
                            onPrimary: black),
                        child: Text(
                          'Annulla',
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig().h4FontSize,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _easyFilter.value = _tempBool[0];
                          _mediumFilter.value = _tempBool[1];
                          _hardFilter.value = _tempBool[2];
                          _extremeFilter.value = _tempBool[3];
                          _mFilter.value = _tempBool[4];
                          _cFilter.value = _tempBool[5];
                          _pFilter.value = _tempBool[6];
                        }),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusTen),
                            ),
                            primary: mainColor,
                            onPrimary: black),
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig().h4FontSize,
                          ),
                        ),
                        onPressed: () async {
                          if (_searchController!.text.isEmpty) {
                            Navigator.of(context).pop();
                            await _searchFilterList(true);
                          } else {
                            Navigator.of(context).pop();
                            await _searchFilterList(false);
                          }
                        }),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> _searchFilterList(bool isEmpty) async {
    List<Itinerary> _temp = List.from(Global().allItinerary.value);

    if (isEmpty) {
      Global().searchItinerary.value = _temp;
    } else {
      Global().searchItinerary.value = _temp.where((element) {
        return element.name!
            .toLowerCase()
            .contains(_searchController!.text.trimAll().toLowerCase());
      }).toList();
    }

    if (!_easyFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.level == 1);
    }

    if (!_mediumFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.level == 2);
    }

    if (!_hardFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.level == 3);
    }

    if (!_extremeFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.level == 4);
    }

    if (!_mFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.category == 1);
    }

    if (!_cFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.category == 2);
    }

    if (!_pFilter.value) {
      Global()
          .searchItinerary
          .value
          .removeWhere((element) => element.category == 3);
    }

    if (mounted) {
      setState(() {
        Global().searchItinerary.value;
      });
    }
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

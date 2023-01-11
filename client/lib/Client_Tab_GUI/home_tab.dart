import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:natour21/Entity_Class/interest_point.dart';
import 'package:provider/provider.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/utils.dart';
import '../Entity_Class/fire_base_user.dart';
import '../Entity_Class/itinerary.dart';
import '../Itinerary_GUI/all_itinerary_gui.dart';
import 'main_tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  final ValueNotifier<double> _textOpacity = ValueNotifier(0);

  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  bool get wantKeepAlive => true;
  int _levelSelected = 0;
  int _intSelected = 0;

  final List<String> _pointAssets = [
    'assets/images/interest_point/1.png',
    'assets/images/interest_point/2.png',
    'assets/images/interest_point/3.png',
    'assets/images/interest_point/4.png',
    'assets/images/interest_point/5.png',
    'assets/images/interest_point/6.png',
    'assets/images/interest_point/7.png',
    'assets/images/interest_point/8.png',
    'assets/images/interest_point/9.png',
    'assets/images/interest_point/10.png',
  ];

  @override
  void initState() {
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
    _init();
    super.initState();
  }

  _init() async {
    Global().homeItinerary.value = Global().allItinerary.value;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<GlobalKey<AnimatorWidgetState>> _keyListCategory = [
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>()
  ];

  final List<GlobalKey<AnimatorWidgetState>> _keyListLevel = [
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () async {
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
                    StreamBuilder<FireBaseUser>(
                      stream: UserController().getStreamUser(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            (snapshot.data as FireBaseUser)
                                .firstName!
                                .capitalizeFirstOfEach,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: black,
                                fontSize: SizeConfig().h1FontSize / 1.5),
                          );
                        } else {
                          return Text(
                            Global()
                                .myUser
                                .value
                                .firstName!
                                .capitalizeFirstOfEach,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: black,
                                fontSize: SizeConfig().h1FontSize / 1.5),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: SizeConfig().paddingTwentyFive),
                padding: EdgeInsets.only(top: SizeConfig().paddingFive / 1.5),
                height: SizeConfig().paddingThirty * 2,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: SizeConfig().paddingFifteen),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) =>
                        _levelCard(index)),
              ),
              ValueListenableBuilder(
                valueListenable: Global().homeItinerary,
                builder: (BuildContext context, List<Itinerary> value,
                    Widget? child) {
                  if (value.isNotEmpty) {
                    changeOpacity(true);
                    return Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                          height: SizeConfig().paddingThirty * 10.5,
                          child: LiveList(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingFifteen / 1.3,
                            ),
                            shrinkWrap: true,
                            showItemInterval: const Duration(milliseconds: 200),
                            showItemDuration: const Duration(milliseconds: 250),
                            visibleFraction: 0.005,
                            physics: const BouncingScrollPhysics(),
                            reAnimateOnVisibility: false,
                            scrollDirection: Axis.horizontal,
                            itemCount: value.length,
                            itemBuilder: animationItemBuilder(
                                (index) => _itineraryCard(index, context)),
                          )),
                    );
                  } else {
                    changeOpacity(false);
                    return ValueListenableBuilder(
                      valueListenable: _textOpacity,
                      builder:
                          (BuildContext context, double value, Widget? child) {
                        return AnimatedOpacity(
                          opacity: value,
                          duration: const Duration(milliseconds: 100),
                          child: BounceIn(
                            child: SizedBox(
                              height: SizeConfig().paddingThirty * 10,
                              child: Center(
                                  child: Text(
                                'Nessun itinerario \nprova a cambiare i criteri di filtraggio.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeConfig().h3FontSize),
                              )),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig().paddingThirty * 1.2),
                height: SizeConfig().paddingTwenty * 6,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: SizeConfig().paddingFifteen,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 11,
                    itemBuilder: (BuildContext context, int index) =>
                        _categoryCard(index)),
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

  Widget _levelCard(int index) {
    String title = '';
    if (index == 1) {
      title = 'Semplice';
    } else if (index == 2) {
      title = 'Moderato';
    } else if (index == 3) {
      title = 'Difficile';
    } else if (index == 4) {
      title = 'Estremo';
    }

    if (index != 0) {
      return Padding(
        padding: EdgeInsets.only(
            right: SizeConfig().paddingTwentyFive,
            top: SizeConfig().paddingFive / 1.5),
        child: GestureDetector(
          onTap: () {
            _keyListLevel[index].currentState!.forward();
            if (mounted) {
              setState(() {
                _levelSelected = index;
              });
            }

            if (_intSelected != 0) {
              List<Itinerary> _temp = [];

              for (int i = 0; i < Global().allItinerary.value.length; i++) {
                for (int j = 0;
                    j < Global().allItinerary.value[i].interestPoint!.length;
                    j++) {
                  if (Global()
                          .allItinerary
                          .value[i]
                          .interestPoint![j]
                          .typology ==
                      _intSelected) {
                    _temp.add(Global().allItinerary.value[i]);
                    break;
                  }
                }
              }
              Global().homeItinerary.value = _temp
                  .where((element) => (element.level! == _levelSelected))
                  .toList();
            } else {
              Global().homeItinerary.value = Global()
                  .allItinerary
                  .value
                  .where((element) => (element.level! == _levelSelected))
                  .toList();
            }
          },
          child: RubberBand(
            key: _keyListLevel[index],
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: _levelSelected == 0
                          ? Colors.grey[400]
                          : _levelSelected == index
                              ? mainColor
                              : Colors.grey[400],
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig().h1FontSize / 1.7),
                ),
                SizedBox(
                  height: SizeConfig().paddingFive / 2,
                ),
                Container(
                  height: SizeConfig().paddingFive,
                  width: SizeConfig().paddingFive,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _levelSelected == 0
                          ? Colors.transparent
                          : _levelSelected == index
                              ? mainColor
                              : Colors.transparent),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
            right: SizeConfig().paddingTwentyFive,
            top: SizeConfig().paddingFive / 1.5),
        child: GestureDetector(
          onTap: () {
            _keyListLevel[index].currentState!.forward();
            if (mounted) {
              setState(() {
                _levelSelected = 0;
              });
            }
            if (_intSelected != 0) {
              List<Itinerary> _temp = [];

              for (int i = 0; i < Global().allItinerary.value.length; i++) {
                for (int j = 0;
                    j < Global().allItinerary.value[i].interestPoint!.length;
                    j++) {
                  if (Global()
                          .allItinerary
                          .value[i]
                          .interestPoint![j]
                          .typology ==
                      _intSelected) {
                    _temp.add(Global().allItinerary.value[i]);
                    break;
                  }
                }
              }
              Global().homeItinerary.value = _temp;
            } else {
              Global().homeItinerary.value = Global().allItinerary.value;
            }
          },
          child: RubberBand(
            key: _keyListLevel[index],
            child: Column(
              children: [
                Icon(
                  Ionicons.layers_outline,
                  color: _levelSelected == 0 ? mainColor : Colors.grey[400],
                  size: SizeConfig().iconSize,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _itineraryCard(int index, context) {
    String _path = _getRandomImage(index);
    String _randomString = getRandomString(30);

    return Padding(
      padding: EdgeInsets.only(right: SizeConfig().paddingTwenty),
      child: CustomBounce(
        duration: const Duration(milliseconds: 100),
        onPressed: () {
          int _temp = 0;
          for (int i = 0; i < Global().allItinerary.value.length; i++) {
            if (Global().allItinerary.value[i] ==
                Global().homeItinerary.value[index]) {
              _temp = i;
              break;
            }
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return AllItineraryPage(
                index: _temp, path: _path, tag: _randomString);
          }));
        },
        child: Hero(
          tag: _randomString,
          transitionOnUserGestures: true,
          child: Card(
            elevation: 2.5,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  SizeConfig().borderRadiusFourteen * 1.2),
            ),
            child: SizedBox(
              width: SizeConfig().paddingTwenty * 10.5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig().borderRadiusFourteen * 1.2),
                      image: DecorationImage(
                          image: AssetImage(_path), fit: BoxFit.cover),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig().paddingFive * 1.7,
                            top: SizeConfig().paddingFive * 2.2),
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
                                  Global().homeItinerary.value[index].level!),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: SizeConfig().h4FontSize,
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
                                        .homeItinerary
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
                                        fontSize: SizeConfig().h1FontSize / 1.3,
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
                        height: SizeConfig().paddingTwentyFive,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig().paddingFive * 1.5),
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
                                          .homeItinerary
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
                                      fontSize: SizeConfig().h4FontSize,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig().paddingFive * 1.5,
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
                                          .homeItinerary
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
                                      fontSize: SizeConfig().h4FontSize,
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
      ),
    );
  }

  Widget _categoryCard(int index) {
    if (index == 0) {
      return GestureDetector(
        onTap: () {
          _keyListCategory[index].currentState!.forward();
          if (mounted) {
            setState(() {
              _intSelected = 0;
            });
          }
          if (_levelSelected != 0) {
            Global().homeItinerary.value = Global()
                .allItinerary
                .value
                .where((element) => (element.level! == _levelSelected))
                .toList();
          } else {
            Global().homeItinerary.value = Global().allItinerary.value;
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
              right: SizeConfig().paddingThirty,
              top: SizeConfig().paddingFive),
          child: BounceIn(
            key: _keyListCategory[index],
            child: Column(
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: _intSelected == 0 ? mainColor : Colors.grey[300],
                      borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig().borderRadiusTen)),
                      boxShadow: [
                        BoxShadow(
                          color: _intSelected == index
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.white,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.all(SizeConfig().paddingFifteen * 1.05),
                      child: Icon(
                        Ionicons.layers_outline,
                        size: SizeConfig().iconSize * 1.2,
                        color: _intSelected == 0 ? white : white,
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _keyListCategory[index].currentState!.forward();
          if (mounted) {
            setState(() {
              _intSelected = index;
            });
          }
          if (_levelSelected != 0) {
            List<Itinerary> _temp = [];

            for (int i = 0; i < Global().allItinerary.value.length; i++) {
              for (int j = 0;
                  j < Global().allItinerary.value[i].interestPoint!.length;
                  j++) {
                if (Global().allItinerary.value[i].interestPoint![j].typology ==
                    _intSelected) {
                  _temp.add(Global().allItinerary.value[i]);
                  break;
                }
              }
            }
            Global().homeItinerary.value = _temp
                .where((element) => (element.level! == _levelSelected))
                .toList();
          } else {
            List<Itinerary> _temp = [];

            for (int i = 0; i < Global().allItinerary.value.length; i++) {
              for (int j = 0;
                  j < Global().allItinerary.value[i].interestPoint!.length;
                  j++) {
                if (Global().allItinerary.value[i].interestPoint![j].typology ==
                    _intSelected) {
                  _temp.add(Global().allItinerary.value[i]);
                  break;
                }
              }
            }
            Global().homeItinerary.value = _temp;
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
              right: SizeConfig().paddingThirty,
              top: SizeConfig().paddingFive),
          child: BounceIn(
            key: _keyListCategory[index],
            child: Column(
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                        color: _intSelected == index
                            ? mainColor
                            : Colors.grey[350],
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig().borderRadiusTen)),
                        boxShadow: [
                          BoxShadow(
                            color: _intSelected == index
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.white,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig().paddingFifteen),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _pointAssets[index - 1],
                            width: SizeConfig().paddingThirty,
                            height: SizeConfig().paddingThirty,
                            color: _intSelected == index ? white : white,
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: SizeConfig().paddingFive,
                ),
                Text(
                  InterestPoint().getInterestPointTitleHome(index),
                  style: TextStyle(
                      color: _intSelected == index ?  black :  Colors.grey[350],
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig().h4FontSize),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  String _getRandomImage(int index) {
    if (Global().homeItinerary.value.length < 2) {
      if (Global().homeItinerary.value[index].category == 1) {
        return 'assets/images/category/m/m_1.png';
      } else if (Global().homeItinerary.value[index].category == 2) {
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
              Global().homeItinerary.value.length -
                  (Global().homeItinerary.value.length - index);
          i++) {
        if (Global().homeItinerary.value[i].category == 1) {
          if (m == 4) {
            m = 1;
          } else {
            m++;
          }
        } else if (Global().homeItinerary.value[i].category == 2) {
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
      if (Global().homeItinerary.value[index].category == 1) {
        return 'assets/images/category/m/m_' +
            (m == 4 ? '1' : (m + 1).toString()) +
            '.png';
      } else if (Global().homeItinerary.value[index].category == 2) {
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
        i < Global().homeItinerary.value[index].reviews!.length;
        i++) {
      value += Global().homeItinerary.value[index].reviews![i].star;
    }
    value /= Global().homeItinerary.value[index].reviews!.length;

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
              : Colors.grey[600],
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
              : Colors.grey[600],
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
              : Colors.grey[600],
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
              : Colors.grey[600],
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
              : Colors.grey[600],
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

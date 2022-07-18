import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Entity_Class/interest_point.dart';
import 'package:natour21/Itinerary_GUI/Add/map/draw_interest_point_gui.dart';

import '../../Accessory_GUI/boucing_animation.dart';

class AddInterestPointStep extends StatefulWidget {
  const AddInterestPointStep({Key? key, required this.controller})
      : super(key: key);

  final PageController controller;

  @override
  _AddInterestPointStepState createState() => _AddInterestPointStepState();
}

class _AddInterestPointStepState extends State<AddInterestPointStep> {
  Map<int, int> _point = <int, int>{
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
    10: 0
  };

  final ValueNotifier<List<InterestPoint>> _tempIntPoint = ValueNotifier([]);

  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    for (int i = 0; i < Global().itinerary.interestPoint!.length; i++) {
      _point[Global().itinerary.interestPoint![i].typology] =
          _point[Global().itinerary.interestPoint![i].typology]! + 1;
    }
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      var _currentScrollPosition = _scrollViewController.position.pixels;
      if (_currentScrollPosition > 0) {
        if (!isScrollingDown) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            isScrollingDown = true;
            _showAppbar = false;
          });
        }
      } else {
        if (isScrollingDown) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            isScrollingDown = false;
            _showAppbar = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scrollViewController,
          child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig().paddingThirty * 4,
              ),
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: _showAppbar ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          'Punti di Interesse',
                          style: TextStyle(
                              fontSize: SizeConfig().h1FontSize,
                              color: mainColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _showAppbar ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          'aggiungi punti di interesse',
                          style: TextStyle(
                              fontSize: SizeConfig().h2FontSize,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig().paddingFive,
                            right: SizeConfig().paddingFive),
                        child: Column(
                          children: [
                            SizedBox(
                              height: SizeConfig().paddingThirty,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Inseriti',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: black,
                                        fontSize: SizeConfig().h2FontSize),
                                  ),
                                  Row(
                                    children: [
                                      CustomBounce(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DrawInterestPointPage(
                                                  editModeOn: false,
                                                ),
                                              ),
                                            )
                                                .then((value) {
                                              _point = <int, int>{
                                                1: 0,
                                                2: 0,
                                                3: 0,
                                                4: 0,
                                                5: 0,
                                                6: 0,
                                                7: 0,
                                                8: 0,
                                                9: 0,
                                                10: 0
                                              };

                                              for (int i = 0;
                                                  i <
                                                      Global()
                                                          .itinerary
                                                          .interestPoint!
                                                          .length;
                                                  i++) {
                                                _point[Global()
                                                    .itinerary
                                                    .interestPoint![i]
                                                    .typology] = _point[Global()
                                                        .itinerary
                                                        .interestPoint![i]
                                                        .typology]! +
                                                    1;
                                              }

                                              Global()
                                                  .itinerary
                                                  .interestPoint!
                                                  .sort((a, b) => a.typology
                                                      .compareTo(b.typology));

                                              List<InterestPoint> _temp = [];

                                              for (int i = 0;
                                                  i <
                                                      Global()
                                                          .itinerary
                                                          .interestPoint!
                                                          .length;
                                                  i++) {
                                                if (i == 0) {
                                                  _temp.add(Global()
                                                      .itinerary
                                                      .interestPoint![0]);
                                                } else {
                                                  if (Global()
                                                          .itinerary
                                                          .interestPoint![i]
                                                          .typology !=
                                                      Global()
                                                          .itinerary
                                                          .interestPoint![i - 1]
                                                          .typology) {
                                                    _temp.add(Global()
                                                        .itinerary
                                                        .interestPoint![i]);
                                                  }
                                                }
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  _tempIntPoint.value = _temp;
                                                  _point;
                                                });
                                              }
                                            });
                                          },
                                          child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig()
                                                      .paddingTwelve,
                                                  top: SizeConfig().paddingFive,
                                                  bottom:
                                                      SizeConfig().paddingFive),
                                              child: Icon(
                                                Global()
                                                        .itinerary
                                                        .interestPoint!
                                                        .isEmpty
                                                    ? Ionicons
                                                        .add_circle_outline
                                                    : Ionicons.eye_outline,
                                                color: mainColor,
                                                size: SizeConfig().iconSize,
                                              ))),
                                      Visibility(
                                        visible: Global()
                                            .itinerary
                                            .interestPoint!
                                            .isNotEmpty,
                                        child: SizedBox(
                                          width: SizeConfig().paddingFive * 2,
                                        ),
                                      ),
                                      Visibility(
                                        visible: Global()
                                            .itinerary
                                            .interestPoint!
                                            .isNotEmpty,
                                        child: CustomBounce(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            onPressed: () {
                                              _point = <int, int>{
                                                1: 0,
                                                2: 0,
                                                3: 0,
                                                4: 0,
                                                5: 0,
                                                6: 0,
                                                7: 0,
                                                8: 0,
                                                9: 0,
                                                10: 0
                                              };

                                              for (int i = 0;
                                                  i <
                                                      Global()
                                                          .itinerary
                                                          .interestPoint!
                                                          .length;
                                                  i++) {
                                                _point[Global()
                                                    .itinerary
                                                    .interestPoint![i]
                                                    .typology] = _point[Global()
                                                        .itinerary
                                                        .interestPoint![i]
                                                        .typology]! +
                                                    1;
                                              }

                                              Global()
                                                  .itinerary
                                                  .interestPoint!
                                                  .clear();
                                              if (mounted) {
                                                setState(() {
                                                  _tempIntPoint.value = [];
                                                  _point;
                                                });
                                              }
                                            },
                                            child: Container(
                                                color: white,
                                                padding: EdgeInsets.only(
                                                    left: SizeConfig()
                                                        .paddingTwelve,
                                                    top: SizeConfig()
                                                        .paddingFive,
                                                    bottom: SizeConfig()
                                                        .paddingFive),
                                                child: Icon(
                                                  Ionicons.trash_outline,
                                                  color: mainColor,
                                                  size: SizeConfig().iconSize,
                                                ))),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig().paddingTwelve,
                            ),
                            if (Global().itinerary.interestPoint!.isEmpty)
                              Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig().paddingThirty * 3.5),
                                child: Column(
                                  children: [
                                    Text(
                                      'Nessun punto di interesse.',
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
                          ],
                        ),
                      ),
                      if (Global().itinerary.interestPoint!.isNotEmpty)
                        SizedBox(
                          height: SizeConfig().paddingTwentyFive * 3.4,
                          child: ValueListenableBuilder(
                            valueListenable: _tempIntPoint,
                            builder: (BuildContext context,
                                List<InterestPoint> value, Widget? child) {
                              return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: false,
                                  padding: EdgeInsets.only(
                                      left: SizeConfig().paddingFive * 2.2,
                                      right: SizeConfig().paddingFive),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    return _addInterestPoint(
                                        index,
                                        InterestPoint().getInterestPointTitle(
                                            value[index].typology),
                                        value[index].typology);
                                  });
                            },
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig().paddingTwenty * 5,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _addInterestPoint(int index, String title, int typology) {
    int _id = _tempIntPoint.value[index].typology;

    return Padding(
      padding: EdgeInsets.only(right: SizeConfig().paddingTwelve),
      child: CustomBounce(
        duration: const Duration(milliseconds: 100),
        onPressed: () {},
        child: Container(
          width: SizeConfig().paddingThirty * 5.1,
          padding: EdgeInsets.only(
              top: SizeConfig().paddingFive / 2,
              left: SizeConfig().paddingFive * 1.5,
              right: SizeConfig().paddingFive * 1.5,
              bottom: SizeConfig().paddingFive),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig().borderRadiusFourteen),
            color: Colors.grey[200],
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig().paddingFive),
                decoration: const BoxDecoration(
                    color: Colors.black26, shape: BoxShape.circle),
                child: Text(
                  _point[_id].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig().h4FontSize / 1.3,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig().paddingFive * 1.5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/interest_point/' +
                          typology.toString() +
                          '.png',
                      width: SizeConfig().paddingTwenty * 1.85,
                      height: SizeConfig().paddingTwenty * 1.85,
                      color: accentColor,
                    ),
                    SizedBox(
                      height: SizeConfig().paddingFive / 2,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: black,
                            fontSize: SizeConfig().h4FontSize,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

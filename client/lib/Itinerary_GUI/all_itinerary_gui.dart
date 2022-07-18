import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Controller/itinerary_controller.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:natour21/Itinerary_GUI/Add/map/draw_interest_point_gui.dart';
import 'package:natour21/Itinerary_GUI/Edit/edit_itinerary_gui.dart';
import 'package:readmore/readmore.dart';
import '../Accessory_Class/global_variable.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Controller/room_controller.dart';
import '../Entity_Class/interest_point.dart';
import '../Entity_Class/itinerary.dart';
import 'Add/map/draw_route_gui.dart';

class AllItineraryPage extends StatefulWidget {
  const AllItineraryPage(
      {Key? key, required this.index, required this.path, required this.tag})
      : super(key: key);

  final int index;
  final String path;
  final String tag;

  @override
  _AllItineraryPageState createState() => _AllItineraryPageState();
}

class _AllItineraryPageState extends State<AllItineraryPage> {
  final ValueNotifier<EdgeInsets> _editEdgeOne =
      ValueNotifier(const EdgeInsets.only(top: 0));
  final ValueNotifier<EdgeInsets> _editEdgeTwo =
      ValueNotifier(const EdgeInsets.only(top: 0));
  final ValueNotifier<EdgeInsets> _editEdgeThree =
      ValueNotifier(const EdgeInsets.only(top: 0));

  final ValueNotifier<EdgeInsets> _saveEdgeOne =
      ValueNotifier(const EdgeInsets.only(top: 0));
  final ValueNotifier<EdgeInsets> _saveEdgeTwo =
      ValueNotifier(const EdgeInsets.only(top: 0));

  final ValueNotifier<bool> _isOpenEdit = ValueNotifier(false);
  final ValueNotifier<bool> _isOpenSave = ValueNotifier(false);

  bool _break = false;

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
        onTap: () {
          if (_isOpenEdit.value) {
            _editEdgeOne.value = const EdgeInsets.only(top: 0);
            _editEdgeTwo.value = const EdgeInsets.only(top: 0);
            _editEdgeThree.value = const EdgeInsets.only(top: 0);
            _isOpenEdit.value = false;
          }
          if (_isOpenSave.value) {
            _saveEdgeOne.value = const EdgeInsets.only(top: 0);
            _saveEdgeTwo.value = const EdgeInsets.only(top: 0);
            _isOpenSave.value = false;
          }
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: Global().allItinerary,
            builder:
                (BuildContext context, List<Itinerary> value, Widget? child) {
              final Map<int, int> _point = <int, int>{
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
                          .allItinerary
                          .value[widget.index]
                          .interestPoint!
                          .length;
                  i++) {
                _point[Global()
                    .allItinerary
                    .value[widget.index]
                    .interestPoint![i]
                    .typology] = _point[Global()
                        .allItinerary
                        .value[widget.index]
                        .interestPoint![i]
                        .typology]! +
                    1;
              }

              return Stack(
                children: [
                  Hero(
                      tag: widget.tag,
                      flightShuttleBuilder: (
                        BuildContext flightContext,
                        Animation<double> animation,
                        HeroFlightDirection flightDirection,
                        BuildContext fromHeroContext,
                        BuildContext toHeroContext,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                SizeConfig().borderRadiusFourteen)),
                            image: DecorationImage(
                              image: AssetImage(widget.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(widget.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollViewController,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig().paddingTwenty * 7,
                                          left: SizeConfig().paddingThirty,
                                          right: SizeConfig().paddingThirty),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(SizeConfig()
                                                        .borderRadiusFourteen))),
                                            padding: EdgeInsets.only(
                                                left: SizeConfig().paddingFive *
                                                    1.7,
                                                right:
                                                    SizeConfig().paddingFive *
                                                        1.7,
                                                top: SizeConfig().paddingFive,
                                                bottom:
                                                    SizeConfig().paddingFive *
                                                        1.7),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        value[widget.index]
                                                            .name!
                                                            .capitalizeFirstOfEach,
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withAlpha(230),
                                                            fontSize:
                                                                SizeConfig()
                                                                    .h1FontSize,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig().paddingFive /
                                                          2,
                                                ),
                                                _generateStar(false, 0)
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig().paddingThirty,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(SizeConfig()
                                                        .borderRadiusFourteen))),
                                            padding: EdgeInsets.only(
                                                left: SizeConfig().paddingFive *
                                                    1.5,
                                                right:
                                                    SizeConfig().paddingFive *
                                                        1.5,
                                                top: SizeConfig().paddingFive *
                                                    1.5,
                                                bottom:
                                                    SizeConfig().paddingFive *
                                                        1.5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Ionicons.walk,
                                                      size:
                                                          SizeConfig().iconSize,
                                                      color: Colors.white
                                                          .withAlpha(200),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig()
                                                              .paddingFive /
                                                          2,
                                                    ),
                                                    Text(
                                                      value[widget.index]
                                                              .distance
                                                              .toString() +
                                                          ' km',
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withAlpha(200),
                                                          fontSize: SizeConfig()
                                                              .h4FontSize,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: SizeConfig()
                                                      .paddingTwentyFive,
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Ionicons.stopwatch,
                                                      size:
                                                          SizeConfig().iconSize,
                                                      color: Colors.white
                                                          .withAlpha(200),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig()
                                                              .paddingFive /
                                                          2,
                                                    ),
                                                    Text(
                                                      Itinerary.convertMsToHuman(
                                                          value[widget.index]
                                                                  .deltaTime! *
                                                              60 *
                                                              1000),
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withAlpha(200),
                                                          fontSize: SizeConfig()
                                                              .h4FontSize,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: SizeConfig()
                                                      .paddingTwentyFive,
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Ionicons.podium,
                                                      size:
                                                          SizeConfig().iconSize,
                                                      color: Colors.white
                                                          .withAlpha(200),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig()
                                                              .paddingFive /
                                                          2,
                                                    ),
                                                    Text(
                                                      Itinerary().getLevelTitle(
                                                          value[widget.index]
                                                              .level!),
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withAlpha(200),
                                                          fontSize: SizeConfig()
                                                              .h4FontSize,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (value[widget.index]
                                              .description!
                                              .isNotEmpty)
                                            SizedBox(
                                              height:
                                                  SizeConfig().paddingTwenty,
                                            ),
                                          if (value[widget.index]
                                              .description!
                                              .isNotEmpty)
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(SizeConfig()
                                                          .borderRadiusFourteen))),
                                              padding: EdgeInsets.only(
                                                  left:
                                                      SizeConfig().paddingFive *
                                                          1.5,
                                                  right:
                                                      SizeConfig().paddingFive *
                                                          1.5,
                                                  top: SizeConfig().paddingFive,
                                                  bottom:
                                                      SizeConfig().paddingFive),
                                              child: ReadMoreText(
                                                value[widget.index]
                                                    .description!,
                                                trimLines: 4,
                                                style: TextStyle(
                                                  fontSize:
                                                      SizeConfig().h3FontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                                      .withAlpha(200),
                                                ),
                                                colorClickableText:
                                                    Colors.white.withAlpha(200),
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: '(Espandi)',
                                                trimExpandedText: '(Riduci)',
                                              ),
                                            ),
                                          SizedBox(
                                            height: SizeConfig().paddingTwenty,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black38,
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            SizeConfig()
                                                                .borderRadiusTwelve))),
                                                padding: EdgeInsets.only(
                                                    left: SizeConfig()
                                                            .paddingFive *
                                                        1.5,
                                                    right: SizeConfig()
                                                            .paddingFive *
                                                        1.5,
                                                    top: SizeConfig()
                                                        .paddingFive,
                                                    bottom: SizeConfig()
                                                        .paddingFive),
                                                child: Text(
                                                  'Punti di Interesse',
                                                  style: TextStyle(
                                                    fontSize:
                                                        SizeConfig().h3FontSize,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                        .withAlpha(200),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    SizeConfig().paddingFive *
                                                        1.5,
                                              ),
                                              CustomBounce(
                                                duration: const Duration(
                                                    milliseconds: 100),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              DrawInterestPointPage(
                                                                  editModeOn:
                                                                      true,
                                                                  itinerary:
                                                                      value[widget
                                                                          .index])))
                                                      .then((value) =>
                                                          Global().itinerary =
                                                              Itinerary());
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      SizeConfig().paddingFive *
                                                          1.20),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black38,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Icon(
                                                    value[widget.index]
                                                            .interestPoint!
                                                            .isEmpty
                                                        ? Ionicons.add_outline
                                                        : Icons.edit_outlined,
                                                    color: Colors.white70,
                                                    size:
                                                        SizeConfig().iconSize /
                                                            1.2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: SizeConfig().paddingFifteen,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig().paddingTwentyFive * 3.2,
                                      child: ListView.builder(
                                        itemCount: value[widget.index]
                                            .interestPoint
                                            ?.length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(
                                            left: SizeConfig().paddingThirty,
                                            right: SizeConfig().paddingThirty),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return _interestPointCard(
                                              index, _point);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig().paddingTwenty,
                                    ),
                                    if (value[widget.index].reviews!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig().paddingThirty,
                                            right: SizeConfig().paddingThirty),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(SizeConfig()
                                                          .borderRadiusTwelve))),
                                              padding: EdgeInsets.only(
                                                  left:
                                                      SizeConfig().paddingFive *
                                                          1.5,
                                                  right:
                                                      SizeConfig().paddingFive *
                                                          1.5,
                                                  top: SizeConfig().paddingFive,
                                                  bottom:
                                                      SizeConfig().paddingFive),
                                              child: Text(
                                                'Recensioni',
                                                style: TextStyle(
                                                  fontSize:
                                                      SizeConfig().h3FontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                                      .withAlpha(200),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (value[widget.index].reviews!.isNotEmpty)
                                      SizedBox(
                                        height: SizeConfig().paddingFifteen,
                                      ),
                                    SizedBox(
                                      height:
                                          SizeConfig().paddingTwentyFive * 4.5,
                                      child: ListView.builder(
                                        itemCount:
                                            value[widget.index].reviews?.length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(
                                            left: SizeConfig().paddingThirty,
                                            right: SizeConfig().paddingThirty),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return _reviewCard(index);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig().paddingTwentyFive * 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  AnimatedOpacity(
                    opacity: _showAppbar ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Stack(
                      children: [
                        if (Global()
                                .allItinerary
                                .value[widget.index]
                                .route!
                                .isNotEmpty &&
                            Global().allItinerary.value[widget.index].fkIdKey !=
                                Global().myUser.value.id)
                          Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.only(
                                  top: SizeConfig().paddingThirty * 1.5,
                                  right: SizeConfig().paddingFive * 17.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomBounce(
                                    duration: const Duration(milliseconds: 100),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                            builder: (context) => DrawRoutePage(
                                              editModeOn: false,
                                              itinerary: value[widget.index],
                                              onCreate: false,
                                            ),
                                          ))
                                          .then((value) =>
                                              Global().itinerary = Itinerary());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          SizeConfig().paddingFive * 1.35),
                                      decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Icon(
                                        Ionicons.map_outline,
                                        color: Colors.white70,
                                        size: SizeConfig().iconSize / 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(
                                top: SizeConfig().paddingThirty * 1.5,
                                right: SizeConfig().paddingFive * 9.5),
                            child: ValueListenableBuilder(
                              valueListenable: _isOpenSave,
                              builder: (BuildContext context, bool isOpenSave,
                                  Widget? child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      children: [
                                        AnimatedOpacity(
                                          opacity: isOpenSave ? 1 : 0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: CustomBounce(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            onPressed: () async {
                                              _saveEdgeOne.value =
                                                  const EdgeInsets.only(top: 0);
                                              _saveEdgeTwo.value =
                                                  const EdgeInsets.only(top: 0);
                                              _editEdgeThree.value =
                                                  const EdgeInsets.only(top: 0);
                                              _isOpenSave.value = false;
                                              if (_isOpenEdit.value) {
                                                _editEdgeOne.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeTwo.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _isOpenEdit.value = false;
                                              }
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300),
                                                  () async {
                                                await ItineraryController()
                                                    .exportPdf(
                                                        value[widget.index],
                                                        context);
                                              });
                                            },
                                            child: ValueListenableBuilder(
                                              valueListenable: _saveEdgeOne,
                                              builder: (BuildContext context,
                                                  EdgeInsets saveEdgeOne,
                                                  Widget? child) {
                                                return AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  padding: saveEdgeOne,
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: SizeConfig()
                                                                  .paddingFive *
                                                              1.55,
                                                          bottom: SizeConfig()
                                                                  .paddingFive *
                                                              1.55,
                                                          right: SizeConfig()
                                                                  .paddingFive *
                                                              1.40,
                                                          left: SizeConfig()
                                                                  .paddingFive *
                                                              1.40),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black45,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Text(
                                                        'PDF',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: SizeConfig()
                                                                    .h4FontSize /
                                                                1.3,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        if (Global()
                                            .allItinerary
                                            .value[widget.index]
                                            .route!
                                            .isNotEmpty)
                                          AnimatedOpacity(
                                            opacity: isOpenSave ? 1 : 0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: CustomBounce(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              onPressed: () async {
                                                _saveEdgeOne.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _saveEdgeTwo.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeThree.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _isOpenSave.value = false;
                                                if (_isOpenEdit.value) {
                                                  _editEdgeOne.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _editEdgeTwo.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _isOpenEdit.value = false;
                                                }
                                                await ItineraryController()
                                                    .exportGpx(
                                                        value[widget.index]
                                                            .route!,
                                                        value[widget.index]
                                                            .name!,
                                                        context);
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: _saveEdgeTwo,
                                                builder: (BuildContext context,
                                                    EdgeInsets saveEdgeTwo,
                                                    Widget? child) {
                                                  return AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    padding: saveEdgeTwo,
                                                    child: Container(
                                                        padding: EdgeInsets.only(
                                                            top: SizeConfig()
                                                                    .paddingFive *
                                                                1.55,
                                                            bottom: SizeConfig()
                                                                    .paddingFive *
                                                                1.55,
                                                            right: SizeConfig()
                                                                    .paddingFive *
                                                                1.10,
                                                            left: SizeConfig()
                                                                    .paddingFive *
                                                                1.10),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.black45,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: Text(
                                                          'GPX',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: SizeConfig()
                                                                      .h4FontSize /
                                                                  1.3,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        CustomBounce(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          onPressed: () {
                                            if (_isOpenSave.value) {
                                              _saveEdgeOne.value =
                                                  const EdgeInsets.only(top: 0);
                                              _saveEdgeTwo.value =
                                                  const EdgeInsets.only(top: 0);
                                              _isOpenSave.value = false;
                                            } else {
                                              _saveEdgeTwo.value =
                                                  EdgeInsets.only(
                                                      top: SizeConfig()
                                                              .paddingThirty *
                                                          2.86);
                                              _saveEdgeOne.value =
                                                  EdgeInsets.only(
                                                      top: SizeConfig()
                                                              .paddingThirty *
                                                          1.43);
                                              _isOpenSave.value = true;
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                SizeConfig().paddingFive *
                                                    1.35),
                                            decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Icon(
                                              isOpenSave
                                                  ? Ionicons.arrow_up_outline
                                                  : Ionicons.save_outline,
                                              color: Colors.white70,
                                              size: SizeConfig().iconSize / 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            )),
                        if (value[widget.index].fkIdKey !=
                            Global().myUser.value.id)
                          Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.only(
                                  top: SizeConfig().paddingThirty * 1.5,
                                  right: SizeConfig().paddingFive * 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomBounce(
                                    duration: const Duration(milliseconds: 100),
                                    onPressed: () async {
                                      await RoomController().startChat(
                                          await UserController().getUser(
                                              value[widget.index].fkIdKey!),
                                          context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          SizeConfig().paddingFive * 1.35),
                                      decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Icon(
                                        Ionicons.chatbubble_outline,
                                        color: Colors.white70,
                                        size: SizeConfig().iconSize / 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        if (value[widget.index].fkIdKey ==
                            Global().myUser.value.id)
                          Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.only(
                                  top: SizeConfig().paddingThirty * 1.5,
                                  right: SizeConfig().paddingFive * 2),
                              child: ValueListenableBuilder(
                                valueListenable: _isOpenEdit,
                                builder: (BuildContext context, bool isOpenEdit,
                                    Widget? child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Stack(
                                        children: [
                                          AnimatedOpacity(
                                            opacity: isOpenEdit ? 1 : 0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: CustomBounce(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              onPressed: () {
                                                _editEdgeOne.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeTwo.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeThree.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _isOpenEdit.value = false;
                                                if (_isOpenSave.value) {
                                                  _saveEdgeOne.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _saveEdgeTwo.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _isOpenSave.value = false;
                                                }
                                                Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditItineraryPage(
                                                            index: widget.index,
                                                            isMy: false),
                                                  ),
                                                )
                                                    .then((value) {
                                                  Global().itinerary =
                                                      Itinerary();
                                                  if (mounted) {
                                                    setState(() {
                                                      Global()
                                                          .allItinerary
                                                          .value;
                                                    });
                                                  }
                                                });
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: _editEdgeOne,
                                                builder: (BuildContext context,
                                                    EdgeInsets editEdgeOne,
                                                    Widget? child) {
                                                  return AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    padding: editEdgeOne,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          SizeConfig()
                                                                  .paddingFive *
                                                              1.35),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black45,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Icon(
                                                        Ionicons
                                                            .document_text_outline,
                                                        color: Colors.white70,
                                                        size: SizeConfig()
                                                                .iconSize /
                                                            1.2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          AnimatedOpacity(
                                            opacity: isOpenEdit ? 1 : 0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: CustomBounce(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              onPressed: () {
                                                _editEdgeOne.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeTwo.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeThree.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _isOpenEdit.value = false;
                                                if (_isOpenSave.value) {
                                                  _saveEdgeOne.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _saveEdgeTwo.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _isOpenSave.value = false;
                                                }
                                                Navigator.of(context)
                                                    .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DrawRoutePage(
                                                          editModeOn: true,
                                                          itinerary: value[
                                                              widget.index],
                                                          onCreate: false,
                                                        ),
                                                      ),
                                                    )
                                                    .then((value) =>
                                                        Global().itinerary =
                                                            Itinerary());
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: _editEdgeTwo,
                                                builder: (BuildContext context,
                                                    EdgeInsets editEdgeTwo,
                                                    Widget? child) {
                                                  return AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    padding: editEdgeTwo,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          SizeConfig()
                                                                  .paddingFive *
                                                              1.35),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black45,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Icon(
                                                        Ionicons.map_outline,
                                                        color: Colors.white70,
                                                        size: SizeConfig()
                                                                .iconSize /
                                                            1.2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          AnimatedOpacity(
                                            opacity: isOpenEdit ? 1 : 0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: CustomBounce(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              onPressed: () async {
                                                _editEdgeOne.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeTwo.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeThree.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _isOpenEdit.value = false;
                                                if (_isOpenSave.value) {
                                                  _saveEdgeOne.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _saveEdgeTwo.value =
                                                      const EdgeInsets.only(
                                                          top: 0);
                                                  _isOpenSave.value = false;
                                                }
                                                await ItineraryController()
                                                    .deleteItinerary(
                                                        context,
                                                        value[widget.index]
                                                            .idItinerary!);
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: _editEdgeThree,
                                                builder: (BuildContext context,
                                                    EdgeInsets editEdgeThree,
                                                    Widget? child) {
                                                  return AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    padding: editEdgeThree,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          SizeConfig()
                                                                  .paddingFive *
                                                              1.35),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black45,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Icon(
                                                        Ionicons.trash_outline,
                                                        color: Colors.white70,
                                                        size: SizeConfig()
                                                                .iconSize /
                                                            1.2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          CustomBounce(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            onPressed: () {
                                              if (_isOpenEdit.value) {
                                                _editEdgeOne.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeTwo.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _editEdgeThree.value =
                                                    const EdgeInsets.only(
                                                        top: 0);
                                                _isOpenEdit.value = false;
                                              } else {
                                                _editEdgeThree.value =
                                                    EdgeInsets.only(
                                                        top: SizeConfig()
                                                                .paddingThirty *
                                                            4.29);
                                                _editEdgeTwo.value =
                                                    EdgeInsets.only(
                                                        top: SizeConfig()
                                                                .paddingThirty *
                                                            2.86);
                                                _editEdgeOne.value =
                                                    EdgeInsets.only(
                                                        top: SizeConfig()
                                                                .paddingThirty *
                                                            1.43);
                                                _isOpenEdit.value = true;
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  SizeConfig().paddingFive *
                                                      1.35),
                                              decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Icon(
                                                isOpenEdit
                                                    ? Ionicons.close_outline
                                                    : Icons.edit_outlined,
                                                color: Colors.white70,
                                                size:
                                                    SizeConfig().iconSize / 1.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              )),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.only(
                                  top: SizeConfig().paddingThirty * 1.5,
                                  left: SizeConfig().paddingFive * 2),
                              child: Container(
                                padding:
                                    EdgeInsets.all(SizeConfig().paddingFive),
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Ionicons.arrow_back_outline,
                                  color: Colors.white70,
                                  size: SizeConfig().iconSize,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget _interestPointCard(int index, Map<int, int> _point) {
    int _id = Global()
        .allItinerary
        .value[widget.index]
        .interestPoint![index]
        .typology;

    if (_point[_id]! < 2 ||
        (index > 0 &&
            _id !=
                Global()
                    .allItinerary
                    .value[widget.index]
                    .interestPoint![index - 1]
                    .typology)) {
      _break = false;
    }

    if (!_break) {
      if (_point[_id]! > 1) {
        _break = true;
      } else {
        _break = false;
      }
      return Padding(
        padding: EdgeInsets.only(right: SizeConfig().paddingFive * 2),
        child: CustomBounce(
          duration: const Duration(milliseconds: 100),
          onPressed: () {},
          child: Container(
            width: SizeConfig().paddingThirty * 4.5,
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig().borderRadiusFourteen))),
            padding: EdgeInsets.only(
                left: SizeConfig().paddingFive * 1.5,
                right: SizeConfig().paddingFive * 1.5,
                bottom: SizeConfig().paddingFive),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/interest_point/' +
                                Global()
                                    .allItinerary
                                    .value[widget.index]
                                    .interestPoint![index]
                                    .typology
                                    .toString() +
                                '.png',
                            width: SizeConfig().paddingTwenty * 1.85,
                            height: SizeConfig().paddingTwenty * 1.85,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig().paddingFive / 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          InterestPoint().getInterestPointTitle(Global()
                              .allItinerary
                              .value[widget.index]
                              .interestPoint![index]
                              .typology),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                              fontSize: SizeConfig().h4FontSize / 1.2),
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
    } else {
      if (_point[_id]! > 1) {
        _break = true;
      } else {
        _break = false;
      }
      return Container();
    }
  }

  Widget _reviewCard(int index) {
    final ValueNotifier<bool> _isPressedText = ValueNotifier(false);

    return Padding(
      padding: EdgeInsets.only(right: SizeConfig().paddingFive * 2),
      child: Container(
        width: SizeConfig().paddingThirty * 10,
        decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig().borderRadiusFourteen))),
        padding: EdgeInsets.only(
            left: SizeConfig().paddingFive * 1.5,
            right: SizeConfig().paddingFive * 1.5,
            top: SizeConfig().paddingFive,
            bottom: SizeConfig().paddingFive),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _isPressedText,
              builder: (BuildContext context, bool value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onLongPressStart: (value) {
                          _isPressedText.value = true;
                        },
                        onLongPressEnd: (value) {
                          _isPressedText.value = false;
                        },
                        child: Text(
                          Global()
                              .allItinerary
                              .value[widget.index]
                              .reviews![index]
                              .title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontSize: SizeConfig().h3FontSize),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: value ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Visibility(
                          visible: !value, child: _generateStar(true, index)),
                    )
                  ],
                );
              },
            ),
            SizedBox(
              height: SizeConfig().paddingFive,
            ),
            Text(
              Global().allItinerary.value[widget.index].reviews![index].body,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black45,
                  fontSize: SizeConfig().h4FontSize / 1.05),
            )
          ],
        ),
      ),
    );
  }

  Widget _generateStar(bool isSingle, int index) {
    double value = 0;

    if (isSingle) {
      value = Global().allItinerary.value[widget.index].reviews![index].star;
    } else {
      for (int i = 0;
          i < Global().allItinerary.value[widget.index].reviews!.length;
          i++) {
        value += Global().allItinerary.value[widget.index].reviews![i].star;
      }
      value /= Global().allItinerary.value[widget.index].reviews!.length;
    }

    if (value.toString() == 'NaN') {
      value = 0;
    }

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
              : Colors.black26,
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
              : Colors.black26,
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
              : Colors.black26,
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
              : Colors.black26,
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
              : Colors.black26,
          size: SizeConfig().iconSizeOne / 1.4,
        ),
        SizedBox(
          width: SizeConfig().paddingFive,
        ),
        Visibility(
          visible: !isSingle,
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: SizeConfig().h4FontSize / 1.3,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(230),
            ),
          ),
        ),
      ],
    );
  }
}

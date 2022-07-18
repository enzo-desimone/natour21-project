import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/itinerary_controller.dart';
import 'package:natour21/Entity_Class/interest_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../Accessory_Class/global_variable.dart';
import '../../../Accessory_GUI/boucing_animation.dart';
import '../../../Entity_Class/itinerary.dart';

class DrawInterestPointPage extends StatefulWidget {
  const DrawInterestPointPage(
      {Key? key, required this.editModeOn, this.itinerary})
      : super(key: key);

  final bool editModeOn;
  final Itinerary? itinerary;

  @override
  State<DrawInterestPointPage> createState() => _DrawInterestPointPageState();
}

class _DrawInterestPointPageState extends State<DrawInterestPointPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final ValueNotifier<bool> _isDone = ValueNotifier(false);
  final List<BitmapDescriptor> _icons = [];
  late SharedPreferences _save;
  final Set<Marker> _markers = {};
  Set<Polyline> _polyline = {};
  late TutorialCoachMark tutorial;
  CameraPosition? _initialPosition;
  BitmapDescriptor? _selectIcon;
  int? _selectInterestPoint;
  bool _isFirst = false;
  GlobalKey keyButton = GlobalKey();
  List<TargetFocus> targets = <TargetFocus>[];

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    _save = await SharedPreferences.getInstance();

    setState(() {
      _isFirst = _save.getBool('tutorialSaveInt') ?? true;
    });

    initTargets();
    if (widget.itinerary != null) {
      Global().itinerary = widget.itinerary!;
    }

    for (int i = 1; i < 11; i++) {
      _icons.add(await getBitmapDescriptorFromAssetBytes(
          'assets/images/markers/' + i.toString() + '.png', 110));
    }

    Set<Marker> _interestPoint =
        await ItineraryController().getInterestPointMarkers();
    List _temp = await ItineraryController().getRouteMarkers();

    if (_temp[0].isNotEmpty) {
      _polyline = _temp[1];
      if (_interestPoint.isNotEmpty) {
        for (int i = 0; i < Global().itinerary.interestPoint!.length; i++) {
          _markers.add(Marker(
            markerId: MarkerId(LatLng(Global().itinerary.interestPoint![i].phi,
                    Global().itinerary.interestPoint![i].lambda)
                .toString()),
            position: LatLng(Global().itinerary.interestPoint![i].phi,
                Global().itinerary.interestPoint![i].lambda),
            visible: true,
            infoWindow: InfoWindow(
              title: InterestPoint().getInterestPointTitle(
                  (Global().itinerary.interestPoint![i].typology)),
              snippet: 'Clicca per eliminare',
              onTap: () {
                for (int j = 0; j < _markers.length; j++) {
                  if (_markers.elementAt(j).markerId.value ==
                      LatLng(Global().itinerary.interestPoint![i].phi,
                              Global().itinerary.interestPoint![i].lambda)
                          .toString()) {
                    if (mounted) {
                      setState(() {
                        _markers.remove(_markers.elementAt(j));
                      });
                    }
                  }
                }
              },
            ),
            icon: await getBitmapDescriptorFromAssetBytes(
                'assets/images/markers/' +
                    Global().itinerary.interestPoint![i].typology.toString() +
                    '.png',
                110),
          ));
        }
      }
      if (mounted) {
        setState(() {
          _initialPosition = CameraPosition(
            target: LatLng(_polyline.elementAt(0).points[0].latitude,
                _polyline.elementAt(0).points[0].longitude),
            zoom: 16,
          );
        });
      }
    } else {
      if (_interestPoint.isNotEmpty) {
        for (int i = 0; i < Global().itinerary.interestPoint!.length; i++) {
          _markers.add(Marker(
            markerId: MarkerId(LatLng(Global().itinerary.interestPoint![i].phi,
                    Global().itinerary.interestPoint![i].lambda)
                .toString()),
            position: LatLng(Global().itinerary.interestPoint![i].phi,
                Global().itinerary.interestPoint![i].lambda),
            visible: true,
            infoWindow: InfoWindow(
              title: InterestPoint().getInterestPointTitle(
                  (Global().itinerary.interestPoint![i].typology)),
              snippet: 'Clicca per eliminare',
              onTap: () {
                for (int j = 0; j < _markers.length; j++) {
                  if (_markers.elementAt(j).markerId.value ==
                      LatLng(Global().itinerary.interestPoint![i].phi,
                              Global().itinerary.interestPoint![i].lambda)
                          .toString()) {
                    if (mounted) {
                      setState(() {
                        _markers.remove(_markers.elementAt(j));
                      });
                    }
                  }
                }
              },
            ),
            icon: await getBitmapDescriptorFromAssetBytes(
                'assets/images/markers/' +
                    Global().itinerary.interestPoint![i].typology.toString() +
                    '.png',
                110),
          ));
        }
        if (mounted) {
          setState(() {
            _initialPosition = CameraPosition(
              target: LatLng(_markers.elementAt(0).position.latitude,
                  _markers.elementAt(0).position.longitude),
              zoom: 15,
            );
          });
        }
      } else {
        bool _permissionGranted;
        LocationPermission permission;
        Position? _locationData;

        _permissionGranted = await Geolocator.isLocationServiceEnabled();
        if (!_permissionGranted) {
          CustomAlertDialog(
            barrierDismissible: false,
            declineButton: false,
            title: 'Attenzione',
            body:
                'Non è possibile utilizzare questa funzionalità, abilitare il servizio di geolocalizzazione',
            titleConfirmButton: 'Ok',
            onPressConfirm: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ).showCustomDialog(context);
          return;
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            CustomAlertDialog(
              barrierDismissible: false,
              declineButton: false,
              title: 'Attenzione',
              body:
                  'Non è possibile utilizzare questa funzionalità senza aver dato i permessi per la localizzazione',
              titleConfirmButton: 'Ok',
              onPressConfirm: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ).showCustomDialog(context);
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          CustomAlertDialog(
            barrierDismissible: false,
            declineButton: false,
            title: 'Attenzione',
            body:
                'Non è possibile utilizzare questa funzionalità senza aver dato i permessi per la localizzazione',
            titleConfirmButton: 'Ok',
            onPressConfirm: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ).showCustomDialog(context);
          return;
        }

        _locationData = await Geolocator.getCurrentPosition();

        if (mounted) {
          setState(() {
            _initialPosition = CameraPosition(
              target: LatLng(_locationData?.latitude ?? 40.7967876,
                  _locationData?.longitude ?? 14.0716307),
              zoom: _locationData?.latitude == null ? 6 : 15,
            );
          });
        }
      }
    }
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyButton,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tieni premuto per posizionare \nun punto di interesse sulla mappa",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig().h2FontSize),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _initialPosition;
        });
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: white,
          automaticallyImplyLeading: false,
          elevation: 0,
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
              Flexible(
                child: Text(
                  'Punti di Interesse',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig().h2FontSize,
                      color: black),
                ),
              ),
            ],
          ),
        ),
        body: _initialPosition == null
            ? Container()
            : Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: _initialPosition!,
                    markers: _markers,
                    polylines: _polyline,
                    onMapCreated: (GoogleMapController controller) {
                      if (mounted) {
                        setState(() {
                          _controller.complete(controller);
                        });
                      }
                    },
                    onCameraMoveStarted: () async {
                      if (_isFirst) {
                        await _showTutorial();
                      }
                    },
                    onTap: (coordinate) async {
                      if (_isFirst) {
                        await _showTutorial();
                      }
                    },
                    onLongPress: (coordinate) async {
                      if (_isFirst) {
                        await _showTutorial();
                      }
                      HapticFeedback.vibrate();
                      if (_selectIcon == null) {
                        _dialog();
                      } else {
                        _markers.add(Marker(
                            markerId: MarkerId(coordinate.toString()),
                            position: coordinate,
                            icon: _selectIcon!,
                            infoWindow: InfoWindow(
                                title: InterestPoint().getInterestPointTitle(
                                    _selectInterestPoint!),
                                snippet: 'Clicca per eliminare',
                                onTap: () {
                                  for (int i = 0; i < _markers.length; i++) {
                                    if (_markers.elementAt(i).markerId.value ==
                                        coordinate.toString()) {
                                      if (mounted) {
                                        setState(() {
                                          _markers
                                              .remove(_markers.elementAt(i));
                                        });
                                      }
                                    }
                                  }
                                })));
                        if (mounted) {
                          setState(() {
                            _markers;
                          });
                        }
                      }
                    },
                  ),
                  if (!_controller.isCompleted)
                    Container(
                      color: Colors.white,
                    ),
                ],
              ),
        floatingActionButton: _isFirst
            ? Container(
                key: keyButton,
                child: Image.asset(
                  'assets/images/markers/6.png',
                  width: 50,
                  height: 50,
                ))
            : ValueListenableBuilder(
                valueListenable: _isDone,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig().paddingFive * 1.2,
                        right: SizeConfig().paddingFive * 1.2,
                        top: SizeConfig().paddingFive * 2,
                        bottom: SizeConfig().paddingFive * 2),
                    decoration: BoxDecoration(
                        color: mainColor.withAlpha(235),
                        borderRadius: BorderRadius.all(Radius.circular(
                            SizeConfig().borderRadiusFourteen))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            _dialog();
                          },
                          child: Container(
                            padding:
                                EdgeInsets.all(SizeConfig().paddingFive * 1.5),
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Ionicons.list_outline,
                              color: Colors.black87,
                              size: SizeConfig().iconSize,
                            ),
                          ),
                        ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: _markers.isNotEmpty
                              ? () {
                                  if (mounted) {
                                    setState(() {
                                      _markers.remove(_markers
                                          .elementAt(_markers.length - 1));
                                    });
                                  }
                                }
                              : () {},
                          child: Container(
                              padding: EdgeInsets.only(
                                top: SizeConfig().paddingFifteen,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(
                                    SizeConfig().paddingFive * 1.5),
                                decoration: BoxDecoration(
                                    color: _markers.isNotEmpty
                                        ? Colors.white70
                                        : Colors.white30,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Ionicons.arrow_undo_outline,
                                  color: _markers.isNotEmpty
                                      ? Colors.black87
                                      : Colors.black12,
                                  size: SizeConfig().iconSize,
                                ),
                              )),
                        ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: _markers.isNotEmpty
                              ? () async {
                                  await ItineraryController()
                                      .confirmInterestPoint(_markers);
                                  if (widget.editModeOn) {
                                    if (await ItineraryController()
                                        .editItineraryRoute(context)) {
                                      await Global.analytics.logEvent(
                                        name: 'edit_interest_point_event',
                                        parameters: <String, dynamic>{
                                          'user': Global().myUser.value.id,
                                        },
                                      );
                                      CustomAlertDialog(
                                          title: 'Congratulazioni',
                                          body:
                                              'La modifica dei punti di interesse è stata correttamente effettuata.',
                                          titleConfirmButton: 'Chiudi',
                                          onPressConfirm: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }).showCustomDialog(context);
                                    } else {
                                      CustomAlertDialog(
                                          title: 'Attenzione',
                                          body:
                                              'Non è stato possibile modificare i punti di interesse.',
                                          titleConfirmButton: 'Chiudi',
                                          onPressConfirm: () {
                                            Navigator.pop(context);
                                          }).showCustomDialog(context);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              : () {
                                  CustomAlertDialog(
                                      title: 'Attenzione',
                                      body:
                                          'Sei sicuro di non voler inserire nessun punto di interesse?',
                                      titleConfirmButton: 'No',
                                      titleDeclineButton: 'Si',
                                      declineButton: true,
                                      onPressConfirm: () =>
                                          Navigator.of(context).pop(),
                                      onPressDecline: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      }).showCustomDialog(context);
                                },
                          child: Container(
                              padding: EdgeInsets.only(
                                top: SizeConfig().paddingFifteen,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(
                                    SizeConfig().paddingFive * 1.5),
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Ionicons.checkmark_outline,
                                  color: Colors.black87,
                                  size: SizeConfig().iconSize,
                                ),
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _showTutorial() async {
    tutorial = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.black12,
        textSkip: 'Chiudi', onFinish: () {
      if (mounted) {
        setState(() {
          _isFirst = false;
        });
        _save.setBool('tutorialSaveInt', false);
      }
    }, onClickTarget: (target) {
      if (mounted) {
        setState(() {
          _isFirst = false;
        });
      }
      _save.setBool('tutorialSaveInt', false);
    }, onSkip: () {
      if (mounted) {
        setState(() {
          _isFirst = false;
        });
      }
      _save.setBool('tutorialSaveInt', false);
    })
      ..show();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  void _dialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusTwelve),
              ),
              title: Text(
                'Punti di Interesse',
                style: TextStyle(
                    color: black, fontSize: SizeConfig().h1FontSize / 1.35),
              ),
              children: <Widget>[
                _dialogOption(1, InterestPoint().getInterestPointTitle(1)),
                _dialogOption(2, InterestPoint().getInterestPointTitle(2)),
                _dialogOption(3, InterestPoint().getInterestPointTitle(3)),
                _dialogOption(4, InterestPoint().getInterestPointTitle(4)),
                _dialogOption(5, InterestPoint().getInterestPointTitle(5)),
                _dialogOption(6, InterestPoint().getInterestPointTitle(6)),
                _dialogOption(7, InterestPoint().getInterestPointTitle(7)),
                _dialogOption(8, InterestPoint().getInterestPointTitle(8)),
                _dialogOption(9, InterestPoint().getInterestPointTitle(9)),
                _dialogOption(10, InterestPoint().getInterestPointTitle(10)),
              ]);
        });
  }

  Widget _dialogOption(int index, String title) {
    return SimpleDialogOption(
        onPressed: () async {
          Navigator.of(context).pop();
          _selectIcon = _icons[index - 1];
          _selectInterestPoint = index;
        },
        child: Row(
          children: [
            Image.asset(
              'assets/images/markers/' + index.toString() + '.png',
              width: SizeConfig().paddingThirty,
              height: SizeConfig().paddingThirty,
            ),
            SizedBox(
              width: SizeConfig().paddingFive,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: SizeConfig().h2FontSize,
                  color: _selectInterestPoint == null
                      ? Colors.grey[500]
                      : _selectInterestPoint == index
                          ? black
                          : Colors.grey[500],
                  fontWeight: _selectInterestPoint == null
                      ? FontWeight.w400
                      : _selectInterestPoint == index
                          ? FontWeight.w500
                          : FontWeight.w400),
            ),
          ],
        ));
  }
}

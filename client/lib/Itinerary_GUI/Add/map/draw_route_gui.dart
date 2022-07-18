import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/itinerary_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../../../Accessory_GUI/boucing_animation.dart';
import '../../../Accessory_GUI/custom_dialog.dart';
import '../../../Entity_Class/itinerary.dart';

class DrawRoutePage extends StatefulWidget {
  const DrawRoutePage(
      {Key? key,
      required this.editModeOn,
      required this.onCreate,
      this.itinerary})
      : super(key: key);

  final bool editModeOn;
  final bool onCreate;
  final Itinerary? itinerary;

  @override
  State<DrawRoutePage> createState() => _DrawRoutePageState();
}

class _DrawRoutePageState extends State<DrawRoutePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final ValueNotifier<bool> _isDone = ValueNotifier(false);

  late BitmapDescriptor _startMarker;
  late BitmapDescriptor _endMarker;
  late TutorialCoachMark tutorial;
  late SharedPreferences _save;

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  int _count = 0;
  bool _isFirst = false;
  CameraPosition? _initialPosition;

  GlobalKey keyButton = GlobalKey();
  List<TargetFocus> targets = <TargetFocus>[];

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _init() async {
    _save = await SharedPreferences.getInstance();
    setState(() {
      _isFirst = _save.getBool('tutorialSaveRoute') ?? true;
    });

    initTargets();
    if (widget.itinerary != null) {
      Global().itinerary = widget.itinerary!;
    }

    _startMarker = await getBitmapDescriptorFromAssetBytes(
        'assets/images/markers/start_marker.png', 110);

    _endMarker = await getBitmapDescriptorFromAssetBytes(
        'assets/images/markers/end_marker.png', 110);

    List _temp = await ItineraryController().getRouteMarkers();

    if (_temp[0].isNotEmpty) {
      _count = _temp[0].length;
      Set<Marker> _tempMarker = _temp[0];
      Set<Polyline> _tempPolyline = _temp[1];
      _markers = _tempMarker;
      _polylines = _tempPolyline;
      if (mounted) {
        setState(() {
          _initialPosition = CameraPosition(
            target: LatLng(_temp[0].elementAt(0).position.latitude,
                _temp[0].elementAt(0).position.longitude),
            zoom: 17,
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
                    "Tieni premuto per posizionare \nun segna posto sulla mappa",
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () async {
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
                  'Tracciato Geografico',
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
                    polylines: _polylines,
                    markers: _markers,
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
                    onLongPress: widget.editModeOn || widget.onCreate
                        ? (coordinate) async {
                            if (_isFirst) {
                              await _showTutorial();
                            }
                            _count++;
                            HapticFeedback.vibrate();
                            _markers.add(Marker(
                              markerId: MarkerId(coordinate.toString()),
                              position: coordinate,
                              icon: _count == 1 ? _startMarker : _endMarker,
                            ));
                            if (mounted) {
                              setState(() {
                                _markers;
                              });
                            }
                            if (_count != 1) {
                              drawLine(_count - 1, Colors.blue);
                            }
                          }
                        : (coordinate) {},
                  ),
                  if (!_controller.isCompleted)
                    Container(
                      color: Colors.white,
                    ),
                ],
              ),
        floatingActionButton: (!widget.editModeOn && !widget.onCreate)
            ? null
            : (_isFirst ? false : widget.editModeOn || widget.onCreate)
                ? ValueListenableBuilder(
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
                              onPressed: value
                                  ? () {
                                      if (mounted) {
                                        setState(() {
                                          _polylines.clear();
                                          _markers.clear();
                                        });
                                      }
                                      _isDone.value = false;
                                    }
                                  : () {
                                      if (_polylines.isNotEmpty) {
                                        if (mounted) {
                                          setState(() {
                                            _markers.remove(_markers.elementAt(
                                                _markers.length - 1));
                                            _polylines.remove(
                                                _polylines.elementAt(
                                                    _polylines.length - 1));
                                          });
                                        }

                                        if (_polylines.isNotEmpty) {
                                          var _temp = _markers
                                              .elementAt(_markers.length - 1);
                                          _markers.remove(_markers
                                              .elementAt(_markers.length - 1));

                                          if (mounted) {
                                            setState(() {
                                              _markers.add(
                                                Marker(
                                                    markerId: _temp.markerId,
                                                    visible: true,
                                                    position: _temp.position,
                                                    icon: BitmapDescriptor
                                                        .defaultMarkerWithHue(
                                                            BitmapDescriptor
                                                                .hueRed)),
                                              );
                                            });
                                          }
                                        }
                                        _count--;
                                      } else if (_markers.isNotEmpty) {
                                        if (mounted) {
                                          setState(() {
                                            _markers.remove(_markers.elementAt(
                                                _markers.length - 1));
                                            _count--;
                                          });
                                        }
                                      }
                                    },
                              child: Container(
                                padding: EdgeInsets.all(
                                    SizeConfig().paddingFive * 1.4),
                                decoration: BoxDecoration(
                                    color: _markers.isNotEmpty
                                        ? Colors.white70
                                        : Colors.white30,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  value
                                      ? Ionicons.trash_outline
                                      : Ionicons.arrow_undo_outline,
                                  color: _markers.isNotEmpty
                                      ? Colors.black87
                                      : Colors.black12,
                                  size: SizeConfig().iconSize,
                                ),
                              ),
                            ),
                            CustomBounce(
                              duration: const Duration(milliseconds: 100),
                              onPressed: _markers.length > 1
                                  ? !value
                                      ? () {
                                          Marker _start = _markers.elementAt(0);
                                          Marker _end = _markers
                                              .elementAt(_markers.length - 1);

                                          Set<Marker> _temp = {};

                                          for (int i = 0;
                                              i < _markers.length;
                                              i++) {
                                            if (i == 0) {
                                              _temp.add(_start);
                                            } else if (i ==
                                                _markers.length - 1) {
                                              _temp.add(_end);
                                            } else {
                                              _temp.add(Marker(
                                                markerId: MarkerId(_markers
                                                    .elementAt(i)
                                                    .position
                                                    .toString()),
                                                position: _markers
                                                    .elementAt(i)
                                                    .position,
                                                visible: false,
                                              ));
                                            }
                                          }
                                          if (mounted) {
                                            setState(() {
                                              _markers = _temp;
                                              _count = 0;
                                            });
                                          }
                                          _isDone.value = true;
                                        }
                                      : () async {
                                          await ItineraryController()
                                              .confirmRoute(_markers);
                                          if (widget.editModeOn) {
                                            if (await ItineraryController()
                                                .editItineraryRoute(context)) {
                                              CustomAlertDialog(
                                                  title: 'Congratulazioni',
                                                  body:
                                                      'La modifica del percorso geografico è stata correttamente effettuata.',
                                                  titleConfirmButton: 'Chiudi',
                                                  onPressConfirm: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }).showCustomDialog(context);
                                            } else {
                                              CustomAlertDialog(
                                                  title: 'Attenzione',
                                                  body:
                                                      'Non è stato possibile modificare il percorso geografico.',
                                                  titleConfirmButton: 'Chiudi',
                                                  onPressConfirm: () {
                                                    Navigator.pop(context);
                                                  }).showCustomDialog(context);
                                            }
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        }
                                  : () {},
                              child: Container(
                                  padding: EdgeInsets.only(
                                    top: SizeConfig().paddingFifteen,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        SizeConfig().paddingFive * 1.4),
                                    decoration: BoxDecoration(
                                        color: _markers.isNotEmpty
                                            ? Colors.white70
                                            : Colors.white30,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Icon(
                                      value
                                          ? Ionicons.arrow_forward_outline
                                          : Ionicons.checkmark_outline,
                                      color: _markers.isNotEmpty
                                          ? Colors.black87
                                          : Colors.black12,
                                      size: SizeConfig().iconSize,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    key: keyButton,
                    child: Image.asset(
                      'assets/images/markers/start_marker.png',
                      width: 50,
                      height: 50,
                    )));
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
        _save.setBool('tutorialSaveRoute', false);
      }
    }, onClickTarget: (target) {
      if (mounted) {
        setState(() {
          _isFirst = false;
        });
      }
      _save.setBool('tutorialSaveRoute', false);
    }, onSkip: () {
      if (mounted) {
        setState(() {
          _isFirst = false;
        });
      }
      _save.setBool('tutorialSaveRoute', false);
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

  void drawLine(int count, Color color) {
    if (mounted) {
      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId(getRandomString(30)),
          visible: true,
          width: 4,
          patterns: [PatternItem.dash(40), PatternItem.gap(0)],
          points: [
            _markers.elementAt(count - 1).position,
            _markers.elementAt(count).position
          ],
          color: color,
        ));
      });
    }
  }
}

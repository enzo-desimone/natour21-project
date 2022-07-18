import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/itinerary_controller.dart';
import '../../Accessory_GUI/boucing_animation.dart';
import 'map/draw_route_gui.dart';

class AddRouteStep extends StatefulWidget {
  const AddRouteStep({Key? key, required this.controller}) : super(key: key);

  final PageController controller;

  @override
  _AddRouteStepState createState() => _AddRouteStepState();
}

class _AddRouteStepState extends State<AddRouteStep> {
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
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollViewController,
          child: Center(
            child: Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig().paddingThirty * 4,
                    left: SizeConfig().paddingFifteen,
                    right: SizeConfig().paddingTwelve),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        AnimatedOpacity(
                          opacity: _showAppbar ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            'Tracciato',
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
                            Global().itinerary.route!.isEmpty
                                ? 'disegna o carica il percorso'
                                : 'visualizza, modifica o cancella il percorso',
                            style: TextStyle(
                                fontSize: SizeConfig().h2FontSize,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: _showAppbar ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: SizedBox(
                        height: SizeConfig().paddingThirty * 2,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const DrawRoutePage(
                                  editModeOn: false,
                                  onCreate: true,
                                ),
                              ),
                            )
                                .then((value) {
                              if (mounted) {
                                setState(() {
                                  Global().itinerary.route!;
                                });
                              }
                            });
                          },
                          child: Image.asset(
                            Global().itinerary.route!.isEmpty
                                ? 'assets/images/drawer_icon.png'
                                : 'assets/images/visibility_icon.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingThirty * 2,
                        ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: Global().itinerary.route!.isNotEmpty
                              ? () {
                                  ItineraryController()
                                      .deleteRoute()
                                      .then((value) {
                                    if (mounted) {
                                      setState(() {
                                        Global().itinerary.route!;
                                      });
                                    }
                                  });
                                }
                              : () async{

                                  ItineraryController()
                                      .importGpx(context)
                                      .then((value) {
                                    if (mounted) {
                                      setState(() {
                                        Global().itinerary.route!;
                                      });
                                    }
                                  });
                                },
                          child: Image.asset(
                            Global().itinerary.route!.isEmpty
                                ? 'assets/images/gpx_icon.png'
                                : 'assets/images/delete_icon.png',
                            width: 90,
                            height: 90,
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
      ),
    );
  }
}

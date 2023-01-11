import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_textfield.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../Accessory_GUI/boucing_animation.dart';
import '../../Accessory_GUI/custom_dialog.dart';
import '../../Controller/itinerary_controller.dart';

class EditItineraryPage extends StatefulWidget {
  const EditItineraryPage({Key? key, required this.index, required this.isMy})
      : super(key: key);
  final bool isMy;
  final int index;

  @override
  _EditItineraryPageState createState() => _EditItineraryPageState();
}

class _EditItineraryPageState extends State<EditItineraryPage> {
  late int _time;
  late double _distance;

  TextEditingController? _nameController;
  TextEditingController? _descriptionController;

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionKey = GlobalKey<FormState>();
  final ValueNotifier<Color> _levelColor = ValueNotifier(mainColor);
  final ValueNotifier<Color> _categoryColor = ValueNotifier(mainColor);
  final ValueNotifier<Color> _distanceColor = ValueNotifier(mainColor);
  final ValueNotifier<Color> _timeColor = ValueNotifier(mainColor);

  String _oldName = '';

  @override
  void initState() {
    if (widget.isMy) {
      Global().itinerary.setName(Global().myItinerary.value[widget.index].name!);
      Global().itinerary.setCategory(Global().myItinerary.value[widget.index].category!);
      Global().itinerary.setDescription(Global().myItinerary.value[widget.index].description!);
      Global().itinerary.setDistance(Global().myItinerary.value[widget.index].distance!);
      Global().itinerary.setFkIdKey(Global().myItinerary.value[widget.index].fkIdKey!);
      Global().itinerary.setIdItinerary(Global().myItinerary.value[widget.index].idItinerary!);
      Global().itinerary.setInterestPoint(Global().myItinerary.value[widget.index].interestPoint!);
      Global().itinerary.setLevel(Global().myItinerary.value[widget.index].level!);
      Global().itinerary.setReviews(Global().myItinerary.value[widget.index].reviews!);
      Global().itinerary.setRoute(Global().myItinerary.value[widget.index].route!);
      Global().itinerary.setTime(Global().myItinerary.value[widget.index].deltaTime!);
    } else {
      Global().itinerary.setName(Global().allItinerary.value[widget.index].name!);
      Global().itinerary.setCategory(Global().allItinerary.value[widget.index].category!);
      Global().itinerary.setDescription(Global().allItinerary.value[widget.index].description!);
      Global().itinerary.setDistance(Global().allItinerary.value[widget.index].distance!);
      Global().itinerary.setFkIdKey(Global().allItinerary.value[widget.index].fkIdKey!);
      Global().itinerary.setIdItinerary(Global().allItinerary.value[widget.index].idItinerary!);
      Global().itinerary.setInterestPoint(Global().allItinerary.value[widget.index].interestPoint!);
      Global().itinerary.setLevel(Global().allItinerary.value[widget.index].level!);
      Global().itinerary.setReviews(Global().allItinerary.value[widget.index].reviews!);
      Global().itinerary.setRoute(Global().allItinerary.value[widget.index].route!);
      Global().itinerary.setTime(Global().allItinerary.value[widget.index].deltaTime!);
    }
    _oldName = Global().itinerary.name!;
    _time = Global().itinerary.deltaTime!;
    _distance = Global().itinerary.distance!;
    _nameController = TextEditingController(text: Global().itinerary.name);
    _descriptionController = TextEditingController(
        text: Global().itinerary.description!.isEmpty
            ? ''
            : Global().itinerary.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
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
                    color: Colors.white,
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
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig().paddingFifteen,
              right: SizeConfig().paddingTwelve),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/first_reg.png',
                    fit: BoxFit.fitWidth,
                    width: SizeConfig().paddingThirty * 4,
                    alignment: Alignment.topCenter,
                  ),
                  Text(
                    'Modifica',
                    style: TextStyle(
                        fontSize: SizeConfig().h1FontSize,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'modifica i dati dell\'itinerario',
                    style: TextStyle(
                        fontSize: SizeConfig().h2FontSize,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: SizeConfig().paddingThirty,
                  ),
                  CustomTextField(
                          hintText: 'Nome itinerario',
                          suffixIcon: Ionicons.mail_outline,
                          prefixIcon: Ionicons.text_outline,
                          controller: _nameController,
                          keyBoardType: TextInputType.name,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          onChanged: (text) {
                            String _text = text;
                            Global().itinerary.setName(_nameController!.text);
                            if (_text.isNotEmpty) {
                              _nameKey.currentState!.validate();
                            }
                          },
                          isObscure: false,
                          haveSuffixIcon: false,
                          havePrefixIcon: true,
                          key: _nameKey,
                          validator: (value) {
                            String _temp = value;
                            if (value!.isEmpty) {
                              return 'Inserisci il nome dell\'itinerario';
                            } else if (_temp.length > 32) {
                              return 'Lunghezza massima, 35 caratteri';
                            } else if (_temp.length < 3) {
                              return 'Lunghezza minima, 3 caratteri';
                            } else if (_oldName == value) {
                              return null;
                            } else if (Global()
                                .allItinerary
                                .value
                                .where((element) =>
                                    element.name!.toLowerCase().trimAll() ==
                                    value)
                                .toList()
                                .isNotEmpty) {
                              return 'E\' già presente un itinerario con quel nome';
                            }
                            Global().itinerary.setName(value);
                            return null;
                          },
                          onTapIcon: () {})
                      .showTextField(context),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ValueListenableBuilder(
                          valueListenable: _levelColor,
                          builder: (BuildContext context, Color value,
                              Widget? child) {
                            return TextButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig()
                                                          .borderRadiusTwelve)),
                                          title: Text('Seleziona Livello',
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize:
                                                      SizeConfig().h1FontSize /
                                                          1.35)),
                                          children: <Widget>[
                                            _levelOption(1),
                                            _levelOption(2),
                                            _levelOption(3),
                                            _levelOption(4),
                                          ]);
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Ionicons.podium_outline,
                                    color: value,
                                    size: SizeConfig().iconSize,
                                  ),
                                  SizedBox(
                                    width: SizeConfig().paddingFive,
                                  ),
                                  Text(
                                    Global().itinerary.level != null
                                        ? Global().itinerary.level == 1
                                            ? 'Semplice'
                                            : Global().itinerary.level == 2
                                                ? 'Moderato'
                                                : Global().itinerary.level == 3
                                                    ? 'Difficile'
                                                    : 'Estremo'
                                        : 'Livello',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig().buttonFontSize,
                                        color: value),
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig().borderRadiusFourteen),
                                ),
                                side: BorderSide(color: value),
                                primary: white,
                                padding: EdgeInsets.only(
                                  top: SizeConfig().paddingTwelve * 1.15,
                                  bottom: SizeConfig().paddingTwelve * 1.15,
                                  left: SizeConfig().paddingTwelve / 1.5,
                                  right: SizeConfig().paddingTwelve / 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig().paddingTwelve,
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: _categoryColor,
                          builder: (BuildContext context, Color value,
                              Widget? child) {
                            return TextButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig()
                                                          .borderRadiusTwelve)),
                                          title: Text('Seleziona Categoria',
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize:
                                                      SizeConfig().h1FontSize /
                                                          1.35)),
                                          children: <Widget>[
                                            _categoryOption(1),
                                            _categoryOption(2),
                                            _categoryOption(3),
                                          ]);
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Ionicons.trail_sign_outline,
                                      color: value,
                                      size: SizeConfig().iconSize),
                                  SizedBox(
                                    width: SizeConfig().paddingFive,
                                  ),
                                  Text(
                                    Global().itinerary.category != null
                                        ? Global().itinerary.category == 1
                                            ? 'Montagna'
                                            : Global().itinerary.category == 2
                                                ? 'Collina'
                                                : 'Pianura'
                                        : 'Categoria',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig().buttonFontSize,
                                        color: value),
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig().borderRadiusFourteen),
                                ),
                                side: BorderSide(color: value),
                                primary: white,
                                padding: EdgeInsets.only(
                                  top: SizeConfig().paddingTwelve * 1.15,
                                  bottom: SizeConfig().paddingTwelve * 1.15,
                                  left: SizeConfig().paddingTwelve / 2,
                                  right: SizeConfig().paddingTwelve / 2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: SizeConfig().paddingFifteen,
                        bottom: SizeConfig().paddingFifteen,
                        left: SizeConfig().paddingTwelve,
                        right: SizeConfig().paddingTwelve),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                            SizeConfig().borderRadiusFourteen))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Ionicons.walk_outline,
                                  color: mainColor,
                                  size: SizeConfig().iconSize,
                                ),
                                SizedBox(
                                  width: SizeConfig().paddingFive,
                                ),
                                Text(
                                  'Distanza',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            Text(
                              Global().itinerary.distance!.toStringAsFixed(2) +
                                  ' km',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: _distanceColor,
                          builder: (BuildContext context, Color value,
                              Widget? child) {
                            return SfSlider(
                              min: 0,
                              max: 100,
                              value: _distance,
                              interval: 20,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              activeColor: value,
                              minorTicksPerInterval: 0,
                              onChanged: (dynamic value) {
                                if (mounted) {
                                  setState(() {
                                    _distance = value;
                                  });
                                }
                                Global().itinerary.setDistance(_distance);
                                if (value > 0) {
                                  _distanceColor.value = mainColor;
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: SizeConfig().paddingTwenty,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Ionicons.stopwatch_outline,
                                  color: mainColor,
                                  size: SizeConfig().iconSize,
                                ),
                                SizedBox(
                                  width: SizeConfig().paddingFive,
                                ),
                                Text(
                                  'Durata',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            Text(
                              Global()
                                          .itinerary
                                          .deltaTime
                                          ?.toStringAsFixed(0) ==
                                      null
                                  ? '0 minuti'
                                  : Global()
                                          .itinerary
                                          .deltaTime!
                                          .toStringAsFixed(0) +
                                      ' minuti',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: _timeColor,
                          builder: (BuildContext context, Color value,
                              Widget? child) {
                            return SfSlider(
                              min: 0,
                              max: 1500,
                              value: _time,
                              interval: 500,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              activeColor: value,
                              minorTicksPerInterval: 0,
                              onChanged: (dynamic value) {
                                if (mounted) {
                                  setState(() {
                                    _time = value.toInt();
                                  });
                                }
                                Global().itinerary.setTime(_time);
                                if (value > 0) {
                                  _timeColor.value = mainColor;
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  Form(
                    child: TextFormField(
                      controller: _descriptionController,
                      scrollPhysics: const BouncingScrollPhysics(),
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      maxLines: null,
                      style: TextStyle(
                          color: black, fontSize: SizeConfig().h2FontSize),
                      decoration: InputDecoration(
                        fillColor: grey.withAlpha(130),
                        contentPadding: EdgeInsets.only(
                            top: SizeConfig().paddingFifteen,
                            bottom: SizeConfig().paddingFifteen,
                            left: SizeConfig().paddingFifteen),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig().borderRadiusTwelve),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        hintText: 'Descrizione (facoltativa)',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: SizeConfig().h2FontSize),
                        errorStyle: TextStyle(
                            color: Colors.red[700],
                            fontSize: SizeConfig().h4FontSize),
                        prefixIcon: Icon(
                          Ionicons.document_text_outline,
                          size: SizeConfig().iconSize,
                        ),
                      ),
                      onChanged: (text) {
                        Global().itinerary.setDescription(text);
                      },
                      validator: (value) {
                        String _temp = value ?? '';
                        if (_temp.length > 400) {
                          return 'Lunghezza massima, 200 caratteri';
                        } else if (_temp.isNotEmpty) {
                          Global().itinerary.setDescription(value!);
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig().paddingThirty,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _confirmButton();
                      },
                      child: Text(
                        'Modifica Itinerario',
                        style: TextStyle(fontSize: SizeConfig().buttonFontSize),
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
                  SizedBox(
                    height: SizeConfig().paddingTwenty * 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryOption(int index) {
    return SimpleDialogOption(
      onPressed: () async {
        if (mounted) {
          setState(() {
            Global().itinerary.setCategory(index);
          });
        }
        _categoryColor.value = mainColor;
        Navigator.pop(context);
      },
      child: Text(
        index == 1
            ? 'Montagna'
            : index == 2
                ? 'Collina'
                : 'Pianura',
        style: TextStyle(color: black, fontSize: SizeConfig().h2FontSize),
      ),
    );
  }

  Widget _levelOption(int index) {
    String title;
    if (index == 1) {
      title = 'Semplice';
    } else if (index == 2) {
      title = 'Moderato';
    } else if (index == 3) {
      title = 'Difficile';
    } else {
      title = 'Estremo';
    }

    return SimpleDialogOption(
      onPressed: () async {
        if (mounted) {
          setState(() {
            Global().itinerary.setLevel(index);
          });
        }
        _levelColor.value = mainColor;
        Navigator.pop(context);
      },
      child: Text(
        title,
        style: TextStyle(color: black, fontSize: SizeConfig().h2FontSize),
      ),
    );
  }

  void _confirmButton() async {
    bool _validateName = _nameKey.currentState!.validate();
    bool _validateTime = _time <= 0 ? false : true;
    bool _validateDistance = _distance <= 0 ? false : true;
    bool _validateLevel = Global().itinerary.level == null ? false : true;
    bool _validateCategory = Global().itinerary.category == null ? false : true;

    if (!_validateTime) {
      _timeColor.value = Colors.red[700]!;
    } else {
      _timeColor.value = mainColor;
    }

    if (!_validateDistance) {
      _distanceColor.value = Colors.red[700]!;
    } else {
      _distanceColor.value = mainColor;
    }

    if (!_validateLevel) {
      _levelColor.value = Colors.red[700]!;
    } else {
      _levelColor.value = mainColor;
    }

    if (!_validateCategory) {
      _categoryColor.value = Colors.red[700]!;
    } else {
      _categoryColor.value = mainColor;
    }

    if (_validateCategory &&
        _validateDistance &&
        _validateLevel &&
        _validateName &&
        _validateTime) {
      if (await ItineraryController().editItineraryRoute(context)) {
        await Global.analytics.logEvent(
          name: 'edit_itinerary_event',
          parameters: <String, dynamic>{
            'user': Global().myUser.value.id,
          },
        );
        CustomAlertDialog(
            title: 'Congratulazioni',
            body:
                'I dettagli dell\'itinerario sono stati correttamente modificati.',
            titleConfirmButton: 'Chiudi',
            onPressConfirm: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }).showCustomDialog(context);
      } else {
        CustomAlertDialog(
            title: 'Attenzione',
            body:
                'Non è stato possibile modificare i dettagli dell\'itinerario.',
            titleConfirmButton: 'Chiudi',
            onPressConfirm: () {
              Navigator.pop(context);
            }).showCustomDialog(context);
      }
    }
  }
}

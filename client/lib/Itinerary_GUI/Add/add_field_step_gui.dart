import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/attention_seekers/shake.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_textfield.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Itinerary_GUI/Add/add_itinerary_gui.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AddFieldStep extends StatefulWidget {
  const AddFieldStep({Key? key, required this.controller}) : super(key: key);

  final PageController controller;

  @override
  _AddFieldStepState createState() => _AddFieldStepState();
}

class _AddFieldStepState extends State<AddFieldStep> {
  int _time = Global().itinerary.deltaTime ?? 0;
  double _distance = Global().itinerary.distance ?? 0;
  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  final TextEditingController? _nameController = TextEditingController(
      text: Global().itinerary.name == null
          ? ''
          : Global().itinerary.name!.isEmpty
              ? ''
              : Global().itinerary.name);
  final TextEditingController? _descriptionController = TextEditingController(
      text: Global().itinerary.description == null
          ? ''
          : Global().itinerary.description!.isEmpty
              ? ''
              : Global().itinerary.description);

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
        body: Padding(
          padding: EdgeInsets.only(
              top: SizeConfig().paddingThirty * 4,
              left: SizeConfig().paddingFifteen,
              right: SizeConfig().paddingTwelve),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollViewController,
            child: Center(
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _showAppbar ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      'Informazioni',
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
                      'inserisci i dati dell\'itinerario',
                      style: TextStyle(
                          fontSize: SizeConfig().h2FontSize,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _showAppbar ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: SizedBox(
                      height: SizeConfig().paddingThirty,
                    ),
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
                              context.read<ValidateField>().validateName();
                            }
                          },
                          isObscure: false,
                          haveSuffixIcon: false,
                          havePrefixIcon: true,
                          key: context.watch<ValidateField>().nameKey,
                          validator: (value) {
                            String _temp = value;
                            if (value!.isEmpty) {
                              return 'Inserisci il nome dell\'itinerario';
                            } else if (_temp.length > 32) {
                              return 'Lunghezza massima, 35 caratteri';
                            } else if (_temp.length < 3) {
                              return 'Lunghezza minima, 3 caratteri';
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
                        child: Shake(
                          key: context.watch<ValidateField>().levelKey,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig().borderRadiusTwelve)),
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
                                  color:
                                      context.watch<ValidateField>().levelColor,
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
                                    color:
                                        context.watch<ValidateField>().levelColor,
                                  ),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig().borderRadiusFourteen),
                              ),
                              side: BorderSide(
                                color: context.watch<ValidateField>().levelColor,
                              ),
                              primary: white,
                              padding: EdgeInsets.only(
                                top: SizeConfig().paddingTwelve * 1.15,
                                bottom: SizeConfig().paddingTwelve * 1.15,
                                left: SizeConfig().paddingTwelve / 1.5,
                                right: SizeConfig().paddingTwelve / 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig().paddingTwelve,
                      ),
                      Expanded(
                          child: Shake(
                            key: context.watch<ValidateField>().categoryKey,
                            child: TextButton(
                        onPressed: () {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig().borderRadiusTwelve)),
                                      title: Text('Seleziona Categoria',
                                          style: TextStyle(
                                              color: black,
                                              fontSize: SizeConfig().h1FontSize /
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
                                  color: context
                                      .watch<ValidateField>()
                                      .categoryColor,
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
                                    color: context
                                        .watch<ValidateField>()
                                        .categoryColor),
                              ),
                            ],
                        ),
                        style: TextButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusFourteen),
                            ),
                            side: BorderSide(
                                color:
                                    context.watch<ValidateField>().categoryColor),
                            primary: white,
                            padding: EdgeInsets.only(
                              top: SizeConfig().paddingTwelve * 1.15,
                              bottom: SizeConfig().paddingTwelve * 1.15,
                              left: SizeConfig().paddingTwelve / 2,
                              right: SizeConfig().paddingTwelve / 2,
                            ),
                        ),
                      ),
                          )),
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
                        SfSlider(
                          min: 0,
                          max: 100,
                          value: _distance,
                          interval: 20,
                          showTicks: true,
                          showLabels: true,
                          enableTooltip: true,
                          tooltipShape: const SfPaddleTooltipShape(),
                          activeColor:
                              context.watch<ValidateField>().distanceColor,
                          minorTicksPerInterval: 1,
                          onChangeStart: (value) {
                            context.read<ScrollType>().disableScroll();
                          },
                          onChangeEnd: (value) {
                            context.read<ScrollType>().enableScroll();
                          },
                          onChanged: (dynamic value) {
                            if (mounted) {
                              setState(() {
                                _distance = value;
                              });
                            }
                            Global().itinerary.setDistance(_distance);
                            context.read<ValidateField>().validateDistance();
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
                        SfSlider(
                          min: 0,
                          max: 1500,
                          value: _time,
                          interval: 500,
                          showTicks: true,
                          showLabels: true,
                          enableTooltip: true,
                          tooltipShape: const SfPaddleTooltipShape(),
                          activeColor: context.watch<ValidateField>().timeColor,
                          minorTicksPerInterval: 5,
                          onChangeStart: (value) {
                            context.read<ScrollType>().disableScroll();
                          },
                          onChangeEnd: (value) {
                            context.read<ScrollType>().enableScroll();
                          },
                          onChanged: (dynamic value) {
                            if (mounted) {
                              setState(() {
                                _time = value.toInt();
                              });
                            }
                            Global().itinerary.setTime(_time);
                            context.read<ValidateField>().validateTime();
                          },
                        )
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
                        context.read<ValidateField>().validateDescription();
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
        Global().itinerary.setCategory(index);
        context.read<ValidateField>().validateCategory();
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
        Global().itinerary.setLevel(index);
        context.read<ValidateField>().validateLevel();
        Navigator.pop(context);
      },
      child: Text(
        title,
        style: TextStyle(color: black, fontSize: SizeConfig().h2FontSize),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/animator_widget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Itinerary_GUI/Add/add_interest_point_step_gui.dart';
import 'package:provider/provider.dart';

import '../../Accessory_Class/global_variable.dart';
import '../../Accessory_GUI/boucing_animation.dart';
import '../../Accessory_GUI/custom_dialog.dart';
import '../../Controller/itinerary_controller.dart';
import 'add_field_step_gui.dart';
import 'add_route_step_gui.dart';

class AddItineraryPage extends StatefulWidget {
  const AddItineraryPage({Key? key}) : super(key: key);

  @override
  _AddItineraryPageState createState() => _AddItineraryPageState();
}

class _AddItineraryPageState extends State<AddItineraryPage> {
  final ValueNotifier<double> _currentPage = ValueNotifier(0.0);
  final _pageViewController = PageController();

  @override
  void initState() {
    _pageViewController.addListener(() {
      _currentPage.value = _pageViewController.page!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: _backButton,
      child: Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: false,
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
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/first_reg.png',
                fit: BoxFit.fitWidth,
                width: SizeConfig().paddingThirty * 4,
                alignment: Alignment.topCenter,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(seconds: 750),
                child: PageView(
                  controller: _pageViewController,
                  physics: context.watch<ScrollType>().scroll,
                  children: <Widget>[
                    AddRouteStep(
                      controller: _pageViewController,
                    ),
                    AddInterestPointStep(controller: _pageViewController),
                    AddFieldStep(controller: _pageViewController),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder(
                valueListenable: _currentPage,
                builder: (BuildContext context, double value, Widget? child) {
                  return Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(
                        right: SizeConfig().paddingThirty,
                        left: SizeConfig().paddingThirty,
                        bottom: SizeConfig().paddingTwentyFive),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(235),
                        borderRadius: BorderRadius.all(Radius.circular(
                            SizeConfig().borderRadiusFourteen * 1.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig().paddingTwelve),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig().paddingFifteen),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicator(),
                            ),
                          ),
                          Row(
                            children: [
                              CustomBounce(
                                duration: const Duration(milliseconds: 100),
                                onPressed: () {
                                  if (_pageViewController.page == 0) {
                                    _pageViewController.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 350),
                                        curve: Curves.easeIn);
                                  } else if (_pageViewController.page == 1) {
                                    _pageViewController.animateToPage(2,
                                        duration:
                                            const Duration(milliseconds: 350),
                                        curve: Curves.easeIn);
                                  } else {
                                    bool _validateName = context
                                        .read<ValidateField>()
                                        .validateName();
                                    bool _validateDescription = context
                                        .read<ValidateField>()
                                        .validateDescription();
                                    bool _validateTime = context
                                        .read<ValidateField>()
                                        .validateTime();
                                    bool _validateDistance = context
                                        .read<ValidateField>()
                                        .validateDistance();
                                    bool _validateLevel = context
                                        .read<ValidateField>()
                                        .validateLevel();
                                    bool _validateCategory = context
                                        .read<ValidateField>()
                                        .validateCategory();

                                    if (_validateCategory &&
                                        _validateDistance &&
                                        _validateLevel &&
                                        _validateName &&
                                        _validateTime &&
                                        _validateDescription) {
                                      ItineraryController()
                                          .addItinerary(context);
                                    }
                                  }
                                },
                                child: Text(
                                  value.round() == 2
                                      ? 'Inserisci Itinerario'
                                      : 'Avanti',
                                  style: TextStyle(
                                      color: value.round() == 2
                                          ? mainColor
                                          : black,
                                      fontSize: SizeConfig().h3FontSize,
                                      fontWeight: value.round() == 2
                                          ? FontWeight.w500
                                          : FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig().paddingTwentyFive,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> indicator() => List<Widget>.generate(
      3,
      (index) => ValueListenableBuilder(
            valueListenable: _currentPage,
            builder: (BuildContext context, double value, Widget? child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig().paddingFive / 2),
                height: value.round() == index
                    ? SizeConfig().paddingFive * 1.8
                    : SizeConfig().paddingTwelve,
                width: value.round() == index
                    ? SizeConfig().paddingTwentyFive * 1.1
                    : SizeConfig().paddingTwelve,
                decoration: BoxDecoration(
                    color: value.round() == index
                        ? mainColor
                        : mainColor.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(SizeConfig().borderRadiusTen)),
              );
            },
          ));

  Future<bool> _backButton() async {
    CustomAlertDialog(
        barrierDismissible: true,
        declineButton: true,
        title: 'Attenzione',
        body:
            'Sei sicuro di voler abbandonare l\'inserimento del nuovo itinerario?',
        titleConfirmButton: 'No',
        titleDeclineButton: 'Si',
        onPressConfirm: () {
          Navigator.pop(context);
        },
        onPressDecline: () {
          Navigator.pop(context);
          Navigator.pop(context);
        }).showCustomDialog(context);

    return Future.value(true);
  }
}

class ScrollType with ChangeNotifier, DiagnosticableTreeMixin {
  ScrollPhysics _scroll = const BouncingScrollPhysics();

  ScrollPhysics get scroll => _scroll;

  void disableScroll() {
    _scroll = const NeverScrollableScrollPhysics();
    notifyListeners();
  }

  void enableScroll() {
    _scroll = const BouncingScrollPhysics();
    notifyListeners();
  }
}

class ValidateField with ChangeNotifier, DiagnosticableTreeMixin {
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionKey = GlobalKey<FormState>();
  Color _timeColor = mainColor;
  Color _distanceColor = mainColor;
  Color _levelColor = mainColor;
  Color _categoryColor = mainColor;

  final GlobalKey<AnimatorWidgetState> _levelKey =
      GlobalKey<AnimatorWidgetState>();

  final GlobalKey<AnimatorWidgetState> _categoryKey =
      GlobalKey<AnimatorWidgetState>();

  GlobalKey<FormState> get nameKey => _nameKey;

  GlobalKey<FormState> get descriptionKey => _descriptionKey;

  Color get timeColor => _timeColor;

  Color get levelColor => _levelColor;

  Color get categoryColor => _categoryColor;

  Color get distanceColor => _distanceColor;

  GlobalKey<AnimatorWidgetState> get levelKey => _levelKey;

  GlobalKey<AnimatorWidgetState> get categoryKey => _categoryKey;

  bool validateDistance() {
    if (Global().itinerary.distance != null &&
        Global().itinerary.distance! > 0.0) {
      _distanceColor = mainColor;
      notifyListeners();
      return true;
    } else {
      _distanceColor = Colors.red[700]!;
      notifyListeners();
      return false;
    }
  }

  bool validateTime() {
    if (Global().itinerary.deltaTime != null &&
        Global().itinerary.deltaTime! > 0.0) {
      _timeColor = mainColor;
      notifyListeners();
      return true;
    } else {
      _timeColor = Colors.red[700]!;
      notifyListeners();
      return false;
    }
  }

  bool validateLevel() {
    if (Global().itinerary.level != null) {
      _levelColor = mainColor;
      notifyListeners();
      return true;
    } else {
      _levelColor = Colors.red[700]!;
      _levelKey.currentState!.forward();
      notifyListeners();
      return false;
    }
  }

  bool validateCategory() {
    if (Global().itinerary.category != null) {
      _categoryColor = mainColor;
      notifyListeners();
      return true;
    } else {
      _categoryColor = Colors.red[700]!;
      _categoryKey.currentState!.forward();
      notifyListeners();
      return false;
    }
  }

  bool validateName() {
    notifyListeners();
    return _nameKey.currentState!.validate();
  }

  bool validateDescription() {
    notifyListeners();
    return _descriptionKey.currentState?.validate() ?? true;
  }

  void setDefault() {
    _timeColor = mainColor;
    _distanceColor = mainColor;
    _levelColor = mainColor;
    _categoryColor = mainColor;
    notifyListeners();
  }
}

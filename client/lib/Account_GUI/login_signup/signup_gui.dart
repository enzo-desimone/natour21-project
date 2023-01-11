import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/animator_widget.dart';
import 'package:flutter_animator/widgets/attention_seekers/shake.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Accessory_GUI/custom_textfield.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/user_controller.dart';

import '../../Accessory_GUI/boucing_animation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? _firstName;
  String? _lastName;
  DateTime? _bornDate;
  String? _gender;
  String? _email;
  String? _password;

  final FocusNode? _focusNodeSurname = FocusNode();
  final FocusNode? _focusNodeEmail = FocusNode();
  final FocusNode? _focusNodePassword = FocusNode();
  final FocusNode? _focusNodeConfirmPassword = FocusNode();

  final TextEditingController? _firstNameController =
      TextEditingController(text: '');
  final TextEditingController? _lastNameController =
      TextEditingController(text: '');
  final TextEditingController? _bornDateController =
      TextEditingController(text: 'Data di nascita');
  final TextEditingController? _emailController =
      TextEditingController(text: '');
  final TextEditingController? _passwordController =
      TextEditingController(text: '');
  final TextEditingController? _confirmPasswordController =
      TextEditingController(text: '');

  final GlobalKey<FormState> _firstNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _lastNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _confirmPasswordKey = GlobalKey<FormState>();
  final GlobalKey<AnimatorWidgetState> _genderKey =
      GlobalKey<AnimatorWidgetState>();
  final GlobalKey<AnimatorWidgetState> _dateKey =
      GlobalKey<AnimatorWidgetState>();

  final ValueNotifier<bool> _isObscure = ValueNotifier(true);
  final ValueNotifier<bool> _isObscureConfirm = ValueNotifier(true);

  final ValueNotifier<Color> _genderColor = ValueNotifier(mainColor);
  final ValueNotifier<Color> _dateColor = ValueNotifier(mainColor);

  final Pattern _patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final Pattern _patternPassword =
      r'^(?=(.*[A-Z]){1,})(?=.*[!@#$&*])(?=(.*[0-9]){1,})(?=(.*[a-z]){1,}).{8,}$';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeSurname?.dispose();
    _focusNodeEmail?.dispose();
    _focusNodePassword?.dispose();
    _focusNodeConfirmPassword?.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _bornDateController?.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
    _confirmPasswordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: _backButton,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 0,
            title: CustomBounce(
              duration: const Duration(milliseconds: 100),
              onPressed: () {
                _backButton();
              },
              child: Icon(
                Ionicons.arrow_back_outline,
                color: black,
                size: SizeConfig().iconSize,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  top: SizeConfig().paddingThirty * 1,
                  left: SizeConfig().paddingTwenty,
                  right: SizeConfig().paddingTwenty),
              child: Column(
                children: [
                  Text(
                    'Registrazione',
                    style: TextStyle(
                        fontSize: SizeConfig().h1FontSize,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'crea il tuo account',
                    style: TextStyle(
                        fontSize: SizeConfig().h2FontSize,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: SizeConfig().paddingThirty,
                  ),
                  CustomTextField(
                          hintText: 'Nome',
                          suffixIcon: Ionicons.mail_outline,
                          prefixIcon: Ionicons.person_outline,
                          controller: _firstNameController,
                          keyBoardType: TextInputType.name,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            String _text = text;
                            Global()
                                .itinerary
                                .setName(_firstNameController!.text);
                            if (_text.isNotEmpty) {
                              _firstNameKey.currentState!.validate();
                            }
                          },
                          onEditingComplete: () {
                            _focusNodeSurname?.requestFocus();
                          },
                          isObscure: false,
                          haveSuffixIcon: false,
                          havePrefixIcon: true,
                          key: _firstNameKey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Inserisci un nome';
                            } else if (value.length < 2) {
                              return 'Lunghezza minima 2 caratteri';
                            } else if (value.length > 30) {
                              return 'Lunghezza massima 30 caratteri';
                            }
                            _firstName = value;
                            return null;
                          },
                          onTapIcon: () {})
                      .showTextField(context),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  CustomTextField(
                          hintText: 'Cognome',
                          suffixIcon: Ionicons.mail_outline,
                          prefixIcon: Ionicons.person_outline,
                          controller: _lastNameController,
                          keyBoardType: TextInputType.name,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          focusNode: _focusNodeSurname,
                          onChanged: (text) {
                            String _text = text;
                            Global()
                                .itinerary
                                .setName(_lastNameController!.text);
                            if (_text.isNotEmpty) {
                              _lastNameKey.currentState!.validate();
                            }
                          },
                          onEditingComplete: () {
                            _focusNodeEmail?.requestFocus();
                          },
                          isObscure: false,
                          haveSuffixIcon: false,
                          havePrefixIcon: true,
                          key: _lastNameKey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Inserisci un cognome';
                            } else if (value.length < 2) {
                              return 'Lunghezza minima 2 caratteri';
                            } else if (value.length > 30) {
                              return 'Lunghezza massima 30 caratteri';
                            }
                            _lastName = value;
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
                        flex: 2,
                        child: Shake(
                          key: _dateKey,
                          child: ValueListenableBuilder(
                            valueListenable: _dateColor,
                            builder: (BuildContext context, Color value,
                                Widget? child) {
                              return TextButton(
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _calendarDialog();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Ionicons.calendar_outline,
                                        color: value,
                                        size: SizeConfig().iconSize),
                                    SizedBox(
                                      width: SizeConfig().paddingTwelve,
                                    ),
                                    Text(
                                      _bornDateController!.text,
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
                                    left: SizeConfig().paddingTwelve,
                                    right: SizeConfig().paddingTwelve,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig().paddingFifteen,
                      ),
                      Expanded(
                        flex: 1,
                        child: Shake(
                          key: _genderKey,
                          child: ValueListenableBuilder(
                            valueListenable: _genderColor,
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
                                                borderRadius: BorderRadius
                                                    .circular(SizeConfig()
                                                        .borderRadiusTwelve)),
                                            title: Text('Seleziona',
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: SizeConfig()
                                                            .h1FontSize /
                                                        1.35)),
                                            children: <Widget>[
                                              SimpleDialogOption(
                                                onPressed: () async {
                                                  if (mounted) {
                                                    setState(() {
                                                      _gender = 'male';
                                                    });
                                                  }
                                                  _genderColor.value =
                                                      mainColor;
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Ionicons.male_outline,
                                                        color: mainColor,
                                                        size: SizeConfig()
                                                            .iconSize),
                                                    SizedBox(
                                                      width: SizeConfig()
                                                              .paddingFive *
                                                          1.2,
                                                    ),
                                                    Text(
                                                      'Uomo',
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: SizeConfig()
                                                              .h2FontSize),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () async {
                                                  if (mounted) {
                                                    setState(() {
                                                      _gender = 'female';
                                                    });
                                                  }
                                                  _genderColor.value =
                                                      mainColor;
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Ionicons.female_outline,
                                                        color: mainColor,
                                                        size: SizeConfig()
                                                            .iconSize),
                                                    SizedBox(
                                                      width: SizeConfig()
                                                              .paddingFive *
                                                          1.2,
                                                    ),
                                                    Text(
                                                      'Donna',
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: SizeConfig()
                                                              .h2FontSize),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]);
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        _gender == null
                                            ? Ionicons.male_female_outline
                                            : _gender == 'male'
                                                ? Ionicons.male_outline
                                                : _gender == 'female'
                                                    ? Ionicons.female_outline
                                                    : Ionicons
                                                        .transgender_outline,
                                        color: value,
                                        size: SizeConfig().iconSize),
                                    SizedBox(
                                      width: SizeConfig().paddingFive,
                                    ),
                                    Text(
                                      _gender != null
                                          ? _gender == 'male'
                                              ? 'Uomo'
                                              : _gender == 'female'
                                                  ? 'Donna'
                                                  : 'Altro'
                                          : 'Genere',
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
                                    left: SizeConfig().paddingTwelve,
                                    right: SizeConfig().paddingTwelve,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  CustomTextField(
                          hintText: 'Email',
                          suffixIcon: Ionicons.mail_outline,
                          prefixIcon: Ionicons.mail_outline,
                          controller: _emailController,
                          keyBoardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          focusNode: _focusNodeEmail,
                          onEditingComplete: () {
                            _focusNodePassword?.requestFocus();
                          },
                          onChanged: (text) {
                            String _text = text;
                            Global().itinerary.setName(_emailController!.text);
                            if (_text.isNotEmpty) {
                              _emailKey.currentState!.validate();
                            }
                          },
                          isObscure: false,
                          haveSuffixIcon: false,
                          havePrefixIcon: true,
                          key: _emailKey,
                          validator: (value) {
                            RegExp _regex = RegExp(_patternEmail as String);
                            if (value!.isEmpty) {
                              return 'Inserisci un\'email';
                            } else if (!(_regex.hasMatch(value))) {
                              return 'Formato email non valido';
                            }
                            _email = value;
                          },
                          onTapIcon: () {})
                      .showTextField(context),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isObscure,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return CustomTextField(
                          hintText: 'Password',
                          suffixIcon: value
                              ? Ionicons.eye_outline
                              : Ionicons.eye_off_outline,
                          prefixIcon: Ionicons.lock_closed_outline,
                          controller: _passwordController,
                          keyBoardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          focusNode: _focusNodePassword,
                          onChanged: (text) {
                            String _text = text;
                            if (_text.isNotEmpty) {
                              _passwordKey.currentState!.validate();
                            }
                          },
                          onEditingComplete: () {
                            _focusNodeConfirmPassword?.requestFocus();
                          },
                          isObscure: value,
                          haveSuffixIcon: true,
                          havePrefixIcon: true,
                          key: _passwordKey,
                          validator: (value) {
                            RegExp _regex = RegExp(_patternPassword as String);
                            if (value!.isEmpty) {
                              return 'Inserisci una password';
                            } else if (value.length < 8) {
                              return 'Lunghezza minima 8 caratteri';
                            } else if (!(_regex.hasMatch(value))) {
                              return 'La password deve contenere un carattere \nmaiuscolo, speciale e un numero';
                            } else if (value.length > 16) {
                              return 'Lunghezza massima 15 caratteri';
                            }
                            _password = value;
                            return null;
                          },
                          onTapIcon: () {
                            if (value) {
                              _isObscure.value = false;
                            } else {
                              _isObscure.value = true;
                            }
                          }).showTextField(context);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingTwenty,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isObscureConfirm,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return CustomTextField(
                          hintText: 'Conferma password',
                          suffixIcon: value
                              ? Ionicons.eye_outline
                              : Ionicons.eye_off_outline,
                          prefixIcon: Ionicons.lock_closed_outline,
                          controller: _confirmPasswordController,
                          keyBoardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.done,
                          focusNode: _focusNodeConfirmPassword,
                          onChanged: (text) {
                            String _text = text;
                            if (_text.isNotEmpty) {
                              _confirmPasswordKey.currentState!.validate();
                            }
                          },
                          onEditingComplete: () {
                            _focusNodeConfirmPassword?.requestFocus();
                          },
                          isObscure: value,
                          haveSuffixIcon: true,
                          havePrefixIcon: true,
                          key: _confirmPasswordKey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Conferma la password';
                            } else if (value != _passwordController!.text) {
                              return 'Le password non corrispondono';
                            }
                            return null;
                          },
                          onTapIcon: () {
                            if (value) {
                              _isObscureConfirm.value = false;
                            } else {
                              _isObscureConfirm.value = true;
                            }
                          }).showTextField(context);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig().paddingThirty,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _registerBtnAction();
                      },
                      child: Text(
                        'Registrati',
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
                    height: SizeConfig().paddingTwenty,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _calendarDialog() {
    showRoundedDatePicker(
      height: SizeConfig().paddingThirty * 11,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        paddingMonthHeader: EdgeInsets.only(
            bottom: SizeConfig().paddingTwenty,
            top: SizeConfig().paddingTwelve / 1.1),
        backgroundHeader: mainColor,
        decorationDateSelected: BoxDecoration(
          color: mainColor,
          shape: BoxShape.circle,
        ),
        textStyleButtonNegative:
            TextStyle(color: black, fontWeight: FontWeight.w400),
        textStyleDayOnCalendarDisabled:
            TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
        textStyleButtonPositive:
            TextStyle(color: mainColor, fontWeight: FontWeight.w500),
        textStyleDayOnCalendar:
            TextStyle(color: black, fontWeight: FontWeight.w400),
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        textStyleYear: TextStyle(
            fontSize: SizeConfig().paddingTwenty / 1.2,
            color: Colors.grey[500]),
        textStyleYearSelected: TextStyle(
            fontSize: SizeConfig().paddingTwentyFive,
            color: mainColor,
            fontWeight: FontWeight.w500),
        heightYearRow: SizeConfig().paddingTwentyFive * 2,
      ),
      context: context,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: mainColor,
        fontFamily: 'Poppins',
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: mainColor, secondary: mainColor)
            .copyWith(secondary: mainColor),
      ),
      fontFamily: 'Poppins',
      textNegativeButton: 'CHIUDI',
      textPositiveButton: 'OK',
      initialDate: _bornDate ??
          DateTime(DateTime.now().year - 18, DateTime.now().month,
              DateTime.now().day),
      firstDate: DateTime(
          DateTime.now().year - 110, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
      locale: Locale(Global().platform),
    ).then((selectedDate) {
      if (selectedDate != null) {
        if (mounted) {
          setState(() {
            _bornDate =
                DateTime.parse(DateFormat('yyyy-MM-dd').format(selectedDate));
            _bornDateController!.text =
                DateFormat('dd-MM-yyyy').format(_bornDate!);
          });
        }
        _dateColor.value = mainColor;
      }
    });
  }

  void _registerBtnAction() async {
    bool validateFirstName = _firstNameKey.currentState!.validate();
    bool validateLastName = _lastNameKey.currentState!.validate();
    bool validateEmail = _emailKey.currentState!.validate();
    bool validatePassword = _passwordKey.currentState!.validate();
    bool validateConfirmPassword = _confirmPasswordKey.currentState!.validate();

    bool _validateBornDate = _bornDate == null ? false : true;
    bool _validateGender = _gender == null ? false : true;

    if (!_validateGender) {
      _genderColor.value = Colors.red[700]!;
      _genderKey.currentState!.forward();
    } else {
      _genderColor.value = mainColor;
    }

    if (!_validateBornDate) {
      _dateKey.currentState!.forward();
      _dateColor.value = Colors.red[700]!;
    } else {
      _dateColor.value = mainColor;
    }

    if (validateFirstName &&
        validateLastName &&
        validateEmail &&
        validatePassword &&
        validateConfirmPassword &&
        _validateBornDate &&
        _validateGender) {
      await UserController().signUpFireBaseUser(
          _firstName!.trimAll().toLowerCase(),
          _lastName!.trimAll().toLowerCase(),
          DateFormat('dd-MM-yyyy').format(_bornDate!),
          _gender!,
          _email!.trimAll().toLowerCase(),
          _password!,
          context);
    }
  }

  Future<bool> _backButton() async {
    CustomAlertDialog(
        barrierDismissible: true,
        declineButton: true,
        title: 'Attenzione',
        body: 'Sei sicuro di voler uscire dalla schermata di registrazione?',
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

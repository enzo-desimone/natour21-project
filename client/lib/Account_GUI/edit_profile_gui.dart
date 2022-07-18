import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_nack_bar.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:shimmer/shimmer.dart';
import '../Accessory_Class/global_variable.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/custom_textfield.dart';
import '../Controller/user_controller.dart';
import '../Entity_Class/fire_base_user.dart';
import 'crop_avatar_gui.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Pattern _patternPassword =
      r'^(?=(.*[A-Z]){1,})(?=.*[!@#$&*])(?=(.*[0-9]){1,})(?=(.*[a-z]){1,}).{8,}$';

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {}

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: white,
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
              Text(
                'Modifica Account',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig().h2FontSize,
                    color: black),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig().paddingThirty,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeConfig().paddingFive / 1.5),
                    decoration:
                        BoxDecoration(color: mainColor, shape: BoxShape.circle),
                    child: ValueListenableBuilder(
                      valueListenable: Global().myUser,
                      builder: (BuildContext context, FireBaseUser value,
                          Widget? child) {
                        return Container(
                          padding: EdgeInsets.all(SizeConfig().paddingFive / 3),
                          decoration: BoxDecoration(
                              color: white, shape: BoxShape.circle),
                          child: _buildAvatar(
                              value.avatar!,
                              SizeConfig().paddingThirty * 3.5,
                              SizeConfig().paddingThirty * 3.5),
                        );
                      },
                    ),
                  ),
                  CustomBounce(
                    duration: const Duration(milliseconds: 100),
                    onPressed: () async {
                      _dialogChangeAvatar();
                    },
                    child: Container(
                        padding: EdgeInsets.all(SizeConfig().paddingFive * 1.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white70,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: SizeConfig().iconSocialSize / 1.5,
                          color: black,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig().paddingTwentyFive,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig().paddingFifteen * 1.1,
                        right: SizeConfig().paddingFifteen * 1.1),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig().paddingTwenty,
                        ),
                        if (Global().provider == 'firebase.com')
                          CustomBounce(
                            duration: const Duration(milliseconds: 100),
                            onPressed: () {
                              _selectEmail();
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(SizeConfig().paddingTwelve),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig().borderRadiusFourteen))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Ionicons.mail_outline,
                                        color: mainColor,
                                        size: SizeConfig().iconSocialSize / 1.4,
                                      ),
                                      SizedBox(
                                        width: SizeConfig().paddingTwelve,
                                      ),
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                          color: black,
                                          fontSize: SizeConfig().h3FontSize,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Ionicons.chevron_forward_outline,
                                    size: SizeConfig().iconSizeOne,
                                    color: mainColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (Global().provider == 'firebase.com')
                          SizedBox(
                            height: SizeConfig().paddingFifteen,
                          ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            _selectNameNSurname('name');
                          },
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig().paddingTwelve),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.person_outline,
                                      color: mainColor,
                                      size: SizeConfig().iconSocialSize / 1.4,
                                    ),
                                    SizedBox(
                                      width: SizeConfig().paddingTwelve,
                                    ),
                                    Text(
                                      'Nome',
                                      style: TextStyle(
                                          color: black,
                                          fontSize: SizeConfig().h3FontSize,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Ionicons.chevron_forward_outline,
                                  size: SizeConfig().iconSizeOne,
                                  color: mainColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFifteen,
                        ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            _selectNameNSurname('surname');
                          },
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig().paddingTwelve),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.person_outline,
                                      color: mainColor,
                                      size: SizeConfig().iconSocialSize / 1.4,
                                    ),
                                    SizedBox(
                                      width: SizeConfig().paddingTwelve,
                                    ),
                                    Text(
                                      'Cognome',
                                      style: TextStyle(
                                          color: black,
                                          fontSize: SizeConfig().h3FontSize,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Ionicons.chevron_forward_outline,
                                  size: SizeConfig().iconSizeOne,
                                  color: mainColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFifteen,
                        ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            _selectBirthDate();
                          },
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig().paddingTwelve),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.calendar_outline,
                                      color: mainColor,
                                      size: SizeConfig().iconSocialSize / 1.4,
                                    ),
                                    SizedBox(
                                      width: SizeConfig().paddingTwelve,
                                    ),
                                    Text(
                                      'Data di nascita',
                                      style: TextStyle(
                                          color: black,
                                          fontSize: SizeConfig().h3FontSize,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                Icon(
                                  Ionicons.chevron_forward_outline,
                                  size: SizeConfig().iconSizeOne,
                                  color: mainColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig().paddingFifteen,
                        ),
                        CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            _selectGender();
                          },
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig().paddingTwelve),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig().borderRadiusFourteen))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.male_female_outline,
                                      color: mainColor,
                                      size: SizeConfig().iconSocialSize / 1.4,
                                    ),
                                    SizedBox(
                                      width: SizeConfig().paddingTwelve,
                                    ),
                                    Text(
                                      'Genere',
                                      style: TextStyle(
                                          color: black,
                                          fontSize: SizeConfig().h3FontSize,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Ionicons.chevron_forward_outline,
                                  size: SizeConfig().iconSizeOne,
                                  color: mainColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        if (Global().provider == 'firebase.com')
                          SizedBox(
                            height: SizeConfig().paddingFifteen,
                          ),
                        if (Global().provider == 'firebase.com')
                          CustomBounce(
                            duration: const Duration(milliseconds: 100),
                            onPressed: () {
                              _editPasswordSheet();
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(SizeConfig().paddingTwelve),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig().borderRadiusFourteen))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Ionicons.lock_closed_outline,
                                        color: mainColor,
                                        size: SizeConfig().iconSocialSize / 1.4,
                                      ),
                                      SizedBox(
                                        width: SizeConfig().paddingTwelve,
                                      ),
                                      Text(
                                        'Password',
                                        style: TextStyle(
                                            color: black,
                                            fontSize: SizeConfig().h3FontSize,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Ionicons.chevron_forward_outline,
                                    size: SizeConfig().iconSizeOne,
                                    color: mainColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: SizeConfig().paddingTwenty,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future<Widget?> _editPasswordSheet() async {
    final TextEditingController? _passwordController =
        TextEditingController(text: '');
    final TextEditingController? _oldPasswordController =
        TextEditingController(text: '');
    final TextEditingController? _confirmPasswordController =
        TextEditingController(text: '');

    final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _oldPasswordKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _confirmPasswordKey = GlobalKey<FormState>();

    final ValueNotifier<bool> _isObscure = ValueNotifier(true);
    final ValueNotifier<bool> _isObscureOld = ValueNotifier(true);
    final ValueNotifier<bool> _isObscureConfirm = ValueNotifier(true);

    String? oldPassword = await Global().storage.read(key: 'password');

    return showModalBottomSheet<Widget>(
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(SizeConfig().borderRadiusFourteen * 2)),
        ),
        context: context,
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        top: SizeConfig().sizeTwenty,
                        left: SizeConfig().paddingFive * 2,
                        right: SizeConfig().paddingFive * 2,
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: <
                          Widget>[
                        Column(children: [
                          Container(
                            width: 45,
                            height: 6.5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(40)),
                                color: grey),
                          ),
                          SizedBox(
                            height: SizeConfig().paddingTwenty,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: SizeConfig().paddingFive,
                              ),
                              Text("Modifica Password",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: SizeConfig().h1FontSize / 1.5,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingTwentyFive,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _isObscureOld,
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return CustomTextField(
                                  hintText: 'Vecchia Password',
                                  suffixIcon: value
                                      ? Ionicons.eye_outline
                                      : Ionicons.eye_off_outline,
                                  prefixIcon: Ionicons.lock_closed_outline,
                                  controller: _oldPasswordController,
                                  keyBoardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (text) {
                                    String _text = text;
                                    if (_text.isNotEmpty) {
                                      _oldPasswordKey.currentState!.validate();
                                    }
                                  },
                                  onEditingComplete: () {},
                                  isObscure: value,
                                  haveSuffixIcon: true,
                                  havePrefixIcon: true,
                                  key: _oldPasswordKey,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Inserisci una password';
                                    } else if (value != oldPassword!) {
                                      return 'La vecchia password non è corretta';
                                    }
                                    return null;
                                  },
                                  onTapIcon: () {
                                    if (value) {
                                      _isObscureOld.value = false;
                                    } else {
                                      _isObscureOld.value = true;
                                    }
                                  }).showTextField(context);
                            },
                          ),
                          SizedBox(
                            height: SizeConfig().paddingTwenty,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _isObscure,
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return CustomTextField(
                                  hintText: 'Nuova Password',
                                  suffixIcon: value
                                      ? Ionicons.eye_outline
                                      : Ionicons.eye_off_outline,
                                  prefixIcon: Ionicons.lock_closed_outline,
                                  controller: _passwordController,
                                  keyBoardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (text) {
                                    String _text = text;
                                    if (_text.isNotEmpty) {
                                      _passwordKey.currentState!.validate();
                                    }
                                  },
                                  onEditingComplete: () {},
                                  isObscure: value,
                                  haveSuffixIcon: true,
                                  havePrefixIcon: true,
                                  key: _passwordKey,
                                  validator: (value) {
                                    RegExp _regex =
                                        RegExp(_patternPassword as String);
                                    if (value!.isEmpty) {
                                      return 'Inserisci una password';
                                    } else if (value.length < 8) {
                                      return 'Lunghezza minima 8 caratteri';
                                    } else if (!(_regex.hasMatch(value))) {
                                      return 'La password deve contenere un carattere \nmaiuscolo, speciale e un numero';
                                    } else if (value.length > 16) {
                                      return 'Lunghezza massima 15 caratteri';
                                    }

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
                            builder: (BuildContext context, bool value,
                                Widget? child) {
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
                                  onChanged: (text) {
                                    String _text = text;
                                    if (_text.isNotEmpty) {
                                      _confirmPasswordKey.currentState!
                                          .validate();
                                    }
                                  },
                                  onEditingComplete: () {},
                                  isObscure: value,
                                  haveSuffixIcon: true,
                                  havePrefixIcon: true,
                                  key: _confirmPasswordKey,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Conferma la password';
                                    } else if (value !=
                                        _passwordController!.text) {
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
                                  child: Text(
                                    "Modifica",
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: SizeConfig().lostCheckText),
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
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    bool _validateOld = _oldPasswordKey
                                        .currentState!
                                        .validate();
                                    bool _validateNew = _oldPasswordKey
                                        .currentState!
                                        .validate();
                                    bool _validateNewConfirm = _oldPasswordKey
                                        .currentState!
                                        .validate();

                                    if (_validateOld &&
                                        _validateNew &&
                                        _validateNewConfirm) {
                                      if (_oldPasswordController!.text ==
                                          _passwordController!.text) {
                                        Navigator.of(context).pop();
                                      } else {
                                        await UserController().updatePassword(
                                            _passwordController.text, context);
                                      }
                                    }
                                  })),
                          SizedBox(
                            height: SizeConfig().paddingTwenty,
                          ),
                        ]),
                      ]))));
        });
  }

  Widget _buildAvatar(String url, double height, double width) {
    return Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          fadeOutDuration: const Duration(milliseconds: 1),
          fadeInDuration: const Duration(milliseconds: 1),
          imageUrl: url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
              ),
            ),
          ),
          placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: grey,
                  shape: BoxShape.circle,
                ),
              )),
        ));
  }

  void _selectEmail() {
    TextEditingController _emailController = TextEditingController();
    final _emailKey = GlobalKey<FormState>();
    String? _tempEmail = '';

    const Pattern _pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusTwelve)),
            title: Text("Modifica Email",
                style: TextStyle(
                    color: black, fontSize: SizeConfig().h1FontSize / 1.5)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomTextField(
                        hintText: Global().myUser.value.email,
                        prefixIcon: Ionicons.mail_outline,
                        suffixIcon: Ionicons.mail_outline,
                        controller: _emailController,
                        haveSuffixIcon: false,
                        havePrefixIcon: true,
                        keyBoardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        isObscure: false,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {},
                        key: _emailKey,
                        validator: (value) {
                          RegExp _regex = RegExp(_pattern as String);
                          if (value!.isEmpty) {
                            return 'Inserisci un\'email';
                          } else if (!(_regex.hasMatch(value))) {
                            return 'Formato email non valido';
                          }
                          _tempEmail = value;
                        },
                        onTapIcon: () {})
                    .showTextField(context)
              ],
            ),
            actions: <Widget>[
              TextButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig().borderRadiusTen),
                      ),
                      onPrimary: black),
                  child: Text(
                    'Chiudi',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig().h4FontSize,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          SizeConfig().borderRadiusTen / 1.2),
                    ),
                    primary: mainColor,
                    onPrimary: black),
                child: Text(
                  "Ok",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig().h4FontSize,
                  ),
                ),
                onPressed: () async {
                  if (_emailKey.currentState!.validate()) {
                    Navigator.pop(context);
                    await UserController().updateUser(
                        Global().myUser.value.id!,
                        Global().myUser.value.firstName!,
                        Global().myUser.value.lastName!,
                        Global().myUser.value.bornDate!,
                        Global().myUser.value.gender!,
                        _tempEmail!,
                        context);
                    if (mounted) {
                      setState(() {
                        Global().myUser.value;
                      });
                    }
                    ScaffoldMessenger.of(Global().navigatorKey.currentContext!)
                        .showSnackBar(CustomSnackBar(
                                title: 'Email aggiornata con successo')
                            .showSnackBar());
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Modifica Email",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            content: Column(
              children: [
                const Text(
                  'inserisci la tua email',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: SizeConfig().paddingTwelve,
                ),
                Form(
                  key: _emailKey,
                  child: CupertinoTextFormFieldRow(
                      padding: const EdgeInsets.all(0),
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      placeholder: Global().myUser.value.email,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(
                              SizeConfig().borderRadiusTen / 1.3),
                          border: Border.all(color: Colors.grey[400]!)),
                      autocorrect: false,
                      maxLines: 1,
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig().buttonDialog),
                      validator: (value) {
                        RegExp _regex = RegExp(_pattern as String);
                        if (value!.isEmpty) {
                          return 'Inserisci un\'email';
                        } else if (!(_regex.hasMatch(value))) {
                          return 'Formato email non valido';
                        }
                        _tempEmail = value;
                        return null;
                      }),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Chiudi",
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig().buttonDialog),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig().buttonDialog),
                ),
                onPressed: () async {
                  if (_emailKey.currentState!.validate()) {
                    Navigator.pop(context);
                    await UserController().updateUser(
                        Global().myUser.value.id!,
                        Global().myUser.value.firstName!,
                        Global().myUser.value.lastName!,
                        Global().myUser.value.bornDate!,
                        Global().myUser.value.gender!,
                        _tempEmail!,
                        context);
                    if (mounted) {
                      setState(() {
                        Global().myUser.value;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(title: 'Email aggiornata con successo')
                            .showSnackBar());
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _selectNameNSurname(String type) {
    TextEditingController _controller = TextEditingController();
    final _key = GlobalKey<FormState>();
    String? _temp = '';

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusTwelve),
              ),
              title: Text(
                type == 'name' ? 'Modifica Nome' : 'Modifica Cognome',
                style: TextStyle(
                    color: black, fontSize: SizeConfig().h1FontSize / 1.5),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomTextField(
                          hintText: type == 'name'
                              ? Global().myUser.value.firstName
                              : Global().myUser.value.lastName,
                          prefixIcon: Ionicons.person_outline,
                          suffixIcon: Ionicons.mail_outline,
                          controller: _controller,
                          haveSuffixIcon: false,
                          havePrefixIcon: true,
                          keyBoardType: TextInputType.name,
                          textCapitalization: TextCapitalization.none,
                          isObscure: false,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {},
                          onChanged: (text) {
                            String _text = text;
                            _temp = _text;
                            if (_text.isNotEmpty) {
                              _key.currentState!.validate();
                            }
                          },
                          key: _key,
                          validator: (value) {
                            if (value!.isEmpty) {
                              if (type == 'name') {
                                return 'Inserisci un nome';
                              } else if (type == 'surname') {
                                return 'Inserisci un cognome';
                              }
                            } else if (value.length < 2) {
                              return 'Lunghezza minima 2 caratteri';
                            } else if (value.length > 30) {
                              return 'Lunghezza massima 30 caratteri';
                            }
                            _temp = value;
                            return null;
                          },
                          onTapIcon: () {})
                      .showTextField(context)
                ],
              ),
              actions: <Widget>[
                TextButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig().borderRadiusTen),
                        ),
                        onPrimary: black),
                    child: Text(
                      'Chiudi',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig().h4FontSize,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig().borderRadiusTen),
                        ),
                        primary: mainColor,
                        onPrimary: black),
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig().h4FontSize,
                      ),
                    ),
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        Navigator.pop(context);
                        if (type == 'name') {
                          await UserController().updateUser(
                              Global().myUser.value.id!,
                              _temp!,
                              Global().myUser.value.lastName!,
                              Global().myUser.value.bornDate!,
                              Global().myUser.value.gender!,
                              null,
                              context);
                        } else {
                          await UserController().updateUser(
                              Global().myUser.value.id!,
                              Global().myUser.value.firstName!,
                              _temp!,
                              Global().myUser.value.bornDate!,
                              Global().myUser.value.gender!,
                              null,
                              context);
                        }
                        if (mounted) {
                          setState(() {
                            Global().myUser;
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                    title: type == 'name'
                                        ? 'Nome aggiornato con successo.'
                                        : 'Cognome aggiornato con successo.')
                                .showSnackBar());
                      }
                    }),
              ],
            );
          });
    } else {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              type == 'name' ? 'Modifica nome' : 'Modifica cognome',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            content: Column(
              children: [
                Text(
                  type == 'name'
                      ? 'inserisci il tuo nome'
                      : 'inserisci il tuo cognome',
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: SizeConfig().paddingTwelve,
                ),
                Form(
                  key: _key,
                  child: CupertinoTextFormFieldRow(
                      padding: const EdgeInsets.all(0),
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      placeholder: type == 'name'
                          ? Global().myUser.value.firstName
                          : Global().myUser.value.lastName,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(
                              SizeConfig().borderRadiusTen / 1.3),
                          border: Border.all(color: Colors.grey[400]!)),
                      autocorrect: false,
                      maxLines: 1,
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig().buttonDialog),
                      validator: (value) {
                        if (value!.isEmpty) {
                          if (type == 'name') {
                            return 'Inserisci un nome';
                          } else if (type == 'surname') {
                            return 'Inserisci un cognome';
                          }
                        } else if (value.length < 2) {
                          return 'Lunghezza minima 2 caratteri';
                        } else if (value.length > 30) {
                          return 'Lunghezza massima 30 caratteri';
                        }
                        _temp = value;
                        return null;
                      }),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Chiudi",
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig().buttonDialog),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig().buttonDialog),
                ),
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    Navigator.pop(context);
                    if (type == 'name') {
                      await UserController().updateUser(
                          Global().myUser.value.id!,
                          _temp!,
                          Global().myUser.value.lastName!,
                          Global().myUser.value.bornDate!,
                          Global().myUser.value.gender!,
                          null,
                          context);
                    } else {
                      await UserController().updateUser(
                          Global().myUser.value.id!,
                          Global().myUser.value.firstName!,
                          _temp!,
                          Global().myUser.value.bornDate!,
                          Global().myUser.value.gender!,
                          null,
                          context);
                    }
                    if (mounted) {
                      setState(() {
                        Global().myUser;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                            title: type == 'name'
                                ? 'Nome aggiornato con successo.'
                                : 'Cognome aggiornato con successo.')
                        .showSnackBar());
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _selectBirthDate() {
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
      initialDate:
          DateFormat('dd-MM-yyyy').parse(Global().myUser.value.bornDate!),
      firstDate: DateTime(
          DateTime.now().year - 110, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
      locale: Locale(Global().platform),
    ).then((selectedDate) async {
      if (selectedDate != null) {
        await UserController().updateUser(
            Global().myUser.value.id!,
            Global().myUser.value.firstName!,
            Global().myUser.value.lastName!,
            DateFormat('dd-MM-yyyy').format(
                DateTime.parse(DateFormat('yyyy-MM-dd').format(selectedDate))),
            Global().myUser.value.gender!,
            null,
            context);
        if (mounted) {
          setState(() {
            Global().myUser;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(title: 'Data di nascita aggiornata con successo.')
                .showSnackBar());
      }
    });
  }

  void _selectGender() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig().borderRadiusTwelve)),
              title: Text('Seleziona Genere',
                  style: TextStyle(
                      color: black, fontSize: SizeConfig().h1FontSize / 1.5)),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    await UserController().updateUser(
                        Global().myUser.value.id!,
                        Global().myUser.value.firstName!,
                        Global().myUser.value.lastName!,
                        Global().myUser.value.bornDate!,
                        'male',
                        null,
                        context);
                    if (mounted) {
                      setState(() {
                        Global().myUser;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(title: 'Genere aggiornato con successo')
                            .showSnackBar());
                  },
                  child: Row(
                    children: [
                      Icon(Ionicons.male_outline,
                          color: mainColor, size: SizeConfig().iconSize),
                      SizedBox(
                        width: SizeConfig().paddingFive * 1.2,
                      ),
                      Text(
                        'Uomo',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h2FontSize),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    await UserController().updateUser(
                        Global().myUser.value.id!,
                        Global().myUser.value.firstName!,
                        Global().myUser.value.lastName!,
                        Global().myUser.value.bornDate!,
                        'female',
                        null,
                        context);
                    if (mounted) {
                      setState(() {
                        Global().myUser;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(title: 'Genere aggiornato con successo')
                            .showSnackBar());
                  },
                  child: Row(
                    children: [
                      Icon(Ionicons.female_outline,
                          color: mainColor, size: SizeConfig().iconSize),
                      SizedBox(
                        width: SizeConfig().paddingFive * 1.2,
                      ),
                      Text(
                        'Donna',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h2FontSize),
                      ),
                    ],
                  ),
                ),
              ]);
        });
  }

  void _dialogChangeAvatar() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig().borderRadiusTwelve)),
              title: Text('Seleziona',
                  style: TextStyle(
                      color: black, fontSize: SizeConfig().h1FontSize / 1.5)),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    try {
                      final pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedImage != null) {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => CropAvatarPage(
                              image: pickedImage,
                            ),
                          ),
                        )
                            .then((img) async {
                          if (img != null) {
                            await UserController().updateAvatar(img, context);
                            if (mounted) {
                              setState(() {
                                Global().myUser.value.avatar;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                        title: 'Avatar aggiornato con successo')
                                    .showSnackBar());
                          }
                        });
                      }
                    } catch (_) {
                      print(_);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Ionicons.image_outline,
                          color: mainColor, size: SizeConfig().iconSize),
                      SizedBox(
                        width: SizeConfig().paddingFive * 1.2,
                      ),
                      Text(
                        'Galleria',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h2FontSize),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      final pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.camera);

                      if (pickedImage != null) {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => CropAvatarPage(
                              image: pickedImage,
                            ),
                          ),
                        )
                            .then((img) async {
                          if (img != null) {
                            await UserController().updateAvatar(img, context);
                            if (mounted) {
                              setState(() {
                                Global().myUser.value.avatar;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                        title: 'Avatar aggiornato con successo')
                                    .showSnackBar());
                          }
                        });
                      }
                    } catch (_) {
                      //
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Ionicons.camera_outline,
                          color: mainColor, size: SizeConfig().iconSize),
                      SizedBox(
                        width: SizeConfig().paddingFive * 1.2,
                      ),
                      Text(
                        'Fotocamera',
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h2FontSize),
                      ),
                    ],
                  ),
                ),
              ]);
        });
  }
}

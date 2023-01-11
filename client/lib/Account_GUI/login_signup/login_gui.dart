import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_textfield.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Account_GUI/login_signup/signup_gui.dart';
import 'package:natour21/Controller/user_controller.dart';

import '../../Accessory_GUI/boucing_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isObscure = ValueNotifier(true);
  final FocusNode? _focusNode = FocusNode();

  final Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            ClipPath(
                clipper: WaveClipperOne(),
                child: Image.asset('assets/images/image.png')),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: SizeConfig().paddingThirty * 7.4),
                child: ClipPath(
                  clipper: WaveClipperOne(reverse: true, flip: true),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig().paddingThirty * 1.7,
                          left: SizeConfig().paddingTwenty,
                          right: SizeConfig().paddingTwenty),
                      child: Column(
                        children: [
                          Text(
                            'Benvenuto',
                            style: TextStyle(
                                fontSize: SizeConfig().h1FontSize,
                                color: mainColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'accedi al tuo account',
                            style: TextStyle(
                                fontSize: SizeConfig().h2FontSize,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: SizeConfig().paddingThirty,
                          ),
                          CustomTextField(
                                  hintText: 'Email / Username (Admin)',
                                  suffixIcon: Ionicons.mail_outline,
                                  prefixIcon: Ionicons.mail_outline,
                                  controller: _emailController,
                                  keyBoardType: TextInputType.emailAddress,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {
                                    _focusNode?.requestFocus();
                                  },
                                  isObscure: false,
                                  haveSuffixIcon: false,
                                  havePrefixIcon: true,
                                  key: _emailKey,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Inserisci una email o username';
                                    }
                                    return null;
                                  },
                                  onTapIcon: () {})
                              .showTextField(context),
                          SizedBox(
                            height: SizeConfig().paddingTwenty,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _isObscure,
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return CustomTextField(
                                  hintText: 'Password',
                                  suffixIcon: value
                                      ? Ionicons.eye_outline
                                      : Ionicons.eye_off_outline,
                                  prefixIcon: Ionicons.lock_closed_outline,
                                  controller: _passwordController,
                                  keyBoardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.done,
                                  focusNode: _focusNode,
                                  onEditingComplete: _loginBtnAction,
                                  isObscure: value,
                                  haveSuffixIcon: true,
                                  havePrefixIcon: true,
                                  key: _passwordKey,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Inserisci una password';
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
                            height: SizeConfig().paddingFifteen,
                          ),
                          CustomBounce(
                            duration: const Duration(milliseconds: 100),
                            onPressed: () {
                              _forgotPasswordDialog();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Password dimenticata?',
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: SizeConfig().h3FontSize),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig().paddingThirty,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                bool validatePassword =
                                    _passwordKey.currentState!.validate();

                                bool validateEmail =
                                    _emailKey.currentState!.validate();

                                if (validatePassword && validateEmail) {
                                  _loginBtnAction();
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: SizeConfig().buttonFontSize),
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
                            height: SizeConfig().paddingThirty,
                          ),
                          Text(
                            "Oppure accedi con",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: SizeConfig().h4FontSize),
                          ),
                          SizedBox(
                            height: SizeConfig().paddingFifteen,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomBounce(
                                duration: const Duration(milliseconds: 100),
                                onPressed: () async {
                                  UserController()
                                      .loginWithSocial('facebook.com', context);
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/facebook_logo.png',
                                      width: SizeConfig().paddingFifteen * 3.13,
                                      height:
                                          SizeConfig().paddingFifteen * 3.13,
                                      color: Colors.blue[600],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: SizeConfig().paddingThirty,
                                  child:
                                      VerticalDivider(color: Colors.grey[300])),
                              CustomBounce(
                                duration: const Duration(milliseconds: 100),
                                onPressed: () {
                                  UserController()
                                      .loginWithSocial('google.com', context);
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/google_logo.png',
                                      width: SizeConfig().paddingFifteen * 3.13,
                                      height:
                                          SizeConfig().paddingFifteen * 3.13,
                                      color: Colors.red[600],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingTwentyFive,
                          ),
                          CustomBounce(
                            duration: const Duration(milliseconds: 100),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Non hai un account?',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig().h2FontSize),
                                ),
                                SizedBox(
                                  width: SizeConfig().paddingFive,
                                ),
                                CustomBounce(
                                  duration: const Duration(milliseconds: 100),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/register_page');
                                  },
                                  child: Text('Registrati',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: SizeConfig().h2FontSize)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig().paddingFifteen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _forgotPasswordDialog() {
    TextEditingController _emailController = TextEditingController();
    final _emailKey = GlobalKey<FormState>();
    String? _tempEmail = '';

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusTwelve)),
            title: Text("Recupera Password",
                style: TextStyle(
                    color: black, fontSize: SizeConfig().h1FontSize / 1.5)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomTextField(
                        hintText: 'email',
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
                  "Invia",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig().h4FontSize,
                  ),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_emailKey.currentState!.validate()) {
                    await UserController()
                        .resetPasswordUser(_tempEmail!, context);
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
              "Recupera password",
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
                  "Invia",
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig().buttonDialog),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_emailKey.currentState!.validate()) {
                    await UserController()
                        .resetPasswordUser(_tempEmail!, context);
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _loginBtnAction() async {
    FocusScope.of(context).unfocus();
    await UserController().login(_emailController.text.trimAll().toLowerCase(),
        _passwordController.text, context);
  }
}

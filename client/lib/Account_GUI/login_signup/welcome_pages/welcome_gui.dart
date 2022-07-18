import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Account_GUI/login_signup/welcome_pages/second_page.dart';
import 'package:natour21/Account_GUI/login_signup/welcome_pages/third_page.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:provider/provider.dart';

import '../../../Accessory_GUI/boucing_animation.dart';
import 'first_page.dart';
import 'fourth_page.dart';
import 'fourth_social_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.provider}) : super(key: key);

  final String provider;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _pageViewController = PageController();
  final ValueNotifier<double> _currentPage = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      _currentPage.value = _pageViewController.page!;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(seconds: 750),
            child: PageView(
              controller: _pageViewController,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const FirstPage(),
                const SecondPage(),
                ThirdPage(
                  provider: widget.provider,
                ),
                if (widget.provider == 'firebase.com') const FourthPage(),
                if (widget.provider != 'firebase.com') const FourthPageSocial()
              ],
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
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: widget.provider == 'firebase.com'
                                ? 1
                                : _pageViewController.page == 3
                                    ? (context
                                                    .watch<ValidateWelcome>()
                                                    .dateColor ==
                                                mainColor &&
                                            context
                                                    .watch<ValidateWelcome>()
                                                    .genderColor ==
                                                mainColor)
                                        ? 1
                                        : 0
                                    : 1,
                            child: Row(
                              children: [
                                CustomBounce(
                                  duration: const Duration(milliseconds: 100),
                                  onPressed: () async {
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
                                    } else if (_pageViewController.page == 2) {
                                      _pageViewController.animateToPage(3,
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeIn);
                                    } else if (widget.provider ==
                                        'firebase.com') {
                                      await UserController()
                                          .updateAvatar(null, context);
                                    } else if (Global().myUser.value.bornDate !=
                                            null &&
                                        Global().myUser.value.gender != null) {
                                      await UserController()
                                          .signUpUserWithSocial(
                                              Global().myUser.value.bornDate!,
                                              Global().myUser.value.gender!,
                                              context);
                                    }
                                  },
                                  child: Text(
                                    value.round() == 3
                                        ? widget.provider == 'firebase.com'
                                            ? 'Salta avatar'
                                            : 'Entra nell\'app'
                                        : 'Avanti',
                                    style: TextStyle(
                                        color: value.round() == 3
                                            ? widget.provider == 'firebase.com'
                                                ? Colors.grey
                                                : mainColor
                                            : black,
                                        fontSize: SizeConfig().h3FontSize,
                                        fontWeight: value.round() == 3
                                            ? widget.provider == 'firebase.com'
                                                ? FontWeight.w400
                                                : FontWeight.w500
                                            : FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig().paddingTwentyFive,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  List<Widget> indicator() => List<Widget>.generate(
      4,
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
}

class ValidateWelcome with ChangeNotifier, DiagnosticableTreeMixin {
  Color _dateColor = Colors.grey[400]!;
  Color _genderColor = Colors.grey[400]!;

  Color get dateColor => _dateColor;

  Color get genderColor => _genderColor;

  bool validateDate() {
    if (Global().myUser.value.bornDate != null) {
      _dateColor = mainColor;
      notifyListeners();
      return true;
    } else {
      _dateColor = Colors.grey[400]!;
      notifyListeners();
      return false;
    }
  }

  bool validateGender() {
    if (Global().myUser.value.gender != null) {
      _genderColor = mainColor;
      notifyListeners();
      return true;
    } else {
      _genderColor = Colors.grey[400]!;
      notifyListeners();
      return false;
    }
  }

  void setDefault() {
    _genderColor = mainColor;
    _dateColor = mainColor;
    notifyListeners();
  }
}

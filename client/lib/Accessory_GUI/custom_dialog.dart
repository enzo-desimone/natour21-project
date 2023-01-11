import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'dart:io' show Platform;

import 'custom_loader.dart';

class CustomAlertDialog {
  String? _title = 'Title';
  String? _body = 'Body';
  String? _titleConfirmButton = '_ok';
  String? _titleDeclineButton = '_close';
  VoidCallback? _onPressConfirm;
  VoidCallback? _onPressDecline;
  bool _declineButton = false;
  bool _barrierDismissible = false;
  bool _onWillPop = false;

  CustomAlertDialog(
      {title,
      body,
      barrierDismissible,
      onWillPop,
      onPressConfirm,
      onPressDecline,
      declineButton,
      titleConfirmButton,
      titleDeclineButton}) {
    _title = title ?? 'title';
    _body = body ?? 'body';
    _titleConfirmButton = titleConfirmButton ?? '_ok';
    _titleDeclineButton = titleDeclineButton ?? '_close';
    _onPressConfirm = onPressConfirm ?? () {};
    _onPressDecline = onPressDecline ?? () {};
    _declineButton = declineButton ?? false;
    _barrierDismissible = barrierDismissible ?? true;
    _onWillPop = onWillPop ?? false;
  }

  Future<Widget?> showCustomDialog(context) {
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => _onWillPopState(context),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig().borderRadiusTwelve),
                ),
                title: Text(
                  _title!,
                  style: TextStyle(
                      color: black, fontSize: SizeConfig().h1FontSize / 1.5),
                ),
                content: Text(
                  _body!,
                  style: TextStyle(
                      color: black, fontSize: SizeConfig().h2FontSize),
                ),
                actions: <Widget>[
                  Visibility(
                    visible: _declineButton,
                    child: TextButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig().borderRadiusTen),
                            ),
                            onPrimary: black),
                        child: Text(
                          _titleDeclineButton!,
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig().h4FontSize,
                          ),
                        ),
                        onPressed: () => _onPressDecline!()),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig().borderRadiusTen),
                          ),
                          primary: mainColor,
                          onPrimary: black),
                      child: Text(
                        _titleConfirmButton!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig().h4FontSize,
                        ),
                      ),
                      onPressed: () => _onPressConfirm!()),
                ],
              ),
            );
          });
    } else if (_declineButton) {
      return showCupertinoDialog(
          context: context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => _onWillPopState(context),
              child: CupertinoAlertDialog(
                title: Text(_title!,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                content: Text(_body!,
                    style: const TextStyle(fontWeight: FontWeight.w400)),
                actions: <Widget>[
                  Visibility(
                    visible: _declineButton,
                    child: CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () => _onPressDecline!(),
                      child: Text(
                        _titleDeclineButton!,
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  CupertinoDialogAction(
                    onPressed: () => _onPressConfirm!(),
                    child: Text(
                      _titleConfirmButton!,
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      return showCupertinoDialog(
          context: context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => _onWillPopState(context),
              child: CupertinoAlertDialog(
                title: Text(_title!,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                content: Text(_body!,
                    style: const TextStyle(fontWeight: FontWeight.w400)),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () => _onPressConfirm!(),
                    child: Text(
                      _titleConfirmButton!,
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  static void loadingScreen(context, Color? color) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12.withAlpha(10),
      builder: (BuildContext context) {
        // ignore: missing_return
        return WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            return Future.value(false);
          },
          child: CustomLoader(color: color ?? mainColor),
        );
      },
    );
  }

  Future<bool> _onWillPopState(context) async {
    if (!_onWillPop) Navigator.pop(context);
    return false;
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';

import '../Accessory_Class/size_config.dart';

class CustomSnackBar {
  String _title = 'Titolo';
  String _buttonTitle = 'ok';

  CustomSnackBar({title, buttonTitle}) {
    _title = title ?? 'Titolo';
    _buttonTitle = buttonTitle ?? 'ok';
  }

  SnackBar showSnackBar() {
    return SnackBar(
      elevation: 2,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig().borderRadiusFourteen),
      ),
      backgroundColor: mainColor,
      duration: const Duration(milliseconds: 3000),
      content: Text(
        _title,
        style: TextStyle(fontWeight: FontWeight.w400, color: white, fontSize: SizeConfig().h2FontSize),
      ),
      action: SnackBarAction(
        label: _buttonTitle,
        textColor: white,
        onPressed: () {},
      ),
    );
  }
}

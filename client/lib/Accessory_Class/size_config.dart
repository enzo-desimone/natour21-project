import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  late final double paddingTwenty;
  late final double h1FontSize;
  late final double h3FontSize;
  late final double paddingTwentyFive;
  late final double imageHeight;
  late final double h4FontSize;
  late final double paddingThirty;
  late final double buttonFontSize;
  late final double paddingTwelve;
  late final double paddingFifteen;
  late final double borderRadiusTwelve;
  late final double boxShadow;
  late final double iconSocialSize;
  late final double paddingFive;
  late final double h2FontSize;
  late final double borderRadiusTen;
  late final double hintText;
  late final double lostCheckText;
  late final double argonHeight;
  late final double buttonHeight;
  late final double buttonText;
  late final double orText;
  late final double sizeTwenty;
  late final double signUpText;
  late final double titleDialog;
  late final double bodyDialog;
  late final double buttonDialog;
  late final double borderRadiusFourteen;
  late final double itemExtent;
  late final double heightPicker;
  late final double magnificationPiker;
  late final double maxChildSize;
  late final double minChildSize;
  late final double avatarHeight;
  late final double avatarWidth;
  late final double iconSize;
  late final double iconSizeOne;

  SizeConfig._privateConstructor() {
    paddingFive = _paddingFiveSet();
    paddingTwelve = _paddingTwelveSet();
    paddingFifteen = _paddingFifteenSet();
    paddingTwenty = _paddingTwentySet();
    paddingTwentyFive = _paddingTwentyFiveSet();
    paddingThirty = _paddingThirtySet();
    h1FontSize = _h1FontSizeSet();
    h2FontSize = _h2FontSizeSet();
    h3FontSize = _h3FontSizeSet();
    h4FontSize = _h4FontSizeSet();
    buttonFontSize = _buttonFontSizeSet();
    iconSize = _iconSizeSet();
    iconSocialSize = _iconSocialSizeSet();
    borderRadiusTen = _borderRadiusTen();
    borderRadiusTwelve = _borderRadiusTwelveSet();
    borderRadiusFourteen = _borderRadiusFourteenSet();
    boxShadow = _boxShadowSet();
    hintText = _hintTextSet();
    lostCheckText = _lostCheckTextSet();
    argonHeight = _argonHeightSet();
    buttonHeight = _buttonHeightSet();
    buttonText = _buttonTextSet();
    orText = _orTextSet();
    sizeTwenty = _sizeTwentySet();
    signUpText = _signUpTextSet();
    titleDialog = _titleDialogSet();
    bodyDialog = _bodyDialogSet();
    buttonDialog = _buttonDialogSet();
    itemExtent = _itemExtentSet();
    heightPicker = _heightPickerSet();
    magnificationPiker = _magnificationPickerSet();
    maxChildSize = _maxChildSizeSet();
    minChildSize = _minChildSizeSet();
    avatarHeight = _avatarHeightSet();
    avatarWidth = _avatarWidthSet();
    iconSizeOne = _iconSizeOneSet();
  }

  static final SizeConfig _instance = SizeConfig._privateConstructor();

  factory SizeConfig() {
    return _instance;
  }

  double _paddingFiveSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.015;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.016;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.01;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _paddingTwelveSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.03;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.06;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.04;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _paddingFifteenSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.040;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.012;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.01;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _paddingTwentySet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.05;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.55;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.48;
    } else {
      return SizeConfig.screenWidth * 0.7;
    }
  }

  double _paddingTwentyFiveSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.06;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.125;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.16;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _paddingThirtySet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.075;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.06;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.044;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _h1FontSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.068;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.6;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.52;
    } else {
      return SizeConfig.screenWidth * 0.7;
    }
  }

  double _h2FontSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.038;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.01;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.008;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _h3FontSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.0365;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.08;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.06;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _h4FontSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.0345;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.28;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.20;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _buttonFontSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.038;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.024;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.020;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _iconSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.058;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.045;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.030;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _iconSocialSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.095;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.016;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.01;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _borderRadiusTen() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.027;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.022;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.02;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _borderRadiusTwelveSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.03;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.01;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.008;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _borderRadiusFourteenSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.035;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.018;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.01;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _boxShadowSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.03;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.015;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.02;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _hintTextSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.04;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.03;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.025;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _lostCheckTextSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.04;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.03;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.026;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _argonHeightSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.13;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.12;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.11;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _buttonHeightSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.045;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.035;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.025;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _buttonTextSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.040;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.030;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.03;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _sizeTwentySet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.06;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.045;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.04;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _orTextSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.04;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.034;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.03;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _signUpTextSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.045;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.034;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.026;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _titleDialogSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.055;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.038;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.030;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _bodyDialogSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.043;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.030;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.022;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _buttonDialogSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.038;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.026;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.02;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _itemExtentSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.095;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.055;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.06;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _heightPickerSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.35;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.3;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.28;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _magnificationPickerSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.0030;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.0020;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.0015;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _maxChildSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.0018;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.0008;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.0015;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _minChildSizeSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.0018;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.0006;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.0015;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _avatarHeightSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.25;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.15;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.15;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _avatarWidthSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.25;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.15;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.15;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  double _iconSizeOneSet() {
    if (SizeConfig.screenWidth < 440) {
      return SizeConfig.screenWidth * 0.045;
    } else if (SizeConfig.screenWidth > 440 && SizeConfig.screenWidth < 620) {
      return SizeConfig.screenWidth * 0.035;
    } else if (SizeConfig.screenWidth > 620 && SizeConfig.screenWidth < 920) {
      return SizeConfig.screenWidth * 0.03;
    } else {
      return SizeConfig.screenWidth * 1.7;
    }
  }

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}

import 'package:flutter/material.dart';

import '../../../Accessory_Class/size_config.dart';
import '../../../Accessory_GUI/theme_color.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: white,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig().paddingFive),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Image.asset(
                'assets/images/first.png',
                fit: BoxFit.fitWidth,
                width: SizeConfig().paddingTwenty * 11,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig().paddingThirty * 1.5),
                child: Column(
                  children: <Widget>[
                    Text("Benvenuto",
                        style: TextStyle(
                          fontSize: SizeConfig().h1FontSize,
                          fontWeight: FontWeight.w500,
                          color: black,
                        )),
                    Text(
                      "Siamo lieti di darti il benvenuto nella community di NaTour21.",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 1.0,
                        fontSize: SizeConfig().h2FontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
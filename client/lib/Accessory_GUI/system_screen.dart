import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:android_power_manager/android_power_manager.dart';
import '../Accessory_Class/global_variable.dart';
import '../Accessory_Class/size_config.dart';
import 'custom_dialog.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: white,
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: Container(
                      padding:
                          EdgeInsets.only(top: SizeConfig().paddingFive / 1.05),
                      child: Container(
                          padding:
                              EdgeInsets.only(top: SizeConfig().paddingTwenty),
                          child: Column(children: [
                            Image.asset(
                              'assets/images/internet_error.png',
                              height: 350,
                              width: 350,
                            ),
                            Text(
                              "Servizio non disponibile",
                              style: TextStyle(
                                color: black,
                                fontSize: SizeConfig().h2FontSize * 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: SizeConfig().paddingTwenty),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig().paddingFive * 2.5,
                                  right: SizeConfig().paddingFive * 2.5),
                              child: Text(
                                  Global().howOS == 'ios' ||
                                          Global().isEnablePermission
                                      ? 'Verifica la tua connessione per un corretto funzionamento.'
                                      : 'Verifica la tua connessione e disattiva il risparmio energetico in background col pulsante in basso, per un corretto funzionamento.',
                                  style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig().h3FontSize),
                                  textAlign: TextAlign.center),
                            ),
                            SizedBox(
                              height: SizeConfig().paddingThirty,
                            ),
                            const CircularProgressIndicator(
                              color: Colors.black54,
                            ),
                            SizedBox(
                              height: SizeConfig().paddingThirty,
                            ),
                            if (Global().howOS != 'ios' &&
                                !Global().isEnablePermission)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig().paddingFive * 2.5,
                                    right: SizeConfig().paddingFive * 2.5),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!Global().isEnablePermission) {
                                        await AndroidPowerManager
                                            .requestIgnoreBatteryOptimizations();
                                      } else {
                                        CustomAlertDialog(
                                            title: 'Attenzione',
                                            body:
                                                'Ci dispiace, ma hai già abilitato il permesso selezionato.',
                                            titleConfirmButton: 'Chiudi',
                                            onPressConfirm: () =>
                                                Navigator.of(context)
                                                    .pop()).showCustomDialog(
                                            context);
                                      }
                                    },
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
                                    child: Text(
                                      "Disabilita risparmio energetico",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig().buttonFontSize),
                                    ),
                                  ),
                                ),
                              ),
                          ]))));
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return Future.value(false);
  }
}

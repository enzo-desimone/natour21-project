import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Account_GUI/login_signup/welcome_pages/welcome_gui.dart';
import 'package:provider/provider.dart';

import '../../../Accessory_Class/global_variable.dart';
import '../../../Accessory_Class/size_config.dart';
import '../../../Accessory_GUI/theme_color.dart';
import '../../../Entity_Class/fire_base_user.dart';

class FourthPageSocial extends StatefulWidget {
  const FourthPageSocial({Key? key}) : super(key: key);

  @override
  _FourthPageSocialState createState() => _FourthPageSocialState();
}

class _FourthPageSocialState extends State<FourthPageSocial> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: white,
          padding: EdgeInsets.symmetric(horizontal: SizeConfig().paddingFive),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imageFile == null)
                Container(
                  width: SizeConfig().paddingThirty * 6,
                  height: SizeConfig().paddingThirty * 4,
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder(
                    valueListenable: Global().myUser,
                    builder: (BuildContext context, FireBaseUser value,
                        Widget? child) {
                      return CachedNetworkImage(
                        fadeOutDuration: const Duration(milliseconds: 1),
                        fadeInDuration: const Duration(milliseconds: 1),
                        imageUrl: value.avatar!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (imageFile != null)
                Container(
                    width: SizeConfig().paddingThirty * 6,
                    height: SizeConfig().paddingThirty * 4,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: FileImage(imageFile!)))),
              SizedBox(
                height: SizeConfig().paddingTwentyFive,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig().paddingThirty * 1.5),
                child: Column(
                  children: <Widget>[
                    Text("Ci siamo",
                        style: TextStyle(
                          fontSize: SizeConfig().h1FontSize,
                          fontWeight: FontWeight.w500,
                          color: black,
                        )),
                    Text(
                      "Inserisci, la tua data di nascita, e il tuo sesso.",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 1.0,
                        fontSize: SizeConfig().h2FontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig().paddingTwentyFive,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            _calendarDialog();
                          },
                          child: Icon(
                              Global().myUser.value.bornDate == null
                                  ? Ionicons.calendar_clear_outline
                                  : Ionicons.calendar_outline,
                              size: SizeConfig().iconSize),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            primary: Global().myUser.value.bornDate == null
                                ? Colors.grey[400]
                                : mainColor,
                            padding: EdgeInsets.only(
                              top: SizeConfig().paddingFifteen,
                              bottom: SizeConfig().paddingFifteen,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig().paddingFive,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            _genderDialog();
                          },
                          child: Icon(
                              Global().myUser.value.gender == null
                                  ? Ionicons.male_female_outline
                                  : Global().myUser.value.gender == 'male'
                                      ? Ionicons.male_outline
                                      : Ionicons.female_outline,
                              size: SizeConfig().iconSize),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            primary: Global().myUser.value.gender == null
                                ? Colors.grey[400]
                                : mainColor,
                            padding: EdgeInsets.only(
                              top: SizeConfig().paddingFifteen,
                              bottom: SizeConfig().paddingFifteen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
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
      initialDate: Global().myUser.value.bornDate == null
          ? DateTime(DateTime.now().year - 18, DateTime.now().month,
              DateTime.now().day)
          : DateFormat('dd-MM-yyyy').parse(Global().myUser.value.bornDate!),
      firstDate: DateTime(
          DateTime.now().year - 110, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
      locale: Locale(Global().platform),
    ).then((selectedDate) {
      if (selectedDate != null) {
        if (mounted) {
          setState(() {
            Global().myUser.value.setBornDate =
                DateFormat('dd-MM-yyyy').format(selectedDate);
          });
        }
        context.read<ValidateWelcome>().validateDate();
      }
    });
  }

  void _genderDialog() {
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
                      color: black, fontSize: SizeConfig().h1FontSize / 1.35)),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    if (mounted) {
                      setState(() {
                        Global().myUser.value.setGender = 'male';
                      });
                    }
                    context.read<ValidateWelcome>().validateGender();
                    Navigator.pop(context);
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
                    if (mounted) {
                      setState(() {
                        Global().myUser.value.setGender = 'female';
                      });
                    }
                    context.read<ValidateWelcome>().validateGender();
                    Navigator.pop(context);
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
}

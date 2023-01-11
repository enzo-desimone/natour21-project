import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_switch.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Account_GUI/edit_profile_gui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../Accessory_Class/global_variable.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Entity_Class/fire_base_user.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ValueNotifier<bool> _saveNotifyStatus = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _saveNotifyStatus.value = prefs.getBool('notifySetting') ?? true;
  }

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
                'Il Mio Account',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig().h2FontSize,
                    color: black),
              ),
            ],
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: Global().myUser,
          builder: (BuildContext context, FireBaseUser value, Widget? child) {
            return Column(
              children: [
                SizedBox(
                  height: SizeConfig().paddingThirty,
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig().paddingFive / 1.5),
                  decoration:
                      BoxDecoration(color: mainColor, shape: BoxShape.circle),
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig().paddingFive / 3),
                    decoration:
                        BoxDecoration(color: white, shape: BoxShape.circle),
                    child: _buildAvatar(
                        value.avatar!,
                        SizeConfig().paddingThirty * 3.5,
                        SizeConfig().paddingThirty * 3.5),
                  ),
                ),
                SizedBox(
                  height: SizeConfig().paddingFive,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig().paddingTwelve,
                            bottom: SizeConfig().paddingTwelve,
                            left: SizeConfig().paddingFifteen * 3,
                            right: SizeConfig().paddingFifteen * 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig().borderRadiusTen)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value.firstName!.capitalizeFirstOfEach +
                                  ' ' +
                                  value.lastName!.capitalizeFirstOfEach,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig().h1FontSize / 1.5,
                                  color: black),
                            ),
                            Text(value.getRegDateExplicit(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeConfig().h4FontSize,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig().paddingFifteen * 1.1,
                          right: SizeConfig().paddingFifteen * 1.1),
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig().paddingThirty,
                          ),
                          Row(
                            children: [
                              Icon(
                                Global().provider == 'firebase.com'
                                    ? Ionicons.mail_outline
                                    : Global().provider == 'facebook.com'
                                        ? Ionicons.logo_facebook
                                        : Ionicons.logo_google,
                                color: Global().provider == 'firebase.com'
                                    ? mainColor
                                    : Global().provider == 'facebook.com'
                                        ? Colors.blue
                                        : Colors.red,
                                size: SizeConfig().iconSocialSize / 1.4,
                              ),
                              SizedBox(
                                width: SizeConfig().paddingTwelve,
                              ),
                              Text(
                                value.email!,
                                style: TextStyle(
                                    color: black,
                                    fontSize: SizeConfig().h3FontSize,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingThirty,
                          ),
                          Row(
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
                                    value.getBornDateExplicit(),
                                    style: TextStyle(
                                        color: black,
                                        fontSize: SizeConfig().h3FontSize,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    value.gender == 'male' ? 'Uomo' : 'Donna',
                                    style: TextStyle(
                                        color: black,
                                        fontSize: SizeConfig().h3FontSize,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: SizeConfig().paddingTwelve,
                                  ),
                                  Icon(
                                    value.gender.toString() == 'male'
                                        ? Ionicons.male_outline
                                        : Ionicons.female_outline,
                                    color: mainColor,
                                    size: SizeConfig().iconSocialSize / 1.4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingThirty,
                          ),
                          Row(
                            children: [
                              Icon(
                                Ionicons.eye_outline,
                                color: mainColor,
                                size: SizeConfig().iconSocialSize / 1.4,
                              ),
                              SizedBox(
                                width: SizeConfig().paddingTwelve,
                              ),
                              Text(
                                value.getLastSeenExplicit(),
                                style: TextStyle(
                                    color: black,
                                    fontSize: SizeConfig().h3FontSize,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingThirty,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Ionicons.chatbubbles_outline,
                                    color: mainColor,
                                    size: SizeConfig().iconSocialSize / 1.4,
                                  ),
                                  SizedBox(
                                    width: SizeConfig().paddingTwelve,
                                  ),
                                  Text(
                                    'Notifiche',
                                    style: TextStyle(
                                        color: black,
                                        fontSize: SizeConfig().h3FontSize,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: _saveNotifyStatus,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return CustomSwitch(
                                          activeColor: mainColor,
                                          value: value,
                                          onToggle: (bool value) async {
                                            _saveNotifyStatus.value = value;
                                            _changeState();
                                          },
                                        );
                                      }),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig().paddingThirty * 1.5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfilePage(),
                                  ),
                                )
                                    .then((value) {
                                  if (mounted) {
                                    setState(() {
                                      Global().myUser;
                                    });
                                  }
                                });
                              },
                              child: Text(
                                'Modifica Account',
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
                            height: SizeConfig().paddingTwenty,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ));
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

  void _changeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifySetting', _saveNotifyStatus.value);
    await Global().notify.initPlatformState(_saveNotifyStatus.value);
  }
}

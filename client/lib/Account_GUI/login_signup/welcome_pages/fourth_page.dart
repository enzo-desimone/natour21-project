import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import '../../../Accessory_Class/global_variable.dart';
import '../../../Accessory_Class/size_config.dart';
import '../../../Accessory_GUI/theme_color.dart';
import '../../../Controller/user_controller.dart';
import '../../../Entity_Class/fire_base_user.dart';
import '../../crop_avatar_gui.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
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
                    Text("Avatar",
                        style: TextStyle(
                          fontSize: SizeConfig().h1FontSize,
                          fontWeight: FontWeight.w500,
                          color: black,
                        )),
                    Text(
                      "Carica una foto unica, che ti identifichi nella nostra community.",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 1.0,
                        fontSize: SizeConfig().h2FontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig().paddingTwenty,
                    ),
                    if (imageFile == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
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
                                      .then((img) {
                                    if (mounted) {
                                      setState(() {
                                        imageFile = img;
                                      });
                                    }
                                  });
                                }
                              } catch (_) {
                                //
                              }
                            },
                            child: Icon(Ionicons.camera_outline,
                                size: SizeConfig().iconSize),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: mainColor,
                              padding: EdgeInsets.only(
                                top: SizeConfig().paddingFifteen,
                                bottom: SizeConfig().paddingFifteen,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig().paddingFive,
                          ),
                          if (imageFile == null)
                            ElevatedButton(
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
                                        .then((img) {
                                      if (mounted) {
                                        setState(() {
                                          imageFile = img;
                                        });
                                      }
                                    });
                                  }
                                } catch (_) {
                                  //
                                }
                              },
                              child: Icon(Ionicons.images_outline,
                                  size: SizeConfig().iconSize),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                primary: mainColor,
                                padding: EdgeInsets.only(
                                  top: SizeConfig().paddingFifteen,
                                  bottom: SizeConfig().paddingFifteen,
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (imageFile != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (mounted) {
                                setState(() {
                                  imageFile = null;
                                });
                              }
                            },
                            child: Icon(Ionicons.trash_outline,
                                size: SizeConfig().iconSize),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: mainColor,
                              padding: EdgeInsets.only(
                                top: SizeConfig().paddingFifteen,
                                bottom: SizeConfig().paddingFifteen,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig().paddingTwelve,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await UserController()
                                  .updateAvatar(imageFile!, context);
                            },
                            child: Icon(Ionicons.arrow_forward_outline,
                                size: SizeConfig().iconSize),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: mainColor,
                              padding: EdgeInsets.only(
                                top: SizeConfig().paddingFifteen,
                                bottom: SizeConfig().paddingFifteen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Opacity(
                      opacity: imageFile == null ? 1 : 0,
                      child: SizedBox(
                        height: SizeConfig().paddingTwenty,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

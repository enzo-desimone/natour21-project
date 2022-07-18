import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';

import '../Accessory_GUI/boucing_animation.dart';

class ImageChatPage extends StatelessWidget {
  const ImageChatPage({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        centerTitle: false,
        elevation: 0,
        title: CustomBounce(
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
      ),
      body: Container(
        padding: EdgeInsets.only(
            bottom: SizeConfig().paddingThirty,
            top: SizeConfig().paddingThirty),
        child: CustomBounce(
          duration: const Duration(milliseconds: 100),
          child: Center(
            child: CachedNetworkImage(
              fadeOutDuration: const Duration(milliseconds: 1),
              fadeInDuration: const Duration(milliseconds: 1),
              imageUrl: image,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

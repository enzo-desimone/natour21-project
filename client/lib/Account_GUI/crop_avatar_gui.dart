import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:path_provider/path_provider.dart';

import '../Accessory_GUI/boucing_animation.dart';

class CropAvatarPage extends StatefulWidget {
  const CropAvatarPage({Key? key, required this.image}) : super(key: key);

  final XFile image;

  @override
  _CropAvatarPageState createState() => _CropAvatarPageState();
}

class _CropAvatarPageState extends State<CropAvatarPage> {
  final _controller = CropController();
  final ValueNotifier<Uint8List?> _croppedData = ValueNotifier(null);
  ValueNotifier<Uint8List?> avatar = ValueNotifier(null);
  bool _isCropped = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    avatar.value = await widget.image.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _croppedData,
        builder: (BuildContext context, Uint8List? value, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: value != null
                      ? () {
                          croppedData = null;
                        }
                      : () {
                          _controller.cropCircle();
                        },
                  child: Icon(
                      value != null ? Ionicons.arrow_undo_outline : Icons.cut,
                      size: SizeConfig().iconSize)),
              if (value != null)
                SizedBox(
                  width: SizeConfig().paddingTwenty,
                ),
              if (value != null)
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () async {
                    Directory root = await getTemporaryDirectory();
                    Navigator.of(context).pop(
                        File(root.path + '/' + getRandomString(100) + 'jpg')
                            .writeAsBytes(value));
                  },
                  child: Icon(
                    Ionicons.checkmark_outline,
                    size: SizeConfig().iconSize,
                  ),
                ),
            ],
          );
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
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
              'Ritaglia',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: black,
                  fontSize: SizeConfig().h2FontSize * 1.2),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: black,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _croppedData,
        builder: (BuildContext context, Uint8List? value, Widget? child) {
          if (value == null) {
            return ValueListenableBuilder(
              valueListenable: avatar,
              builder: (BuildContext context, Uint8List? value, Widget? child) {
                if (value != null) {
                  return Crop(
                    controller: _controller,
                    image: value,
                    onCropped: (cropped) {
                      croppedData = cropped;
                    },
                    onStatusChanged: (value) {
                      if (value.name == 'cropping') {
                        _isCropped = true;
                        CustomAlertDialog.loadingScreen(context, null);
                      } else if (_isCropped) {
                        Navigator.pop(context);
                        _isCropped = false;
                      }
                    },
                    initialSize: 1.0,
                    cornerDotBuilder: (size, cornerIndex) => DotControl(
                      color: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                      ][1],
                    ),
                    maskColor: Colors.grey.shade300.withAlpha(200),
                    baseColor: Colors.white,
                    withCircleUi: true,
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container(
              color: Colors.grey.shade300.withAlpha(200),
              padding: EdgeInsets.all(SizeConfig().paddingTwelve),
              height: double.infinity,
              width: double.infinity,
              child: Image.memory(
                value,
                fit: BoxFit.contain,
              ),
            );
          }
        },
      ),
    );
  }

  set croppedData(Uint8List? value) {
    _croppedData.value = value;
  }
}

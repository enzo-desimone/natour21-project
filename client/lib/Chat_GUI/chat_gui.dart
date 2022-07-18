import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Chat_GUI/image_chat_gui.dart';
import 'package:natour21/Controller/message_controller.dart';
import 'package:natour21/Controller/notify_controller.dart';
import 'package:natour21/Entity_Class/chat_entity/message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/text_message_chat.dart';

import '../Accessory_GUI/boucing_animation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required this.room, required this.stream, required this.list})
      : super(key: key);
  final Stream<List<MessageChat>> stream;
  final List<MessageChat> list;
  final RoomChat room;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController =
      TextEditingController(text: '');
  final ValueNotifier<String> _messageText = ValueNotifier('');

  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void onDispose() {
    _timer?.cancel();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0.1,
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
              SizedBox(
                  height: SizeConfig().paddingThirty * 1.2,
                  width: SizeConfig().paddingThirty * 1.2,
                  child: CachedNetworkImage(
                    fadeOutDuration: const Duration(milliseconds: 1),
                    fadeInDuration: const Duration(milliseconds: 1),
                    imageUrl: widget.room.avatar!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                width: SizeConfig().paddingTwelve,
              ),
              Flexible(
                child: Text(
                  widget.room.name!.capitalizeFirstOfEach,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig().h2FontSize,
                      color: black),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: FooterLayout(
              footer: Container(
                padding: EdgeInsets.only(
                    bottom: SizeConfig().paddingFifteen,
                    top: SizeConfig().paddingFifteen),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight:
                        Radius.circular(SizeConfig().borderRadiusFourteen),
                    topLeft: Radius.circular(SizeConfig().borderRadiusFourteen),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBounce(
                      duration: const Duration(milliseconds: 100),
                      onPressed: () {
                        _selectImage();
                      },
                      child: Container(
                        color: white,
                        padding: EdgeInsets.only(
                            left: SizeConfig().paddingTwelve,
                            right: SizeConfig().paddingFifteen,
                            top: SizeConfig().paddingFive,
                            bottom: SizeConfig().paddingFive),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Ionicons.image_outline,
                              color: black,
                              size: SizeConfig().iconSize,
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        scrollPhysics: const BouncingScrollPhysics(),
                        keyboardType: TextInputType.multiline,
                        autofocus: false,
                        maxLines: null,
                        style: TextStyle(
                            color: black, fontSize: SizeConfig().h2FontSize),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig().borderRadiusTwelve),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText: 'Messaggio',
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: SizeConfig().h2FontSize),
                          contentPadding:
                              EdgeInsets.all(SizeConfig().paddingTwelve),
                          fillColor: grey.withAlpha(130),
                          filled: true,
                        ),
                        onChanged: (text) {
                          _messageText.value = text.trimAll();
                        },
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _messageText,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return CustomBounce(
                          duration: const Duration(milliseconds: 100),
                          onPressed: () {
                            if (value != '' && value.isNotEmpty) {
                              _sendMessage(PartialText(text: value));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                right: SizeConfig().paddingTwelve,
                                left: SizeConfig().paddingFifteen,
                                top: SizeConfig().paddingFive,
                                bottom: SizeConfig().paddingFive),
                            color: white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Ionicons.send,
                                  color: value.isNotEmpty ? mainColor : grey,
                                  size: SizeConfig().iconSize,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              child: Container(
                color: accentColor.withAlpha(25),
                child: StreamBuilder<List<MessageChat>>(
                  initialData: widget.list,
                  stream: widget.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      for (int i = 0; i < snapshot.data!.length; i++) {
                        if (snapshot.data![i].author.id !=
                            FirebaseAuth.instance.currentUser!.uid) {
                          if (snapshot.data![i].status.toString() !=
                              'Status.seen') {
                            MessageController().updateMessage(
                                snapshot.data![i], widget.room.id);
                          }
                        }
                      }
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: false,
                          reverse: true,
                          padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive / 3,
                              right: SizeConfig().paddingFive / 3,
                              top: SizeConfig().paddingFive * 1.5,
                              bottom: SizeConfig().paddingFive * 1.5),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            if (snapshot.data![index].author.id ==
                                Global().myUser.value.id) {
                              return _chatIsSender(
                                  index, snapshot.data![index], snapshot.data!);
                            } else {
                              return _chatIsNotSender(
                                  index, snapshot.data![index], snapshot.data!);
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
              )),
        ),
      ),
    );
  }

  Widget _chatIsSender(int index, MessageChat message, List<MessageChat> list) {
    if (message.createdAt != null) {
      IconData _icon = Ionicons.alert_circle;

      late DateTime _currDate;
      late DateTime _oldDate;

      bool _isNext = false;
      bool _isCenter = false;
      bool _isEnd = false;

      _currDate =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(message.createdAt!));
      _oldDate = DateTime.parse('2000-01-01');

      if (index < list.length - 1) {
        _oldDate = DateTime.parse(
            DateFormat('yyyy-MM-dd').format(list[index + 1].createdAt!));
      }

      if (message.status.toString() == 'Status.sent') {
        _icon = Ionicons.checkmark_outline;
      } else if (message.status.toString() == 'Status.seen') {
        _icon = Ionicons.checkmark_done_outline;
      } else if (message.status.toString() == 'Status.error') {
        _icon = Ionicons.alert_circle;
      } else if (message.status.toString() == 'Status.delivered') {
        _icon = Ionicons.checkmark_outline;
      }

      if (list[0].author.id == Global().myUser.value.id &&
          message.id == list[0].id) {
        if (message.status.toString() == 'Status.seen') {
          _timer?.cancel();
        }
        _timer = Timer(const Duration(seconds: 4), () async {
          if (message.status.toString() != 'Status.seen' &&
              message.createdAt!
                  .add(const Duration(seconds: 6))
                  .isAfter(DateTime.now())) {
            if (widget.room.users[0].id != Global().myUser.value.id) {
              if (message.type.toString() == 'MessageType.text') {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    message.props[6].toString().capitalize(),
                    widget.room.users[0].id!);
              } else {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    'Nuova foto',
                    widget.room.users[0].id!);
              }
            } else {
              if (message.type.toString() == 'MessageType.text') {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    message.props[6].toString().capitalize(),
                    widget.room.users[1].id!);
              } else {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    'Nuova foto',
                    widget.room.users[1].id!);
              }
            }
          }
        });
      }

      if (index > 0 && list[index - 1].author.id == Global().myUser.value.id) {
        _isNext = true;
      }

      if (index < list.length - 1 &&
          list[index + 1].author.id == Global().myUser.value.id &&
          _isNext) {
        _isCenter = true;
      }

      if (!_isNext && !_isCenter) {
        _isEnd = true;
      }

      return Column(
        children: [
          if (message.createdAt != null && _currDate != _oldDate)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig().paddingTwenty,
                          bottom: SizeConfig().paddingTwenty),
                      child: Text(
                        DateFormat('d MMMM yyyy').format(_currDate),
                        style: TextStyle(
                            color: Colors.grey.withAlpha(150),
                            fontSize: SizeConfig().h4FontSize / 1.05,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (message.type.toString() == 'MessageType.text')
            Padding(
              padding: EdgeInsets.only(
                  top: 0,
                  bottom: !_isNext ? SizeConfig().paddingFive * 2 : 0,
                  left: SizeConfig().paddingThirty * 2.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Card(
                        elevation: 0,
                        color: mainColor.withAlpha(190),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              SizeConfig().borderRadiusTen,
                            ),
                            topRight: _isCenter
                                ? Radius.circular(
                                    SizeConfig().paddingFive / 1.5)
                                : _isEnd
                                    ? Radius.circular(
                                        SizeConfig().paddingFive / 1.5)
                                    : Radius.circular(
                                        SizeConfig().borderRadiusTen),
                            bottomLeft: Radius.circular(
                              SizeConfig().borderRadiusTen,
                            ),
                            bottomRight: _isCenter
                                ? Radius.circular(
                                    SizeConfig().paddingFive / 1.5)
                                : _isNext
                                    ? Radius.circular(
                                        SizeConfig().paddingFive / 1.5)
                                    : Radius.circular(
                                        SizeConfig().borderRadiusTen),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig().paddingFive * 1.2,
                            bottom: SizeConfig().paddingFive * 1.2,
                            left: SizeConfig().paddingTwelve,
                            right: SizeConfig().paddingFive * 1.5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Text(
                                    message.props[6].toString(),
                                    style: TextStyle(
                                        color: white,
                                        fontSize:
                                            SizeConfig().h2FontSize * 1.03),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat('kk:mm')
                                        .format(message.createdAt!),
                                    style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize:
                                            SizeConfig().h4FontSize / 1.1),
                                  ),
                                  SizedBox(
                                    width: SizeConfig().paddingFive / 2,
                                  ),
                                  Icon(
                                    _icon,
                                    color: Colors.grey[300],
                                    size: SizeConfig().iconSize / 1.2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          if (message.type.toString() != 'MessageType.text')
            Padding(
              padding: EdgeInsets.only(
                  top: 0,
                  bottom: !_isNext ? SizeConfig().paddingFive * 2 : 0,
                  left: SizeConfig().paddingThirty * 2.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomBounce(
                    duration: const Duration(milliseconds: 100),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: false,
                          builder: (context) =>
                              ImageChatPage(image: message.props[9].toString()),
                        ),
                      );
                    },
                    child: Card(
                        elevation: 0,
                        color: mainColor.withAlpha(190),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              SizeConfig().borderRadiusTen,
                            ),
                            topRight: _isEnd
                                ? Radius.circular(
                                    SizeConfig().paddingFive / 1.5)
                                : Radius.circular(SizeConfig().borderRadiusTen),
                            bottomLeft: Radius.circular(
                              SizeConfig().borderRadiusTen,
                            ),
                            bottomRight: _isCenter
                                ? Radius.circular(SizeConfig().borderRadiusTen)
                                : _isNext
                                    ? Radius.circular(
                                        SizeConfig().paddingFive / 1.5)
                                    : Radius.circular(
                                        SizeConfig().borderRadiusTen),
                          ),
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig().paddingFive * 2,
                                bottom: SizeConfig().paddingFive),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  fadeOutDuration:
                                      const Duration(milliseconds: 1),
                                  fadeInDuration:
                                      const Duration(milliseconds: 1),
                                  imageUrl: message.props[9].toString(),
                                  fit: BoxFit.cover,
                                  width: SizeConfig().paddingThirty * 3.5,
                                ),
                                Container(
                                  width: SizeConfig().paddingThirty * 3.5,
                                  margin: EdgeInsets.only(
                                    top: SizeConfig().paddingFive / 2,
                                  ),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('kk:mm')
                                            .format(message.createdAt!),
                                        style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize:
                                                SizeConfig().h4FontSize / 1.1),
                                      ),
                                      SizedBox(
                                        width: SizeConfig().paddingFive / 2,
                                      ),
                                      Icon(
                                        _icon,
                                        color: Colors.grey[300],
                                        size: SizeConfig().iconSize / 1.2,
                                      ),
                                      SizedBox(
                                        width: SizeConfig().paddingFive,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ),
                ],
              ),
            ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _chatIsNotSender(
      int index, MessageChat message, List<MessageChat> list) {
    if (message.createdAt != null) {
      late DateTime _currDate;
      late DateTime _oldDate;

      bool _isNext = false;
      bool _isCenter = false;
      bool _isEnd = false;

      _currDate =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(message.createdAt!));
      _oldDate = DateTime.parse('2000-01-01');

      if (index < list.length - 1) {
        _oldDate = DateTime.parse(
            DateFormat('yyyy-MM-dd').format(list[index + 1].createdAt!));
      }

      if (list[0].author.id == Global().myUser.value.id &&
          message.id == list[0].id) {
        if (message.status.toString() == 'Status.seen') {
          _timer?.cancel();
        }
        _timer = Timer(const Duration(seconds: 4), () async {
          if (message.status.toString() != 'Status.seen' &&
              message.createdAt!
                  .add(const Duration(seconds: 6))
                  .isAfter(DateTime.now())) {
            if (widget.room.users[0].id != Global().myUser.value.id) {
              if (message.type.toString() == 'MessageType.text') {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    message.props[6].toString().capitalize(),
                    widget.room.users[0].id!);
              } else {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    'Nuova foto',
                    widget.room.users[0].id!);
              }
            } else {
              if (message.type.toString() == 'MessageType.text') {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    message.props[6].toString().capitalize(),
                    widget.room.users[1].id!);
              } else {
                NotifyController().sendChatNotify(
                    Global().myUser.value.firstName!.capitalizeFirstOfEach +
                        ' ' +
                        Global().myUser.value.lastName!.capitalizeFirstOfEach,
                    'Nuova foto',
                    widget.room.users[1].id!);
              }
            }
          }
        });
      }

      if (index > 0 && list[index - 1].author.id != Global().myUser.value.id) {
        _isNext = true;
      }

      if (index < list.length - 1 &&
          list[index + 1].author.id != Global().myUser.value.id &&
          _isNext) {
        _isCenter = true;
      }

      if (!_isNext && !_isCenter) {
        _isEnd = true;
      }

      return Column(
        children: [
          if (message.createdAt != null && _currDate != _oldDate)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig().paddingTwenty,
                          bottom: SizeConfig().paddingTwenty),
                      child: Text(
                        DateFormat('d MMMM yyyy').format(_currDate),
                        style: TextStyle(
                            color: Colors.grey.withAlpha(150),
                            fontSize: SizeConfig().h4FontSize / 1.05,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (message.type.toString() == 'MessageType.text')
            Padding(
              padding: EdgeInsets.only(
                  top: 0,
                  bottom: !_isNext ? SizeConfig().paddingTwelve : 0,
                  right: SizeConfig().paddingThirty * 2.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Card(
                        elevation: 0,
                        color: black.withAlpha(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                              SizeConfig().borderRadiusTen,
                            ),
                            topLeft: _isCenter
                                ? Radius.circular(
                                    SizeConfig().paddingFive / 1.5)
                                : _isEnd
                                    ? Radius.circular(
                                        SizeConfig().paddingFive / 1.5)
                                    : Radius.circular(
                                        SizeConfig().borderRadiusTen),
                            bottomRight: Radius.circular(
                              SizeConfig().borderRadiusTen,
                            ),
                            bottomLeft: _isCenter
                                ? Radius.circular(
                                    SizeConfig().paddingFive / 1.5)
                                : _isNext
                                    ? Radius.circular(
                                        SizeConfig().paddingFive / 1.5)
                                    : Radius.circular(
                                        SizeConfig().borderRadiusTen),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig().paddingFive * 1.2,
                            bottom: SizeConfig().paddingFive * 1.2,
                            left: SizeConfig().paddingTwelve,
                            right: SizeConfig().paddingFive * 1.5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Text(
                                    message.props[6].toString(),
                                    style: TextStyle(
                                        color: black,
                                        fontSize:
                                            SizeConfig().h2FontSize * 1.03),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: SizeConfig().paddingFive / 2,
                                  ),
                                  Text(
                                    DateFormat('kk:mm')
                                        .format(message.createdAt!),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            SizeConfig().h4FontSize / 1.1),
                                  ),
                                  SizedBox(
                                    width: SizeConfig().paddingFive / 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          if (message.type.toString() != 'MessageType.text')
            Padding(
              padding: EdgeInsets.only(
                  bottom: !_isNext ? 0 : 0, right: SizeConfig().paddingTwenty),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomBounce(
                    duration: const Duration(milliseconds: 100),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: false,
                          builder: (context) =>
                              ImageChatPage(image: message.props[9].toString()),
                        ),
                      );
                    },
                    child: Card(
                        elevation: 0,
                        color: black.withAlpha(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  SizeConfig().borderRadiusFourteen),
                              topLeft: Radius.circular(
                                  SizeConfig().borderRadiusFourteen),
                              bottomRight: Radius.circular(
                                  SizeConfig().borderRadiusFourteen),
                              bottomLeft: Radius.circular(
                                  SizeConfig().paddingFive / 2)),
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig().paddingFive * 2,
                                bottom: SizeConfig().paddingFive),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  fadeOutDuration:
                                      const Duration(milliseconds: 1),
                                  fadeInDuration:
                                      const Duration(milliseconds: 1),
                                  imageUrl: message.props[9].toString(),
                                  fit: BoxFit.cover,
                                  width: SizeConfig().paddingThirty * 3.5,
                                ),
                                Container(
                                  width: SizeConfig().paddingThirty * 3.5,
                                  margin: EdgeInsets.only(
                                    top: SizeConfig().paddingFive / 2,
                                  ),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: SizeConfig().paddingFive,
                                      ),
                                      Text(
                                        DateFormat('kk:mm')
                                            .format(message.createdAt!),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize:
                                                SizeConfig().h4FontSize / 1.1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ),
                ],
              ),
            ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _sendMessage(PartialText message) async {
    if (await MessageController().sendMessage(message, widget.room.id)) {
      await Global.analytics.logEvent(
        name: 'send_message_event',
        parameters: <String, dynamic>{
          'user': Global().myUser.value.id,
        },
      );
      _messageController.clear();
      _messageText.value = '';
    }
  }

  Future<void> _selectImage() async {
    final _result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: SizeConfig().paddingThirty * 48,
      source: ImageSource.gallery,
    );
    if (_result != null) {
      await MessageController().sendImage(widget.room.id, _result, context);
      await Global.analytics.logEvent(
        name: 'send_message_event',
        parameters: <String, dynamic>{
          'user': Global().myUser.value.id,
        },
      );
    }
  }
}

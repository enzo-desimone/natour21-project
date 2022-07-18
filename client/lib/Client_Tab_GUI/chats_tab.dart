import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Chat_GUI/chat_gui.dart';
import 'package:natour21/Controller/message_controller.dart';
import 'package:natour21/Controller/room_controller.dart';
import 'package:natour21/Entity_Class/chat_entity/message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/utils.dart';
import 'main_tab.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab>
    with AutomaticKeepAliveClientMixin<ChatsTab> {
  @override
  bool get wantKeepAlive => true;

  final ValueNotifier<double> _textOpacity = ValueNotifier(0);

  final ValueNotifier<String> _searchText = ValueNotifier('');
  final ValueNotifier<bool> _isSearch = ValueNotifier(false);
  final ValueNotifier<double> _textFieldWidth = ValueNotifier(0);
  final TextEditingController? _searchController =
      TextEditingController(text: '');

  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      var _currentScrollPosition = _scrollViewController.position.pixels;
      if (_currentScrollPosition > 0) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          context.read<Elevation>().increment();
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});
        }
      } else {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          context.read<Elevation>().decrement();
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: white,
        body: Padding(
          padding: EdgeInsets.only(
              top: _showAppbar ? SizeConfig().paddingTwelve : 0,
              left: SizeConfig().paddingFifteen,
              right: SizeConfig().paddingFifteen),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollViewController,
            child: Column(
              children: [
                AnimatedContainer(
                  height: _showAppbar ? SizeConfig().paddingTwenty * 2 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chat',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig().h2FontSize * 1.2),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _isSearch,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomBounce(
                                  duration: const Duration(milliseconds: 100),
                                  onPressed: () {
                                    if (value) {
                                      _textFieldWidth.value = 0;
                                      _isSearch.value = false;
                                      _searchText.value = '';
                                      _searchController!.clear();
                                    } else {
                                      _textFieldWidth.value =
                                          SizeConfig().paddingThirty * 8;
                                      _isSearch.value = true;
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig().paddingFive,
                                        bottom: SizeConfig().paddingFive,
                                        left: SizeConfig().paddingTwelve),
                                    color: white,
                                    child: AnimatedOpacity(
                                      opacity: _showAppbar ? 1 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: Icon(
                                        value
                                            ? Ionicons.close_outline
                                            : Ionicons.search_outline,
                                        color: black,
                                        size: SizeConfig().iconSize,
                                      ),
                                    ),
                                  )),
                              if (value)
                                SizedBox(
                                  width: SizeConfig().paddingTwelve,
                                ),
                              ValueListenableBuilder(
                                valueListenable: _textFieldWidth,
                                builder: (BuildContext context, double value,
                                    Widget? child) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: value,
                                    height: SizeConfig().paddingThirty * 1.4,
                                    color: Colors.transparent,
                                    child: TextField(
                                      controller: _searchController,
                                      style: TextStyle(
                                          color: black,
                                          fontSize: SizeConfig().h2FontSize),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig().borderRadiusTwelve),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: 'cerca utente',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: SizeConfig().h2FontSize),
                                        contentPadding: EdgeInsets.only(
                                          left: SizeConfig().paddingTwelve,
                                          right: SizeConfig().paddingTwelve,
                                        ),
                                        fillColor: grey.withAlpha(130),
                                        filled: true,
                                      ),
                                      onChanged: (value) {
                                        _searchText.value = value;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
                StreamBuilder<List<RoomChat>>(
                  stream: Global().streamRoomChat,
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      changeOpacity(false);
                      return ValueListenableBuilder(
                        valueListenable: _textOpacity,
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return AnimatedOpacity(
                            opacity: value,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                top: SizeConfig().paddingThirty * 8,
                              ),
                              child: Text('Nessuna chat attiva',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig().h3FontSize)),
                            ),
                          );
                        },
                      );
                    } else {
                      changeOpacity(true);
                      return LiveList(
                        padding: EdgeInsets.only(
                          top: SizeConfig().paddingThirty,
                        ),
                        shrinkWrap: true,
                        showItemInterval: const Duration(milliseconds: 150),
                        showItemDuration: const Duration(milliseconds: 200),
                        visibleFraction: 0.005,
                        physics: const NeverScrollableScrollPhysics(),
                        reAnimateOnVisibility: false,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: animationItemBuilder(
                            (index) => _chatList(snapshot.data!, index)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatList(List<RoomChat> list, int index) {
    final room = list[index];
    Stream<List<MessageChat>> _stream =
        MessageController().getMessageList(room);
    List<MessageChat> listMessage = [];

    return StreamBuilder<List<MessageChat>>(
      initialData: const [],
      stream: _stream,
      builder: (context, snapshot) {
        String _text = '';
        DateTime _temp = DateTime.fromMillisecondsSinceEpoch(234532432);
        int _count = 0;
        double _countOpacity = 0;
        IconData _icon = Ionicons.information_circle_outline;

        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          _text = snapshot.data![0].props[6].toString();
          listMessage = snapshot.data!;
          if (snapshot.data![0].type.toString() != 'MessageType.image') {
            if (snapshot.data![0].createdAt != null) {
              _temp = snapshot.data![0].createdAt!;
            }
          } else {
            _text = 'Immagine';
            if (snapshot.data![0].createdAt != null) {
              _temp = snapshot.data![0].createdAt!;
            }
          }

          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            if (snapshot.data![0].status.toString() == 'Status.sent') {
              _icon = Ionicons.checkmark_outline;
            } else if (snapshot.data![0].status.toString() == 'Status.seen') {
              _icon = Ionicons.checkmark_done_outline;
            } else if (snapshot.data![0].status.toString() == 'Status.error') {
              _icon = Ionicons.information_circle_outline;
            } else if (snapshot.data![0].status.toString() ==
                'Status.delivered') {
              _icon = Ionicons.checkmark_done;
            }

            if (snapshot.data![0].status.toString() != 'Status.seen' &&
                snapshot.data![0].author.id.toString() !=
                    FirebaseAuth.instance.currentUser!.uid.toString()) {
              for (int i = 0; i < snapshot.data!.length; i++) {
                if (snapshot.data![i].status.toString() != 'Status.seen') {
                  _count++;
                  _countOpacity = 1;
                }
              }
            }
          }
          return ValueListenableBuilder(
            valueListenable: _searchText,
            builder: (BuildContext context, String value, Widget? child) {
              bool _isTrue = value.length <= 1 ||
                  room.name!.toLowerCase().contains(value.toLowerCase());
              return Visibility(
                visible: _isTrue,
                child: Column(
                  children: [
                    Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (value) async {
                              await RoomController()
                                  .deleteRoom(room.id.toString());
                            },
                            flex: 1,
                            autoClose: true,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.red[700],
                            icon: Ionicons.trash_outline,
                            label: 'Elimina',
                          ),
                        ],
                      ),
                      child: CustomBounce(
                        duration: const Duration(milliseconds: 100),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                room: room,
                                stream: _stream,
                                list: listMessage,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: SizeConfig().paddingFive * 1.5,
                              right: SizeConfig().paddingFive,
                              top: SizeConfig().paddingTwelve,
                              bottom: SizeConfig().paddingTwelve),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig().borderRadiusFourteen),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              _buildAvatar(
                                  room,
                                  SizeConfig().paddingThirty * 1.5,
                                  SizeConfig().paddingThirty * 1.5),
                              Flexible(
                                  child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          room.name!.capitalizeFirstOfEach,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: SizeConfig().h2FontSize,
                                              fontWeight: FontWeight.w500,
                                              color: black),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (_text != '')
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: SizeConfig()
                                                      .paddingTwenty,
                                                ),
                                                Text(
                                                  DateFormat('kk:mm')
                                                      .format(_temp),
                                                  style: TextStyle(
                                                      color:
                                                          black.withAlpha(170),
                                                      fontSize: SizeConfig()
                                                              .h4FontSize /
                                                          1.15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width:
                                                      SizeConfig().paddingFive,
                                                ),
                                              ],
                                            )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig().paddingFive / 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            if (_text == 'Immagine')
                                              _imageMessageView(
                                                snapshot.data!,
                                                _icon,
                                              ),
                                            if (_text == 'Immagine')
                                              Flexible(
                                                child: Text(
                                                  _text,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  //_text,
                                                  style: TextStyle(
                                                      color:
                                                          black.withAlpha(170),
                                                      fontSize: SizeConfig()
                                                          .h3FontSize),
                                                ),
                                              ),
                                            if (_text != 'Immagine' &&
                                                snapshot.data != null &&
                                                snapshot.data!.isNotEmpty)
                                              _textMessageView(
                                                snapshot.data!,
                                                _icon,
                                              ),
                                            if (_text != 'Immagine' &&
                                                snapshot.data != null &&
                                                snapshot.data!.isNotEmpty)
                                              Flexible(
                                                child: Text(
                                                  _text,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          black.withAlpha(170),
                                                      fontSize: SizeConfig()
                                                          .h3FontSize),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig().paddingTwenty),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 150),
                                              opacity: _countOpacity,
                                              child: Container(
                                                width:
                                                    SizeConfig().paddingTwenty,
                                                height:
                                                    SizeConfig().paddingTwenty,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red[600]),
                                                child: Center(
                                                  child: Text(
                                                    _count.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig()
                                                            .h4FontSize,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig().paddingFive,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig().paddingFifteen,
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _textMessageView(List<MessageChat> list, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!(list[0].author.id.toString() !=
                    FirebaseAuth.instance.currentUser!.uid.toString() &&
                list[0].status.toString() != 'Status.seen') &&
            !(list[0].author.id.toString() !=
                FirebaseAuth.instance.currentUser!.uid.toString()))
          Row(
            children: [
              Icon(
                icon,
                color:
                    icon == Ionicons.checkmark_done_outline ? mainColor : black,
                size: SizeConfig().iconSize / 1.2,
              ),
              SizedBox(
                width: SizeConfig().paddingFive,
              ),
            ],
          ),
      ],
    );
  }

  Widget _imageMessageView(List<MessageChat> list, IconData icon) {
    return Row(
      children: [
        if (!(list[0].author.id.toString() !=
                    FirebaseAuth.instance.currentUser!.uid.toString() &&
                list[0].status.toString() != 'Status.seen') &&
            !(list[0].author.id.toString() !=
                FirebaseAuth.instance.currentUser!.uid.toString()))
          Row(
            children: [
              Icon(
                icon,
                color:
                    icon == Ionicons.checkmark_done_outline ? mainColor : black,
                size: SizeConfig().iconSize / 1.2,
              ),
              SizedBox(
                width: SizeConfig().paddingFive,
              ),
            ],
          ),
        Icon(
          Ionicons.image_outline,
          color: black.withAlpha(170),
          size: SizeConfig().iconSize / 1.1,
        ),
        SizedBox(
          width: SizeConfig().paddingFive,
        ),
      ],
    );
  }

  Widget _buildAvatar(RoomChat room, double height, double width) {
    return Container(
        margin: EdgeInsets.only(right: SizeConfig().paddingTwelve),
        height: height,
        width: width,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          fadeOutDuration: const Duration(milliseconds: 1),
          fadeInDuration: const Duration(milliseconds: 1),
          imageUrl: room.avatar!,
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

  changeOpacity(bool isList) {
    if (isList) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _textOpacity.value = 0.0;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        _textOpacity.value = 1.0;
      });
    }
  }
}

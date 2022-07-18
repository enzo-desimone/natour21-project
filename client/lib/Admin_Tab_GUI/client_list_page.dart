import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:provider/provider.dart';
import '../Accessory_GUI/boucing_animation.dart';
import '../Accessory_GUI/utils.dart';
import 'main_tab_admin.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({Key? key, required this.provider}) : super(key: key);

  final String provider;

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  final ValueNotifier<String> _searchText = ValueNotifier('');
  final TextEditingController? _searchController =
      TextEditingController(text: '');

  @override
  void initState() {
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      var _currentScrollPosition = _scrollViewController.position.pixels;
      if (_currentScrollPosition > 0) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          context.read<ElevationAdmin>().increment();
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});
        }
      } else {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          context.read<ElevationAdmin>().decrement();
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              backgroundColor: white,
              elevation: _showAppbar ? 0: 0.5,
              automaticallyImplyLeading: false,
              centerTitle: false,
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
            body: SingleChildScrollView(
              controller: _scrollViewController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig().paddingFifteen,
                    right: SizeConfig().paddingFifteen),
                child: Column(children: [
                  AnimatedContainer(
                    height: _showAppbar ? SizeConfig().paddingTwenty * 2 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.provider == 'googleusercontent'
                              ? 'Utenti Google'
                              : widget.provider == 'platform'
                                  ? 'Utenti Facebook'
                                  : 'Utenti Firebase',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig().h2FontSize * 1.2),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    height: _showAppbar ? SizeConfig().paddingTwelve : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: SizedBox(
                      height: SizeConfig().paddingTwelve,
                    ),
                  ),
                  AnimatedContainer(
                    height:
                        _showAppbar ? SizeConfig().paddingTwentyFive * 2 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
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
                              hintText: 'cerca per nome',
                              prefixIcon: AnimatedOpacity(
                                opacity: _showAppbar ? 1 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Ionicons.search_outline,
                                  size: SizeConfig().iconSizeOne,
                                ),
                              ),
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
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    height: _showAppbar ? SizeConfig().paddingTwentyFive : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: SizedBox(
                      height: SizeConfig().paddingThirty,
                    ),
                  ),
                  Column(
                    children: [
                      StreamBuilder<List<FireBaseUser>>(
                          stream: UserController().getUserList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return LiveList(
                                padding: EdgeInsets.only(
                                    top: _showAppbar
                                        ? SizeConfig().paddingFive
                                        : 0),
                                shrinkWrap: true,
                                showItemInterval:
                                    const Duration(milliseconds: 150),
                                showItemDuration:
                                    const Duration(milliseconds: 200),
                                visibleFraction: 0.005,
                                physics: const NeverScrollableScrollPhysics(),
                                reAnimateOnVisibility: false,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                itemBuilder: animationItemBuilder((index) =>
                                    _userList(snapshot.data![index], index)),
                              );
                            } else {
                              return Container();
                            }
                          })
                    ],
                  ),
                ]),
              ),
            )));
  }

  Widget _userList(FireBaseUser user, int index) {
    if (user.avatar!.contains(widget.provider)) {
      return ValueListenableBuilder(
          valueListenable: _searchText,
          builder: (BuildContext context, String value, Widget? child) {
            bool _isTrue = value.length <= 1 ||
                (user.firstName! + ' ' + user.lastName!)
                    .toLowerCase()
                    .contains(value.toLowerCase());

            if (index % 2 == 0) {
              return Visibility(
                visible: _isTrue,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig().paddingFive * 1.5),
                  child: BounceInLeft(
                    child: Card(
                      elevation: 1,
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  SizeConfig().borderRadiusFourteen * 2.2),
                              bottomRight: Radius.circular(
                                  SizeConfig().borderRadiusFourteen * 2.2),
                              topLeft: const Radius.circular(100),
                              bottomLeft: const Radius.circular(100))),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SizedBox(
                              height: SizeConfig().paddingThirty * 2,
                              width: SizeConfig().paddingThirty * 2,
                              child: CachedNetworkImage(
                                fadeOutDuration:
                                    const Duration(milliseconds: 1),
                                fadeInDuration: const Duration(milliseconds: 1),
                                imageUrl: user.avatar!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingThirty * 2.34,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (user.firstName! + ' ' + user.lastName!)
                                          .capitalizeFirstOfEach,
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeConfig().h2FontSize),
                                    ),
                                    Padding(
                                     padding: EdgeInsets.only(right: SizeConfig().paddingFive * 2),
                                      child: Text(
                                        user.loginCounter.toString(),
                                        style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: SizeConfig().h2FontSize),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Ultimo Accesso: ${user.getLastSeenExplicit()}',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            SizeConfig().h4FontSize / 1.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Visibility(
                visible: _isTrue,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig().paddingFive * 1.5),
                  child: BounceInRight(
                    child: Card(
                      elevation: 1,
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  SizeConfig().borderRadiusFourteen * 2.2),
                              bottomRight: Radius.circular(
                                  SizeConfig().borderRadiusFourteen * 2.2),
                              topLeft: const Radius.circular(100),
                              bottomLeft: const Radius.circular(100))),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SizedBox(
                              height: SizeConfig().paddingThirty * 2,
                              width: SizeConfig().paddingThirty * 2,
                              child: CachedNetworkImage(
                                fadeOutDuration:
                                    const Duration(milliseconds: 1),
                                fadeInDuration: const Duration(milliseconds: 1),
                                imageUrl: user.avatar!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig().paddingThirty * 2.34,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (user.firstName! + ' ' + user.lastName!)
                                          .capitalizeFirstOfEach,
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeConfig().h2FontSize),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: SizeConfig().paddingFive * 2),
                                      child: Text(
                                        user.loginCounter.toString(),
                                        style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: SizeConfig().h2FontSize),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Ultimo Accesso: ${user.getLastSeenExplicit()}',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            SizeConfig().h4FontSize / 1.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          });
    } else {
      return Container();
    }
  }
}

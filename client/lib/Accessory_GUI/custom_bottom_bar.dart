import 'package:flutter/material.dart';
import 'package:natour21/Accessory_Class/size_config.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar(
      {Key? key,
      required this.items,
      this.currentIndex = 0,
      this.onTap,
      this.selectedItemColor,
      this.unselectedItemColor,
      this.margin = const EdgeInsets.all(8),
      this.itemPadding =
          const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      this.duration = const Duration(milliseconds: 500),
      this.curve = Curves.easeOutQuint,
      this.dotIndicatorColor,
      this.marginR = const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      this.paddingR = const EdgeInsets.only(bottom: 5, top: 10),
      this.borderRadius = 30,
      this.backgroundColor = Colors.white,
      this.boxShadow = const [
        BoxShadow(
          color: Colors.transparent,
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
      this.enableFloatingNavBar = true})
      : super(key: key);

  final List<SingleItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;
  final Color? dotIndicatorColor;
  final EdgeInsetsGeometry? marginR;
  final EdgeInsetsGeometry? paddingR;
  final double? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow> boxShadow;
  final bool enableFloatingNavBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return enableFloatingNavBar
        ? BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: marginR!,
                  child: Container(
                    padding: paddingR,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius!),
                      color: backgroundColor,
                      boxShadow: boxShadow,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig().paddingFive),
                      child: CustomNavigationItem(
                          items: items,
                          currentIndex: currentIndex,
                          curve: curve,
                          duration: duration,
                          selectedItemColor: selectedItemColor,
                          theme: theme,
                          unselectedItemColor: unselectedItemColor,
                          onTap: onTap!,
                          itemPadding: itemPadding,
                          dotIndicatorColor: dotIndicatorColor),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: SizeConfig().paddingTwelve),
            color: backgroundColor,
            child: Padding(
              padding: margin,
              child: CustomNavigationItem(
                  items: items,
                  currentIndex: currentIndex,
                  curve: curve,
                  duration: duration,
                  selectedItemColor: selectedItemColor,
                  theme: theme,
                  unselectedItemColor: unselectedItemColor,
                  onTap: onTap!,
                  itemPadding: itemPadding,
                  dotIndicatorColor: dotIndicatorColor),
            ),
          );
  }
}

class CustomNavigationItem extends StatelessWidget {
  const CustomNavigationItem({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.curve,
    required this.duration,
    required this.selectedItemColor,
    required this.theme,
    required this.unselectedItemColor,
    required this.onTap,
    required this.itemPadding,
    required this.dotIndicatorColor,
  }) : super(key: key);

  final List<SingleItem> items;
  final int currentIndex;
  final Curve curve;
  final Duration duration;
  final Color? selectedItemColor;
  final ThemeData theme;
  final Color? unselectedItemColor;
  final Function(int p1) onTap;
  final EdgeInsets itemPadding;
  final Color? dotIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final item in items)
          TweenAnimationBuilder<double>(
            tween: Tween(
              end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
            ),
            curve: curve,
            duration: duration,
            builder: (context, t, _) {
              final _selectedColor =
                  item.selectedColor ?? selectedItemColor ?? theme.primaryColor;

              final _unselectedColor = item.unselectedColor ??
                  unselectedItemColor ??
                  theme.iconTheme.color;

              return Material(
                color: Color.lerp(Colors.transparent, Colors.transparent, t),
                child: GestureDetector(
                  onTap: () => onTap.call(items.indexOf(item)),
                  child: Stack(children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: itemPadding -
                          EdgeInsets.only(right: itemPadding.right * t),
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                  _unselectedColor, _selectedColor, t),
                              size: SizeConfig().iconSize * 1.05,
                            ),
                            child: item.icon,
                          ),
                        ],
                      ),
                    ),
                    ClipRect(
                      child: SizedBox(
                        height: SizeConfig().paddingThirty * 1.3,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          widthFactor: t,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: itemPadding.right / 0.63,
                                right: itemPadding.right),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color.lerp(
                                    _selectedColor.withOpacity(0.0),
                                    _selectedColor,
                                    t),
                                fontWeight: FontWeight.w600,
                              ),
                              child: CircleAvatar(
                                  radius: 2.5,
                                  backgroundColor:
                                      dotIndicatorColor ?? _selectedColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
      ],
    );
  }
}

class SingleItem {
  final Widget icon;
  final Color? selectedColor;
  final Color? unselectedColor;

  SingleItem({
    required this.icon,
    this.selectedColor,
    this.unselectedColor,
  });
}

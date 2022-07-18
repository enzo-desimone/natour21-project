library flutter_switch;

import 'package:flutter/material.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onToggle,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.toggleColor = Colors.white,
    this.width = 70.0,
    this.height = 35.0,
    this.toggleSize = 25.0,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 4.0,
    this.showOnOff = false,
    this.activeText,
    this.inactiveText,
    this.activeTextFontWeight,
    this.inactiveTextFontWeight,
  }) : super(key: key);

  final bool value;

  final ValueChanged<bool> onToggle;

  final bool showOnOff;

  final String? activeText;

  final String? inactiveText;

  final Color activeColor;

  final Color inactiveColor;

  final Color activeTextColor;

  final Color inactiveTextColor;

  final FontWeight? activeTextFontWeight;

  final FontWeight? inactiveTextFontWeight;

  final Color toggleColor;

  final double width;

  final double height;

  final double toggleSize;

  final double valueFontSize;

  final double borderRadius;

  final double padding;

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _toggleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 60),
    );
    _toggleAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) return;

    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (widget.value) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }

            widget.onToggle(!widget.value);
          },
          child: Container(
            width: 55,
            height: 32,
            padding: EdgeInsets.all(widget.padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: _toggleAnimation.value == Alignment.centerLeft
                  ? grey
                  : mainColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _toggleAnimation.value == Alignment.centerRight
                    ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: const Text('On',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: _toggleAnimation.value,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.toggleColor,
                    ),
                  ),
                ),
                _toggleAnimation.value == Alignment.centerLeft
                    ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          alignment: Alignment.centerRight,
                          child: const Text('Off',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class CustomBounce extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Duration duration;

  const CustomBounce(
      {Key? key,
      required this.child,
      required this.duration,
      required this.onPressed})
      : super(key: key);

  @override
  CustomBounceState createState() => CustomBounceState();
}

class CustomBounceState extends State<CustomBounce> with SingleTickerProviderStateMixin {
  late double _scale;

  AnimationController? _animate;

  VoidCallback? get onPressed => widget.onPressed;

  Duration get userDuration => widget.duration;

  @override
  void initState() {
    _animate = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animate?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate!.value;
    return GestureDetector(
        onTap: _onTap,
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ));
  }

  void _onTap() {
    _animate!.forward();

    Future.delayed(userDuration, () {
      _animate!.reverse();

      if (onPressed != null) onPressed!();
    });
  }
}

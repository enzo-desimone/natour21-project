import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:natour21/Accessory_Class/size_config.dart';

class CustomLoader extends StatelessWidget {
  final Color color;

  const CustomLoader({Key? key, required this.color}) : super(key: key);

  Color _getColor(BuildContext context) => color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig().paddingThirty,
      height: SizeConfig().paddingThirty,
      child: _getLoader(context),
    );
  }

  Widget _getLoader(BuildContext context) {
    return LoaderType(
      color: _getColor(context),
    );
  }
}

class LoaderType extends StatefulWidget {
  final Color color;

  const LoaderType({Key? key, required this.color}) : super(key: key);

  @override
  _LoaderTypeState createState() => _LoaderTypeState();
}

class _LoaderTypeState extends State<LoaderType>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationRotation;
  late Animation<double> _animationRadiusOut;
  late Animation<double> _animationRadiusIn;
  final double _initialRadius = 20.0;
  double _radius = 20.0;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _animationRadiusIn = Tween<double>(begin: 1.0, end: 0.5).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));

    _animationRadiusOut = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.linear)));

    _animationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    _controller.addListener(() {
      if(mounted) {
        setState(() {
          if (_controller.value >= 0.0 && _controller.value <= 0.5) {
            _radius = _initialRadius * _animationRadiusIn.value;
          } else if (_controller.value >= 0.5 && _controller.value <= 1.0) {
            _radius = _initialRadius * _animationRadiusOut.value;
          }
        });
      }

    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RotationTransition(
      turns: _animationRotation,
      child: SizedBox(
        width: SizeConfig().paddingThirty,
        height: SizeConfig().paddingThirty,
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, _radius),
              child: Dot(
                radius: 10.0,
                color: widget.color,
              ),
            ),
            Transform.translate(
              offset: Offset(_radius, 0),
              child: Dot(
                radius: 10.0,
                color: widget.color,
              ),
            ),
            Transform.translate(
              offset: Offset(-_radius, 0),
              child: Dot(
                radius: 10.0,
                color: widget.color,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -_radius),
              child: Dot(
                radius: 10.0,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  const Dot({Key? key, required this.radius, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

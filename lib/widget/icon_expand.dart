import 'package:flutter/material.dart';
import 'dart:math' as math;

class IconExpand extends StatefulWidget {
  final Function(bool) onExpand;
  const IconExpand({required this.onExpand}) : super(key: const Key('icon_expand'));

  @override
  State<IconExpand> createState() => _IconExpandState();
}

class _IconExpandState extends State<IconExpand> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _expand = true;
  final angle = Tween(begin: 0 / 360, end: -90 / 360);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final scaleTween = TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
        ]);
        return RotationTransition(
          turns: _expand ? angle.animate(animation) : angle.animate(ReverseAnimation(animation)),
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: scaleTween.animate(animation),
            child: child,
          ),
        );
      },
      child: _expand
          ? FloatingActionButton(
              key: UniqueKey(),
              onPressed: () {
                setState(() {
                  _expand = !_expand;
                });
                widget.onExpand(_expand);
              },
              child: Transform.rotate(
                angle: math.pi / 2,
                child: Image.asset(
                  'asset/ic_show_less.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            )
          : FloatingActionButton(
              key: UniqueKey(),
              onPressed: () {
                setState(() {
                  _expand = !_expand;
                });
                widget.onExpand(_expand);
              },
              child: const Icon(Icons.menu, size: 20),
            ),
    );
  }
}

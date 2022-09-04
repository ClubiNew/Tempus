import 'package:flutter/material.dart';
import 'dart:math';

class ProgressCircle extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const ProgressCircle({
    required this.animation,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: SizedBox(
            height: size,
            width: size,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(size, size),
                  painter: _ProgressCirclePainter(
                    animation: animation,
                    ringColor: theme.colorScheme.background,
                    fillColor: theme.colorScheme.primary,
                    strokeWidth: 32.0,
                  ),
                ),
                Center(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final Animation<double> animation;
  final Color ringColor;
  final Color fillColor;
  final double strokeWidth;

  _ProgressCirclePainter({
    required this.animation,
    required this.ringColor,
    required this.fillColor,
    required this.strokeWidth,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset offset = Offset(strokeWidth / 2, strokeWidth / 2);
    size = Size(size.width - strokeWidth, size.height - strokeWidth);

    Paint paint = Paint()
      ..color = ringColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      size.center(offset),
      size.width / 2,
      paint,
    );

    paint.color = fillColor;

    canvas.drawArc(
      offset & size,
      pi * 1.5,
      animation.value * 2 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressCirclePainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}

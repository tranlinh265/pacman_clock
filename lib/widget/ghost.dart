// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:pacman_clock/widget/pacman.dart';
import 'package:flutter/material.dart';

// Ghost is one of movable object
// return a widget contains Ghost painter
class Ghost extends Pacman {
  final Color ghostColor;

  const Ghost({Key key, @required this.ghostColor, @required cellSize})
      : super(key: key, cellSize: cellSize);

  @override
  CustomPainter buildWidgetPainter() {
    return _GhostPainter(color: this.ghostColor, size: cellSize);
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}

// Cutom painter for Ghost Widget
class _GhostPainter extends CustomPainter {
  Path _bodyPath = Path();
  Paint _bodyPaint = Paint();
  Offset _eyeLeft;
  Offset _eyeRight;
  double _eyeRadius;
  Paint _eyePaint = Paint();

  _GhostPainter({Color color, size}) {
    _bodyPaint
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    _eyePaint
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    _bodyPath.moveTo(size * 0.2, size * 0.5);
    _bodyPath.cubicTo(
        size * 0.2, size * 0.5, size * 0.5, 0, size * 0.8, size * 0.5);
    _bodyPath.lineTo(size * 0.8, size * 0.9);
    _bodyPath.cubicTo(
        size * 0.8, size * 0.9, size * 0.7, size, size * 0.65, size * 0.95);
    _bodyPath.cubicTo(size * 0.75, size * 0.95, size * 0.6, size * 0.9,
        size * 0.55, size * 0.95);
    _bodyPath.cubicTo(
        size * 0.55, size * 0.95, size * 0.5, size, size * 0.45, size * 0.95);
    _bodyPath.cubicTo(size * 0.45, size * 0.95, size * 0.4, size * 0.9,
        size * 0.35, size * 0.95);
    _bodyPath.cubicTo(
        size * 0.35, size * 0.95, size * 0.3, size, size * 0.2, size * 0.9);
    _eyeLeft = Offset(0.4 * size, 0.5 * size);
    _eyeRight = Offset(0.6 * size, 0.5 * size);
    _eyeRadius = 0.05 * size;
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(_bodyPath, _bodyPaint);
    canvas.drawCircle(_eyeLeft, _eyeRadius, _eyePaint);
    canvas.drawCircle(_eyeRight, _eyeRadius, _eyePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

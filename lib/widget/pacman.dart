// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// Pacman is one of movable object
// return a widget contains Pacman painter
class Pacman extends StatelessWidget {
  final cellSize;

  const Pacman({Key key, this.cellSize}) : super(key: key);

  CustomPainter buildWidgetPainter() {
    return _PacmanPainter(size: cellSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(cellSize, cellSize),
        painter: buildWidgetPainter(),
      ),
    );
  }
}

// Cutom painter for Pacman Widget
class _PacmanPainter extends CustomPainter {
  Paint _bodyPaint = Paint();
  Offset _center;
  Paint _mouthPaint = Paint();
  Path _mouthPath = Path();
  double _bodyRadius;

  _PacmanPainter({@required double size}) {
    _bodyPaint
      ..color = Colors.yellowAccent
      ..strokeWidth = 0.0
      ..style = PaintingStyle.fill;
    _center = Offset(size / 2, size / 2);
    _mouthPaint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    _mouthPath.moveTo(0.1 * size, 0.25 * size);
    _mouthPath.lineTo(0.5 * size, 0.5 * size);
    _mouthPath.lineTo(0.1 * size, 0.75 * size);
    _bodyRadius = size * 0.35;
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(_center, _bodyRadius, _bodyPaint);
    canvas.drawPath(_mouthPath, _mouthPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

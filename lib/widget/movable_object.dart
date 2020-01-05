// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'ghost.dart' show Ghost;
import 'box.dart' show Cell;
import 'dart:math' show pi;

// Model for movable object ( pacman, ghost)
class MovableObject {
  List positions;
  MovableObjType movingObjType;
  Color color;
  MovableObject({this.positions, this.movingObjType, this.color});
}

enum MovableObjType {
  pacman,
  ghost,
}

// Change position of Movable object every second
class MovableObjectWidget extends StatefulWidget {
  final List positions;
  final double cellSize;
  final Widget child;

  const MovableObjectWidget(
      {@required this.positions,
      @required this.cellSize,
      @required this.child});

  @override
  _MovableObjectWidgetState createState() => _MovableObjectWidgetState();
}

class _MovableObjectWidgetState extends State<MovableObjectWidget> {
  Timer _timer;
  DateTime _dateTime;
  int _currentPosition = 0;
  int _currentDirection = 1;
  List<Widget> peachPosition = [];

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();

    _currentPosition =
        int.parse(DateFormat('ss').format(_dateTime)) % widget.positions.length;

    _updatePosition();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updatePosition() {
    setState(() {
      _dateTime = DateTime.now();

      var currentSec = int.parse(DateFormat('ss').format(_dateTime));

      if (widget.child is Ghost) {
        if (_currentPosition == 0) {
          _currentDirection = 1;
        } else if (_currentPosition == widget.positions.length - 1) {
          _currentDirection = -1;
        }

        _currentPosition += _currentDirection;
      } else {
        var currentMin = int.parse(DateFormat('mm').format(_dateTime));
        _currentPosition = currentSec + 60 * (currentMin % 2);

        if (currentSec == 0) {
          peachPosition.clear();
        }
        if (currentSec == 59) {
          if (peachPosition.length >= 58) {
            peachPosition.removeAt(peachPosition.length - 58);
          }
        }
      }

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updatePosition,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.cellSize;
    final currentCell = widget.positions[_currentPosition];

    Widget view = Stack(
      children: <Widget>[
        Positioned(
          top: currentCell["row"] * size,
          left: currentCell["col"] * size,
          child: Transform.rotate(
            angle: (currentCell["angle"] ?? 0) * pi,
            child: Container(
              height: size,
              width: size,
              child: widget.child,
            ),
          ),
        ),
        ...?peachPosition,
      ],
    );

    if (!(widget.child is Ghost)) {
      peachPosition.add(
        Positioned(
          top: size * currentCell["row"],
          left: size * currentCell["col"],
          child: Cell(
            size: widget.cellSize,
            hidePeach: true,
          ),
        ),
      );
    }

    return view;
  }
}

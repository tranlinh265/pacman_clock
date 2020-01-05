// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pacman_clock/widget/widget_helper.dart';

// A stack of Clock, Map, Pacman, Ghost
class PacmanDigitalClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    var size = 0.0;
    if (MediaQuery.of(context).orientation != Orientation.landscape) {
      size = _screenWidth / 35;
    } else {
      size = (_screenHeight -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom) /
          21;
    }
    return SafeArea(
      child: Center(
        child: AspectRatio(
          aspectRatio: 5 / 3,
          child: Stack(
            children: <Widget>[
              Map(
                cellSize: size,
              ),
              Clock(
                cellSize: size,
              ),
              MovableObjectGroup(
                cellSize: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Return group of Number widget. Two for showing hour, two for showing minute, and two dot in center
// e.g 02 : 28
//
// Widget update every minute
class Clock extends StatefulWidget {
  final cellSize;
  const Clock({this.cellSize});

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.cellSize;
    final hour = DateFormat('HH').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    return Positioned(
      top: size * 8,
      left: size * 9,
      child: Row(
        children: <Widget>[
          Number.fromString(hour[0], size),
          Cell.emptyCell(size: size),
          Number.fromString(hour[1], size),
          Cell.emptyCell(size: size),
          Column(
            children: <Widget>[
              Cell.dotCell(size: size),
              Cell.emptyCell(size: size),
              Cell.dotCell(size: size),
            ],
          ),
          Cell.emptyCell(size: size),
          Number.fromString(minute[0], size),
          Cell.emptyCell(size: size),
          Number.fromString(minute[1], size),
        ],
      ),
    );
  }
}

// Return a map, line for Pacman and Ghost
// map's size is 35x21 Cell size
class Map extends StatelessWidget {
  final cellSize;

  const Map({this.cellSize});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString("assets/map.json"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var mapData = json.decode(snapshot.data.toString());

          return GridView.builder(
            itemCount: mapData == null ? 0 : mapData.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 35),
            itemBuilder: (BuildContext context, int index) {
              var data = mapData[index];
              return Cell(
                left: data['left'] ?? false,
                right: data['right'] ?? false,
                top: data['top'] ?? false,
                bottom: data['bottom'] ?? false,
                size: cellSize,
              );
            },
          );
        } else {
          return GridView.builder(
            itemCount: 35 * 21,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 35),
            itemBuilder: (BuildContext context, int index) {
              return Cell(
                size: cellSize,
              );
            },
          );
        }
      },
    );
  }
}

// Group of Pacman and 4 Ghost
// Movable object position can be loaded from json file in assets/
class MovableObjectGroup extends StatefulWidget {
  final cellSize;

  const MovableObjectGroup({Key key, @required this.cellSize})
      : super(key: key);

  @override
  _MovableObjectGroupState createState() => _MovableObjectGroupState();
}

class _MovableObjectGroupState extends State<MovableObjectGroup> {
  List<MovableObject> _positionData = [];

  @override
  void initState() {
    super.initState();
    loadObjectDataFromJsonFile(
        jsonFile: "assets/pacman_position.json",
        movingObjType: MovableObjType.pacman);
    loadObjectDataFromJsonFile(
        jsonFile: "assets/white_ghost_position.json", color: Colors.white);
    loadObjectDataFromJsonFile(
        jsonFile: "assets/blue_ghost_position.json", color: Colors.blue);
    loadObjectDataFromJsonFile(
        jsonFile: "assets/green_ghost_position.json", color: Colors.green);
    loadObjectDataFromJsonFile(
        jsonFile: "assets/pink_ghost_position.json", color: Colors.pink);
  }

  Future<void> loadObjectDataFromJsonFile(
      {@required String jsonFile,
      MovableObjType movingObjType = MovableObjType.ghost,
      Color color = Colors.blue}) async {
    var jsonText = await rootBundle.loadString(jsonFile);
    var positionList = json.decode(jsonText);
    var movingObjData = MovableObject(
        positions: positionList, movingObjType: movingObjType, color: color);
    this._positionData.add(movingObjData);

    setState(() {
      this._positionData = this._positionData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this._positionData != null && this._positionData.isNotEmpty) {
      List<Widget> movingObjectWidgets = [];
      for (var movingObject in this._positionData) {
        movingObjectWidgets.add(MovableObjectWidget(
          cellSize: widget.cellSize,
          positions: movingObject.positions,
          child: movingObject.movingObjType == MovableObjType.pacman
              ? Pacman(
                  cellSize: widget.cellSize,
                )
              : Ghost(
                  ghostColor: movingObject.color,
                  cellSize: widget.cellSize,
                ),
        ));
      }

      return Stack(
        children: movingObjectWidgets,
      );
    }
    return SizedBox();
  }
}

// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'box.dart';

// Return a widget with rectangle shape ( 3 x 5 Cell widget size)
// View the number 0 to 9 with Cell widget
//  _
// | |
//  -
// | |
//  -
class Number extends StatelessWidget {
  final bool top, mid, btm, topLeft, topRight, btmLeft, btmRight;
  final double size;

  const Number({
    @required this.size,
    this.top = false,
    this.mid = false,
    this.btm = false,
    this.topLeft = false,
    this.topRight = false,
    this.btmLeft = false,
    this.btmRight = false,
  });

  static Number fromString(String numStr, double size) {
    var top = "23567890".contains(numStr);
    var topLeft = "4567890".contains(numStr);
    var topRight = "12347890".contains(numStr);
    var mid = "2345689".contains(numStr);
    var btmLeft = "2680".contains(numStr);
    var btmRight = "134567890".contains(numStr);
    var btm = "2356890".contains(numStr);
    return Number(
      top: top,
      mid: mid,
      btm: btm,
      topLeft: topLeft,
      topRight: topRight,
      btmLeft: btmLeft,
      btmRight: btmRight,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Cell(
              left: top | topLeft,
              right: !top & topLeft,
              top: top | topLeft,
              bottom: top & !topLeft,
              size: size,
            ),
            Cell(
              top: top,
              bottom: top,
              size: size,
            ),
            Cell(
              left: !top & topRight,
              right: top | topRight,
              top: top | topRight,
              bottom: top & !topRight,
              size: size,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Cell(
              left: topLeft,
              right: topLeft,
              size: size,
            ),
            Cell(
              size: size,
            ),
            Cell(
              left: topRight,
              right: topRight,
              size: size,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Cell(
              left: topLeft | mid | btmLeft,
              right: (topLeft | btmLeft) & !mid,
              top: !topLeft & (mid | btmLeft),
              bottom: !btmLeft & (mid | topLeft),
              size: size,
            ),
            Cell(
              top: mid,
              bottom: mid,
              size: size,
            ),
            Cell(
              left: !mid & (topRight | btmRight),
              right: mid | topRight | btmRight,
              top: !topRight & (mid | btmRight),
              bottom: !btmRight & (mid | topRight),
              size: size,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Cell(
              left: btmLeft,
              right: btmLeft,
              size: size,
            ),
            Cell(
              size: size,
            ),
            Cell(
              left: btmRight,
              right: btmRight,
              size: size,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Cell(
              left: btm | btmLeft,
              right: !btm & btmLeft,
              top: btm & !btmLeft,
              bottom: btm | btmLeft,
              size: size,
            ),
            Cell(
              top: btm,
              bottom: btm,
              size: size,
            ),
            Cell(
              left: !btm & btmRight,
              right: btm | btmRight,
              top: btm & !btmRight,
              bottom: btm | btmRight,
              size: size,
            ),
          ],
        ),
      ],
    );
  }
}

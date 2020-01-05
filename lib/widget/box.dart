// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// The smallest unit on Map
// return a square container with side border, and small circle in center
class Cell extends StatelessWidget {
  final bool left, right, top, bottom;
  final double size;
  final hidePeach;

  const Cell(
      {this.left = false,
      this.right = false,
      this.top = false,
      this.bottom = false,
      this.size = 20.0,
      this.hidePeach = false});

  static Cell emptyCell({@required double size}) {
    return Cell(
      size: size,
    );
  }

  static Cell dotCell({@required double size}) {
    return Cell(
      top: true,
      right: true,
      bottom: true,
      left: true,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(width: 1.1, color: Colors.blue);
    final nullBorder = BorderSide(width: 0.0, color: Colors.black);

    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          left: this.left ? border : nullBorder,
          bottom: this.bottom ? border : nullBorder,
          right: this.right ? border : nullBorder,
          top: this.top ? border : nullBorder,
        ),
      ),
      child: (hidePeach | left | right | top | bottom)
          ? SizedBox()
          : Container(
              margin: EdgeInsets.all(size * 0.4),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
            ),
    );
  }
}

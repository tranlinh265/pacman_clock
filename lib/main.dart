// Copyright 2020 Tran Linh. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:pacman_clock/pacman_digital_clock.dart' show PacmanDigitalClock;

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PacmanDigitalClock(),
      ),
    );
  }
}

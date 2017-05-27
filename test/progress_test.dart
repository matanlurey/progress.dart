// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:progress/progress.dart';
import 'package:test/test.dart';

void main() {
  test('asProgress should convert an input stream into moments', () async {
    final inputs = new Stream.fromIterable([
      10,
      20,
      30,
      40,
      50,
      60,
      70,
      80,
      90,
      100,
    ]);
    expect(
      await asProgress(inputs, 100).map((moment) => moment.percent).toList(),
      [
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9,
        1.0,
      ],
    );
  });
}

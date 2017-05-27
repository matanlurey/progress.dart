// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';

typedef DateTime _Clock();
DateTime _defaultClock() => new DateTime.now();

/// Represents a [Stream] of [Moment]s, including helpers for common tasks.
abstract class Progress<N extends num> extends Stream<Moment<N>> {
  /// Returns transformed as a stream of percents.
  Stream<num> percent();
}

/// Returns a stream of input [current] values compared against [total].
Progress<N> asProgress<N extends num>(
  Stream<N> current,
  N total, {
  DateTime clock(): _defaultClock,
}) {
  StreamSubscription subscription;
  StreamController<Moment<N>> controller;
  Updater<N> updater;
  controller = new StreamController<Moment<N>>(
    onListen: () {
      subscription = current.listen(updater.update, onDone: controller.close);
    },
    onCancel: () {
      subscription.cancel();
    },
  );
  return updater = new _Updater(controller, total, clock);
}

/// Concrete implementation of [Progress] that includes mutability.
abstract class Updater<N extends num> extends Progress<N> {
  factory Updater(N total, {DateTime clock(): _defaultClock}) {
    return new _Updater(new StreamController<Moment<N>>(), total, clock);
  }

  /// Updates the progress to [current].
  ///
  /// If [current] equals the total amount, the stream is closed.
  void update(N current);
}

class _Updater<N extends num> extends StreamView<Moment<N>>
    implements Updater<N> {
  final _Clock _clock;
  final Sink<Moment> _sink;
  final num _total;

  _Updater(
    StreamController<Moment<N>> controller,
    this._total, [
    this._clock = _defaultClock,
  ])
      : _sink = controller,
        super(controller.stream);

  @override
  Stream<num> percent() => map((m) => m.percent);

  @override
  void update(N current) {
    _sink.add(new Moment._(current, _total, _clock()));
    if (current == _total) {
      _sink.close();
    }
  }
}

/// Represents a position ([current] / [total]) in a [Progress] stream.
@immutable
class Moment<N extends num> {
  /// Current value, such as the amount of data downloaded so far.
  final N current;

  /// Total value, such as the total amount of data being downloaded.
  final N total;

  /// When the moment occurred.
  final DateTime at;

  Moment._(this.current, this.total, this.at) {
    assert(current <= total, 'Current cannot exceed the total.');
  }

  /// Moment as a percent (i.e. between `0.0` -> `1.0`).
  num get percent => total == 0 ? 0 : current / total;

  /// How many exact units are remaining.
  N get remaining => total - current;

  @override
  String toString() => '$Moment {$current out of $total: $percent%}';
}

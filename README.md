# progress

Compute progress of a long-running process.

This package is platform agnostic, and will work equally well for command-line
applications (CLI), mobile applications on [Flutter][], and web applications
written in Dart.

[Flutter]: https://flutter.io

**Warning**: This is not an official Google or Dart project.

## Installation

```yaml
dependencies:
  progress: ^0.1.0
```

## Usage

To produce a `Stream<Moment>`, use an `Updater`:

```dart
// A simple stub of reporting 50% progress, then 100%.
Stream<Moment> progress() {
  final updater = new Updater(100);
  scheduleMicrotask(() {
    updater.update(50);
    scheduleMicrotask(() {
      updater.update(100);
    });
  });
  return updater;
}
```

To use an existing `Stream<num>` of current values, use `asProgress`:

```dart
asProgress(currentValues, totalValue);
```

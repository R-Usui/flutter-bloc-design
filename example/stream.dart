// Contents
// 1. Creating streams in Dart
//  1.1. Transforming an existing stream
//  1.2 Creating a stream from scratch
//  1.3 Using a StreamController

// =========================================================
// 1. Creating streams in Dart

// ---------------------------------------------------------
//  1.1. Transforming an existing stream

// 1.1.1 A stream that doubles each value
import 'dart:async';

Stream<T> doubledStream<T extends num>(Stream<T> stream) async* {
  await for (final value in stream) {
    yield value * 2 as T;
  }
}

// By using .map(), you can also implement above sample simply.
Stream<T> doubledStream2<T extends num>(Stream<T> stream) {
  return stream.map((final value) => value * 2 as T);
}

// ---------------------------------------------------------
// 1.2 Creating a stream from scratch
Stream<int> timedCounter({required Duration interval, int? maxCount}) async* {
  int i = 0;
  while (true) {
    await Future.delayed(interval);
    yield i++;
    if (i == maxCount) break;
  }
}

// ---------------------------------------------------------
//  1.3 Using a StreamController

Stream<int> timedCounterWithController(Duration interval, [int? maxCount]) {
  late StreamController<int> controller;
  Timer? timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (counter == maxCount) {
      timer?.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}

void main() async {}

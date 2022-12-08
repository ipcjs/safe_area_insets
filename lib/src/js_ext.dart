// ignore_for_file: avoid_web_libraries_in_flutter

@JS()
library js_ext;

import 'dart:html';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:js/js.dart';

/// @see
/// - https://github.com/dart-lang/sdk/issues/26544
/// - https://github.com/luanpotter/dart_web_audio/blob/master/package/lib/dart_web_audio.dart
///
/// Created by ipcjs on 2022/12/8.
@JS()
@staticInterop
class JSEventTarget {}

extension JSEventTargetExt on JSEventTarget {
  external void addEventListener(
    String type,
    EventListener listener, [
    AddEventListenerOptionsOrBool? options,
  ]);
  external void removeEventListener(
    String type,
    EventListener listener, [
    EventListenerOptionsOrBool? options,
  ]);
}

typedef Disposable = void Function();

extension EventTargetExt on EventTarget {
  Disposable listenEvent(
    String type,
    EventListener listener, [
    AddEventListenerOptionsOrBool? options,
  ]) {
    final jsListener = allowInterop(listener);
    final js = this as JSEventTarget;
    js.addEventListener(type, jsListener, options);
    return () => js.removeEventListener(type, jsListener);
  }
}

typedef EventListenerOptionsOrBool = dynamic;
typedef AddEventListenerOptionsOrBool = dynamic;

@anonymous
@JS()
abstract class EventListenerOptions {
  external bool get capture;
  external set capture(bool v);
  external factory EventListenerOptions({bool capture});
}

@anonymous
@JS()
abstract class AddEventListenerOptions implements EventListenerOptions {
  external bool get once;
  external set once(bool v);
  external bool get passive;
  external set passive(bool v);
  external factory AddEventListenerOptions(
      {bool once, bool passive, bool capture});
}

@visibleForTesting
void testJsExt() {
  final div = DivElement()
    ..id = 'js_ext_test'
    ..text = 'click to hide me.';
  div.style
    ..backgroundColor = 'red'
    ..color = 'white'
    ..position = 'fixed';
  Disposable? disposable;
  disposable = div.listenEvent(
    'click',
    (event) {
      window.console.log('$event');
      div.style.display = 'none';
      disposable?.call();
    },
  );

  document.body?.children.add(div);
}

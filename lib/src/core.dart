// ignore_for_file: avoid_web_libraries_in_flutter, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:core';
import 'dart:html';

import 'package:flutter/rendering.dart' show EdgeInsets;

import 'js_ext.dart';

enum _InsetsAttr { top, left, right, bottom }

EdgeInsets _readInsets() {
  final styles = elementComputedStyle;
  return EdgeInsets.only(
    left: styles[_InsetsAttr.left]?.insetValue ?? 0.0,
    top: styles[_InsetsAttr.top]?.insetValue ?? 0.0,
    right: styles[_InsetsAttr.right]?.insetValue ?? 0.0,
    bottom: styles[_InsetsAttr.bottom]?.insetValue ?? 0.0,
  );
}

extension _Ext on CssStyleDeclaration {
  double? get insetValue {
    final value = paddingBottom;
    if (!value.endsWith('px')) {
      return null;
    }
    return double.tryParse(value.substring(0, value.length - 2));
  }
}

/// use Dart rewrite [safeAreaInsets](https://github.com/zhetengbiji/safeAreaInsets/blob/master/src/index.ts)
var inited = false;
var elementComputedStyle = <_InsetsAttr, CssStyleDeclaration>{};
String? support;

String getSupport() {
  String support;
  if (Css.supportsCondition('top: env(safe-area-inset-top)')) {
    support = 'env';
  } else if (Css.supportsCondition('top: constant(safe-area-inset-top)')) {
    support = 'constant';
  } else {
    support = '';
  }
  return support;
}

void init() {
  if (!isSupported) {
    return;
  }

  void setStyle(HtmlElement el, Map<String, String> style) {
    style.forEach((key, value) {
      el.style.setProperty(key, value);
    });
  }

  final cbs = <VoidCallback>[];
  void parentReady([VoidCallback? callback]) {
    if (callback != null) {
      cbs.add(callback);
    } else {
      cbs.forEach((cb) {
        cb();
      });
    }
  }

  /*
    // Check if passive is supported
    var passiveEvents: any = false
    try {
        var opts = Object.defineProperty({}, 'passive', {
            get: function() {
                passiveEvents = { passive: true }
            }
        })
        window.addEventListener('test', null, opts)
    } catch(e) {

    }
    */

  void addChild(HtmlElement parent, _InsetsAttr attr) {
    final a1 = DivElement();
    final a2 = DivElement();
    final a1Children = DivElement();
    final a2Children = DivElement();
    const W = 100;
    // ignore: constant_identifier_names
    const MAX = 10000;
    final aStyle = <String, String>{
      'position': 'absolute',
      'width': '${W}px',
      'height': '200px',
      'box-sizing': 'border-box',
      'overflow': 'hidden',
      'padding-bottom': '$support(safe-area-inset-${attr.name})'
    };
    setStyle(a1, aStyle);
    setStyle(a2, aStyle);
    setStyle(a1Children, {
      'transition': '0s',
      'animation': 'none',
      'width': '400px',
      'height': '400px',
    });
    setStyle(a2Children, {
      'transition': '0s',
      'animation': 'none',
      'width': '250%',
      'height': '250%',
    });
    a1.children.add(a1Children);
    a2.children.add(a2Children);
    parent.children.add(a1);
    parent.children.add(a2);

    parentReady(() {
      a1.scrollTop = a2.scrollTop = MAX;
      var a1LastScrollTop = a1.scrollTop;
      var a2LastScrollTop = a2.scrollTop;
      EventListener onScroll(HtmlElement that) {
        return (ev) {
          if (that.scrollTop ==
              (that == a1 ? a1LastScrollTop : a2LastScrollTop)) {
            return;
          }
          a1.scrollTop = a2.scrollTop = MAX;
          a1LastScrollTop = a1.scrollTop;
          a2LastScrollTop = a2.scrollTop;
          _attrChange(attr);
        };
      }

      a1.listenEvent(
        'scroll',
        onScroll(a1),
        AddEventListenerOptions(passive: true),
      );
      a2.listenEvent(
        'scroll',
        onScroll(a2),
        AddEventListenerOptions(passive: true),
      );
    });

    final computedStyle = a1.getComputedStyle();
    elementComputedStyle[attr] = computedStyle;
  }

  final parentDiv = DivElement();
  setStyle(parentDiv, {
    'position': 'absolute',
    'left': '0',
    'top': '0',
    'width': '0',
    'height': '0',
    'zIndex': '-1',
    'overflow': 'hidden',
    'visibility': 'hidden',
  });
  _InsetsAttr.values.forEach((key) {
    addChild(parentDiv, key);
  });
  document.body?.children.add(parentDiv);
  parentReady();
  inited = true;
}

/// Read the current 'safe-area-insets'
EdgeInsets get safeAreaInsets {
  if (!inited) {
    init();
  }
  return _readInsets();
}

final _insetsStreamController = StreamController<EdgeInsets>.broadcast(
  onListen: () {
    if (!inited) {
      init();
    }
  },
  sync: true,
);

/// Listen to the changes of `safe-area-insets`
Stream<EdgeInsets> get safeAreaInsetsStream => _insetsStreamController.stream;

var changeAttrs = <_InsetsAttr>[];
void _attrChange(_InsetsAttr attr) {
  if (changeAttrs.isEmpty) {
    Timer(Duration.zero, () {
      if (changeAttrs.isEmpty) {
        return;
      }
      changeAttrs.clear();
      _insetsStreamController.add(_readInsets());
    });
  }
  changeAttrs.add(attr);
}

bool get isSupported => (support ??= getSupport()).isNotEmpty;

/// Set `viewport-fit=cover`
///
/// @see https://github.com/flutter/flutter/issues/84833#issuecomment-890540239
void setupViewportFit() {
  var viewport = querySelector('meta[name=viewport]') as MetaElement?;
  if (viewport == null) {
    viewport = MetaElement();
    document.head?.children.add(viewport);
  }
  final attrs = <String, String>{};
  for (final keyValue
      in viewport.content.split(',').map((e) => e.trim().split('='))) {
    if (keyValue.length == 2) {
      attrs[keyValue[0]] = keyValue[1];
    }
  }

  if (attrs['viewport-fit'] != 'cover') {
    attrs['viewport-fit'] = 'cover';
    viewport.content =
        attrs.entries.map((e) => '${e.key}=${e.value}').join(',');
  }
}

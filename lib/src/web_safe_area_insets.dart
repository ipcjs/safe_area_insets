// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:safe_area_insets/safe_area_insets.dart';

typedef SafeAreaInsetsChangedCallback = void Function(EdgeInsets insets);

/// Created by ipcjs on 2022/12/8.
class WebSafeAreaInsets extends StatefulWidget {
  const WebSafeAreaInsets({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<WebSafeAreaInsets> createState() => _WebSafeAreaInsetsState();
}

class _WebSafeAreaInsetsState extends State<WebSafeAreaInsets> {
  late EdgeInsets _insets;
  @override
  void initState() {
    super.initState();
    _insets = safeAreaInsets;
    onChange(_handleInsetsChanged);
  }

  void _handleInsetsChanged(EdgeInsets insets) {
    setState(() {
      _insets = insets;
    });
  }

  @override
  void dispose() {
    offChange(_handleInsetsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    if (data.viewPadding != EdgeInsets.zero) {
      return widget.child;
    }

    return MediaQuery(
      data: data.copyWith(
        viewPadding: _insets,
        padding: (_insets - data.viewInsets)
            .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity) as EdgeInsets,
      ),
      child: widget.child,
    );
  }
}

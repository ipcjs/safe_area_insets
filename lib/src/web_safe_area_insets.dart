// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/widgets.dart';
import 'package:safe_area_insets/safe_area_insets.dart';

typedef SafeAreaInsetsChangedCallback = void Function(EdgeInsets insets);

/// Created by ipcjs on 2022/12/8.
class WebSafeAreaInsets extends StatelessWidget {
  const WebSafeAreaInsets({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    if (data.viewPadding != EdgeInsets.zero) {
      // If it is not zero, it means that Flutter may have implemented the method of
      // reading the SafeArea of the webpage, and no processing is required.
      return child;
    }

    return StreamBuilder<EdgeInsets>(
      stream: safeAreaInsetsStream,
      builder: (context, snapshot) {
        final insets = snapshot.data ?? safeAreaInsets;
        return MediaQuery(
          data: data.copyWith(
            viewPadding: insets,
            padding: (insets - data.viewInsets).clamp(
                EdgeInsets.zero, EdgeInsetsGeometry.infinity) as EdgeInsets,
          ),
          child: child,
        );
      },
    );
  }
}

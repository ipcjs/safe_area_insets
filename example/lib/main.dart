import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_area_insets/safe_area_insets.dart';

import 'js_ext_stub.dart'
    if (dart.library.html) 'package:safe_area_insets/src/js_ext.dart';

void main() {
  testJsExt();
  if (kIsWeb) setupViewportFit();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          left: false,
          right: false,
          child: Container(
            alignment: Alignment.center,
            color: Colors.green,
            child: Material(
              child: kIsWeb
                  ? StreamBuilder(
                      stream: safeAreaInsetsStream,
                      builder: (context, snapshot) => Text(
                        'SafeAreaInsets: ${snapshot.data ?? safeAreaInsets}',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const Text('unsupported'),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        child ??= const SizedBox();
        return kIsWeb ? WebSafeAreaInsets(child: child) : child;
      },
    );
  }
}

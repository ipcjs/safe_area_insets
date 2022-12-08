import 'package:flutter/rendering.dart';

import 'web_safe_area_insets.dart';

Never _unsupported() =>
    throw UnsupportedError('The method only be called on Web platform.');

EdgeInsets get safeAreaInsets => _unsupported();

void onChange(SafeAreaInsetsChangedCallback callback) => _unsupported();

void offChange(SafeAreaInsetsChangedCallback callback) => _unsupported();

void setupViewportFit() => _unsupported();

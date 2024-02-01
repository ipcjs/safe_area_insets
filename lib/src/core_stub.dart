import 'package:flutter/rendering.dart';

Never _unsupported() =>
    throw UnsupportedError('The method only be called on Web platform.');

EdgeInsets get safeAreaInsets => _unsupported();

Stream<EdgeInsets> get safeAreaInsetsStream => _unsupported();

void setupViewportFit() => _unsupported();

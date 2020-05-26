import 'package:flutter/material.dart';

class Style {
  final context;
  Style.of(this.context);

  ThemeData get appTheme => ThemeData(
    primarySwatch: Colors.cyan,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
import 'package:quicknotes/src/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
    theme: ThemeData(
        primaryColor: Colors.red
    ),
  ),
  );
}
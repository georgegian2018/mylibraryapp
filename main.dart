// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(ResearchLibraryApp());
}

class ResearchLibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LibraryScreen(),
    );
  }
}

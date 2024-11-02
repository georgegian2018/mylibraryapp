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

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ResearchLibraryApp());
}

class ResearchLibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research Library',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LibraryScreen(),
    );
  }
}

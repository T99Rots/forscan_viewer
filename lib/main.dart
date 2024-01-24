import 'package:flutter/material.dart';
import 'package:forscan_viewer/screens/graph_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
        ),
      ),
      home: const GraphPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:location_template/view/user_input_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location App',
      home: UserInputPage(),
    );
  }
}

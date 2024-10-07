import 'package:flutter/material.dart';
import 'package:location_template/provider/location_provider.dart';
import 'package:location_template/view/user_input_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location App',
        home: UserInputPage(),
      ),
    );
  }
}

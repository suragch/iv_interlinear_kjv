import 'package:flutter/material.dart';

import 'package:iv_interlinear_kjv/screens/home/home_screen.dart';
import 'package:iv_interlinear_kjv/services/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
      ),
      title: 'IV Interlinear KJV',
      home: const HomeScreen(),
    );
  }
}

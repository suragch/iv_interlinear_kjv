import 'package:flutter/material.dart';

import 'package:iv_interlinear_kjv/screens/home/home_screen.dart';
import 'package:iv_interlinear_kjv/services/database_helper.dart';
import 'package:iv_interlinear_kjv/services/service_locator.dart';

import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<NtDatabaseHelper>().init();
  await getIt<OtDatabaseHelper>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = MaterialTheme(Theme.of(context).textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      title: 'IV Interlinear KJV',
      home: const HomeScreen(),
    );
  }
}

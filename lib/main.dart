import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reachgoal/database/habit_db.dart';
import 'package:reachgoal/theme/Light_mode.dart';
import 'package:reachgoal/theme/ThemeProvider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDb.initialize();

  HabitDb habitDb = HabitDb();
  await habitDb.saveFirstLaunchDate();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => habitDb),
        ChangeNotifierProvider( create: (context) => ThemeProvider()),
 ], child: const MyApp())
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.w
  @override
Widget build(BuildContext context) {
    return MaterialApp(
title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home:  const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData 
    );
  }
}
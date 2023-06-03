import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:myapp/screens/homescreen.dart';
import 'package:myapp/screens/todolist.dart';
import 'package:myapp/screens/todolistmysql.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main(List<String> args) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomeScreen(),
        "/todolist": (context) => const TodoList(),
        "/todolistmysql": (context) => const TodoListMysql(),
      },
    );
  }
}

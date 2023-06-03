import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:myapp/utils/myappbar.dart';
import 'package:myapp/utils/mybottombar.dart';
import 'package:myapp/utils/mydrawer.dart';
import 'package:myapp/utils/myfab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  double fontSize = 12;
  List<Widget> bodyList = [
    const Text("Ana Sayfa"),
    const Text("İletişim"),
    const Text("Ayarlar")
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(builder: (context, state, child) {
      return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const MyFAB(),
          bottomNavigationBar: const MyBottomBar(),
          drawer: const MyDrawer(),
          appBar: const MyAppBar(),
          body: Center(child: bodyList[state.currentIndex]));
    });
  }
}

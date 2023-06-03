import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:provider/provider.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(builder: (context, state, child) {
      return BottomNavigationBar(
          selectedItemColor: Colors.white,
          backgroundColor: Colors.teal,
          onTap: (value) {
            state.setCurrentIndex(value);
          },
          currentIndex: state.currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.phone,
                  size: 0,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Ayarlar"),
          ]);
    });
  }
}

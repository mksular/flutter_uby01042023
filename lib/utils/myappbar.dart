import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:myapp/utils/searchtodo.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight + 10);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(builder: (context, state, child) {
      return AppBar(
        title: state.routeName == "/"
            ? state.currentIndex == 0
                ? const Text("Ana Sayfa")
                : state.currentIndex == 1
                    ? const Text("İletişim")
                    : const Text("Ayarlar")
            : state.routeName == "/todolist"
                ? const Text("Todolist")
                : state.routeName == "/todolistmysql"
                    ? const SearchTodo()
                    : const Text(""),
      );
    });
  }
}

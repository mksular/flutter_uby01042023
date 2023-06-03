import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(builder: (context, state, child) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/mksular2.jpg"),

                          /* NetworkImage(
                                  "https://media.licdn.com/dms/image/D4D03AQGcyfAm3CZQIA/profile-displayphoto-shrink_800_800/0/1679577384772?e=2147483647&v=beta&t=FiYXpdk0dIYUgTBk8BKwgM12WrDtXrAN4t8XN-yskOY")
                                  
                                   */
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  const Text('Mehmet Kasım Sular'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pushNamed(context, "/");
                state.setRouteName("/");
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Todolist'),
              onTap: () {
                Navigator.pushNamed(context, "/todolist");
                state.setRouteName("/todolist");
              },
            ),
            ListTile(
              leading: const Icon(Icons.dataset),
              title: const Text('Todolist Mysql'),
              onTap: () {
                Navigator.pushNamed(context, "/todolistmysql");
                state.setRouteName("/todolistmysql");
              },
            ),
          ],
        ),
      );
    });
  }
}

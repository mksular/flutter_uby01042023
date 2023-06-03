import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:provider/provider.dart';

class MyFAB extends StatefulWidget {
  const MyFAB({super.key});

  @override
  State<MyFAB> createState() => _MyFABState();
}

class _MyFABState extends State<MyFAB> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(builder: (context, state, child) {
      return InkWell(
          onTap: () {
            state.setCurrentIndex(1);
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                color: Colors.teal,
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.phone,
              size: 36,
              color: state.currentIndex == 1 ? Colors.white : Colors.black,
            ),
          ));
    });
  }
}

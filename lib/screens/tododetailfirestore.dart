import 'package:flutter/material.dart';
import 'package:myapp/models/todofire.dart';

class TodoDetailFirestore extends StatefulWidget {
  final TodoFire todo;
  const TodoDetailFirestore({super.key, required this.todo});

  @override
  State<TodoDetailFirestore> createState() => _TodoDetailFirestoreState();
}

class _TodoDetailFirestoreState extends State<TodoDetailFirestore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.todo.title} Detay"),
        actions: [
          InkWell(
              onTap: () {},
              child: const Icon(
                Icons.edit,
              )),
          InkWell(
              onTap: () {
                setState(() {
                  widget.todo.isStar = !widget.todo.isStar!;
                });
              },
              child: Icon(
                Icons.star,
                color: widget.todo.isStar! ? Colors.amber : Colors.black45,
              )),
          InkWell(onTap: () {}, child: const Icon(Icons.delete)),
        ],
      ),
      body: Center(
        child: ListTile(
          title: Text(widget.todo.title.toString()),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/models/todo.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  const TodoDetail({super.key, required this.todo});

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
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
          title: Text(widget.todo.title),
        ),
      ),
    );
  }
}

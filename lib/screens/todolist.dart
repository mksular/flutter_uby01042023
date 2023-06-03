import 'package:flutter/material.dart';
import 'package:myapp/models/todo.dart';
import 'package:myapp/utils/myappbar.dart';
import 'package:myapp/utils/mydrawer.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todoList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
      drawer: const MyDrawer(),
      appBar: const MyAppBar(),
      body: Column(children: [
        Expanded(
            flex: 1,
            child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                color: Colors.yellow[200],
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(),
                    keyboardType: TextInputType.text,
                    onSaved: (newValue) {
                      setState(() {
                        title = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Boş geçilemez";
                      }
                      return null;
                    },
                    autovalidateMode: autoValidateMode,
                  ),
                ))),
        Expanded(
            flex: 2,
            child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: todoList.isEmpty
                    ? const Center(
                        child: Text("Kayıt bulunamadı"),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 2,
                              color: Colors.white,
                            ),
                        itemCount: todoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var element = todoList[index];
                          return ListTile(
                            tileColor: element.isComplated!
                                ? Colors.red[200]
                                : Colors.green[200],
                            leading: Checkbox(
                              onChanged: (newValue) {
                                setState(() {
                                  element.isComplated = !element.isComplated!;
                                });
                              },
                              value: element.isComplated,
                            ),
                            title: Text(
                              element.title,
                              style: TextStyle(
                                  decoration: element.isComplated!
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        todoList.remove(element);
                                      });
                                    },
                                    child: const Icon(Icons.delete)),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        element.isStar = !element.isStar!;
                                      });
                                    },
                                    child: Icon(
                                      Icons.star,
                                      color: element.isStar!
                                          ? Colors.amber
                                          : Colors.black45,
                                    )),
                              ],
                            ),
                          );
                        }))),
      ]),
    );
  }

  void addTodo() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Todo todo =
          Todo(id: todoList.isEmpty ? 1 : todoList.last.id + 1, title: title);

      setState(() {
        todoList.add(todo);
      });
      successAlert();
      formKey.currentState!.reset();
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  Future<void> successAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tebrikler!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  Icons.check,
                  size: 120,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

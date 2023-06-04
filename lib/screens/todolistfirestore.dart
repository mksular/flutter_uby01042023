import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/state.dart';
import 'package:myapp/models/todofire.dart';
import 'package:myapp/screens/tododetailfirestore.dart';
import 'package:myapp/utils/myappbar.dart';
import 'package:myapp/utils/mydrawer.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class TodoListFirestore extends StatefulWidget {
  const TodoListFirestore({super.key});

  @override
  State<TodoListFirestore> createState() => _TodoListFirestoreState();
}

class _TodoListFirestoreState extends State<TodoListFirestore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String title;
  late final MySqlConnection conn;
  late TodoFire todo;
  bool isObsecure = false;
  bool isLoading = false;
  bool isEdit = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  var colRef = FirebaseFirestore.instance.collection("todo");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    conn.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(builder: (context, state, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            isEdit ? updateTodoMysql(todo) : addTodo(state);
          },
          child: Icon(isEdit ? Icons.save : Icons.add),
        ),
        drawer: const MyDrawer(),
        appBar: const MyAppBar(),
        body: Stack(children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                    semanticsLabel: "yükleniyor...",
                  ),
                )
              : const SizedBox(),
          Column(children: [
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    color: Colors.yellow[200],
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: titleController,
                        obscureText: isObsecure,
                        decoration: InputDecoration(
                            labelText: "Başlık",
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isObsecure = !isObsecure;
                                  });
                                },
                                child: Icon(isObsecure
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
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
                flex: 5,
                child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 100),
                    alignment: Alignment.topLeft,
                    child: state.todoListFirestore.isEmpty
                        ? const Center(
                            child: Text("Kayıt bulunamadı"),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                                  height: 2,
                                  color: Colors.white,
                                ),
                            itemCount: state.todoListFirestore.length,
                            itemBuilder: (BuildContext context, int index) {
                              var element = state.todoListFirestore[index];
                              return ListTile(
                                subtitle: Text(element.id.toString()),
                                tileColor: element.isComplated!
                                    ? Colors.red[200]
                                    : Colors.green[200],
                                leading: Checkbox(
                                  onChanged: (newValue) {
                                    setState(() {
                                      element.isComplated =
                                          !element.isComplated!;
                                    });
                                    updateIsComplatedMysql(element);
                                  },
                                  value: element.isComplated,
                                ),
                                title: Text(
                                  element.title.toString(),
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
                                          updateTodo(element);
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                        )),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            element.isStar = !element.isStar!;
                                          });
                                          updateIsStarMysql(element);
                                        },
                                        child: Icon(
                                          Icons.star,
                                          color: element.isStar!
                                              ? Colors.amber
                                              : Colors.black45,
                                        )),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            state.todoListFirestore
                                                .remove(element);
                                          });
                                          deleteTodoMysql(element);
                                        },
                                        child: const Icon(Icons.delete)),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TodoDetailFirestore(
                                                        todo: element,
                                                      )));
                                        },
                                        child: const Icon(
                                          Icons.more_vert,
                                        )),
                                  ],
                                ),
                              );
                            }))),
          ])
        ]),
      );
    });
  }

  Future successAlert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
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

  Future addTodo(StateModel state) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isLoading = true;
        titleController.text = "";
      });

      TodoFire todo = TodoFire(title: title);

      var data = todo.toJson();
      String id;
      colRef.add(data).then((value) {
        id = value.id;
        todo.id = id;
        data = todo.toJson();
        colRef.doc("todo/$id").set(data).then((value) {
          List<TodoFire> newTodoList = state.todoListFirestore;
          newTodoList.add(todo);
          state.setTodoListFirestore(newTodoList);
        });
      }).catchError((onError) {
        debugPrint("hata: $onError");
      });

      successAlert("Tebrikler");
      formKey.currentState!.reset();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  Future updateIsComplatedMysql(TodoFire element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('update todo set iscomplated=? where id=?',
        [element.isComplated, element.id]).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future updateIsStarMysql(TodoFire element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('update todo set isstar=? where id=?',
        [element.isStar, element.id]).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  void updateTodo(TodoFire element) {
    setState(() {
      titleController.text = element.title.toString();
      isEdit = true;
      todo = element;
    });
  }

  Future updateTodoMysql(TodoFire element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('update todo set title=? where id=?',
        [titleController.text, element.id]).then((value) {
      setState(() {
        isLoading = false;
        isEdit = false;
        titleController.text = "";
      });
      successAlert("Kayıt Güncellendi!");
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future deleteTodoMysql(TodoFire element) async {
    setState(() {
      isLoading = true;
    });
    await conn.query('delete from todo where id=?', [element.id]).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      debugPrint(onError);
    });
  }
}
